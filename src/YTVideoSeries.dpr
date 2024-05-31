program YTVideoSeries;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
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
  fVideoTubeLinkCRUD in 'fVideoTubeLinkCRUD.pas' {frmVideoTubeLinkCRUD},
  uBuilder in 'uBuilder.pas',
  fShowMemo in 'fShowMemo.pas' {frmShowMemo},
  u_urlOpen in '..\lib-externes\librairies\src\u_urlOpen.pas',
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\src\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  Olf.RTL.GenRandomID in '..\lib-externes\librairies\src\Olf.RTL.GenRandomID.pas',
  DelphiBooks.Tools in '..\lib-externes\DelphiBooks-Common\src\DelphiBooks.Tools.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdb, db);
  Application.CreateForm(TDMLogo, DMLogo);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
