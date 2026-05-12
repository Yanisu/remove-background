# Background Remover

Application web de suppression d'arrière-plan d'images, ultra précise, 100% locale.

Basée sur le modèle d'IA **BRIA RMBG-1.4**, l'un des modèles de référence actuels pour la segmentation d'images. Le traitement se fait intégralement dans le navigateur via WebAssembly et WebGPU — aucune image n'est envoyée vers un serveur externe.

## Fonctionnalités

- **Glisser-déposer** de plusieurs images simultanément (PNG, JPG, WEBP)
- **Traitement par lot** : lancer toute la file d'attente en un clic
- **Haute précision** : gestion fine des cheveux, des trous (entre bras, jambes), et des fonds complexes
- **Modes de finition des bords** :
  - *Doux* — matte naturel, idéal pour cheveux et fourrure
  - *Précis* — équilibre entre netteté et naturel (par défaut)
  - *Net* — contours marqués, optimal pour les "faux fonds" PNG
- **Téléchargement** : image par image ou tout en archive ZIP
- **Accélération GPU** automatique via WebGPU si disponible
- **Confidentialité totale** : aucune donnée ne quitte le navigateur

## Prérequis

- **Python 3.8+** (pour le mini-serveur local). Disponible gratuitement via le Microsoft Store ou sur [python.org](https://www.python.org/downloads/).
- Un navigateur récent : **Chrome**, **Edge** ou **Firefox** (Chrome/Edge recommandés pour le support WebGPU).

## Démarrage rapide

### Windows

Double-cliquer sur `Démarrer.bat`. Le serveur local se lance et l'application s'ouvre automatiquement dans le navigateur par défaut.

### macOS / Linux

```bash
python3 serve.py
```

Puis ouvrir [http://localhost:8765/index.html](http://localhost:8765/index.html).

## Utilisation

1. Glisser une ou plusieurs images dans la zone prévue (ou cliquer pour parcourir).
2. Régler le mode de finition des bords selon le type d'image.
3. Cliquer sur **Traiter tout** pour lancer le batch, ou traiter chaque image individuellement.
4. Télécharger le résultat : bouton **PNG** par image, ou **Télécharger tout (ZIP)** pour l'ensemble.

Le premier lancement télécharge le modèle d'IA (~85 Mo). Ce modèle est ensuite mis en cache par le navigateur et les sessions suivantes sont instantanées.

## Architecture technique

| Composant | Rôle |
|-----------|------|
| `index.html` | Interface complète (HTML / CSS / JS en un seul fichier autonome) |
| `serve.py` | Serveur HTTP local avec en-têtes COOP/COEP requis par WebAssembly threads |
| `Démarrer.bat` | Lanceur Windows : démarre le serveur Python et ouvre le navigateur |

### Pile technique

- **Modèle d'IA** : [BRIA RMBG-1.4](https://huggingface.co/briaai/RMBG-1.4)
- **Runtime IA** : [Transformers.js v3](https://github.com/huggingface/transformers.js) (Hugging Face)
- **Exécution** : ONNX Runtime Web avec WebAssembly SIMD + threads, accélération WebGPU
- **Archivage** : [JSZip](https://stuk.github.io/jszip/) pour l'export ZIP côté client

### Pourquoi un serveur local plutôt qu'un fichier ouvert directement ?

Les navigateurs bloquent certaines fonctionnalités (SharedArrayBuffer, threads WebAssembly) lorsqu'une page est ouverte via le protocole `file://`. Le serveur local émet les en-têtes nécessaires :

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

Ces en-têtes activent le mode d'isolation cross-origin, indispensable au moteur d'inférence.

## Performances

| Configuration | Temps moyen / image (1024×1024) |
|---------------|--------------------------------|
| GPU dédié + WebGPU | ~0.5 à 1 s |
| CPU + WASM (threads) | ~3 à 8 s |

Le statut du moteur (GPU/CPU) s'affiche au lancement initial.

## Confidentialité

Aucune image n'est envoyée à un serveur tiers. Toute l'inférence se déroule localement dans le navigateur. Le modèle d'IA est téléchargé une seule fois depuis le CDN de Hugging Face, puis stocké dans le cache local du navigateur.

## Licence

© 2026 Yanis Cheze. Tous droits réservés.

Le code source est mis à disposition à titre de consultation. Toute utilisation, reproduction ou redistribution requiert une autorisation préalable de l'auteur.

Le modèle BRIA RMBG-1.4 est distribué sous sa propre licence ([voir conditions](https://huggingface.co/briaai/RMBG-1.4)). Son usage commercial peut nécessiter une licence séparée auprès de BRIA AI.

## Auteur

Yanis Cheze — [yanis.cheze@open-lake.com](mailto:yanis.cheze@open-lake.com)
