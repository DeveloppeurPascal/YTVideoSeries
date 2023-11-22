# Database structure

## Tube (tube)

- code
- id
- label : nom du site
- url : URL du site
- tpl_label : modèle de texte généré avec les titres (depuis série/saison/épisode)
- tpl_comment : modèle de texte généré avec les descriptions (depuis série/saison/épisode)
- tpl_keyword : modèle de texte généré avec les mots-clés (depuis série/saison/épisode)

## Série (serial)

- code
- id
- label : nom de la série
- url : url où consulter la série
- keyword : mots-clés de la série
- comment : description de la série 

## Lien entre série et tube (serial_tube)

- tube_code
- serial_code
- url : URL de la série (ou playlist) sur le tube concerné
- label : nom de la série sur ce tube
- keyword : mots-clés de la série sur ce tube
- comment : description de la série sur ce tube

## Saison (season)

- code
- id
- serial_code
- order_in_serial : ordre de la saison dans la série
- label : nom de la saison
- url : url où consulter cette saison
- record_date : date d'enregistrement
- keyword : mots-clés de la saison
- comment : description de la saison

## Lien entre saison et tube (season_tube)

- tube_code
- season_code
- url : URL de la série (ou playlist) sur le tube concerné
- label : nom de la saison sur ce tube
- keyword : mots-clés de la saison sur ce tube
- comment : description de la série sur ce tube

## Episode (video)

- code
- id
- label : nom de l'épisode
- serial_code
- season_code
- order_in_season : ordre de l'épisode dans la saison
- record_date : date d'enregistrement
- url : URL de l'épisode s'il a une page web ailleurs
- keyword : mots-clés de l'épisode
- comment : description de l'épisode

## Lien entre épisode et tube (video_tube)

- tube_code
- video_code
- publish_date : date de publication de la vidéo sur le tube
- url : URL de l'épisode sur le tube concerné
- embed : code du player vidéo intégré
- label : nom de l'épisode sur ce tube
- keyword : mots-clés de l'épisode sur ce tube
- comment : description de l'épisode sur ce tube
