unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ATLinkLabel,
  LCLIntf;

type

  { TForm3 }

  TForm3 = class(TForm)
    ATLabelLink1: TATLabelLink;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure ATLabelLink1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm3.ATLabelLink1Click(Sender: TObject);
begin
  OpenURL(ATLabelLink1.Caption);
end;

end.

