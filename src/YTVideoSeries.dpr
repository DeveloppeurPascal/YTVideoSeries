(* C2PP
  ***************************************************************************

  YT Video Series

  Copyright 2023-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://ytvideoseries.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/YTVideoSeries

  ***************************************************************************
  File last update : 2025-10-16T10:43:21.465+02:00
  Signature : 310a121c3d648c9ff06c550b94dc2b94e147a06b
  ***************************************************************************
*)

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
