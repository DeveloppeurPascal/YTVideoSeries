unit fSelectRecord;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Layouts,
  FMX.ListView,
  uDB,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmSelectRecord = class(TForm)
    ListView1: TListView;
    GridPanelLayout1: TGridPanelLayout;
    FDQuery1: TFDQuery;
    btnSelect: TButton;
    btnCancel: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure FormCreate(Sender: TObject);
    procedure ListView1Change(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Déclarations privées }
    class function CreateAndShowSelectForm(ASQL: string): integer;
  public
    { Déclarations publiques }
    class function FromTubeTable: integer;
    class function FromSerialTable: integer;
    class function FromSeasonTable: integer;
  end;

implementation

{$R *.fmx}

class function TfrmSelectRecord.CreateAndShowSelectForm(ASQL: string): integer;
var
  frm: TfrmSelectRecord;
begin
result := -1;
  frm := TfrmSelectRecord.Create(nil);
  try
    frm.FDQuery1.Open(ASQL);
    if frm.ListView1.ItemCount > 0 then
    begin
      frm.ListView1.Itemindex := 0; // don't call onChange event
      if assigned(frm.ListView1.OnChange) then
        frm.ListView1.OnChange(frm.ListView1);
    end;
    case frm.ShowModal of
      mrCancel:
        result := -1;
      mrOk:
        result := frm.FDQuery1.FieldByName('code').asinteger;
    end;
  finally
    frm.Free;
  end;
end;

procedure TfrmSelectRecord.FormCreate(Sender: TObject);
begin
  FDQuery1.Active := false;
  btnSelect.Enabled := false;
end;

class function TfrmSelectRecord.FromSeasonTable: integer;
begin
  try
    result := CreateAndShowSelectForm
      ('select season.code, season.label, serial.label as url from season, serial where season.serial_code=serial.code order by serial.label, season.label');
  except
    result := -1;
  end;
end;

class function TfrmSelectRecord.FromSerialTable: integer;
begin
  try
    result := CreateAndShowSelectForm
      ('select code, label, url from serial order by label');
  except
    result := -1;
  end;
end;

class function TfrmSelectRecord.FromTubeTable: integer;
begin
  try
    result := CreateAndShowSelectForm
      ('select code, label, url from tube order by label');
  except
    result := -1;
  end;
end;

procedure TfrmSelectRecord.ListView1Change(Sender: TObject);
begin
  btnSelect.Enabled := ListView1.Itemindex >= 0;
end;

procedure TfrmSelectRecord.ListView1DblClick(Sender: TObject);
begin
  modalresult := mrOk;
end;

end.
