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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FCurrentScreen: TRootFrame;
    procedure SetCurrentScreen(const Value: TRootFrame);
  protected
    procedure InitMainFormCaption;
    procedure InitAboutDialogDescriptionAndLicense;
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
  FMX.DialogService,
  u_urlOpen,
  fSeasonCRUD,
  fSerialCRUD,
  fTubeCRUD,
  fVideoCRUD;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
  // tab: TFDTable;
begin
  CanClose := true;
  for i := 0 to ComponentCount - 1 do
    // if (components[i] is TFDTable) and (components[i] as TFDTable).Active and
    // ((components[i] as TFDTable).State in dsEditModes) then
    // begin
    // CanClose := false;
    // tab := components[i] as TFDTable;
    // TDialogService.MessageDialog
    // ('This record has been edited. Do you want to save the changes ?',
    // TMsgDlgType.mtWarning, mbyesno, tmsgdlgbtn.mbYes, 0,
    // procedure(const AResult: TModalResult)
    // begin
    // case AResult of
    // mryes:
    // tab.Post;
    // else
    // tab.Cancel;
    // end;
    // tthread.forcequeue(nil,
    // procedure
    // begin
    // close;
    // end);
    // end);
    // end
    // else
    if (components[i] is TRootFrame) and (components[i] as TRootFrame).visible
    then
      (components[i] as TRootFrame).OnHide;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitMainFormCaption;

  InitAboutDialogDescriptionAndLicense;

{$IF Defined(MACOS)}
  mnuQuit.visible := false; // added by default in Mac system menu
  mnuQuit.text := mnuQuit.text + ' ' + OlfAboutDialog1.Titre;
  mnuFile.visible := false;
  mnuAbout.Parent := mnuMacSystem;
  mnuHelp.visible := false;
{$ELSE}
  mnuMacSystem.visible := false;
{$ENDIF}
  mnuAbout.text := mnuAbout.text + ' ' + OlfAboutDialog1.Titre;

  FCurrentScreen := nil;
end;

procedure TfrmMain.InitAboutDialogDescriptionAndLicense;
begin
  OlfAboutDialog1.Licence.text :=
    'This program is distributed as shareware. If you use it (especially for ' +
    'commercial or income-generating purposes), please remember the author and '
    + 'contribute to its development by purchasing a license.' + slinebreak +
    slinebreak +
    'This software is supplied as is, with or without bugs. No warranty is offered '
    + 'as to its operation or the data processed. Make backups!';
  OlfAboutDialog1.Description.text :=
    'Utility for managing a local database of series and episodes published or to be published on video-on-demand sites (such as YouTube).'
    + slinebreak + slinebreak + '*****************' + slinebreak +
    '* Publisher info' + slinebreak + slinebreak +
    'This application was developed by Patrick Prémartin.' + slinebreak +
    slinebreak +
    'It is published by OLF SOFTWARE, a company registered in Paris (France) under the reference 439521725.'
    + slinebreak + slinebreak + '****************' + slinebreak +
    '* Personal data' + slinebreak + slinebreak +
    'This program is autonomous in its current version. It does not depend on the Internet and communicates nothing to the outside world.'
    + slinebreak + slinebreak + 'We have no knowledge of what you do with it.' +
    slinebreak + slinebreak +
    'No information about you is transmitted to us or to any third party.' +
    slinebreak + slinebreak +
    'We use no cookies, no tracking, no stats on your use of the application.' +
    slinebreak + slinebreak + '**********************' + slinebreak +
    '* User support' + slinebreak + slinebreak +
    'If you have any questions or require additional functionality, please leave us a message on the application''s website or on its code repository.'
    + slinebreak + slinebreak +
    'To find out more, visit https://ytvideoseries.olfsoftware.fr';
end;

procedure TfrmMain.InitMainFormCaption;
begin
{$IFDEF DEBUG}
  caption := '[DEBUG] ';
{$ELSE}
  caption := '';
{$ENDIF}
  caption := caption + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;

  if assigned(FCurrentScreen) then
    caption := caption + ' - ' + FCurrentScreen.GetFormTitle;
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
    FCurrentScreen.OnHide;
  FCurrentScreen := Value;
  if assigned(FCurrentScreen) then
  begin
    FCurrentScreen.Parent := self;
    FCurrentScreen.onshow;
  end;
  InitMainFormCaption;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
{$IFDEF MACOS}
globalusemetal := true;
{$ENDIF}

end.
