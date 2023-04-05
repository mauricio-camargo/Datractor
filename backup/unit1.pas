unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Spin, PdfiumCore, PdfiumCtrl, LCLIntf, Math, Unit2, Buttons, ValEdit, Grids,
  ColorSpeedButton, BCButton, BGRABitmap, BGRABitmapTypes, BGRAGraphicControl,
  fpspreadsheetgrid, SpinEx, fpsallformats, StrUtils, Unit3, BCTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    bGetText: TButton;
    BGCont: TBGRAGraphicControl;
    BtnStart: TSpeedButton;
    CheckB1: TCheckBox;
    CoordXlab: TLabel;
    CoordYlab: TLabel;
    EdX1: TFloatSpinEditEx;
    EdX2: TFloatSpinEditEx;
    EdY1: TFloatSpinEditEx;
    EdY2: TFloatSpinEditEx;
    ExtractBtn: TSpeedButton;
    grid: TsWorksheetGrid;
    Label1: TLabel;
    label10: TLabel;
    Label2: TLabel;
    label3: TLabel;
    label4: TLabel;
    label5: TLabel;
    label6: TLabel;
    label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MemoTemp: TMemo;
    MkX1lab: TLabel;
    MkX2lab: TLabel;
    MkY1lab: TLabel;
    MkY2lab: TLabel;
    odPDF: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    OpenDialog1: TOpenDialog;
    Panel5: TPanel;
    SaveBtn: TSpeedButton;
    SaveDialog1: TSaveDialog;
    ScrollBox1: TScrollBox;
    sePageNo: TSpinEdit;
    SG: TStringGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    bScaleM: TSpeedButton;
    bScaleP: TSpeedButton;
    bScaleAuto: TSpeedButton;
    bPrev: TSpeedButton;
    bNext: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure BGContMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure BGContRedraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure bGetTextClick(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure bPrevClick(Sender: TObject);
    procedure bScaleAutoClick(Sender: TObject);
    procedure bScaleM1Click(Sender: TObject);
    procedure bScaleMClick(Sender: TObject);
    procedure bScalePClick(Sender: TObject);
    procedure CheckB1Change(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure EdX1Click(Sender: TObject);
    procedure EdX2Click(Sender: TObject);
    procedure EdY1Click(Sender: TObject);
    procedure EdY2Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ExtractBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sePageNoChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    Zoom: ShortInt;
    procedure WebLinkClick(Sender: TObject; Url: string);
    procedure MouseMovePdf(Sender: TObject;Shift: TShiftState; X, Y: Integer);
  public
    image: TBGRABitmap;

  end;

var
  Form1: TForm1;
  ax1,ax2,ay1,ay2,Cont: Integer;
  bx1,bx2,by1,by2: double;
  CalibrateOk: Boolean;
  PDFCtrl: TPdfControl;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MouseMovePdf(Sender: TObject;Shift: TShiftState; X, Y: Integer);
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

procedure TForm1.WebLinkClick(Sender: TObject; Url: string);
begin
  OpenURL(Url);
end;

procedure TForm1.CheckB1Change(Sender: TObject);
begin
BGCont.DiscardBitmap;
end;

procedure TForm1.bPrevClick(Sender: TObject);
begin
if PDFCtrl.CurrentPage=nil then Exit;
PDFCtrl.GotoPrevPage;
sePageNo.Value := PDFCtrl.PageIndex + 1;
end;

procedure TForm1.bScaleAutoClick(Sender: TObject);
begin
if ScrollBox1.Visible then begin
 if PDFCtrl.CurrentPage=nil then Exit;
 //PDFCtrl.ScaleMode := smZoom;
 PDFCtrl.ZoomPercentage:=100;
 Label9.Caption:='Zoom ('+IntToStr(PDFCtrl.ZoomPercentage)+'%)';
end else begin
 Zoom:=100;
 BGCont.DiscardBitmap;
 Label9.Caption:='Zoom (100%)';
end;
end;

procedure TForm1.bScaleM1Click(Sender: TObject);
begin
PDFCtrl.PageIndex := sePageNo.Value;
end;

procedure TForm1.bScaleMClick(Sender: TObject);
begin
if ScrollBox1.Visible then begin
 if PDFCtrl.CurrentPage=nil then Exit;
 if PDFCtrl.ScaleMode <> smZoom then
   PDFCtrl.ScaleMode := smZoom;
 if PDFCtrl.ZoomPercentage > 25 then
   PDFCtrl.ZoomPercentage := PDFCtrl.ZoomPercentage - 5;
 Label9.Caption:='Zoom ('+IntToStr(PDFCtrl.ZoomPercentage)+'%)';
end else begin
 Zoom:=Zoom-5;
 BGCont.DiscardBitmap;
 Label9.Caption:='Zoom ('+IntToStr(Zoom)+'%)';
end;
end;

procedure TForm1.bScalePClick(Sender: TObject);
begin
if ScrollBox1.Visible then begin
 if PDFCtrl.CurrentPage=nil then Exit;
 if PDFCtrl.ScaleMode <> smZoom then
   PDFCtrl.ScaleMode := smZoom;
 if PDFCtrl.ZoomPercentage < 400 then
   PDFCtrl.ZoomPercentage := PDFCtrl.ZoomPercentage + 5;
 Label9.Caption:='Zoom ('+IntToStr(PDFCtrl.ZoomPercentage)+'%)';
end else begin
 Zoom:=Zoom+5;
 BGCont.DiscardBitmap;
 Label9.Caption:='Zoom ('+IntToStr(Zoom)+'%)';
end;
end;

procedure TForm1.bNextClick(Sender: TObject);
begin
if PDFCtrl.CurrentPage=nil then Exit;
PDFCtrl.GotoNextPage;
sePageNo.Value := PDFCtrl.PageIndex + 1;
end;

procedure TForm1.bGetTextClick(Sender: TObject);
var s: String;
begin
if PDFCtrl.CurrentPage=nil then Exit;
  s := PDFCtrl.CurrentPage.ReadText(0, PDFCtrl.CurrentPage.GetCharCount);
  if s = '' then
  begin
    ShowMessage('Page contains no text');
    exit;
  end;
  Application.CreateForm(TForm2, Form2);
  Form2.Memo1.Lines.Text := s;
  Form2.ShowModal;
  FreeAndNil(Form2);
end;

procedure TForm1.BGContRedraw(Sender: TObject; Bitmap: TBGRABitmap);
var i,x,y,x_Orig,y_Orig: integer;
imgT: TBGRABitmap;
begin
if Assigned(image) then begin
 Bitmap.FillTransparent;
 imgT:=image.Resample(trunc(image.Width*Zoom/100), trunc(image.Height*Zoom/100)) as TBGRABitmap;
 Bitmap.PutImageAngle(0,0, imgT, 0, TResampleFilter.rfBestQuality, 0,0);
 if CheckB1.Checked then begin
  x:=0;
  y:=0;
  x_Orig:=imgT.Width;
  y_Orig :=imgT.Height;
  //Escreve diretamente no BGCont.Canvas ao inver do image.Canvas
  BGCOnt.Bitmap.Canvas.Pen.Color:=clSilver;
  BGCOnt.Bitmap.Canvas.Pen.Width:=1;
  for i:=0 to x_Orig div 35 do begin
   BGCont.Bitmap.Canvas.MoveTo(x,0);
   BGCont.Bitmap.Canvas.LineTo(x,Y_Orig);
   x:=x+35;
  end;
  for i:=0 to y_Orig div 35 do begin
   BGCont.Bitmap.Canvas.MoveTo(0,y);
   BGCont.Bitmap.Canvas.LineTo(X_Orig,y);
   y:=y+35;
  end;
 end;
imgT.Free;
end;
end;

procedure TForm1.BGContMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var Ry,Rx: Double;
begin
Rx:=X;
Ry:=Y;
if CalibrateOk then begin
 Ry:=(by1)+(((Y-ay1)/(ay2-ay1))*(by2-by1));
 Rx:=(bx1)+(((X-ax1)/(ax2-ax1))*(bx2-bx1));
end;
CoordXlab.Caption:=FloatToStrF(Rx,ffFixed,8,0);
CoordYlab.Caption:=FloatToStrF(Ry,ffFixed,8,0);
end;

procedure TForm1.BtnStartClick(Sender: TObject);
begin
if BtnStart.Caption='Start calibrating' then begin
 Screen.Cursor:=crCross;
 MkX1lab.Caption:='Waiting...';
 ExtractBtn.Enabled:=True;
 BtnStart.Caption:='STOP calibrating';
end else begin
 BtnStart.Caption:='Start calibrating';
 Screen.Cursor:=crDefault;
end;
end;

procedure TForm1.EdX1Click(Sender: TObject);
begin
EdX1.SelectAll;
end;

procedure TForm1.EdX2Click(Sender: TObject);
begin
EdX2.SelectAll;
end;

procedure TForm1.EdY1Click(Sender: TObject);
begin
EdY1.SelectAll;
end;

procedure TForm1.EdY2Click(Sender: TObject);
begin
EdY2.SelectAll;
end;

procedure TForm1.SaveBtnClick(Sender: TObject);
var i,j: integer;
begin
if not SaveDialog1.Execute then Exit;
if SaveDialog1.FilterIndex=2 then begin;
 MemoTemp.Lines.Clear;
 for i:=0 to SG.RowCount-1 do
  MemoTemp.Lines.Add(SG.Cells[0,i]+';'+SG.Cells[1,i]+';'+SG.Cells[2,i]+';'+SG.Cells[3,i]);
 MemoTemp.Lines.SaveToFile(SaveDialog1.FileName);
end else
if SaveDialog1.FilterIndex=1 then begin
 grid.Cells[1,1]:='Y';
 grid.Cells[2,1]:='X';
 grid.Cells[3,1]:='Obs';
 for i:=1 to SG.RowCount-1 do
  for j:=1 to 3 do begin
   if (j=1) or (j=2) then              //Y e X
   grid.Cells[j,i+1]:=StrToFloat(SG.Cells[j,i]) else
   grid.Cells[j,i+1]:=SG.Cells[j,i] //Obs
  end;
 Screen.Cursor := crHourglass;
 Grid.SaveToSpreadsheetFile(SaveDialog1.FileName);
 Screen.Cursor := crDefault;
end;
end;

procedure TForm1.ExtractBtnClick(Sender: TObject);
begin
PDFCtrl.AllowUserTextSelection:=True;
CalibrateOk:=False;
SaveBtn.Enabled:=True;
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
  bx1:=EdX1.Value;
  bx2:=EdX2.Value;
  by1:=EdY1.Value;
  by2:=EdY2.Value;
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
PDFiumDllDir := ExtractFilePath(Application.ExeName);
PDFCtrl := TPdfControl.Create(Self);
ScrollBox1.Align := alClient;
PDFCtrl.Align := alClient;
PDFCtrl.Parent := ScrollBox1;
PDFCtrl.SendToBack;
//PDFCtrl.Color := clGray;
//PDFCtrl.PageColor := RGB(255, 255, 255);
PDFCtrl.OnWebLinkClick := @WebLinkClick;
PDFCtrl.OnMouseMove := @MouseMovePdf;
PDFCtrl.OnMouseDown:=@imgMouseDown;
SG.Cells[0,0]:='N';
SG.Cells[1,0]:='Y_vert';
SG.Cells[2,0]:='X_horiz';
SG.Cells[3,0]:='Obs';
//SpeedButton1.Caption := 'Open image' +#13#10 + 'jpg,png,tif etc';
Zoom:=100;
end;

procedure TForm1.imgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var Dax,Day,R: integer;
Dbx,Dby,Rx,Ry: Double;
S: String;
begin
if MkX1lab.Caption='Waiting...' then begin
 MkX1lab.Caption:=IntToStr(X);
 MkX2lab.Caption:='Waiting...';
 PDFCtrl.AllowUserTextSelection:=False;
 EdX1.SetFocus;
 EdX1.SelectAll;
 Exit;
end;
if MkX2lab.Caption='Waiting...' then begin
 MkX2lab.Caption:=IntToStr(X);
 MkY1lab.Caption:='Waiting...';
 PDFCtrl.AllowUserTextSelection:=False;
 EdX2.SetFocus;
 EdX2.SelectAll;
 Exit;
end;
if MkY1lab.Caption='Waiting...' then begin
 MkY1lab.Caption:=IntToStr(Y);
 MkY2lab.Caption:='Waiting...';
 PDFCtrl.AllowUserTextSelection:=False;
 EdY1.SetFocus;
 EdY1.SelectAll;
 Exit;
end;
if MkY2lab.Caption='Waiting...' then begin
 MkY2lab.Caption:=IntToStr(Y);
 PDFCtrl.AllowUserTextSelection:=False;
 EdY2.SetFocus;
 EdY2.SelectAll;
 Exit;
end;
if ExtractBtn.Caption='STOP EXTRACTING' then begin
 //Interpoladores lineares
 Ry:=(by1)+(((Y-ay1)/(ay2-ay1))*(by2-by1));
 Rx:=(bx1)+(((X-ax1)/(ax2-ax1))*(bx2-bx1));
 SG.RowCount:=SG.RowCount+1;
 SG.Cells[0,SG.RowCount-1]:=IntToStr(SG.RowCount-1);
// SG.Cells[1,SG.RowCount-1]:=FloatToStrF(Ry,ffFixed,8,2);
 S:=FloatToStrF(Ry,ffFixed,8,2);
 ReplaceText(S,',','.');
 SG.Cells[1,SG.RowCount-1]:=S;
 // SG.Cells[2,SG.RowCount-1]:=FloatToStrF(Rx,ffFixed,8,2);
 S:=FloatToStrF(Rx,ffFixed,8,2);
 ReplaceText(S,',','.');
 SG.Cells[2,SG.RowCount-1]:=S;
 SG.Row:=SG.RowCount-1;
 PDFCtrl.AllowUserTextSelection:=False;
end;

SG.AutoSizeColumn(0);
SG.AutoSizeColumn(1);
SG.AutoSizeColumn(2);
end;

procedure TForm1.sePageNoChange(Sender: TObject);
begin
if PDFCtrl.CurrentPage=nil then Exit;
if sePageNo.Value <= PDFCtrl.PageCount then
  PDFCtrl.PageIndex := sePageNo.Value - 1
else
  sePageNo.Value := PDFCtrl.PageCount;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if not OpenDialog1.Execute then Exit;
  image.Free;
  image := TBGRABitmap.Create(OpenDialog1.FileName);
  BGCont.DiscardBitmap;

  ScrollBox1.Visible:=False;
  //img.Picture.LoadFromFile(OpenDialog1.FileName);
  CheckB1.Enabled:=True;
  BtnStart.Enabled:=True;
  ExtractBtn.Enabled:=True;
  Caption := OpenDialog1.FileName;

  EdX1.Value:=0;
  EdX2.Value:=0;
  EdY1.Value:=0;
  EdY2.Value:=0;
  SG.Clear;
  SG.RowCount:=1;
  SG.Cells[0,0]:='N';
  SG.Cells[1,0]:='Y_vert';
  SG.Cells[2,0]:='X_horiz';
  SG.Cells[3,0]:='Obs';
  sePageNo.Value:=1;
  CheckB1.Checked:=False;
  Label9.Caption:='Zoom';

  Label9.Visible:=True;
  CheckB1.Visible:=True;
  bScaleM.Visible:=True;
  bScaleAuto.Visible:=True;
  bScaleP.Visible:=True;
  bPrev.Visible:=False;
  bNext.Visible:=False;
  Label8.Visible:=False;
  sePageNo.Visible:=False;
  bGetText.Visible:=False;
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
Form3.Label1.Caption :=
  'Camargo, M.G. 2023. Datractor: an open source software for'+#13+
  'extracting data points directly from PDFs and images. v. 1.1.';
Form3.Label3.Caption :=  'By Maurício G. Camargo. Version 1.1. April, 2023.';
Form3.Label4.Caption :=  'Video tutorial: ';
Form3.ATLabelLink1.Caption :=  'https://youtu.be/GI8dnzxbOVk';
Form3.ATLabelLink2.Caption :=  'https://github.com/mauricio-camargo/Datractor';
Form3.Show;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
if not odPDF.Execute then exit;
ScrollBox1.Visible:=True;
PDFCtrl.ScaleMode := smZoom;
PDFCtrl.LoadFromFile(odPDF.FileName);
Caption := odPDF.FileName;
sePageNo.Enabled := PDFCtrl.PageCount > 1;
bPrev.Enabled := PDFCtrl.PageCount > 1;
bNext.Enabled := PDFCtrl.PageCount > 1;
BtnStart.Enabled:=True;
ExtractBtn.Enabled:=True;

EdX1.Value:=0;
EdX2.Value:=0;
EdY1.Value:=0;
EdY2.Value:=0;
SG.Clear;
SG.RowCount:=1;
SG.Cells[0,0]:='N';
SG.Cells[1,0]:='Y_vert';
SG.Cells[2,0]:='X_horiz';
SG.Cells[3,0]:='Obs';
sePageNo.Value:=1;
CheckB1.Checked:=False;

Label9.Caption:='Zoom ('+IntToStr(PDFCtrl.ZoomPercentage)+'%)';
CheckB1.Visible:=False;
bScaleM.Visible:=True;
bScaleAuto.Visible:=True;
bScaleP.Visible:=True;
bPrev.Visible:=True;
bNext.Visible:=True;
Label8.Visible:=True;
sePageNo.Visible:=True;
bGetText.Visible:=True;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
var i: integer;
begin
MemoTemp.Lines.Clear;
MemoTemp.Lines.Add('Y;X;Obs');
for i:=1 to SG.RowCount-1 do
 MemoTemp.Lines.Add(SG.Cells[0,i]+';'+SG.Cells[1,i]+';'+SG.Cells[2,i]+';'+SG.Cells[3,i]);
MemoTemp.SelectAll;
MemoTemp.CopyToClipboard;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
ax1:=0;
MkX1lab.Caption:='Nothing';
EdX1.Value:=0;
ax2:=0;
MkX2lab.Caption:='Nothing';
EdX2.Value:=0;
ay1:=0;
MkY1lab.Caption:='Nothing';
EdY1.Value:=0;
ay2:=0;
MkY2lab.Caption:='Nothing';
EdY2.Value:=0;
end;

end.



