unit fSerialCRUD;

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
  FMX.Layouts,
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
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Bind.Navigator,
  FMX.ListView,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  uDB,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope;

type
  TfrmSerialCRUD = class(TRootFrame)
    lLeft: TLayout;
    Splitter1: TSplitter;
    ListView1: TListView;
    BindNavigator1: TBindNavigator;
    FDTable1: TFDTable;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    mmoComment: TMemo;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    sbRight: TVertScrollBox;
    lblKeywords: TLabel;
    edtKeywords: TEdit;
    LinkControlToField4: TLinkControlToField;
    btnSeasons: TButton;
    btnVideos: TButton;
    lBottomMargin: TLayout;
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnSeasonsClick(Sender: TObject);
    procedure btnVideosClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure OnShow; override;
    procedure OnHide; override;
    function GetFormTitle: string; override;
  end;

implementation

{$R *.fmx}

uses
  u_urlOpen,
  fMain,
  fSeasonCRUD,
  fVideoCRUD;

procedure TfrmSerialCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSerialCRUD.btnSeasonsClick(Sender: TObject);
begin
  // TODO : tester si record en ajout/modif pour demander confirmation avant
  frmmain.CurrentScreen := TfrmSeasonCRUD.GetInstance<TfrmSeasonCRUD>(self,
    FDTable1.FieldByName('code').AsInteger);
end;

procedure TfrmSerialCRUD.btnVideosClick(Sender: TObject);
begin
  // TODO : tester si record en ajout/modif pour demander confirmation avant
  frmmain.CurrentScreen := TfrmVideoCRUD.GetInstance<TfrmVideoCRUD>(self,
    FDTable1.FieldByName('code').AsInteger);
end;

procedure TfrmSerialCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

function TfrmSerialCRUD.GetFormTitle: string;
begin
  result := 'Serial CRUD';
end;

procedure TfrmSerialCRUD.OnHide;
begin
  // TODO : tester si record en ajout/modif pour demander confirmation avant
  FDTable1.Active := false;
  inherited;
end;

procedure TfrmSerialCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
end;

end.
