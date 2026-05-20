<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class AddQuantiteToAppartenir extends Migration
{
    public function up()
    {
        if (! $this->db->tableExists('appartenir')) {
            return;
        }

        if ($this->db->fieldExists('quantite', 'appartenir')) {
            return;
        }

        $this->forge->addColumn('appartenir', [
            'quantite' => [
                'type'       => 'INT',
                'constraint' => 11,
                'default'    => 1,
                'after'      => 'id_commande',
            ],
        ]);
    }

    public function down()
    {
        if ($this->db->tableExists('appartenir') && $this->db->fieldExists('quantite', 'appartenir')) {
            $this->forge->dropColumn('appartenir', 'quantite');
        }
    }
}
