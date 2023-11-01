unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Olf.FMX.AboutDialog,
  FMX.Menus,
  uDMLogo,
  cadRootFrame;

type
  TfrmMain = class(TForm)
    OlfAboutDialog1: TOlfAboutDialog;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuHelp: TMenuItem;
    mnuQuit: TMenuItem;
    mnuAbout: TMenuItem;
    mnuMacSystem: TMenuItem;
    mnuData: TMenuItem;
    mnuTube: TMenuItem;
    mnuSerial: TMenuItem;
    mnuSeason: TMenuItem;
    mnuVideo: TMenuItem;
    mnuTools: TMenuItem;
    mnuOptions: TMenuItem;
    MenuItem1: TMenuItem;
    mnuBackupDB: TMenuItem;
    mnuRestoreDB: TMenuItem;
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure mnuTubeClick(Sender: TObject);
    procedure mnuSerialClick(Sender: TObject);
    procedure mnuSeasonClick(Sender: TObject);
    procedure mnuVideoClick(Sender: TObject);
  private
    FCurrentScreen: TRootFrame;
    procedure SetCurrentScreen(const Value: TRootFrame);
  protected
    procedure SetFormTitle;
  public
    { Déclarations publiques }
    property CurrentScreen: TRootFrame read FCurrentScreen
      write SetCurrentScreen;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  u_urlOpen,
  fSeasonCRUD,
  fSerialCRUD,
  fTubeCRUD,
  fVideoCRUD;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IF Defined(MACOS)}
  mnuQuit.Visible := false; // added by default in Mac system menu
  mnuQuit.text := mnuQuit.text + ' ' + OlfAboutDialog1.Titre;
  mnuFile.Visible := false;
  mnuAbout.Parent := mnuMacSystem;
  mnuHelp.Visible := false;
{$ELSE}
  mnuMacSystem.Visible := false;
{$ENDIF}
  mnuAbout.text := mnuAbout.text + ' ' + OlfAboutDialog1.Titre;
  SetFormTitle;
  FCurrentScreen := nil;
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.mnuQuitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.mnuSeasonClick(Sender: TObject);
begin
  CurrentScreen := TfrmSeasonCRUD.GetInstance<TfrmSeasonCRUD>(self);
end;

procedure TfrmMain.mnuSerialClick(Sender: TObject);
begin
  CurrentScreen := TfrmSerialCRUD.GetInstance<TfrmSerialCRUD>(self);
end;

procedure TfrmMain.mnuTubeClick(Sender: TObject);
begin
  CurrentScreen := tfrmTubeCRUD.GetInstance<tfrmTubeCRUD>(self);
end;

procedure TfrmMain.mnuVideoClick(Sender: TObject);
begin
  CurrentScreen := TfrmVideoCRUD.GetInstance<TfrmVideoCRUD>(self);
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.SetCurrentScreen(const Value: TRootFrame);
begin
  if assigned(FCurrentScreen) then
    FCurrentScreen.onhide;
  FCurrentScreen := Value;
  if assigned(FCurrentScreen) then
  begin
    FCurrentScreen.Parent := self;
    FCurrentScreen.onshow;
  end;
    SetFormTitle;
end;

procedure TfrmMain.SetFormTitle;
begin
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;
{$ELSE}
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$ENDIF}
  if assigned(FCurrentScreen) then
    caption := caption + ' - ' + FCurrentScreen.GetFormTitle;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
