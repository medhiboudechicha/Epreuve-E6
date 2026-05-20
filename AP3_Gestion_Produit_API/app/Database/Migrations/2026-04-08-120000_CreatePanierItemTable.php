<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class CreatePanierItemTable extends Migration
{
    public function up()
    {
        if ($this->db->tableExists('panier_item')) {
            return;
        }

        $this->forge->addField([
            'id_panier_item' => [
                'type'           => 'INT',
                'constraint'     => 11,
                'auto_increment' => true,
            ],
            'id_utilisateur' => [
                'type'       => 'INT',
                'constraint' => 11,
            ],
            'id_produit' => [
                'type'       => 'VARCHAR',
                'constraint' => 50,
            ],
            'quantite' => [
                'type'       => 'INT',
                'constraint' => 11,
                'default'    => 1,
            ],
            'created_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
            'updated_at' => [
                'type' => 'DATETIME',
                'null' => true,
            ],
        ]);

        $this->forge->addKey('id_panier_item', true);
        $this->forge->addKey('id_utilisateur');
        $this->forge->addKey('id_produit');
        $this->forge->addUniqueKey(['id_utilisateur', 'id_produit'], 'uniq_panier_utilisateur_produit');
        $this->forge->createTable('panier_item');
    }

    public function down()
    {
        if ($this->db->tableExists('panier_item')) {
            $this->forge->dropTable('panier_item');
        }
    }
}
