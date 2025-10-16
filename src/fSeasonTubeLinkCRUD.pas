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
  File last update : 2025-10-16T10:43:21.466+02:00
  Signature : 05c748c23db145294b16dff181324f3f9c0e875c
  ***************************************************************************
*)

unit fSeasonTubeLinkCRUD;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  fRootTubeLink,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  Data.Bind.Controls,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Bind.Navigator,
  FMX.ListView,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  uDB;

type
  TfrmSeasonTubeLinkCRUD = class(TfrmRootTubeLink)
    edtKeywords: TEdit;
    edtLabel: TEdit;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    lblKeywords: TLabel;
    lblLabel: TLabel;
    lblURL: TLabel;
    mmoComment: TMemo;
    FDTable1tube_code: TIntegerField;
    FDTable1season_code: TIntegerField;
    FDTable1url: TWideMemoField;
    FDTable1label: TWideMemoField;
    FDTable1comment: TWideMemoField;
    FDTable1keyword: TWideMemoField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    procedure edtURLChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
  private

  protected
    function GetLabelFromTheFilter: string; override;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSeasonTubeLinkCRUD: TfrmSeasonTubeLinkCRUD;

implementation

{$R *.fmx}

uses
  u_urlOpen;

procedure TfrmSeasonTubeLinkCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSeasonTubeLinkCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmSeasonTubeLinkCRUD.FormCreate(Sender: TObject);
begin
  btnOpenURL.Enabled := false;
end;

function TfrmSeasonTubeLinkCRUD.GetLabelFromTheFilter: string;
begin
  result := DB.FDConnection1.ExecSQLScalar
    ('select concat(concat(serial.label," - "),season.label) from season, serial where (season.code=:c) and (serial.code=season.serial_code)',
    [FFilterFieldValue]);
end;

end.
