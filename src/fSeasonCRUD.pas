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
  Data.Bind.DBScope,
  FMX.Calendar;

type
  TfrmSeasonCRUD = class(TRootFrame)
    FDTable1: TFDTable;
    lLeft: TLayout;
    Splitter1: TSplitter;
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
    sbRight: TVertScrollBox;
    edtSerialLabel: TEdit;
    btnSerialSelect: TButton;
    LinkControlToField6: TLinkControlToField;
    FDTable1keyword: TWideMemoField;
    lblKeywords: TLabel;
    edtKeywords: TEdit;
    LinkControlToField7: TLinkControlToField;
    lRight: TLayout;
    btnTubesLinks: TButton;
    btnVideos: TButton;
    btnShowCalendar: TDropDownEditButton;
    Popup1: TPopup;
    Calendar1: TCalendar;
    procedure FDTable1CalcFields(DataSet: TDataSet);
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnSerialSelectClick(Sender: TObject);
    procedure cbSerialFilterChange(Sender: TObject);
    procedure btnVideosClick(Sender: TObject);
    procedure btnTubesLinksClick(Sender: TObject);
    procedure FDTable1AfterPost(DataSet: TDataSet);
    procedure Calendar1DateSelected(Sender: TObject);
    procedure btnShowCalendarClick(Sender: TObject);
  private
  protected
    procedure SetTableFilter;
    procedure FillSerialFilter;
  public
    procedure OnShow; override;
    procedure OnHide; override;
    function GetFormTitle: string; override;
  end;

implementation

{$R *.fmx}

uses
  FMX.DialogService,
  System.DateUtils,
  u_urlOpen,
  fSelectRecord,
  fMain,
  fVideoCRUD,
  fSeasonTubeLinkCRUD;

procedure TfrmSeasonCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSeasonCRUD.btnSerialSelectClick(Sender: TObject);
var
  code: integer;
begin
  code := TfrmSelectRecord.FromSerialTable;
  if (code >= 0) then
  begin
    if assigned(ListView1.Selected) then
      FDTable1.Edit
    else
      FDTable1.insert;
    FDTable1.FieldByName('serial_code').AsInteger := code;
  end;
end;

procedure TfrmSeasonCRUD.btnShowCalendarClick(Sender: TObject);
begin
  Popup1.Width := Calendar1.Margins.Left + Calendar1.Width +
    Calendar1.Margins.right;
  Popup1.Height := Calendar1.Margins.top + Calendar1.Height +
    Calendar1.Margins.Bottom;
  Popup1.IsOpen := not Popup1.IsOpen;
  if Popup1.IsOpen then
    Calendar1.TagString := edtRecordDate.Text;
end;

procedure TfrmSeasonCRUD.btnTubesLinksClick(Sender: TObject);
var
  frm: TfrmSeasonTubeLinkCRUD;
begin
  frm := TfrmSeasonTubeLinkCRUD.Create(self, 'season_code',
    FDTable1.FieldByName('code').AsInteger);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmSeasonCRUD.btnVideosClick(Sender: TObject);
begin
  if FDTable1.State in dsEditModes then
  begin
    TDialogService.MessageDialog
      ('This record has been edited. Do you want to save the changes ?',
      TMsgDlgType.mtWarning, mbyesno, tmsgdlgbtn.mbYes, 0,
      procedure(const AResult: TModalResult)
      begin
        case AResult of
          mryes:
            FDTable1.Post;
        else
          FDTable1.Cancel;
        end;
        frmmain.CurrentScreen := TfrmVideoCRUD.GetInstance<TfrmVideoCRUD>(self,
          FDTable1.FieldByName('serial_code').AsInteger,
          FDTable1.FieldByName('code').AsInteger);
      end);
  end
  else
    frmmain.CurrentScreen := TfrmVideoCRUD.GetInstance<TfrmVideoCRUD>(self,
      FDTable1.FieldByName('serial_code').AsInteger,
      FDTable1.FieldByName('code').AsInteger);
end;

procedure TfrmSeasonCRUD.Calendar1DateSelected(Sender: TObject);
begin
  if not(FDTable1.State in dsEditModes) then
    FDTable1.Edit;

  FDTable1.FieldByName('record_date').AsString :=
    Calendar1.DateTime.ToISO8601.Substring(0, 10);
end;

procedure TfrmSeasonCRUD.cbSerialFilterChange(Sender: TObject);
begin
  SetTableFilter;
end;

procedure TfrmSeasonCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmSeasonCRUD.FDTable1AfterPost(DataSet: TDataSet);
begin
  DB.FDConnection1.ExecSQL('update video set serial_code=' +
    DataSet.FieldByName('serial_code').AsString + ' where season_code=' +
    DataSet.FieldByName('code').AsString);
end;

procedure TfrmSeasonCRUD.FDTable1CalcFields(DataSet: TDataSet);
var
  LSerialLabel: string;
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
end;

procedure TfrmSeasonCRUD.FillSerialFilter;
var
  qry: TFDQuery;
  NewItemIndex: integer;
begin
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
end;

function TfrmSeasonCRUD.GetFormTitle: string;
begin
  result := 'Season CRUD';
end;

procedure TfrmSeasonCRUD.SetTableFilter;
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

procedure TfrmSeasonCRUD.OnHide;
begin
  if FDTable1.State in dsEditModes then
  begin
    TDialogService.MessageDialog
      ('This record has been edited. Do you want to save the changes ?',
      TMsgDlgType.mtWarning, mbyesno, tmsgdlgbtn.mbYes, 0,
      procedure(const AResult: TModalResult)
      begin
        case AResult of
          mryes:
            FDTable1.Post;
        else
          FDTable1.Cancel;
        end;
        FDTable1.Active := false;
      end);
  end
  else
    FDTable1.Active := false;
  inherited;
end;

procedure TfrmSeasonCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
  FillSerialFilter;
end;

end.
