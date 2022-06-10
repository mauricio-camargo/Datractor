unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, ValEdit, Grids, ComCtrls, JvMovableBevel, RTTICtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckB1: TCheckBox;
    EdX1: TEdit;
    EdX2: TEdit;
    EdY1: TEdit;
    EdY2: TEdit;
    ExtractBtn: TSpeedButton;
    img: TImage;
    JvMovablePanel1: TJvMovablePanel;
    Memo1: TMemo;
    SaveBtn: TSpeedButton;
    label4: TLabel;
    label5: TLabel;
    label6: TLabel;
    BtnStart: TSpeedButton;
    label7: TLabel;
    MkX1lab: TLabel;
    label3: TLabel;
    MkX2lab: TLabel;
    MkY1lab: TLabel;
    MkY2lab: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    CoordXlab: TLabel;
    CoordYlab: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel3: TPanel;
    SaveDialog1: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SG: TStringGrid;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure CheckB1Change(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ExtractBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  ax1,ax2,ay1,ay2,Cont: Integer;
  bx1,bx2,by1,by2: double;
  CalibrateOk: Boolean;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.CheckB1Change(Sender: TObject);
begin
img.Stretch:=CheckB1.Checked;
//img.Align:=alClient;
end;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
Screen.Cursor:=crCross;
MkX1lab.Caption:='Waiting...';
EdX1.SetFocus;
ExtractBtn.Enabled:=True;
SaveBtn.Enabled:=True;
end;

procedure TForm1.SaveBtnClick(Sender: TObject);
var i: integer;
begin
if not SaveDialog1.Execute then Exit;
Memo1.Lines.Clear;
for i:=0 to SG.RowCount-1 do
 Memo1.Lines.Add(SG.Cells[0,i]+';'+SG.Cells[1,i]+';'+SG.Cells[2,i]);
Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.ExtractBtnClick(Sender: TObject);
begin
CalibrateOk:=False;
if ExtractBtn.Caption='Extract points' then begin
 try
  ax1:=StrToInt(MkX1lab.Caption);
  ax2:=StrToInt(MkX2lab.Caption);
  ay1:=StrToInt(MkY1lab.Caption);
  ay2:=StrToInt(MkY2lab.Caption);
 except on exception do begin
  ShowMessage('Please, press "Start calibration"');
  Exit;
 end;
 end;
 try
  bx1:=StrToFloat(EdX1.Text);
  bx2:=StrToFloat(EdX2.Text);
  by1:=StrToFloat(EdY1.Text);
  by2:=StrToFloat(EdY2.Text);
  except on exception do
   ShowMessage('Please, inform all values in graphs, using point (.) as decimal deparator');
  end;
 ExtractBtn.Caption:='STOP EXTRACTING';
 Screen.Cursor:=crCross;
 CalibrateOk:=True;
end else begin
 ExtractBtn.Caption:='Extract points';
 Screen.Cursor:=crDefault;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
SG.Cells[0,0]:='N';
SG.Cells[1,0]:='Y value';
SG.Cells[2,0]:='X value';
end;

procedure TForm1.imgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Dax,Day,R: integer;
Dbx,Dby,Rx,Ry: Double;
begin
if MkX1lab.Caption='Waiting...' then begin
 MkX1lab.Caption:=IntToStr(X);
 MkX2lab.Caption:='Waiting...';
 EdX2.SetFocus;
 Exit;
end;
if MkX2lab.Caption='Waiting...' then begin
 MkX2lab.Caption:=IntToStr(X);
 MkY1lab.Caption:='Waiting...';
 EdY1.SetFocus;
 Exit;
end;
if MkY1lab.Caption='Waiting...' then begin
 MkY1lab.Caption:=IntToStr(Y);
 MkY2lab.Caption:='Waiting...';
 EdY2.SetFocus;
 Exit;
end;
if MkY2lab.Caption='Waiting...' then begin
 MkY2lab.Caption:=IntToStr(Y);
 Screen.Cursor:=crDefault;
 Exit;
end;
if ExtractBtn.Caption='STOP EXTRACTING' then begin
 //Interpoladores lineares
 Ry:=(by1)+(((Y-ay1)/(ay2-ay1))*(by2-by1));
 Rx:=(bx1)+(((X-ax1)/(ax2-ax1))*(bx2-bx1));
 SG.RowCount:=SG.RowCount+1;
 SG.Cells[0,SG.RowCount-1]:=IntToStr(SG.RowCount-1);
 SG.Cells[1,SG.RowCount-1]:=FloatToStrF(Ry,ffFixed,8,2);
 SG.Cells[2,SG.RowCount-1]:=FloatToStrF(Rx,ffFixed,8,2);

end;
SG.AutoSizeColumn(0);
SG.AutoSizeColumn(1);
SG.AutoSizeColumn(2);
end;

procedure TForm1.imgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var Ry,Rx: Double;
begin
Rx:=X;
Ry:=Y;
if CalibrateOk then begin
 Ry:=(by1)+(((Y-ay1)/(ay2-ay1))*(by2-by1));
 Rx:=(bx1)+(((X-ax1)/(ax2-ax1))*(bx2-bx1));
end;
CoordXlab.Caption:=FloatToStrF(Rx,ffFixed,8,2);
CoordYlab.Caption:=FloatToStrF(Ry,ffFixed,8,2);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;
  img.Picture.LoadFromFile(OpenDialog1.FileName);
  CheckB1.Enabled:=True;
  BtnStart.Enabled:=True;
  ExtractBtn.Enabled:=True;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var i: integer;
begin
if SG.RowCount>1 then
  SG.DeleteRow(SG.Row);
for i:=1 to SG.RowCount-1 do
 SG.Cells[0,i]:=IntToStr(i);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  ShowMessage(
  'Free-software license by Maurício Camargo'+#13#13+
  'https://github.com/mauricio-camargo'

  );

end;

end.

