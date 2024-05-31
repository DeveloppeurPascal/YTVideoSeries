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
    lRight: TLayout;
    btnTubesLinks: TButton;
    btnVideos: TButton;
    btnSeasons: TButton;
    procedure btnOpenURLClick(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnSeasonsClick(Sender: TObject);
    procedure btnVideosClick(Sender: TObject);
    procedure btnTubesLinksClick(Sender: TObject);
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
  FMX.DialogService,
  u_urlOpen,
  fMain,
  fSeasonCRUD,
  fVideoCRUD,
  fSerialTubeLinkCRUD;

procedure TfrmSerialCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmSerialCRUD.btnSeasonsClick(Sender: TObject);
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
        frmmain.CurrentScreen := TfrmSeasonCRUD.GetInstance<TfrmSeasonCRUD>
          (self, FDTable1.FieldByName('code').AsInteger);
      end);
  end
  else
    frmmain.CurrentScreen := TfrmSeasonCRUD.GetInstance<TfrmSeasonCRUD>(self,
      FDTable1.FieldByName('code').AsInteger);
end;

procedure TfrmSerialCRUD.btnTubesLinksClick(Sender: TObject);
var
  frm: TfrmSerialTubeLinkCRUD;
begin
  frm := TfrmSerialTubeLinkCRUD.Create(self, 'serial_code',
    FDTable1.FieldByName('code').AsInteger);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmSerialCRUD.btnVideosClick(Sender: TObject);
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
          FDTable1.FieldByName('code').AsInteger);
      end);
  end
  else
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

procedure TfrmSerialCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.Active := true;
end;

end.
