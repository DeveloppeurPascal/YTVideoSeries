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
  Signature : 65363bcd3324e313b3de2df943009179079fe5ea
  ***************************************************************************
*)

unit fSerialTubeLinkCRUD;

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
  FMX.Layouts,
  FMX.Bind.Navigator,
  FMX.ListView,
  FMX.Controls.Presentation,
  uDB,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo, FMX.Edit;

type
  TfrmSerialTubeLinkCRUD = class(TfrmRootTubeLink)
    FDTable1tube_code: TIntegerField;
    FDTable1serial_code: TIntegerField;
    FDTable1url: TWideMemoField;
    FDTable1comment: TWideMemoField;
    FDTable1label: TWideMemoField;
    FDTable1keyword: TWideMemoField;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    mmoComment: TMemo;
    lblKeywords: TLabel;
    edtKeywords: TEdit;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  protected
    function GetLabelFromTheFilter: string; override;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmSerialTubeLinkCRUD: TfrmSerialTubeLinkCRUD;

implementation

{$R *.fmx}

uses
  u_urlOpen;

{ TfrmSerialTubeLinkCRUD }

procedure TfrmSerialTubeLinkCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSerialTubeLinkCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmSerialTubeLinkCRUD.FormCreate(Sender: TObject);
begin
  btnOpenURL.Enabled := false;
end;

function TfrmSerialTubeLinkCRUD.GetLabelFromTheFilter: string;
begin
  result := DB.FDConnection1.ExecSQLScalar
    ('select label from serial where code=:c', [FFilterFieldValue]);
end;

end.
