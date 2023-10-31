# 20231031 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

Modification de l abase de données pour ajouter quelques champs et une liaison entre saisons et tubes au cas où on ne les diffuserait pas toutes sur celles des séries. Ca impliquera quelques bidouillages au niveau des épisodes qui devront se diffuser par rapport à la liste récupérée au niveau de la saison qui devra elle-même se faire par rapport à la série mais on verra ça le moment venu.

J'ai ensuite poursuivi les modifications sur le programme en ajoutant les écrans de saisie pour les séries et les saisons.

Quelques modifications au niveau de l'automatisation des remplissages de champs et bidouillages sur LiveBindings pour simplifier le travail plus tard et éliminer quelques erreurs liées à la non récupération des valeurs par défaut depuis SQLite qui semble ne pas en tenir compte dans le cas de champs NOT NULL même si on spécifie le DEFAULT lors de l'ajout du champ à la table.
