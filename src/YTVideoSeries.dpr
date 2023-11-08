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
  fTubeCRUD in 'fTubeCRUD.pas' {frmTubeCRUD: TFrame},
  fSerialCRUD in 'fSerialCRUD.pas' {frmSerialCRUD: TFrame},
  fSeasonCRUD in 'fSeasonCRUD.pas' {frmSeasonCRUD: TFrame},
  fVideoCRUD in 'fVideoCRUD.pas' {frmVideoCRUD: TFrame},
  fSelectRecord in 'fSelectRecord.pas' {frmSelectRecord},
  fRootTubeLink in 'fRootTubeLink.pas' {frmRootTubeLink},
  fSerialTubeLinkCRUD in 'fSerialTubeLinkCRUD.pas' {frmSerialTubeLinkCRUD},
  fSeasonTubeLinkCRUD in 'fSeasonTubeLinkCRUD.pas' {frmSeasonTubeLinkCRUD},
  fVideoTubeLinkCRUD in 'fVideoTubeLinkCRUD.pas' {frmVideoTubeLinkCRUD};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdb, db);
  Application.CreateForm(TDMLogo, DMLogo);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
