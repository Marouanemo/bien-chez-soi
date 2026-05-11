# Bien Chez Soi — Landing Page

Landing page de capture de leads pour l'offre **« Isolation à 1€ »** (aides CEE 2026), ciblée propriétaires occupants en zones climatiques **H1 et H2** (France).

## 🎯 Objectif

Maximiser le taux de conversion en proposant un parcours d'éligibilité interactif en moins de 60 secondes, avec qualification automatique des leads par zone climatique, statut, ancienneté du logement et profil énergétique.

## ✨ Caractéristiques

- **Single-file HTML** — zéro dépendance, < 50 KB, chargement < 1s
- **Mobile-first** — sticky CTA, formulaire conversationnel, gros boutons
- **Formulaire multi-étapes** — 9 étapes avec barre de progression, navigation arrière
- **Qualification automatique** :
  - Détection zone climatique (H1/H2/H3) via code postal
  - Blocage locataires + logements < 2 ans
  - Capture light pour leads hors zone (H3)
- **Calcul dynamique** du montant des aides estimées selon le profil
- **Exit-intent** pour rattraper les abandons
- **Tracking-ready** : Google Tag Manager, Meta Pixel, Google Ads conversions
- **RGPD-compliant** — case de consentement obligatoire

## 🚀 Déploiement local

```bash
# Servir la page localement (Python 3)
python -m http.server 8080
# puis ouvrir http://localhost:8080
```

## ⚙️ Configuration du formulaire

Ouvrir `index.html` et configurer en haut du `<script>` :

```js
const WEBHOOK_URL = "https://hooks.zapier.com/..."; // ou Make / Brevo / HubSpot
```

Données envoyées en POST JSON :
```json
{
  "type_logement": "maison",
  "statut": "proprietaire",
  "construction": "avant1990",
  "chauffage": "gaz",
  "isolation": "mal",
  "surface": 130,
  "code_postal": "59000",
  "zone_climatique": "H1",
  "foyer": "3",
  "revenus": "intermediaire",
  "prenom": "...",
  "nom": "...",
  "telephone": "...",
  "email": "...",
  "moment_appel": "Matin",
  "submitted_at": "ISO-date",
  "source": "...",
  "utm": "..."
}
```

## 📦 Déploiement Hetzner (Nginx)

Voir [deploy.sh](deploy.sh) pour le script de déploiement complet sur un serveur Hetzner.

## 🛠 À compléter avant production

- [ ] Configurer `WEBHOOK_URL` dans `index.html`
- [ ] Remplacer le numéro de téléphone `09 72 00 00 00`
- [ ] Compléter SIRET, numéros RGE Qualibat et Qualipac dans le footer
- [ ] Ajouter les pages mentions légales, CGV, RGPD, cookies
- [ ] Ajouter les IDs de tracking (GTM, Meta Pixel, Google Ads)
- [ ] Configurer un domaine + certificat SSL (Let's Encrypt)
