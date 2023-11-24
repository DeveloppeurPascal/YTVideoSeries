# Default Templates

## Default label template for a tube

!$if exists_video_tube_label$!!$video_tube_label$!!$else$!
!$if exists_video_label$!!$video_label$!!$else$!
!$if exists_season_tube_label$!!$season_tube_label$!!$else$!
!$if exists_season_label$!!$season_label$!!$else$!
!$if exists_serial_tube_label$!!$serial_tube_label$!!$else$!
!$if exists_serial_label$!!$serial_label$!!$else$!
no title available
!$/if$!
!$/if$!
!$/if$!
!$/if$!
!$/if$!
!$/if$!

## Default description template for a tube

!$if exists_video_tube_comment$!!$video_tube_comment$!!$else$!!$if exists_video_comment$!!$video_comment$!!$else$!!$if exists_season_tube_comment$!!$season_tube_comment$!!$else$!!$if exists_season_comment$!!$season_comment$!!$else$!!$if exists_serial_tube_comment$!!$serial_tube_comment$!!$else$!!$if exists_serial_comment$!!$serial_comment$!!$else$!no description available!$/if$!!$/if$!!$/if$!!$/if$!!$/if$!!$/if$!

## Default keywords template for a tube

!$if exists_video_tube_keyword$!!$video_tube_keyword$!,!$/if$!
!$if exists_video_keyword$!!$video_keyword$!,!$/if$!
!$if exists_season_tube_keyword$!!$season_tube_keyword$!,!$/if$!
!$if exists_season_keyword$!!$season_keyword$!,!$/if$!
!$if exists_serial_tube_keyword$!!$serial_tube_keyword$!,!$/if$!
!$if exists_serial_keyword$!!$serial_keyword$!,!$/if$!
