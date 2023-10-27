unit fTubeList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  cadRootFrame, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.Layouts,
  FMX.ListView, uDB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Edit,
  System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Data.Bind.Controls, FMX.Bind.Navigator;

type
  TfrmTubeList = class(TRootFrame)
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
    procedure FDTable1BeforePost(DataSet: TDataSet);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure OnShow; override;
    procedure OnHide; override;

  end;

implementation

{$R *.fmx}

uses u_urlOpen;

procedure TfrmTubeList.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmTubeList.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmTubeList.FDTable1BeforePost(DataSet: TDataSet);
begin
  if FDTable1.FieldByName('id').AsString.IsEmpty then
    FDTable1.FieldByName('id').AsString := ''; // TODO : generer valeur ID
end;

procedure TfrmTubeList.OnHide;
begin
  // TODO : tester si champ en saisie pour demandeer confirmation avant
  FDTable1.Active := false;
  inherited;
end;

procedure TfrmTubeList.OnShow;
begin
  inherited;
  FDTable1.Active := true;
end;

end.
