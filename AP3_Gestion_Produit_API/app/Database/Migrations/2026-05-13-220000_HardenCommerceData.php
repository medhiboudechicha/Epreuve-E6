<?php

namespace App\Database\Migrations;

use App\Support\PasswordSupport;
use CodeIgniter\Database\Migration;

class HardenCommerceData extends Migration
{
    // Noms fixes pour rendre la migration idempotente: elle peut verifier si
    // chaque contrainte ou trigger existe avant de le creer ou supprimer.
    private const PANIER_FK_PRODUCT = 'fk_panier_item_produit';
    private const PANIER_FK_USER = 'fk_panier_item_utilisateur';
    private const PRODUIT_ID_CHECK = 'chk_produit_id_non_vide';

    private const TRIGGER_APPARTENIR_INSERT = 'sync_commande_quantite_after_insert';
    private const TRIGGER_APPARTENIR_UPDATE = 'sync_commande_quantite_after_update';
    private const TRIGGER_APPARTENIR_DELETE = 'sync_commande_quantite_after_delete';

    public function up()
    {
        // Cette migration consolide les donnees existantes avant d'ajouter des
        // contraintes. Les corrections doivent passer avant les ALTER TABLE.
        $this->hashLegacyPasswords();
        $this->deleteInvalidProduct();
        $this->syncCommandeQuantites();
        $this->addPanierItemForeignKeys();
        $this->addProduitIdCheckConstraint();
        $this->createCommandeQuantiteSyncTriggers();
    }

    public function down()
    {
        $this->dropCommandeQuantiteSyncTriggers();
        $this->dropProduitIdCheckConstraint();
        $this->dropPanierItemForeignKeys();
    }

    private function hashLegacyPasswords(): void
    {
        if (! $this->db->tableExists('utilisateur')) {
            return;
        }

        // La base de depart contenait des mots de passe en clair. On les hash
        // une fois pour aligner le site web et l'API mobile.
        $users = $this->db->table('utilisateur')
            ->select('id_utilisateur, mot_de_passe')
            ->get()
            ->getResultArray();

        foreach ($users as $user) {
            $storedPassword = (string) ($user['mot_de_passe'] ?? '');

            if ($storedPassword === '' || PasswordSupport::isHash($storedPassword)) {
                continue;
            }

            $this->db->table('utilisateur')
                ->where('id_utilisateur', (int) $user['id_utilisateur'])
                ->update([
                    'mot_de_passe' => PasswordSupport::hash($storedPassword),
                ]);
        }
    }

    private function deleteInvalidProduct(): void
    {
        if (! $this->db->tableExists('produit')) {
            return;
        }

        // Ancienne anomalie: un produit pouvait avoir id_produit = ''.
        // On ne le supprime que s'il n'est reference nulle part.
        $hasInvalidProduct = $this->db->table('produit')
            ->where('id_produit', '')
            ->countAllResults() > 0;

        if (! $hasInvalidProduct) {
            return;
        }

        $references = 0;

        foreach (['appartenir', 'consulter', 'fournir', 'produit_livre', 'produit_vetement', 'panier_item'] as $table) {
            if (! $this->db->tableExists($table)) {
                continue;
            }

            $references += $this->db->table($table)
                ->where('id_produit', '')
                ->countAllResults();
        }

        if ($references === 0) {
            $this->db->table('produit')
                ->where('id_produit', '')
                ->delete();
        }
    }

    private function syncCommandeQuantites(): void
    {
        if (! $this->db->tableExists('commande') || ! $this->db->tableExists('appartenir')) {
            return;
        }

        // commande.quantite est redondant avec les lignes appartenir.
        // On le recalcule avant d'installer les triggers de synchronisation.
        $this->db->query(
            'UPDATE commande c
             LEFT JOIN (
                 SELECT id_commande, COALESCE(SUM(quantite), 0) AS total_quantite
                 FROM appartenir
                 GROUP BY id_commande
             ) a ON a.id_commande = c.id_commande
             SET c.quantite = COALESCE(a.total_quantite, 0)'
        );
    }

    private function addPanierItemForeignKeys(): void
    {
        if (! $this->db->tableExists('panier_item')) {
            return;
        }

        // Si un utilisateur ou un produit est supprime, son panier doit suivre
        // automatiquement pour eviter les lignes orphelines.
        if (! $this->constraintExists('panier_item', self::PANIER_FK_USER)) {
            $this->db->query(
                'ALTER TABLE panier_item
                 ADD CONSTRAINT ' . self::PANIER_FK_USER . '
                 FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur)
                 ON DELETE CASCADE
                 ON UPDATE CASCADE'
            );
        }

