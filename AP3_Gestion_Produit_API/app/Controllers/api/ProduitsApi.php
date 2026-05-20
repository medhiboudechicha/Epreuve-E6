<?php

namespace App\Controllers\Api;

use App\Models\ProduitModel;
use App\Support\JwtSupport;
use CodeIgniter\RESTful\ResourceController;

class ProduitsApi extends ResourceController
{
    protected $modelName = ProduitModel::class;
    protected $format = 'json';

    public function index()
    {
        // L'app mobile consomme uniquement la table produit generique.
        // Les sous-types livre/vetement restent optionnels dans la BDD.
        $produits = $this->model
            ->where('id_produit !=', '')
            ->findAll();

        return $this->respond($produits);
    }

    public function show($id = null)
    {
        $produit = $this->model->find($id);

        if (! $produit) {
            return $this->failNotFound('Produit non trouve');
        }

        return $this->respond($produit);
    }

    public function create()
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        // Pour l'API mobile/admin, les produits sont envoyes en JSON.
        // Les uploads d'images restent geres par le controleur web.
        $data = $this->request->getJSON(true);

        if (! $data) {
            return $this->fail('Donnees invalides');
        }

        $validationError = $this->validateProduitPayload($data, true);
        if ($validationError !== null) {
            return $this->failValidationErrors($validationError);
        }

        // On normalise apres validation pour garder une forme stable en base.
        $payload = $this->normalizeProduitPayload($data, true);

        if ($this->model->find($payload['id_produit']) !== null) {
            return $this->failValidationErrors('id_produit deja utilise');
        }

        if (! $this->model->insert($payload)) {
            return $this->failValidationErrors($this->model->errors());
        }

        return $this->respondCreated([
            'message' => 'Produit cree',
            'id_produit' => $payload['id_produit'],
        ]);
    }

    public function update($id = null)
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        $produit = $this->model->find($id);

        if (! $produit) {
            return $this->failNotFound('Produit non trouve');
        }

        $data = $this->request->getJSON(true);

        if (! $data) {
            return $this->fail('Donnees invalides');
        }

        $validationError = $this->validateProduitPayload($data, false);
        if ($validationError !== null) {
            return $this->failValidationErrors($validationError);
        }

        if (! $this->model->update($id, $this->normalizeProduitPayload($data, false))) {
            return $this->failValidationErrors($this->model->errors());
        }

        return $this->respond([
            'message' => 'Produit mis a jour',
        ]);
    }

    public function delete($id = null)
    {
        if (! $this->isAdmin()) {
            return $this->failForbidden('Acces reserve aux administrateurs');
        }

        $produit = $this->model->find($id);

        if (! $produit) {
            return $this->failNotFound('Produit non trouve');
        }

        $this->model->delete($id);

        return $this->respondDeleted([
            'message' => 'Produit supprime',
        ]);
    }

    private function isAdmin(): bool
    {
        return JwtSupport::isAdminRequest($this->request);
    }

    private function validateProduitPayload(array $data, bool $isCreate): ?string
    {
        // Validation minimale commune au site et a l'app: l'API ne doit pas
        // faire confiance aux controles de formulaire Android.
        if ($isCreate && trim((string) ($data['id_produit'] ?? '')) === '') {
            return 'id_produit requis';
        }

        if (trim((string) ($data['nom'] ?? '')) === '') {
            return 'nom requis';
        }

        if (! array_key_exists('prix', $data) || ! is_numeric($data['prix']) || (float) $data['prix'] < 0) {
            return 'prix invalide';
        }

        if (
            ! array_key_exists('stock', $data)
            || filter_var($data['stock'], FILTER_VALIDATE_INT) === false
            || (int) $data['stock'] < 0
        ) {
            return 'stock invalide';
        }

        return null;
    }

    /**
     * @return array<string, int|float|string>
     */
    private function normalizeProduitPayload(array $data, bool $isCreate): array
    {
        // Les types numeriques sont forces ici pour eviter de propager des
        // chaines JSON jusque dans les calculs de panier/commande.
        $payload = [
            'nom' => trim((string) ($data['nom'] ?? '')),
            'description' => isset($data['description']) ? trim((string) $data['description']) : '',
            'prix' => round((float) $data['prix'], 2),
            'stock' => (int) $data['stock'],
            'image' => isset($data['image']) ? trim((string) $data['image']) : '',
        ];

        if ($isCreate) {
            $payload['id_produit'] = trim((string) $data['id_produit']);
        }

        return $payload;
    }
}
