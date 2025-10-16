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
  Signature : bef3d74848177fd3f43c415af29dec28dc75a3f3
  ***************************************************************************
*)

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
  uDB,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmRootTubeLink = class(TForm)
    lLeft: TLayout;
    Splitter1: TSplitter;
    sRight: TVertScrollBox;
    lBottomMargin: TLayout;
    ListView1: TListView;
    BindNavigator1: TBindNavigator;
    lBottom: TLayout;
    btnClose: TButton;
    FDTable1: TFDTable;
    FDTable1TubeLabel: TStringField;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    procedure btnCloseClick(Sender: TObject);
    procedure FDTable1AfterInsert(DataSet: TDataSet);
    procedure FDTable1CalcFields(DataSet: TDataSet);
    procedure ListView1Change(Sender: TObject);
    procedure FDTable1BeforePost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Déclarations privées }
  protected
    FFilterFieldName: string;
    FFilterFieldValue: integer;
    /// <summary>
    /// used to fill the edit fields with default values (or use Live Bindings in descendant forms)
    /// </summary>
    procedure initFieldsForInsert; virtual;
    /// <summary>
    /// used to fill the edit fields with record fields values (or use Live Bindings in descendant forms)
    /// </summary>
    procedure initFieldsFromTable; virtual;
    /// <summary>
    /// used to fill the record fields values from the edit fields (or use Live Bindings in descendant forms)
    /// </summary>
    procedure FillTableFromFields; virtual;
    /// <summary>
    /// Fill the caption of the form
    /// </summary>
    function GetLabelFromTheFilter: string; virtual; abstract;
  public
    constructor Create(AOwner: TComponent; AFilterFieldName: string;
      AFilterFieldValue: integer);
  end;

var
  frmRootTubeLink: TfrmRootTubeLink;

implementation

{$R *.fmx}

uses
  FMX.DialogService,
  fSelectRecord;

procedure TfrmRootTubeLink.btnCloseClick(Sender: TObject);
begin
  close;
end;

constructor TfrmRootTubeLink.Create(AOwner: TComponent;
  AFilterFieldName: string; AFilterFieldValue: integer);
begin
  inherited Create(AOwner);
  FFilterFieldName := AFilterFieldName;
  FFilterFieldValue := AFilterFieldValue;

  caption := GetLabelFromTheFilter;

  FDTable1.Filter := FFilterFieldName + '=' + FFilterFieldValue.tostring;
  FDTable1.Filtered := true;
  FDTable1.Open;
end;

procedure TfrmRootTubeLink.FDTable1AfterInsert(DataSet: TDataSet);
var
  SelectedTubeCode: integer;
  code: integer;
begin
  SelectedTubeCode := TfrmSelectRecord.FromTubeTable;
  if (SelectedTubeCode < 0) then
    FDTable1.Cancel
  else
  begin
    code := DB.FDConnection1.execsqlscalar('select tube_code from ' +
      FDTable1.TableName + ' where (tube_code=:tc) and (' + FFilterFieldName +
      '=:fc)', [SelectedTubeCode, FFilterFieldValue]);
    if code = SelectedTubeCode then
      FDTable1.Cancel
    else
    begin
      FDTable1.FieldByName('tube_code').AsInteger := SelectedTubeCode;
      FDTable1.FieldByName(FFilterFieldName).AsInteger := FFilterFieldValue;
      initFieldsForInsert;
    end;
  end;
end;

procedure TfrmRootTubeLink.FDTable1BeforePost(DataSet: TDataSet);
begin
  FillTableFromFields;
  DB.InitDefaultFieldsValues(DataSet);
end;

procedure TfrmRootTubeLink.FDTable1CalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('TubeLabel').AsString := DB.FDConnection1.execsqlscalar
    ('select label from tube where code=:c',
    [DataSet.FieldByName('tube_code').AsInteger]);
end;

procedure TfrmRootTubeLink.FillTableFromFields;
begin
  // Do nothing at this level
end;

procedure TfrmRootTubeLink.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FDTable1.State in dsEditModes then
  begin
    CanClose := false;
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
        tthread.forcequeue(nil,
          procedure
          begin
            close;
          end);
      end);
  end
  else
    CanClose := true;
end;

procedure TfrmRootTubeLink.initFieldsForInsert;
begin
  // Do nothing at this level
end;

procedure TfrmRootTubeLink.initFieldsFromTable;
begin
  // Do nothing at this level
end;

procedure TfrmRootTubeLink.ListView1Change(Sender: TObject);
begin
  initFieldsFromTable;
end;

end.
