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
  Signature : 567a152d69a577b1cf17b684c4604a244e14475a
  ***************************************************************************
*)

unit fShowMemo;

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
  FMX.Memo.Types,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Memo;

type
  TfrmShowMemo = class(TForm)
    Memo1: TMemo;
    Layout1: TLayout;
    btnClose: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    class procedure Execute(AOwner: TComponent;
      Const AFormCaption, AText: string);
  end;

implementation

{$R *.fmx}
{ TfrmShowMemo }

class procedure TfrmShowMemo.Execute(AOwner: TComponent;
  Const AFormCaption, AText: string);
var
  frm: TfrmShowMemo;
begin
  frm := TfrmShowMemo.Create(AOwner);
  try
    frm.Caption := AFormCaption;
    frm.Memo1.Text := AText;
    frm.showmodal;
  finally
    frm.Free;
  end;
end;

procedure TfrmShowMemo.FormShow(Sender: TObject);
begin
  Memo1.SetFocus;
end;

end.
