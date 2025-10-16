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
  Signature : 26ed0f989cde3a2825902b1b8907724c4b202df2
  ***************************************************************************
*)

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
