unit cadRootFrame;

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
  System.Generics.Collections;

type
  TRootFrame = class(TFrame)
  private
  class var
    FInstanceList: TDictionary<string, TRootFrame>;
    FDirectCreate: boolean;
  public
    class function GetInstance<T: TRootFrame>(AOwner: TComponent): T;
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure OnShow; virtual;
    procedure OnHide; virtual;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}
{ TFrame1 }

constructor TRootFrame.Create(AOwner: TComponent);
begin
  if not FDirectCreate then
    inherited
  else
    raise exception.Create('Use GetInstance<T>');
end;

destructor TRootFrame.Destroy;
begin
  Finalize;
  inherited;
end;

procedure TRootFrame.Finalize;
begin
  // nothing to do at this level
end;

class function TRootFrame.GetInstance<T>(AOwner: TComponent): T;
var
  rf: TRootFrame;
begin
  if not FInstanceList.trygetvalue(ClassName, rf) then
    try
      FDirectCreate := false;
      result := T.Create(AOwner);
      FDirectCreate := true;
      result.Align := TAlignLayout.Client;
      result.Initialize;
      FInstanceList.Add(ClassName, result);
    except
      result := nil;
    end
  else
    result := T(rf);
end;

procedure TRootFrame.Initialize;
begin
  // nothing to do at this level
end;

procedure TRootFrame.OnHide;
begin
  visible := false;
end;

procedure TRootFrame.OnShow;
begin
  visible := true;
end;

initialization

TRootFrame.FInstanceList := TDictionary<string, TRootFrame>.Create;
TRootFrame.FDirectCreate := true;

finalization

freeandnil(TRootFrame.FInstanceList);

end.
