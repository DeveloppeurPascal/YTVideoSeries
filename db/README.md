#Database structure

## Tube (tube)

- code
- id
- label : nom du site
- url : URL du site

## Série (serial)

- code
- id
- label : nom de la série
- url : url où consulter la série
- comment : description de la série (utilisé en playlist) => prérenseignement du niveau lien

## Lien entre série et tube (serial_tube)

- tube_code
- serial_code
- url : URL de la série (ou playlist) sur le tube concerné
- comment : description de la série (utilisé en playlist)

## Episode (video)

- code
- id
- label : nom de l'épisode
- serial_code
- order_in_serial : ordre de l'épisode dans la série
- record_date : date d'enregistrement
- url : URL de l'épisode s'il a une page web ailleurs
- comment : description de l'épisode (utilisé en page vidéo) => prérenseignement du niveau lien

## Lien entre épisode et tube (video_tube)

- tube_code
- video_code
- publish_date : date de publication de la vidéo sur le tube
- url : URL de l'épisode sur le tube concerné
- comment : description de l'épisode (utilisé en page vidéo)
