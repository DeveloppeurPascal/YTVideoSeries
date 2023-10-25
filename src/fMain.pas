unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Olf.FMX.AboutDialog, FMX.Menus;

type
  TfrmMain = class(TForm)
    OlfAboutDialog1: TOlfAboutDialog;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuHelp: TMenuItem;
    mnuQuit: TMenuItem;
    mnuAbout: TMenuItem;
    mnuMacSystem: TMenuItem;
    procedure mnuAboutClick(Sender: TObject);
    procedure mnuQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OlfAboutDialog1URLClick(const AURL: string);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses u_urlOpen;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
{$IF Defined(MACOS)}
  mnuQuit.Visible := false; // added by default in Mac system menu
  mnuFile.Visible := false;
  mnuAbout.Parent := mnuMacSystem;
  mnuHelp.Visible := false;
{$ELSE}
  mnuMacSystem.Visible := false;
{$ENDIF}
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;
{$ELSE}
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$ENDIF}
end;

procedure TfrmMain.mnuAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.mnuQuitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

end.
