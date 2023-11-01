# 20231101 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* ascenseur sur zone droites des écrans
* ajout de marge
* forçage de la taille du TMemo
* ajout titre de fiche dans la barre de titre de la fenêtre
* reproduction bogue et signalement défaillance irrémédiable suite à bidouillage de fiche et plantage LiveBindings
* remplacement du libellé de la série par un champ de saisie en lecture seule dans l'écran des saisons
* création de l'écran de gestion des épisodes
* ajout de la série dans la table des épisodes + mise à jour du script d'installation de la DB
* finalisation de l'écran de saisie des épisodes (activation LiveBindings) et mise en place de l'option de menu pour y accéder
* mise en place du filtrage par série sur les saisons et les épisodes

-----

=> timecode 11h
=> suppression lblSerialLabel sur fSeasonCRUD.pas déclenche une défaillance irrémédiable de l'IDE
=> si suppression du fichier VLB, l'IDE reconstruit à partir des composants mais la suppression du composant déclenche une violation d'accès
=> si l'éditeur LB visuel est ouvert ça plante, s'il ne l'est pas ça plante parfois
