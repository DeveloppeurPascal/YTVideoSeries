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
