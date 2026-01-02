#set document(title: "Tactical Board: Nouvelles Fonctionnalités")
#set page(paper: "a4", margin: (x: 2.5cm, y: 2cm))
#set text(font: "Times New Roman", size: 11pt)
#set par(justify: true)

#align(center)[
  #text(size: 18pt, weight: "bold")[
    Tableau Tactique
  ]
  #linebreak()
  #text(size: 14pt)[
    Rapport sur les Nouvelles Fonctionnalités
  ]
  #linebreak()
  #text(size: 12pt)[
    #datetime.today().display("[day]/[month]/[year]")
  ]
]

= Introduction

L'application Tableau Tactique a été enrichie de trois nouvelles fonctionnalités majeures qui améliorent considérablement son utilité pour l'entraînement sportif : l'Enregistreur de Séquences, le Gestionnaire de Formations, et la Numérotation des Joueurs.

= 1. Enregistreur de Séquences

== Fonctionnalité

L'enregistreur de séquences permet aux entraîneurs d'enregistrer les mouvements tactiques en temps réel, puis de les rejouer pour analyser et enseigner les stratégies.

== Caractéristiques principales

- Enregistrement en temps réel : Capture tous les mouvements des joueurs et du ballon
- Lecture avec contrôle de vitesse : Rejouer les séquences de 0.25x à 3x la vitesse normale
- Sauvegarde personnalisée : Donner un nom à nos séquences et les stocker localement, elles sont persistantes entre les sessions.
- Interface intuitive : Boutons d'enregistrement, lecture, pause et arrêt
- Barre de progression : Suivi visuel de la lecture avec indicateur d'action courante

== Utilisation

1. Cliquer sur "Record" pour commencer l'enregistrement
2. Effectuer les mouvements tactiques sur le tableau
3. Cliquer sur "Stop" pour terminer l'enregistrement
4. Donner un nom à la séquence et la sauvegarder
5. Sélectionner une séquence sauvegardée et cliquer sur "Play" pour la rejouer

= 2. Gestionnaire de Formations

  == Caractéristiques principales

  - Sauvegarde complète : Capture toutes les positions des joueurs et du ballon
  - Chargement instantané : Restaure une formation en un clic
  - Noms personnalisés : Attribution de noms descriptifs aux formations
  - Stockage persistant : Les formations sont sauvegardées localement dans le navigateur
  - Gestion simple : Interface pour sélectionner, charger et supprimer les formations

== Utilisation

1. Placer les joueurs dans la formation désirée
2. Entrer un nom pour la formation
3. Cliquer sur "Save" pour sauvegarder
4. Utiliser le menu déroulant pour sélectionner une formation sauvegardée
5. Cliquer sur "Load" pour appliquer la formation

= 3. Numérotation des Joueurs

== Fonctionnalité

Chaque joueur affiche désormais un numéro en noir au centre du cercle qui le représente. Cette numérotation facilite grandement la communication lors des explications tactiques et permet une identification claire de chaque joueur.

== Caractéristiques principales

- Numérotation automatique : Les joueurs sont numérotés de 1 à N selon le sport
  - Basketball : numéros 1 à 5 pour chaque équipe
  - Football : numéros 1 à 11 pour chaque équipe
  - Shuttle : numéros 1 à 2 pour chaque équipe
- Dimensionnement adaptatif : La taille des numéros s'ajuste automatiquement selon la taille du terrain
- Persistance : Les numéros restent visibles lors des déplacements et enregistrements

== Implémentation technique

La numérotation est implémentée dans le composant Panel.vue en créant un groupe SVG contenant à la fois le cercle représentant le joueur et le texte du numéro. Cette approche garantit que le numéro reste centré sur le joueur lors de tous les déplacements et manipulations.


= Compatibilité

Ces fonctionnalités sont disponibles sur tous les tableaux tactiques de l'application car nous utilisons l'architecture mise en place par l'auteur du porjet.

Les données sont automatiquement sauvegardées dans le navigateur et persistent entre les sessions.
