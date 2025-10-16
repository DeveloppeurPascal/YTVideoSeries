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
  Signature : 8401ad92ce5064d14c415ae36b2bcfb9b4e39bfe
  ***************************************************************************
*)

unit fVideoTubeLinkCRUD;

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
  fRootTubeLink,
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
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  System.Rtti,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Bind.Navigator,
  FMX.ListView,
  FMX.Edit,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  uDB,
  FMX.Calendar;

type
  TfrmVideoTubeLinkCRUD = class(TfrmRootTubeLink)
    FDTable1tube_code: TIntegerField;
    FDTable1video_code: TIntegerField;
    FDTable1publish_date: TWideMemoField;
    FDTable1url: TWideMemoField;
    FDTable1comment: TWideMemoField;
    FDTable1label: TWideMemoField;
    FDTable1embed: TWideMemoField;
    FDTable1keyword: TWideMemoField;
    edtKeywords: TEdit;
    edtLabel: TEdit;
    edtURL: TEdit;
    btnOpenURL: TButton;
    lblComment: TLabel;
    lblKeywords: TLabel;
    lblLabel: TLabel;
    lblURL: TLabel;
    mmoComment: TMemo;
    lblPublishedDate: TLabel;
    edtPublishedDate: TEdit;
    lblEmbed: TLabel;
    mmoEmbed: TMemo;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField6: TLinkControlToField;
    btnShowCalendar: TDropDownEditButton;
    Popup1: TPopup;
    Calendar1: TCalendar;
    procedure FormCreate(Sender: TObject);
    procedure edtURLChangeTracking(Sender: TObject);
    procedure btnOpenURLClick(Sender: TObject);
    procedure ListView1ButtonClick(const Sender: TObject;
      const AItem: TListItem; const AObject: TListItemSimpleControl);
    procedure Calendar1DateSelected(Sender: TObject);
    procedure btnShowCalendarClick(Sender: TObject);
  private

  protected
    function GetLabelFromTheFilter: string; override;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmVideoTubeLinkCRUD: TfrmVideoTubeLinkCRUD;

implementation

{$R *.fmx}

uses
  System.DateUtils,
  u_urlOpen,
  uBuilder,
  fShowMemo;

{ TfrmVideoTubeLinkCRUD }

procedure TfrmVideoTubeLinkCRUD.btnOpenURLClick(Sender: TObject);
begin
  if not edtURL.Text.IsEmpty then
    url_Open_In_Browser(edtURL.Text);
end;

procedure TfrmVideoTubeLinkCRUD.btnShowCalendarClick(Sender: TObject);
begin
  Popup1.Width := Calendar1.Margins.Left + Calendar1.Width +
    Calendar1.Margins.right;
  Popup1.Height := Calendar1.Margins.top + Calendar1.Height +
    Calendar1.Margins.Bottom;
  Popup1.IsOpen := not Popup1.IsOpen;
  if Popup1.IsOpen then
    Calendar1.TagString := edtPublishedDate.Text;
end;

procedure TfrmVideoTubeLinkCRUD.Calendar1DateSelected(Sender: TObject);
begin
  if not(FDTable1.State in dsEditModes) then
    FDTable1.Edit;

  FDTable1.FieldByName('publish_date').AsString :=
    Calendar1.DateTime.ToISO8601.Substring(0, 10);
end;

procedure TfrmVideoTubeLinkCRUD.edtURLChangeTracking(Sender: TObject);
begin
  btnOpenURL.Enabled := not edtURL.Text.IsEmpty;
end;

procedure TfrmVideoTubeLinkCRUD.FormCreate(Sender: TObject);
begin
  btnOpenURL.Enabled := false;
end;

function TfrmVideoTubeLinkCRUD.GetLabelFromTheFilter: string;
begin
  result := DB.FDConnection1.ExecSQLScalar
    ('select label from video where code=:c', [FFilterFieldValue]);
end;

procedure TfrmVideoTubeLinkCRUD.ListView1ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);
var
  ExportedText: string;
begin
  ExportedText := GetTextFromTemplate(FDTable1.FieldByName('video_code')
    .AsInteger, FDTable1.FieldByName('tube_code').AsInteger);
  TfrmShowMemo.Execute(self, 'Exported text', ExportedText);
end;

end.
