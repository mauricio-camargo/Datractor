unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  SpinEx;

type

  { TForm3 }

  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    EdVal: TFloatSpinEditEx;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.FormActivate(Sender: TObject);
begin
  EdVal.SelectAll;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  EdVal.SelectAll;

end;

end.

