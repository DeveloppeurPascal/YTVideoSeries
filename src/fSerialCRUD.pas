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
  Signature : 6356528e5a306e89af2b482c01ab5728c7656652
  ***************************************************************************
*)

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
        btnTubesLinksClick(Sender);
      end);
  end
  else
  begin
    frm := TfrmSerialTubeLinkCRUD.Create(self, 'serial_code',
      FDTable1.FieldByName('code').AsInteger);
    try
      frm.ShowModal;
    finally
      frm.Free;
    end;
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
  FDTable1.BeforeDelete := DB.BeforeDeleteOnTable;
  FDTable1.Active := true;
end;

end.
