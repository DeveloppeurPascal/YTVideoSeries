# 20240530 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* mise jour des liens de téléchargement et achat de licence dans la doc (FR/EN)
* suppression du TODO.md (remplacé par les tickets sur GitHub Issues)
* mise à jour des liens vers les unités dans les dépendances (about box + librairies) où le classement des fichiers a évolué
* suppression d'un avertissement du compilateur en affectant une valeur par défaut au retour d'une fonction
* changement de la mise à jour du titre de la fenêtre principale en reprenant le code habituel
* changement du texte de la description du projet et de la licence dans la boite de dialogues "à propos"
* tentative de correction du problème d'accès à la table "séries" sur les données réelles => bogue LB => RSS-1051 (https://embt.atlassian.net/servicedesk/customer/portal/1/RSS-1051)
* filtrage des "_" en début de saisie des champs "label", remplacement par des espaces à la place
* correction de l'affichage des libellés de tables liées sur les différents écrans (les champs calculés étaient affichés avec une taille de 20 caractères à peine)
* la modification de la série associée à une saison est maintenant répercutée sur ses épisodes (pour s'assurer que la base de données est cohérente)
* ajout d'un calendrier facultatif pour saisir les dates d'enregistrement (épisodes et saisons) ou de publication (tubes des épisodes)
