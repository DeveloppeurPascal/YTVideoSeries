unit fTubeCRUD;

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
  FMX.Controls.Presentation,
  FMX.ListView.Types,
  FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base,
  FMX.Layouts,
  FMX.ListView,
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
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.Bind.Controls,
  FMX.Bind.Navigator;

type
  TfrmTubeCRUD = class(TRootFrame)
    ListView1: TListView;
    Splitter1: TSplitter;
    Layout1: TLayout;
    FDTable1: TFDTable;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    lblTemplate: TLabel;
    mmoTemplate: TMemo;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    Layout2: TLayout;
    BindNavigator1: TBindNavigator;
    btnOpenURL: TButton;
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    procedure OnShow; override;
    procedure OnHide; override;
  end;

implementation

{$R *.fmx}

uses
  u_urlOpen;

procedure TfrmTubeCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmTubeCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmTubeCRUD.OnHide;
begin
  // TODO : tester si champ en saisie pour demander confirmation avant
  FDTable1.Active := false;
  inherited;
end;

procedure TfrmTubeCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
end;

end.
