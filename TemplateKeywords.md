# Templates keywords

L'export des textes pour tube dépend d'une vidéo (= d'un épisode). Le positionement sur la saison, la série et les liens avec les tubes sont faits automatiquement et systématiquement. Pas de besoin de dépositionner des éléments depuis le générateur.

Il n'y a pas de listes d'éléments à afficher pour un autre élément.

!$if exists_Table$! teste si un enregistrement est disponible dans la "Table" pour la vidéo en cours.
!$if exists_Table_Champ$! est vrai si le "Champ" de la "Table" n'est pas vide.
!$Table_Champ$! remplace par le contenu du "Champ" dans la "Table".

## Tube (tube)

- if exists_tube_label
- tube_label
- if exists_tube_url
- tube_url

## Série (serial)

- if exists_serial
- if exists_serial_label
- serial_label
- if exists_serial_url
- serial_url
- if exists_serial_keyword
- serial_keyword
- if exists_serial_comment
- serial_comment

## Lien entre série et tube (serial_tube)
- if exists_serial_tube
- if exists_serial_tube_url
- serial_tube_url
- if exists_serial_tube_label
- serial_tube_label
- if exists_serial_tube_keyword
- serial_tube_keyword
- if exists_serial_tube_comment
- serial_tube_comment

## Saison (season)

- if exists_season
- if exists_season_order_in_serial
- season_order_in_serial
- if exists_season_label
- season_label
- if exists_season_url
- season_url
- if exists_season_record_date
- season_record_date
- if exists_season_keyword
- season_keyword
- if exists_season_comment
- season_comment

## Lien entre saison et tube (season_tube)

- if exists_season_tube
- if exists_season_tube_url
- season_tube_url
- if exists_season_tube_label
- season_tube_label
- if exists_season_tube_keyword
- season_tube_keyword
- if exists_season_tube_comment
- season_tube_comment

## Episode (video)

- if exists_video_label
- video_label
- if exists_video_order_in_season
- video_order_in_season
- if exists_video_record_date
- video_record_date
- if exists_video_url
- video_url
- if exists_video_keyword
- video_keyword
- if exists_video_comment
- video_comment

## Lien entre épisode et tube (video_tube)

- if exists_video_tube_publish_date
- video_tube_publish_date
- if exists_video_tube_url
- video_tube_url
- if exists_video_tube_embed
- video_tube_embed
- if exists_video_tube_label
- video_tube_label
- if exists_video_tube_keyword
- video_tube_keyword
- if exists_video_tube_comment
- video_tube_comment
