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
  File last update : 2025-10-16T10:43:21.480+02:00
  Signature : 40e202b178b8224b92ed17e2401784b322a8c37f
  ***************************************************************************
*)

unit uDMLogo;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TDMLogo = class(TDataModule)
    ProgIcon: TImageList;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DMLogo: TDMLogo;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
