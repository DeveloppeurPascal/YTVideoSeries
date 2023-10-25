object db: Tdb
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    LoginPrompt = False
    AfterConnect = FDConnection1AfterConnect
    BeforeConnect = FDConnection1BeforeConnect
    Left = 200
    Top = 160
  end
  object FDScript1: TFDScript
    SQLScripts = <
      item
        Name = 'v0'
        SQL.Strings = (
          'CREATE TABLE "tube" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL,'
          #9'"label"'#9'TEXT NOT NULL,'
          #9'"url"'#9'TEXT NOT NULL,'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "serial" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL,'
          #9'"label"'#9'TEXT NOT NULL,'
          #9'"url"'#9'TEXT NOT NULL,'
          #9'"comment"'#9'TEXT NOT NULL,'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "serial_tube" ('
          #9'"tube_code"'#9'INTEGER NOT NULL,'
          #9'"serial_code"'#9'INTEGER NOT NULL,'
          #9'"url"'#9'TEXT NOT NULL,'
          #9'"comment"'#9'TEXT NOT NULL'
          ');'
          ''
          'CREATE TABLE "video" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL,'
          #9'"label"'#9'TEXT NOT NULL,'
          #9'"serial_code"'#9'INTEGER NOT NULL,'
          #9'"order_in_serial"'#9'INTEGER NOT NULL,'
          #9'"record_date"'#9'TEXT NOT NULL,'
          #9'"url"'#9'TEXT NOT NULL,'
          #9'"comment"'#9'TEXT NOT NULL,'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "video_tube" ('
          #9'"tube_code"'#9'INTEGER NOT NULL,'
          #9'"video_code"'#9'INTEGER NOT NULL,'
          #9'"publish_date"'#9'TEXT NOT NULL,'
          #9'"url"'#9'TEXT NOT NULL,'
          #9'"comment"'#9'TEXT NOT NULL'
          ');'
          ''
          'CREATE INDEX "tube_by_label" ON "tube" ('
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "serial_by_label" ON "serial" ('
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "link_serial_tube" ON "serial_tube" ('
          #9'"serial_code",'
          #9'"tube_code"'
          ');'
          ''
          'CREATE INDEX "link_tube_serial" ON "serial_tube" ('
          #9'"tube_code",'
          #9'"serial_code"'
          ');'
          ''
          'CREATE INDEX "video_by_label" ON "video" ('
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "video_by_serial_label" ON "video" ('
          #9'"serial_code",'
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "video_by_serial_order" ON "video" ('
          #9'"serial_code",'
          #9'"order_in_serial",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "link_video_tube" ON "video_tube" ('
          #9'"video_code",'
          #9'"tube_code"'
          ');'
          ''
          'CREATE INDEX "link_tube_video" ON "video_tube" ('
          #9'"tube_code",'
          #9'"video_code"'
          ');')
      end>
    Connection = FDConnection1
    Params = <>
    Macros = <>
    Left = 432
    Top = 168
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 304
    Top = 224
  end
end
