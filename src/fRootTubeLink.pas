unit fRootTubeLink;

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
  FMX.Layouts,
  FMX.StdCtrls,
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
  FMX.Controls.Presentation,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Bind.Navigator,
  FMX.ListView,
  uDB;

type
  TfrmRootTubeLink = class(TForm)
    lTop: TLayout;
    lLeft: TLayout;
    Splitter1: TSplitter;
    sRight: TVertScrollBox;
    lBottomMargin: TLayout;
    ListView1: TListView;
    BindNavigator1: TBindNavigator;
    lBottom: TLayout;
    btnClose: TButton;
    Label1: TLabel;
    FDQuery1: TFDQuery;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FDTable1AfterInsert(DataSet: TDataSet);
  private
    { Déclarations privées }
    FManualInsert: boolean;
    FTableName: string;
    FFilterFieldName: string;
    FFilterFieldValue: integer;
  protected
  public
    constructor Create(AOwner: TComponent; ATableName, AFilterFieldName: string;
      AFilterFieldValue: integer);
  end;

var
  frmRootTubeLink: TfrmRootTubeLink;

implementation

{$R *.fmx}

uses
  fSelectRecord;

procedure TfrmRootTubeLink.btnCloseClick(Sender: TObject);
begin
  close;
end;

constructor TfrmRootTubeLink.Create(AOwner: TComponent;
  ATableName, AFilterFieldName: string; AFilterFieldValue: integer);
begin
  inherited Create(AOwner);
  FDQuery1.Open('select ' + ATableName + '.*, tube.label as tube_label from ' +
    ATableName + ',tube where (' + ATableName + '.tube_code=tube.code) and (' +
    ATableName + '.' + AFilterFieldName + '=' + AFilterFieldValue.tostring +
    ') order by tube_label');
end;

procedure TfrmRootTubeLink.FDTable1AfterInsert(DataSet: TDataSet);
var
  code: integer;
begin
  // if not FManualInsert then
  // begin
  // code := TfrmSelectRecord.FromSerialTable;
  // if (code >= 0) then
  // begin
  // if assigned(ListView1.Selected) then
  // FDTable1.Edit
  // else
  // FDTable1.insert;
  // FDTable1.FieldByName('serial_code').AsInteger := code;
  // cancel;
  // end;
  // end;
  // TODO : sélectionner tube pour remplir le champ correspondant et vérifier qu'il n'y est pas déjà
end;

procedure TfrmRootTubeLink.FormCreate(Sender: TObject);
begin
  FManualInsert := false;
end;

end.
