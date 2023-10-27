program YTVideoSeries;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  uDB in 'uDB.pas' {db: TDataModule},
  uDMLogo in 'uDMLogo.pas' {DMLogo: TDataModule},
  cadRootFrame in 'cadRootFrame.pas' {RootFrame: TFrame},
  fTubeList in 'fTubeList.pas' {frmTubeList: TFrame},
  fSerialList in 'fSerialList.pas' {frmSerialList: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdb, db);
  Application.CreateForm(TDMLogo, DMLogo);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