        if (! $this->constraintExists('panier_item', self::PANIER_FK_PRODUCT)) {
            $this->db->query(
                'ALTER TABLE panier_item
                 ADD CONSTRAINT ' . self::PANIER_FK_PRODUCT . '
                 FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
                 ON DELETE CASCADE
                 ON UPDATE CASCADE'
            );
        }
    }

    private function dropPanierItemForeignKeys(): void
    {
        if (! $this->db->tableExists('panier_item')) {
            return;
        }

        if ($this->constraintExists('panier_item', self::PANIER_FK_USER)) {
            $this->db->query('ALTER TABLE panier_item DROP FOREIGN KEY ' . self::PANIER_FK_USER);
        }

        if ($this->constraintExists('panier_item', self::PANIER_FK_PRODUCT)) {
            $this->db->query('ALTER TABLE panier_item DROP FOREIGN KEY ' . self::PANIER_FK_PRODUCT);
        }
    }

    private function addProduitIdCheckConstraint(): void
    {
        if (! $this->db->tableExists('produit') || $this->constraintExists('produit', self::PRODUIT_ID_CHECK)) {
            return;
        }

        // La validation applicative ne suffit pas: la BDD refuse aussi les ids
        // vides pour proteger les imports SQL et les appels API directs.
        $this->db->query(
            'ALTER TABLE produit
             ADD CONSTRAINT ' . self::PRODUIT_ID_CHECK . '
             CHECK (CHAR_LENGTH(TRIM(id_produit)) > 0)'
        );
    }

    private function dropProduitIdCheckConstraint(): void
    {
        if (! $this->db->tableExists('produit') || ! $this->constraintExists('produit', self::PRODUIT_ID_CHECK)) {
            return;
        }

        $this->db->query('ALTER TABLE produit DROP CHECK ' . self::PRODUIT_ID_CHECK);
    }

    private function createCommandeQuantiteSyncTriggers(): void
    {
        if (! $this->db->tableExists('appartenir')) {
            return;
        }

        // Les triggers gardent commande.quantite synchronise si les lignes sont
        // modifiees hors du flux PHP normal.
        $this->dropCommandeQuantiteSyncTriggers();

        $this->db->query(
            'CREATE TRIGGER ' . self::TRIGGER_APPARTENIR_INSERT . '
             AFTER INSERT ON appartenir
             FOR EACH ROW
             UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = NEW.id_commande
             )
             WHERE id_commande = NEW.id_commande'
        );

        $this->db->query(
            'CREATE TRIGGER ' . self::TRIGGER_APPARTENIR_UPDATE . '
             AFTER UPDATE ON appartenir
             FOR EACH ROW
             UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(a.quantite), 0)
                 FROM appartenir a
                 WHERE a.id_commande = commande.id_commande
             )
             WHERE id_commande IN (OLD.id_commande, NEW.id_commande)'
        );

        $this->db->query(
            'CREATE TRIGGER ' . self::TRIGGER_APPARTENIR_DELETE . '
             AFTER DELETE ON appartenir
             FOR EACH ROW
             UPDATE commande
             SET quantite = (
                 SELECT COALESCE(SUM(quantite), 0)
                 FROM appartenir
                 WHERE id_commande = OLD.id_commande
             )
             WHERE id_commande = OLD.id_commande'
        );
    }

    private function dropCommandeQuantiteSyncTriggers(): void
    {
        foreach ([
            self::TRIGGER_APPARTENIR_INSERT,
            self::TRIGGER_APPARTENIR_UPDATE,
            self::TRIGGER_APPARTENIR_DELETE,
        ] as $triggerName) {
            if ($this->triggerExists($triggerName)) {
                $this->db->query('DROP TRIGGER ' . $triggerName);
            }
        }
    }

    private function constraintExists(string $tableName, string $constraintName): bool
    {
        // MySQL expose les contraintes dans information_schema; cela evite les
        // erreurs "duplicate constraint" lors des relances locales.
        return $this->db->table('information_schema.TABLE_CONSTRAINTS')
            ->where('CONSTRAINT_SCHEMA', $this->db->getDatabase())
            ->where('TABLE_NAME', $tableName)
            ->where('CONSTRAINT_NAME', $constraintName)
            ->countAllResults() > 0;
    }

    private function triggerExists(string $triggerName): bool
    {
        // Meme logique que pour les contraintes, appliquee aux triggers.
        return $this->db->table('information_schema.TRIGGERS')
            ->where('TRIGGER_SCHEMA', $this->db->getDatabase())
            ->where('TRIGGER_NAME', $triggerName)
            ->countAllResults() > 0;
    }
}
