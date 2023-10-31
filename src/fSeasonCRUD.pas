unit fSeasonCRUD;

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
  cadRootFrame,
  uDB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Data.Bind.Controls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListBox,
  FMX.ListView,
  FMX.Bind.Navigator,
  FMX.Layouts,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  FMX.Controls.Presentation,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmSeasonCRUD = class(TRootFrame)
    FDTable1: TFDTable;
    Layout1: TLayout;
    Splitter1: TSplitter;
    Layout2: TLayout;
    BindNavigator1: TBindNavigator;
    ListView1: TListView;
    cbSerialFilter: TComboBox;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    mmoComment: TMemo;
    lblRecordDate: TLabel;
    edtRecordDate: TEdit;
    edtSeasonNumber: TEdit;
    lblSeasonNumber: TLabel;
    lblSerial: TLabel;
    lblSerialLabel: TLabel;
    btnSerialSelect: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    FDTable1SerialLabel: TStringField;
    FDTable1code: TFDAutoIncField;
    FDTable1id: TWideMemoField;
    FDTable1serial_code: TIntegerField;
    FDTable1order_in_serial: TIntegerField;
    FDTable1label: TWideMemoField;
    FDTable1url: TWideMemoField;
    FDTable1record_date: TWideMemoField;
    FDTable1comment: TWideMemoField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    procedure FDTable1CalcFields(DataSet: TDataSet);
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnSerialSelectClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure OnShow; override;
    procedure OnHide; override;
  end;

implementation

{$R *.fmx}

uses
  u_urlOpen;

// TODO : gérer sélection par série (cbSerialFilter)
// TODO : change edtSeasonNumber to allow only numbers
procedure TfrmSeasonCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSeasonCRUD.btnSerialSelectClick(Sender: TObject);
begin
  inherited;
  // TODO : afficher la fenêtre de sélection de la série (prérenseignée à l'actuelle)
  // TODO : modifier la série et le libellé associés à cette fiche
end;

procedure TfrmSeasonCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmSeasonCRUD.FDTable1CalcFields(DataSet: TDataSet);
var
  LSerialLabel: string;
begin
  if DataSet.FieldByName('serial_code').IsNull or
    (DataSet.FieldByName('serial_code').AsInteger < 1) then
    DataSet.FieldByName('SerialLabel').asstring := ''
  else
    try
      LSerialLabel := DB.FDConnection1.ExecSQLScalar
        ('select label from serial where code=%c',
        [DataSet.FieldByName('serial_code').AsInteger]);
      DataSet.FieldByName('SerialLabel').asstring := LSerialLabel;
    except
      DataSet.FieldByName('SerialLabel').asstring := '';
    end;
end;

procedure TfrmSeasonCRUD.OnHide;
begin
  // TODO : tester si champ en saisie pour demander confirmation avant
  FDTable1.Active := false;
  inherited;
end;

procedure TfrmSeasonCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
//lblSerialLabel.Text := '';
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
end;

end.
