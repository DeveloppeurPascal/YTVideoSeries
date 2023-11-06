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

  protected
    FFilterCode1, FFilterCode2: integer;
  public
    class function GetInstance<T: TRootFrame>(AOwner: TComponent;
      FilterCode1: integer = -1; FilterCode2: integer = -1): T;
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure Finalize; virtual;
    procedure OnShow; virtual;
    procedure OnHide; virtual;
    constructor Create(AOwner: TComponent); override;
    function GetFormTitle: string; virtual; abstract;
  end;

implementation

{$R *.fmx}

constructor TRootFrame.Create(AOwner: TComponent);
begin
  if not FDirectCreate then
  begin
    inherited;
    FFilterCode1 := -1;
    FFilterCode2 := -1;
  end
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

class function TRootFrame.GetInstance<T>(AOwner: TComponent;
  FilterCode1, FilterCode2: integer): T;
var
  rf: TRootFrame;
begin
  if not FInstanceList.trygetvalue(ClassName, rf) then
    try
      FDirectCreate := false;
      result := T.Create(AOwner);
      FDirectCreate := true;
      result.Align := TAlignLayout.Client;
      result.FFilterCode1 := FilterCode1;
      result.FFilterCode2 := FilterCode2;
      result.Initialize;
      FInstanceList.Add(ClassName, result);
    except
      result := nil;
    end
  else
  begin
    result := T(rf);
    result.FFilterCode1 := FilterCode1;
    result.FFilterCode2 := FilterCode2;
  end;
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
