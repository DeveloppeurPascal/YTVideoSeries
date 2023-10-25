unit uDB;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite;

type
  Tdb = class(TDataModule)
    FDConnection1: TFDConnection;
    FDScript1: TFDScript;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FDConnection1AfterConnect(Sender: TObject);
  private
    { Déclarations privées }
    function dbname: string;
  public
    { Déclarations publiques }
  end;

var
  DB: Tdb;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  System.IOUtils;

procedure Tdb.DataModuleCreate(Sender: TObject);
begin
  FDConnection1.Connected := true;
end;

function Tdb.dbname: string;
var
  chemin: string;
begin
{$IFDEF DEBUG}
  chemin := TPath.Combine(TPath.GetDocumentsPath,
    TPath.Combine('OlfSoftware-debug', 'YTVideoSeries-debug'));
{$ELSE}
  chemin := TPath.Combine(TPath.GetHomePath, TPath.Combine('OlfSoftware',
    'YTVideoSeries'));
{$ENDIF}
  if not TDirectory.Exists(chemin) then
    TDirectory.CreateDirectory(chemin);
  result := TPath.Combine(chemin, 'ytvideoseries');
end;

procedure Tdb.FDConnection1AfterConnect(Sender: TObject);
var
  version: integer;
  fichier: string;
  i: integer;
begin
  fichier := dbname + '.dbv';
  if tfile.Exists(fichier) then
    version := tfile.ReadAllText(fichier).ToInteger
  else
    version := -1;
  for i := version + 1 to FDScript1.SQLScripts.Count - 1 do
  begin
    try
      FDScript1.ExecuteScript(FDScript1.SQLScripts[i].SQL);
      inc(version);
      tfile.writeAllText(fichier, version.ToString);
    finally

    end;
  end;
  for i := 0 to ComponentCount - 1 do
    if (Components[i] is TFDTable) then
      (Components[i] as TFDTable).Open;
end;

procedure Tdb.FDConnection1BeforeConnect(Sender: TObject);
begin
  FDConnection1.Params.Clear;
  FDConnection1.Params.AddPair('DriverID', 'SQLite');
  FDConnection1.Params.AddPair('Database', dbname + '.db');
end;

end.
