unit fVideoCRUD;

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
  FMX.ListBox,
  FMX.Layouts,
  Data.Bind.Controls,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.ListView,
  FMX.Bind.Navigator,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  FMX.Controls.Presentation,
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
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmVideoCRUD = class(TRootFrame)
    lLeft: TLayout;
    Splitter1: TSplitter;
    sbRight: TVertScrollBox;
    cbSerialFilter: TComboBox;
    cbSeasonFilter: TComboBox;
    BindNavigator1: TBindNavigator;
    ListView1: TListView;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    lblRecordDate: TLabel;
    edtRecordDate: TEdit;
    edtVideoNumber: TEdit;
    lblVideoNumber: TLabel;
    lblSerial: TLabel;
    edtSerialLabel: TEdit;
    btnSerialSelect: TButton;
    mmoComment: TMemo;
    FDTable1: TFDTable;
    FDTable1code: TFDAutoIncField;
    FDTable1id: TWideMemoField;
    FDTable1label: TWideMemoField;
    FDTable1season_code: TIntegerField;
    FDTable1order_in_season: TIntegerField;
    FDTable1record_date: TWideMemoField;
    FDTable1url: TWideMemoField;
    FDTable1comment: TWideMemoField;
    FDTable1SerialLabel: TStringField;
    FDTable1SeasonLabel: TStringField;
    FDTable1serial_code: TIntegerField;
    edtSaisonLabel: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    LinkControlToField7: TLinkControlToField;
    FDTable1SerialSeasonLabel: TStringField;
    lblKeywords: TLabel;
    edtKeywords: TEdit;
    FDTable1keyword: TWideMemoField;
    LinkControlToField8: TLinkControlToField;
    procedure FDTable1CalcFields(DataSet: TDataSet);
    procedure btnSerialSelectClick(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure cbSerialFilterChange(Sender: TObject);
    procedure cbSeasonFilterChange(Sender: TObject);
  private
  protected
    procedure SetTableFilter;
    procedure FillSerialFilter;
    procedure FillSeasonFilter;
  public
    procedure OnShow; override;
    procedure OnHide; override;
    function GetFormTitle: string; override;
  end;

var
  frmVideoCRUD: TfrmVideoCRUD;

implementation

{$R *.fmx}

uses
  u_urlOpen, fSelectRecord;

procedure TfrmVideoCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmVideoCRUD.btnSerialSelectClick(Sender: TObject);
var
  code: integer;
begin
  code := TfrmSelectRecord.FromSeasonTable;
  if (code >= 0) then
  begin
    if assigned(ListView1.Selected) then
      FDTable1.Edit
    else
      FDTable1.insert;
    FDTable1.FieldByName('season_code').AsInteger := code;
    FDTable1.FieldByName('serial_code').AsInteger :=
      DB.FDConnection1.ExecSQLScalar
      ('select serial_code from season where code=:c', [code]);
  end;
end;

procedure TfrmVideoCRUD.cbSeasonFilterChange(Sender: TObject);
begin
  SetTableFilter;
end;

procedure TfrmVideoCRUD.cbSerialFilterChange(Sender: TObject);
begin
  SetTableFilter;
end;

procedure TfrmVideoCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmVideoCRUD.FDTable1CalcFields(DataSet: TDataSet);
var
  LSerialLabel: string;
  LSeasonLabel: string;
begin
  if DataSet.FieldByName('serial_code').IsNull or
    (DataSet.FieldByName('serial_code').AsInteger < 1) then
    DataSet.FieldByName('SerialLabel').asstring := ''
  else
    try
      LSerialLabel := DB.FDConnection1.ExecSQLScalar
        ('select label from serial where code=:c',
        [DataSet.FieldByName('serial_code').AsInteger]);
      DataSet.FieldByName('SerialLabel').asstring := LSerialLabel;
    except
      DataSet.FieldByName('SerialLabel').asstring := '';
    end;
  if DataSet.FieldByName('season_code').IsNull or
    (DataSet.FieldByName('season_code').AsInteger < 1) then
    DataSet.FieldByName('SeasonLabel').asstring := ''
  else
    try
      LSeasonLabel := DB.FDConnection1.ExecSQLScalar
        ('select label from season where code=:c',
        [DataSet.FieldByName('season_code').AsInteger]);
      DataSet.FieldByName('SeasonLabel').asstring := LSeasonLabel;
    except
      DataSet.FieldByName('SeasonLabel').asstring := '';
    end;
  if DataSet.FieldByName('SerialLabel').asstring.IsEmpty then
    DataSet.FieldByName('SerialSeasonLabel').asstring :=
      DataSet.FieldByName('SeasonLabel').asstring
  else if DataSet.FieldByName('SeasonLabel').asstring.IsEmpty then
    DataSet.FieldByName('SerialSeasonLabel').asstring :=
      DataSet.FieldByName('SerialLabel').asstring
  else
    DataSet.FieldByName('SerialSeasonLabel').asstring :=
      DataSet.FieldByName('SerialLabel').asstring + ' - ' +
      DataSet.FieldByName('SeasonLabel').asstring;
end;

procedure TfrmVideoCRUD.FillSeasonFilter;
begin
  // TODO : gérer sélection par saison (cbSeasonFilter)
end;

procedure TfrmVideoCRUD.FillSerialFilter;
var
  qry: TFDQuery;
begin
  cbSerialFilter.Clear;
  cbSerialFilter.ListItems[cbSerialFilter.Items.Add('')].Tag := -1;
  qry := TFDQuery.Create(self);
  try
    qry.Connection := DB.FDConnection1;
    qry.Open('select code, label from serial order by label');
    qry.First;
    while not qry.Eof do
    begin
      cbSerialFilter.ListItems[cbSerialFilter.Items.Add(qry.FieldByName('label')
        .asstring)].Tag := qry.FieldByName('code').AsInteger;
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TfrmVideoCRUD.GetFormTitle: string;
begin
  result := 'Video CRUD';
end;

procedure TfrmVideoCRUD.OnHide;
begin
  // TODO : tester si champ en saisie pour demander confirmation avant
  FDTable1.Active := false;
  inherited;
end;

procedure TfrmVideoCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  // lblSerialLabel.Text := '';
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
  FillSerialFilter;
  FillSeasonFilter;
end;

procedure TfrmVideoCRUD.SetTableFilter;
begin
  if assigned(cbSerialFilter.Selected) then
    case cbSerialFilter.Selected.Tag of
      - 1:
        FDTable1.Filtered := false;
    else
      FDTable1.Filter := 'serial_code=' + cbSerialFilter.Selected.Tag.ToString;
      FDTable1.Filtered := true;
    end
  else
    FDTable1.Filtered := false;
end;

end.
