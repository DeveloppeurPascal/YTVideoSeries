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
