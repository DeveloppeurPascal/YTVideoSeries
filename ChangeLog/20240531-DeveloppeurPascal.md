# 20240531 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour des dépendances
* ajout de la génération des ID dans les tables de la base de données (en mise à jour s'il est vide ou insertion)
* ajout du dépôt https://github.com/DeveloppeurPascal/DelphiBooks-Common.git comme sous-module
* traitement des tags "date", "date-iso" et "date-rfc822" pour les templates exportés depuis les tubes des vidéos par le programme
* prise en charge de l'état de la table en cours (édition/insertion ou rien) lors du changement d'écran par les menus (méthode onHide de chaque) => proposition d'enregistrement ou d'abandon de la modification
* idem pour les boutons permettant de passer aux épisodes ou saisons depuis les saisons et les séries
* idem pour les boutons permettant d'afficher une fenêtre modale pour les liens vers les tubes depuis séries, saisons et épisodes
* même vérification de l'état d'une table ouverte dans une frame avant la fermeture de la fenêtre principale et donc du programme
* mise en place d'un contrôle de référence lors de la suppression d'un élémént des tubes, séries, saisons et épisodes (contraintes de relation gérées à la main pour éviter la suppression d'un truc utilisé ailleurs entrainant des anomalies dans les données)
* ajout d'une barre d'outil avec les boutons d'accès aux écrans de saisie sur l'écran principal 
* modification du parent des fenêtres (frames) secondaires pour conserver une marge par rapport aux rebords de la fenêtre (et éviter les pertes d'éléments à cause des arrondis ajoutés par Microsoft sous Windows 11)

* publication d'une version 1.2 - 20240531 du programme
