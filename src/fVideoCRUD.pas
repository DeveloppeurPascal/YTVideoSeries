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
  Data.Bind.DBScope,
  FMX.Calendar;

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
    btnSerialSelect: TButton;
    lRight: TLayout;
    btnTubesLinks: TButton;
    btnShowCalendar: TDropDownEditButton;
    Popup1: TPopup;
    Calendar1: TCalendar;
    procedure FDTable1CalcFields(DataSet: TDataSet);
    procedure btnSerialSelectClick(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure cbSerialFilterChange(Sender: TObject);
    procedure cbSeasonFilterChange(Sender: TObject);
    procedure FDTable1AfterInsert(DataSet: TDataSet);
    procedure btnTubesLinksClick(Sender: TObject);
    procedure Calendar1DateSelected(Sender: TObject);
    procedure btnShowCalendarClick(Sender: TObject);
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
  System.DateUtils,
  u_urlOpen,
  fSelectRecord,
  fVideoTubeLinkCRUD;

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

procedure TfrmVideoCRUD.btnShowCalendarClick(Sender: TObject);
begin
  Popup1.Width := Calendar1.Margins.Left + Calendar1.Width +
    Calendar1.Margins.right;
  Popup1.Height := Calendar1.Margins.top + Calendar1.Height +
    Calendar1.Margins.Bottom;
  Popup1.IsOpen := not Popup1.IsOpen;
  if Popup1.IsOpen then
    Calendar1.TagString := edtRecordDate.Text;
end;

procedure TfrmVideoCRUD.btnTubesLinksClick(Sender: TObject);
var
  frm: TfrmVideoTubeLinkCRUD;
begin
  frm := TfrmVideoTubeLinkCRUD.Create(self, 'video_code',
    FDTable1.FieldByName('code').AsInteger);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmVideoCRUD.Calendar1DateSelected(Sender: TObject);
begin
  if not(FDTable1.State in dsEditModes) then
    FDTable1.Edit;

  FDTable1.FieldByName('record_date').AsString :=
    Calendar1.DateTime.ToISO8601.Substring(0, 10);
end;

procedure TfrmVideoCRUD.cbSeasonFilterChange(Sender: TObject);
begin
  SetTableFilter;
end;

procedure TfrmVideoCRUD.cbSerialFilterChange(Sender: TObject);
begin
  SetTableFilter;
  FillSeasonFilter;
end;

procedure TfrmVideoCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmVideoCRUD.FDTable1AfterInsert(DataSet: TDataSet);
begin
  if assigned(cbSerialFilter.Selected) and (cbSerialFilter.Selected.Tag > -1)
  then
    DataSet.FieldByName('serial_code').AsInteger := cbSerialFilter.Selected.Tag;

  if assigned(cbSeasonFilter.Selected) and (cbSeasonFilter.Selected.Tag > -1)
  then
    DataSet.FieldByName('season_code').AsInteger := cbSeasonFilter.Selected.Tag;
end;

procedure TfrmVideoCRUD.FDTable1CalcFields(DataSet: TDataSet);
var
  LSerialLabel: string;
  LSeasonLabel: string;
begin
  if DataSet.FieldByName('serial_code').IsNull or
    (DataSet.FieldByName('serial_code').AsInteger < 1) then
    DataSet.FieldByName('SerialLabel').AsString := ''
  else
    try
      LSerialLabel := DB.FDConnection1.ExecSQLScalar
        ('select label from serial where code=:c',
        [DataSet.FieldByName('serial_code').AsInteger]);
      DataSet.FieldByName('SerialLabel').AsString := LSerialLabel;
    except
      DataSet.FieldByName('SerialLabel').AsString := '';
    end;
  if DataSet.FieldByName('season_code').IsNull or
    (DataSet.FieldByName('season_code').AsInteger < 1) then
    DataSet.FieldByName('SeasonLabel').AsString := ''
  else
    try
      LSeasonLabel := DB.FDConnection1.ExecSQLScalar
        ('select label from season where code=:c',
        [DataSet.FieldByName('season_code').AsInteger]);
      DataSet.FieldByName('SeasonLabel').AsString := LSeasonLabel;
    except
      DataSet.FieldByName('SeasonLabel').AsString := '';
    end;
  if DataSet.FieldByName('SerialLabel').AsString.IsEmpty then
    DataSet.FieldByName('SerialSeasonLabel').AsString :=
      DataSet.FieldByName('SeasonLabel').AsString
  else if DataSet.FieldByName('SeasonLabel').AsString.IsEmpty then
    DataSet.FieldByName('SerialSeasonLabel').AsString :=
      DataSet.FieldByName('SerialLabel').AsString
  else
    DataSet.FieldByName('SerialSeasonLabel').AsString :=
      DataSet.FieldByName('SerialLabel').AsString + ' - ' +
      DataSet.FieldByName('SeasonLabel').AsString;
end;

procedure TfrmVideoCRUD.FillSeasonFilter;
var
  qry: TFDQuery;
  NewItemIndex: integer;
begin
  cbSeasonFilter.beginupdate;
  try
    cbSeasonFilter.Clear;
    cbSeasonFilter.ListItems[cbSeasonFilter.Items.Add('')].Tag := -1;
    if (ffiltercode2 = -1) then
      cbSeasonFilter.itemindex := 0;
    qry := TFDQuery.Create(self);
    try
      qry.Connection := DB.FDConnection1;
      if assigned(cbSerialFilter.Selected) and (cbSerialFilter.Selected.Tag > -1)
      then
        qry.Open('select code, label from season where serial_code=:c order by label',
          [cbSerialFilter.Selected.Tag])
      else
        qry.Open('select code, label from season order by label');
      qry.First;
      while not qry.Eof do
      begin
        NewItemIndex := cbSeasonFilter.Items.Add(qry.FieldByName('label')
          .AsString);
        cbSeasonFilter.ListItems[NewItemIndex].Tag := qry.FieldByName('code')
          .AsInteger;
        if (ffiltercode2 = qry.FieldByName('code').AsInteger) then
          cbSeasonFilter.itemindex := NewItemIndex;
        qry.Next;
      end;
    finally
      qry.Free;
    end;
  finally
    cbSeasonFilter.endupdate;
  end;
end;

procedure TfrmVideoCRUD.FillSerialFilter;
var
  qry: TFDQuery;
  NewItemIndex: integer;
begin
  cbSerialFilter.beginupdate;
  try
    cbSerialFilter.Clear;
    cbSerialFilter.ListItems[cbSerialFilter.Items.Add('')].Tag := -1;
    if (ffiltercode1 = -1) then
      cbSerialFilter.itemindex := 0;
    qry := TFDQuery.Create(self);
    try
      qry.Connection := DB.FDConnection1;
      qry.Open('select code, label from serial order by label');
      qry.First;
      while not qry.Eof do
      begin
        NewItemIndex := cbSerialFilter.Items.Add(qry.FieldByName('label')
          .AsString);
        cbSerialFilter.ListItems[NewItemIndex].Tag := qry.FieldByName('code')
          .AsInteger;
        if (ffiltercode1 = qry.FieldByName('code').AsInteger) then
          cbSerialFilter.itemindex := NewItemIndex;
        qry.Next;
      end;
    finally
      qry.Free;
    end;
  finally
    cbSerialFilter.endupdate;
  end;
end;

function TfrmVideoCRUD.GetFormTitle: string;
begin
  result := 'Video CRUD';
end;

procedure TfrmVideoCRUD.OnHide;
begin
  // TODO : tester si record en ajout/modif pour demander confirmation avant
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
var
  where: string;
begin
  where := '';

  if assigned(cbSerialFilter.Selected) and (cbSerialFilter.Selected.Tag > -1)
  then
    where := '(serial_code=' + cbSerialFilter.Selected.Tag.ToString + ')';

  if assigned(cbSeasonFilter.Selected) and (cbSeasonFilter.Selected.Tag > -1)
  then
    if where.IsEmpty then
      where := '(season_code=' + cbSeasonFilter.Selected.Tag.ToString + ')'
    else
      where := where + ' and (season_code=' +
        cbSeasonFilter.Selected.Tag.ToString + ')';

  if where.IsEmpty then
    FDTable1.Filtered := false
  else
  begin
    FDTable1.Filter := where;
    FDTable1.Filtered := true;
  end;
end;

end.
