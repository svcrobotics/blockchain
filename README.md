# 🧱 blockchain

Une gem Ruby légère pour certifier les ventes d’une application de caisse via une blockchain locale, simple et fiable.

## ✨ Objectif

Garantir l’intégrité des ventes, remboursements et annulations dans un environnement de point de vente.  
Chaque opération sensible est enregistrée dans un bloc, chaîné cryptographiquement pour garantir l’inviolabilité de l’historique.

---

## ⚙️ Fonctionnalités principales

- Création d’un **Genesis block**
- Ajout de blocs contenant les données suivantes :
  - Type d'opération (`Vente`, `Annulation`, `Remboursement`)
  - Détail des produits (nom, prix, quantité)
  - Montant total
  - Client associé (le cas échéant)
- Vérification de l’intégrité de la chaîne (`Blockchain::Service.valid?`)
- Affichage HTML stylisé avec état de la blockchain (✅ valide ou ❌ corrompue)
- Intégration simple dans une app Rails

---

## 🚀 Installation

Ajoute cette ligne à ton `Gemfile` dans l'application principale :

```ruby
gem 'blockchain', path: '../blockchain'
````

Puis lance :

```bash
bundle install
```

---

## 🧩 Utilisation dans Rails

### Création d’un bloc après une vente :

```ruby
Blockchain::Service.add_block({
  type: 'Vente',
  vente_id: @vente.id,
  produits: @vente.ventes_produits.map do |vp|
    {
      nom: vp.produit.nom,
      quantite: vp.quantite,
      prix: vp.prix_unitaire
    }
  end,
  total: @vente.total_net,
  client: @vente.client&.nom
})
```

### Vérification de la chaîne :

```ruby
Blockchain::Service.valid? # => true ou false
```

---

## 🗂️ Fichier blockchain

La blockchain est stockée sous forme JSON dans :

```
Rails.root/storage/blockchain.json
```

---

## 👩‍💻 Interface admin (facultatif)

Une page `/blockchain` peut afficher l’historique sous forme de tableau imprimable avec :

* Numéro de bloc
* Date / heure
* Type d’opération
* Vente liée
* Détail des produits
* Montant
* Client

---

## ✅ Exemple d’entrée dans la blockchain

```json
{
  "index": 5,
  "timestamp": "2025-06-04 13:45:10 UTC",
  "data": {
    "type": "Annulation",
    "vente_id": 123,
    "produits": [
      { "nom": "Robe Zara", "quantite": 1, "prix": "29.0" }
    ],
    "total": "29.0",
    "client": "Sophie Dupont"
  },
  "previous_hash": "a34e6b...f5629c",
  "hash": "b28df5...c9370a"
}
```

---

## 🔐 Pourquoi une blockchain locale ?

* Pour répondre aux **exigences de traçabilité et d’inaltérabilité** imposées aux systèmes de caisse.
* Pour **prévenir toute falsification** de ventes ou d’annulations après coup.
* Pour **informer clairement en cas de corruption** de l’historique.

---

## 🛠️ TODO

* Installation depuis RubyGems
---

## 📄 Licence

MIT – Utilisation libre pour projets commerciaux ou personnels.

