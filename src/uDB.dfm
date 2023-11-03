object db: Tdb
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\patrickpremartin\Documents\Embarcadero\Studio\' +
        'Projets\YTVideoSeries\db\DBStructure.db'
      'LockingMode=Normal'
      'DriverID=SQLite')
    ConnectedStoredUsage = [auDesignTime]
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
          #9'"id"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"label"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"template"'#9'TEXT NOT NULL DEFAULT "",'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "serial" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"label"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"comment"'#9'TEXT NOT NULL DEFAULT "",'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "serial_tube" ('
          #9'"tube_code"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"serial_code"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"comment"'#9'TEXT NOT NULL DEFAULT ""'
          ');'
          ''
          'CREATE TABLE "season" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"serial_code"'#9'INTEGER,'
          #9'"order_in_serial"'#9'INTEGER,'
          #9'"label"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"record_date"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"comment"'#9'TEXT NOT NULL DEFAULT "",'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "video" ('
          #9'"code"'#9'INTEGER,'
          #9'"id"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"label"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"season_code"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"order_in_season"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"record_date"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"comment"'#9'TEXT NOT NULL DEFAULT "",'
          #9'PRIMARY KEY("code" AUTOINCREMENT)'
          ');'
          ''
          'CREATE TABLE "video_tube" ('
          #9'"tube_code"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"video_code"'#9'INTEGER NOT NULL DEFAULT 0,'
          #9'"publish_date"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"url"'#9'TEXT NOT NULL DEFAULT "",'
          #9'"comment"'#9'TEXT NOT NULL DEFAULT ""'
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
          'CREATE INDEX "season_by_serial_label" ON "season" ('
          #9'"serial_code",'
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "season_by_serial_order" ON "season" ('
          #9'"serial_code",'
          #9'"order_in_serial",'
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
          'CREATE INDEX "video_by_season_label" ON "video" ('
          #9'"season_code",'
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "video_by_season_order" ON "video" ('
          #9'"season_code",'
          #9'"order_in_season",'
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
      end
      item
        Name = 'v1'
        SQL.Strings = (
          'CREATE TABLE "season_tube" ('
          #9'"tube_code" INTEGER NOT NULL DEFAULT 0,'
          #9'"season_code" INTEGER NOT NULL DEFAULT 0,'
          #9'"url" TEXT NOT NULL DEFAULT "",'
          #9'"label" TEXT NOT NULL DEFAULT "",'
          #9'"comment" TEXT NOT NULL DEFAULT ""'
          ');'
          ''
          'ALTER TABLE "video_tube" add "label" TEXT NOT NULL DEFAULT "";'
          #9
          'ALTER TABLE "video_tube" add "embed" TEXT NOT NULL DEFAULT "";'
          ''
          'ALTER TABLE "serial_tube" add "label" TEXT NOT NULL DEFAULT "";'
          ''
          'CREATE INDEX "link_season_tube" ON "season_tube" ('
          #9'"season_code",'
          #9'"tube_code"'
          ');'
          ''
          'CREATE INDEX "link_tube_season" ON "season_tube" ('
          #9'"tube_code",'
          #9'"season_code"'
          ');')
      end
      item
        Name = 'v2'
        SQL.Strings = (
          
            'ALTER TABLE "video" add "serial_code" INTEGER NOT NULL DEFAULT 0' +
            ';'
          #9
          'CREATE INDEX "video_by_serial_season_label" ON "video" ('
          #9'"serial_code",'
          #9'"season_code",'
          #9'"label",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "video_by_serial_season_order" ON "video" ('
          #9'"serial_code",'
          #9'"season_code",'
          #9'"order_in_season",'
          #9'"code"'
          ');'
          ''
          'CREATE INDEX "video_by_serial_label" ON "video" ('
          #9'"serial_code",'
          #9'"label",'
          #9'"code"'
          ');')
      end
      item
        Name = 'v3'
        SQL.Strings = (
          'ALTER TABLE "tube" add "tpl_label" TEXT NOT NULL DEFAULT "";'
          'ALTER TABLE "tube" add "tpl_comment" TEXT NOT NULL DEFAULT "";'
          'ALTER TABLE "tube" add "tpl_keyword" TEXT NOT NULL DEFAULT "";'
          'update tube set tpl_comment=template;'
          'ALTER TABLE "serial" add "keyword" TEXT NOT NULL DEFAULT "";'
          
            'ALTER TABLE "serial_tube" add "keyword" TEXT NOT NULL DEFAULT ""' +
            ';'
          'ALTER TABLE "season" add "keyword" TEXT NOT NULL DEFAULT "";'
          
            'ALTER TABLE "season_tube" add "keyword" TEXT NOT NULL DEFAULT ""' +
            ';'
          'ALTER TABLE "video" add "keyword" TEXT NOT NULL DEFAULT "";'
          'ALTER TABLE "video_tube" add "keyword" TEXT NOT NULL DEFAULT "";')
      end>
    Connection = FDConnection1
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 432
    Top = 168
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 304
    Top = 224
  end
end
