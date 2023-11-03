unit fSelectRecord;

// TODO : pr�renseigner la s�lection avec la valeur actuelle (si elle existe)
// TODO : ressortir aussi le libell� de la ligne pour ne pas le recharger apr�s

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
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { D�clarations priv�es }
    class function CreateAndShowSelectForm(ASQL: string): integer;
  public
    { D�clarations publiques }
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
  frm := TfrmSelectRecord.Create(nil);
  try
    frm.FDQuery1.Open(ASQL);
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

procedure TfrmSelectRecord.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  btnSelect.Enabled := true;
end;

end.
