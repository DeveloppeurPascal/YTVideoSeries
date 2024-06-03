# 20240603 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* mise à jour de l'ordre de tabulation sur la fiche principale (au niveau de la toolbar)
* modification du nom de la base de données utilisée en DEBUG
* ajout d'un contrôle de version de la base de données lors de la connexion afin de ne pas ouvrir une base de données plus récente que le programme (et donc théoriquement pas prise en charge par lui)
* correction de la génération des tags complexes qui plantait (cas de soulignés dans les noms de champs qui le découpaient en table_champ à tort)
* prise en charge de formateurs sur les marqueurs présents dans les templates.
* ajout du formateur "-tostring" pour les champs "(xxx)date".
* ajout d'un bouton d'export global sur la gestion des tubes permettant d'exporter les infos de toutes les vidéos associées à ce "tube"
* désactivation des possibilités de modification du texte récupérable dans la fenêtre d'affichage post export

* export de la version 1.3a pour MacOS en test local avant publication officielle
