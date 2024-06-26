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
    FDTable1: TFDTable;
    lblLabel: TLabel;
    edtLabel: TEdit;
    lblURL: TLabel;
    edtURL: TEdit;
    lblTemplateComment: TLabel;
    mmoTemplateComment: TMemo;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    lLeft: TLayout;
    BindNavigator1: TBindNavigator;
    btnOpenURL: TButton;
    sbRight: TVertScrollBox;
    lblTemplateLabel: TLabel;
    lblTemplateKeywords: TLabel;
    mmoTemplateLabel: TMemo;
    mmoTemplateKeywords: TMemo;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    lBottomMargin: TLayout;
    lRight: TLayout;
    btnExportAllVideos: TButton;
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
    procedure btnExportAllVideosClick(Sender: TObject);
  private
    { D�clarations priv�es }
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
  uBuilder,
  fShowMemo;

procedure TfrmTubeCRUD.btnExportAllVideosClick(Sender: TObject);
var
  ExportedText: string;
  Qry: TFDQuery;
begin
  ExportedText := '';
  Qry := TFDQuery.Create(self);
  try
    Qry.Connection := FDTable1.Connection;
    Qry.sql.Text :=
      'select video_tube.video_code, video.label as video_label, season.label as season_label, serial.label as serial_label '
      + 'from video_tube, video, season, serial ' +
      'where (serial.code=video.serial_code) and (season.code=video.season_code) and'
      + ' (video_tube.video_code=video.code) and (video_tube.tube_code=' +
      FDTable1.FieldByName('code').asstring + ') ' +
      'order by serial.label, season.label, video.label';
    Qry.Open;
    while not Qry.eof do
    begin
      ExportedText := ExportedText + '****************************************'
        + slinebreak;
      ExportedText := ExportedText + FDTable1.FieldByName('label').asstring +
        slinebreak;
      ExportedText := ExportedText + Qry.FieldByName('serial_label').asstring +
        slinebreak;
      ExportedText := ExportedText + Qry.FieldByName('season_label').asstring +
        slinebreak;
      ExportedText := ExportedText + Qry.FieldByName('video_label').asstring +
        slinebreak;
      ExportedText := ExportedText + '****************************************'
        + slinebreak;
      ExportedText := ExportedText + slinebreak;
      ExportedText := ExportedText + GetTextFromTemplate
        (Qry.FieldByName('video_code').AsInteger, FDTable1.FieldByName('code')
        .AsInteger);
      ExportedText := ExportedText + slinebreak;
      Qry.next;
    end;
  finally
    Qry.free;
  end;
  TfrmShowMemo.Execute(self, 'Exported text', ExportedText);
end;

procedure TfrmTubeCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmTubeCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

function TfrmTubeCRUD.GetFormTitle: string;
begin
  result := 'Tube CRUD';
end;

procedure TfrmTubeCRUD.OnHide;
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

procedure TfrmTubeCRUD.OnShow;
begin
  inherited;
  btnOpenURL.Enabled := false;
  FDTable1.BeforePost := DB.InitDefaultFieldsValues;
  FDTable1.BeforeDelete := DB.BeforeDeleteOnTable;
  FDTable1.Active := true;
end;

end.
