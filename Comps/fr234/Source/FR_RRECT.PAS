{*****************************************************}
{                                                     }
{               FastReport v2.3                       }
{          RoundRect plus Add-in object               }
{       (C) Guilbaud Olivier for FR 2.3x              }
{    Some corrections by Alexander Tzyganenko         }
{     For question mail to : golivier@free.fr         }
{*****************************************************}
{Histo :                                              }
{ 29/04/99 : Cr?ation                                 }
{ 30/04/99 : Corrections minueurs                     }
{            Changer le TButton en TImage             }
{            pour le choix de la couleur              }
{            de l'ombre.                              }
{            Initialis? avec mots entiers             }
{            par defaut                               }
{ 22/06/99 : Ajout? la possibilit? de d?grad?         }
{            mais dans ce cas, c'est un rectangle     }
{ 10/11/99 : Update for the FR 2.31 version           }
{                                                     }

unit FR_RRect;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FR_Class, StdCtrls, ExtCtrls, ClipBrd {$IFDEF Delphi4}, ImgList {$ENDIF};

type
  {These are the six different gradient styles available.}
  TGradientStyle = (gsHorizontal, gsVertical, gsElliptic, gsRectangle,
                    gsVertCenter, gsHorizCenter);

  TfrRoundRectObject = class(TComponent)  // fake component
  end;

  // Pour enregistrer les param?tres
  TfrRoundRect = packed record
    SdColor: TColor;    // Color of Shadow
    wShadow: Integer;   // Width of shadow
    Cadre  : Boolean;   // Frame On/Off
    sCurve : Boolean;   // RoundRect On/Off
    wCurve : Integer;   // Curve size
  end;

  TfrRoundRectView = class(TfrMemoView)
  public
    Cadre: TfrRoundRect;
    constructor Create; override;
    procedure Assign(From: TfrView); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure CalcGaps; override;
    procedure ShowFrame; override;
    procedure ShowBackGround; override;
  end;

  // Editeur de propri?t?s
  TfrRoundRectForm = class(TfrObjEditorForm)
    M1: TMemo;
    Button5: TButton;
    Button6: TButton;
    lblSample: TLabel;
    colorDlg: TColorDialog;
    bOk: TButton;
    bCancel: TButton;
    Image1: TImage;
    imgSample: TImage;
    cbGradian: TCheckBox;
    panCurve: TPanel;
    cmShadow: TCheckBox;
    sCurve: TEdit;
    lblSWidth: TLabel;
    ShWidth: TEdit;
    lblSColor: TLabel;
    bcolor: TImage;
    cbCadre: TCheckBox;
    panGrad: TPanel;
    Label1: TLabel;
    bcolor3: TImage;
    Label2: TLabel;
    bColor2: TImage;
    cbStyle: TComboBox;
    Label3: TLabel;
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure bColorClick(Sender: TObject);
    procedure ShWidthChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCadreClick(Sender: TObject);
    procedure cmShadowClick(Sender: TObject);
    procedure M1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbGradianClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { D?clarations priv?es }
    ShadowColor: TColor;
    NormalColor: TColor;
    procedure ChgColorButton(S: TObject; C: TColor);
    procedure UpdateSample;
  public
    { D?clarations publiques }
    procedure ShowEditor(t: TfrView); override;
  end;

implementation

uses FR_Const, FR_Var, FR_Flds, Fr_Utils;

{$R *.DFM}

var
  frRoundRectForm: TfrRoundRectForm;

procedure PaintGrad(Cv: TCanvas; X, Y, X1, Y1: Word;
  FBeginClr, FEndClr: TColor; FGradientStyle: TGradientStyle);
var
  FromR, FromG, FromB: Integer; //These are the separate color values for RGB
  DiffR, DiffG, DiffB: Integer; // of color values.
  rct: TRect;                   //Rectangle used to draw frame around button
  bm: TBitMap;

{To speed things up and reduce flicker, I use a Bitmap to draw the button in
 its entirety, ten BitBlt it to the canvas of the control.}
procedure DoHorizontal(fr, fg, fb, dr, dg, db: Integer);
var
  ColorRect: TRect;
  I: Integer;
  R, G, B: Byte;
begin
  ColorRect.Top := 0;                        //Set rectangle top
  ColorRect.Bottom := bm.Height;
  for I := 0 to 255 do
  begin         //Make lines (rectangles) of color
    ColorRect.Left := MulDiv (I, bm.Width, 256);    //Find left for this color
    ColorRect.Right := MulDiv (I + 1, bm.Width, 256);   //Find Right
    R := fr + MulDiv(I, dr, 255);            //Find the RGB values
    G := fg + MulDiv(I, dg, 255);
    B := fb + MulDiv(I, db, 255);
    bm.Canvas.Brush.Color := RGB(R, G, B);   //Plug colors into brush
    bm.Canvas.FillRect(ColorRect);           //Draw on Bitmap
  end;
end;

procedure DoVertical(fr, fg, fb, dr, dg, db: Integer);
var
  ColorRect: TRect;
  I: Integer;
  R, G, B: Byte;
begin
  ColorRect.Left := 0;                //Set rectangle left&right
  ColorRect.Right := bm.Width;
  for I := 0 to 255 do
  begin                               //Make lines (rectangles) of color
    ColorRect.Top := MulDiv (I, bm.Height, 256);    //Find top for this color
    ColorRect.Bottom := MulDiv (I + 1, bm.Height, 256);   //Find Bottom
    R := fr + MulDiv(I, dr, 255);    //Find the RGB values
    G := fg + MulDiv(I, dg, 255);
    B := fb + MulDiv(I, db, 255);
    bm.Canvas.Brush.Color := RGB(R, G, B);   //Plug colors into brush
    bm.Canvas.FillRect(ColorRect);           //Draw on Bitmap
  end;
end;

procedure DoElliptic(fr, fg, fb, dr, dg, db: Integer);
var
  I: Integer;
  R, G, B: Byte;
  Pw, Ph: Double;
  x1, y1, x2, y2: Double;
{The elliptic is a bit different, since I had to use real numbers. I cut down
 on the number (to 155 instead of 255) of iterations in an attempt to speed
 things up, to no avail.  I think it just takes longer for windows to draw an
 ellipse as opposed to a rectangle.}
begin
  bm.Canvas.Pen.Style := psClear;
  bm.Canvas.Pen.Mode := pmCopy;
  x1 := 0 - (bm.Width / 4);
  x2 := bm.Width + (bm.Width / 4);
  y1 := 0 - (bm.Height / 4);
  y2 := bm.Height + (bm.Height / 4);
  Pw := ((bm.Width / 4) + (bm.Width / 2)) / 155;
  Ph := ((bm.Height / 4) + (bm.Height / 2)) / 155;
  for I := 0 to 155 do
  begin                              //Make ellipses of color
    x1 := x1 + Pw;
    x2 := X2 - Pw;
    y1 := y1 + Ph;
    y2 := y2 - Ph;
    R := fr + MulDiv(I, dr, 155);    //Find the RGB values
    G := fg + MulDiv(I, dg, 155);
    B := fb + MulDiv(I, db, 155);
    bm.Canvas.Brush.Color := R or (G shl 8) or (b shl 16);   //Plug colors into brush
    bm.Canvas.Ellipse(Trunc(x1), Trunc(y1), Trunc(x2), Trunc(y2));
  end;
  bm.Canvas.Pen.Style := psSolid;
end;

procedure DoRectangle(fr, fg, fb, dr, dg, db: Integer);
var
  I: Integer;
  R, G, B: Byte;
  Pw, Ph: Real;
  x1, y1, x2, y2: Double;
begin
  bm.Canvas.Pen.Style := psClear;
  bm.Canvas.Pen.Mode := pmCopy;
  x1 := 0;
  x2 := bm.Width;
  y1 := 0;
  y2 := bm.Height;
  Pw := (bm.Width / 2) / 255;
  Ph := (bm.Height / 2) / 255;
  for I := 0 to 255 do
  begin                              //Make rectangles of color
    x1 := x1 + Pw;
    x2 := X2 - Pw;
    y1 := y1 + Ph;
    y2 := y2 - Ph;
    R := fr + MulDiv(I, dr, 255);    //Find the RGB values
    G := fg + MulDiv(I, dg, 255);
    B := fb + MulDiv(I, db, 255);
    bm.Canvas.Brush.Color := RGB(R, G, B);   //Plug colors into brush
    bm.Canvas.FillRect(Rect(Trunc(x1), Trunc(y1), Trunc(x2), Trunc(y2)));
  end;
  bm.Canvas.Pen.Style := psSolid;
end;

procedure DoVertCenter(fr, fg, fb, dr, dg, db: Integer);
var
  ColorRect: TRect;
  I: Integer;
  R, G, B: Byte;
  Haf: Integer;
begin
  Haf := bm.Height Div 2;
  ColorRect.Left := 0;
  ColorRect.Right := bm.Width;
  for I := 0 to Haf do
  begin
    ColorRect.Top := MulDiv(I, Haf, Haf);
    ColorRect.Bottom := MulDiv(I + 1, Haf, Haf);
    R := fr + MulDiv(I, dr, Haf);
    G := fg + MulDiv(I, dg, Haf);
    B := fb + MulDiv(I, db, Haf);
    bm.Canvas.Brush.Color := RGB(R, G, B);
    bm.Canvas.FillRect(ColorRect);
    ColorRect.Top := bm.Height - (MulDiv (I, Haf, Haf));
    ColorRect.Bottom := bm.Height - (MulDiv (I + 1, Haf, Haf));
    bm.Canvas.FillRect(ColorRect);
  end;
end;

procedure DoHorizCenter(fr, fg, fb, dr, dg, db: Integer);
var
  ColorRect: TRect;
  I: Integer;
  R, G, B: Byte;
  Haf: Integer;
begin
  Haf := bm.Width Div 2;
  ColorRect.Top := 0;
  ColorRect.Bottom := bm.Height;
  for I := 0 to Haf do
  begin
    ColorRect.Left := MulDiv(I, Haf, Haf);
    ColorRect.Right := MulDiv(I + 1, Haf, Haf);
    R := fr + MulDiv(I, dr, Haf);
    G := fg + MulDiv(I, dg, Haf);
    B := fb + MulDiv(I, db, Haf);
    bm.Canvas.Brush.Color := RGB(R, G, B);
    bm.Canvas.FillRect(ColorRect);
    ColorRect.Left := bm.Width - (MulDiv (I, Haf, Haf));
    ColorRect.Right := bm.Width - (MulDiv (I + 1, Haf, Haf));
    bm.Canvas.FillRect(ColorRect);
  end;
end;

begin
  try
    bm := TBitMap.Create;
    if Cv = nil then Exit;
    bm.Width := X1 - X;          //Set BMP dimensions to match control's
    bm.Height :=Y1 - Y;
    rct := Rect(0, 0, bm.Width, bm.Height);  //Set rectangle size for later use
    FromR := FBeginClr and $000000ff;  //Strip out separate RGB values
    FromG := (FBeginClr shr 8) and $000000ff;
    FromB := (FBeginClr shr 16) and $000000ff;
    DiffR := (FEndClr and $000000ff) - FromR;   //Find the difference
    DiffG := ((FEndClr shr 8) and $000000ff) - FromG;
    DiffB := ((FEndClr shr 16) and $000000ff) - FromB;
    //Depending on gradient style selected, go draw it on the Bitmap canvas.
    if FGradientStyle = gsHorizontal then
      DoHorizontal(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    if FGradientStyle = gsVertical then
      DoVertical(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    if FGradientStyle = gsElliptic then
      DoElliptic(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    if FGradientStyle = gsRectangle then
      DoRectangle(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    if FGradientStyle = gsVertCenter then
      DoVertCenter(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    if FGradientStyle = gsHorizCenter then
      DoHorizCenter(FromR, FromG, FromB, DiffR, DiffG, DiffB);
    //By setting the Brush style to Clear, it will draw without overlaying bkgrnd
    bm.Canvas.Brush.Style := bsClear;  //Gradient is done, time for Hilite-Shadow
    {Finally, the button is all painted on the bitmap canvas. Now we just need
     to copy it to the canvas of our control.  BitBlt is one method; there are
     several others.}
    BitBlt(Cv.Handle, X, Y, bm.Width, bm.Height, bm.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    bm.Free;
  end;
end;

(********************************************************)
constructor TfrRoundRectView.Create;
begin
  inherited Create;

  //Initialization
  Typ      := gtAddIn;
  FrameTyp := $FF;
  BaseName := 'RoundRect';

  //Default values
  Cadre.SdColor := clGray;
  Cadre.wShadow := 6;
  Cadre.Cadre := True;
  Cadre.sCurve := True;
  Cadre.wCurve := 10;
end;

procedure TfrRoundRectView.Assign(From: TfrView);
begin
  inherited Assign(From);
  Cadre := TfrRoundRectView(From).Cadre;
end;

procedure TfrRoundRectView.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  Stream.Read(Cadre, SizeOf(Cadre));
end;

procedure TfrRoundRectView.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  Stream.Write(Cadre, SizeOf(Cadre));
end;

procedure TfrRoundRectView.CalcGaps;
begin
  inherited CalcGaps;

  // Zone de text (MEMO)
  Drect.Left := DRect.Left + (Cadre.wCurve div 4);
  DRect.Top := DRect.Top + (Cadre.wCurve div 4);
  DRect.Right := DRect.Right - ((Cadre.wShadow + Cadre.wCurve) div 4);
  DRect.Bottom := DRect.Bottom - ((Cadre.wShadow + Cadre.wCurve) div 4);
  // Position de d?but haut ? gauche}
  gapx := gapx + (Cadre.wCurve div 4);
  gapy := gapy + (Cadre.wCurve div 4);
end;

procedure TfrRoundRectView.ShowBackGround;
var
  OldDRect: TRect;
  OldFill: TColor;
begin
  // prevent screen garbage in designer
  if (DocMode <> dmDesigning) or (Cadre.wShadow = -99) then Exit;
  OldDRect := DRect;
  OldFill := FillColor;
  DRect := Rect(x, y, x + dx + 1, y + dy + 1);
  FillColor := clWhite;
  inherited;
  DRect := OldDRect;
  FillColor := OldFill;
end;

procedure TfrRoundRectView.ShowFrame;
var
  FSW, FCU: Integer;

  procedure Line(x, y, dx, dy: Integer);
  begin
    Canvas.MoveTo(x, y);
    Canvas.LineTo(x + dx, y + dy);
  end;

  procedure FrameLine(i: Integer);
  begin
    Canvas.Pen.Width := Round(FrameWidth);
    case i of
      0: Line(x + dx, y, 0, dy);
      1: Line(x, y, 0, dy);
      2: Line(x, y + dy, dx, 0);
      3: Line(x, y, dx, 0);
    end;
  end;

begin
  if DisableDrawing then Exit;
  with Canvas do
  begin
    if Cadre.wShadow = -99 then
    begin
      if Cadre.wCurve < 0 then
        Cadre.wCurve := 0;
      PaintGrad(Canvas, X, Y, X + DX, Y + DY, FillColor, Cadre.SdColor,
        TGradientStyle(Cadre.wCurve));
      Pen.Width := Round(FrameWidth);
      Pen.Color := FrameColor;

      if (FrameTyp and $1) <> 0 then FrameLine(0);
      if (FrameTyp and $4) <> 0 then FrameLine(1);
      if (FrameTyp and $2) <> 0 then FrameLine(2);
      if (FrameTyp and $8) <> 0 then FrameLine(3);

      Exit;
    end;

    // Trace l'ombre
    Pen.Style := psSolid;
    Brush.Style := bsClear;
    Pen.Color := Cadre.SdColor;
    Pen.Width := Round(FrameWidth);
    Brush.Color := Cadre.SdColor;

    FSW := Round(Cadre.wShadow * ScaleY);
    FCU := Round(Cadre.wCurve * ScaleY);

    if Cadre.sCurve then
      RoundRect(x + FSW, y + FSW, x + dx + 1, y + dy + 1, FCu, Fcu) else
      Rectangle(x + FSW, y + FSW, x + dx + 1, y + dy + 1);

    // Trace la zone de texte
    Pen.Width := Round(FrameWidth);
    Cadre.Cadre := ((FrameTyp and $F) = $F); // Si zone de cadre d?sactiv?e

    if not Cadre.Cadre then
      Pen.Color := FillColor else
      Pen.Color := FrameColor; // Trace le cadre

    Brush.Color := FillColor;
    if Cadre.sCurve then
      RoundRect(x, y, x + dx + 1 - FSW, y + dy + 1 - FSW, FCu, Fcu) else
      Rectangle(x, y, x + dx + 1 - FSW, y + dy + 1 - FSW);
  end;
end;


(****************************************************)
procedure TfrRoundRectForm.FormCreate(Sender: TObject);
var
  i: Integer;
  s: String;
begin
  Caption := LoadStr(frRes + 670);
  LblSample.Caption := LoadStr(frRes + 671);
  Button5.Caption   := LoadStr(frRes + 672);
  Button6.Caption   := LoadStr(frRes + 673);
  cbGradian.Caption := LoadStr(frRes + 674);
  lblSWidth.Caption := LoadStr(frRes + 675);
  LblSColor.Caption := LoadStr(frRes + 676);
  cmShadow.Caption  := LoadStr(frRes + 677);
  cbCadre.Caption   := LoadStr(frRes + 678);
  Label1.Caption    := LoadStr(frRes + 679);
  Label2.Caption    := LoadSTr(frRes + 680);
  Label3.Caption    := LoadStr(frRes + 681);
  bColor.Hint       := LoadStr(frRes + 683);
  bColor2.Hint      := bColor.Hint;
  bColor3.Hint      := bColor3.Hint;
  BOk.Caption       := LoadStr(SOk);
  bCancel.Caption   := LoadStr(SCancel);

  cbStyle.Items.CommaText := LoadStr(frRes + 682);
  for i := 0 to cbStyle.Items.Count - 1 do
  begin
    s := cbStyle.Items.Strings[i];
    if Pos('_', s) <> 0 then
    begin
      s[Pos('_', s)] := ' ';
      cbStyle.Items.Strings[i] := s;
    end;
  end;

  panGrad.Left := panCurve.Left;
  panGrad.Top := panCurve.Top;
  panGrad.Visible := False;
end;

procedure TfrRoundRectForm.Button5Click(Sender: TObject);
begin
  frVarForm := TfrVarForm.Create(nil);
  with frVarForm do
  if ShowModal = mrOk then
  begin
    ClipBoard.Clear;
    if SelectedItem <> '' then
    Begin
      ClipBoard.Clear;
      ClipBoard.AsText := '[' + SelectedItem + ']';
      M1.PasteFromClipboard;
    end;
  end;
  frVarForm.Free;
  M1.SetFocus;
end;

procedure TfrRoundRectForm.Button6Click(Sender: TObject);
begin
  frFieldsForm := TfrFieldsForm.Create(nil);
  with frFieldsForm do
  if ShowModal = mrOk then
    if DBField <> '' then
    begin
      ClipBoard.Clear;
      ClipBoard.AsText := '[' + DBField + ']';
      M1.PasteFromClipboard;
    end;
  frFieldsForm.Free;
  M1.SetFocus;
end;

procedure TfrRoundRectForm.ChgColorButton(S: TObject; C: TColor);
var
  BM: TBitmap;
  Bc: TImage;
begin
  BM := TBitmap.Create;
  Bc := S as TImage;
  BM.Height := bC.Height;
  BM.Width := bC.Width;

  with BM.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := C;
    Rectangle(0, 0, bC.Width, bC.Height);
  end;
  if Bc.Tag = 0 then
    ShadowColor := C else
    NormalColor := C;

  bC.Picture.Assign(BM);
  BM.Free;
end;

procedure TfrRoundRectForm.UpdateSample;
var
  CC: TCanvas;
  FsW: Integer;
  FCu: Integer;
  BM: TBitmap;
begin
  try
    FsW := StrToInt(ShWidth.Text);
  except
    FsW := 10;
  end;

  try
    FCu := StrToInt(SCurve.Text);
  except
    FCu := 10;
  end;

  BM := TBitmap.Create;
  BM.Height := imgSample.Height;
  BM.Width := imgSample.Width;

  CC := BM.Canvas;

  if cbGradian.Checked then
  begin
    FsW := cbStyle.ItemIndex;
    if FsW < 0 then FsW:=0;
    PaintGrad(CC, 0, 0, bm.Width, bm.Height, NormalColor, ShadowColor,
      TGradientStyle(FsW));
  end
  else
  begin
    // R?initialise le panel
    CC.Pen.Color := clBtnFace;
    CC.Brush.Color := clBtnFace;
    CC.Rectangle(0, 0, imgSample.Width, imgSample.Height);

    // Trace l'ombre
    CC.Pen.Color := ShadowColor;
    CC.Brush.Color := ShadowColor;

    if cmShadow.Checked then
      CC.RoundRect(0 + FSW, 0 + FSW, imgSample.Width, imgSample.Height,
        FCu, FCu)
    else
      CC.Rectangle(0 + FSW, 0 + FSW, imgSample.Width, imgSample.Height);

    // Trace la zone de texte
    if not cbCadre.Checked then
      CC.Pen.Color := NormalColor else
      CC.Pen.Color := clBlack; // Trace le cadre

    CC.Brush.Color := NormalColor;
    if cmShadow.Checked then
      CC.RoundRect(0, 0, imgSample.Width - FSW, imgSample.Height - FSW,
        FCu, FCu)
    else
      CC.Rectangle(0, 0, imgSample.Width - FSW, imgSample.Height - FSW);
  end;

  imgSample.Picture.Assign(BM);
  BM.Free;
end;

procedure TfrRoundRectForm.bColorClick(Sender: TObject);
begin
  ColorDlg.Color := ShadowColor;
  if ColorDlg.Execute then
  begin
    ChgColorButton(Sender, ColorDlg.Color);
    UpdateSample;
  end;
end;

procedure TfrRoundRectForm.ShWidthChange(Sender: TObject);
begin
  if Sender is TEdit then
    if TEdit(Sender).Text = '' then Exit;
  UpdateSample;
end;

procedure TfrRoundRectForm.cbCadreClick(Sender: TObject);
begin
  UpdateSample;
end;

procedure TfrRoundRectForm.cmShadowClick(Sender: TObject);
begin
  UpdateSample;
end;

procedure TfrRoundRectForm.cbGradianClick(Sender: TObject);
begin
  panGrad.Visible := cbGradian.Checked;
  panCurve.Visible := not panGrad.Visible;
  if panGrad.Visible then
  begin
    shWidth.Text := '-99';
    sCurve.Text := '0';
    cbStyle.ItemIndex := 0;
  end
  else
  begin
    shWidth.Text := '10';
    sCurve.Text := '10';
  end;
end;

procedure TfrRoundRectForm.M1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Insert) and (Shift = []) then Button5Click(Self);
  if Key = vk_Escape then ModalResult := mrCancel;
end;

procedure TfrRoundRectForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = vk_Return) and (ssCtrl in Shift) then
  begin
    ModalResult := mrOk;
    Key := 0;
  end;
end;

procedure TfrRoundRectForm.ShowEditor(t:TfrView);
begin
  M1.Lines.Assign(t.Memo);
  with t as TfrRoundRectView do
  begin
    shWidth.Text := IntToStr(Cadre.wShadow);
    if Cadre.wShadow <> -99 then
    begin // RoundRect
      cbGradian.Checked := False;
      ShadowColor := Cadre.sdColor;
      NormalColor := FillColor;
      cbCadre.Checked := Cadre.Cadre;
      cmShadow.Checked := Cadre.sCurve;
      sCurve.Text := IntToStr(Cadre.wCurve);
    end
    else
    begin //Gradian
      cbGradian.Checked := True;
      ShadowColor := Cadre.sdColor;
      NormalColor := FillColor;
      if Cadre.wCurve > cbStyle.Items.Count - 1 then
        Cadre.wCurve := 0;
      cbStyle.ItemIndex := Cadre.wCurve;
    end;

    if ShowModal = mrOk then
    begin
      Memo.Assign(M1.Lines);
      Cadre.sdColor := ShadowColor;
      FillColor := NormalColor;
      Cadre.sCurve := cmShadow.Checked;
      Cadre.Cadre := cbCadre.Checked;
      try
        Cadre.wShadow := StrToInt(shWidth.Text);
      except
        Cadre.wShadow := 6;
      end;

      try
        Cadre.wCurve := StrToInt(sCurve.Text);
        if Cadre.wShadow = -99 then
          Cadre.wCurve := cbStyle.ItemIndex;
      except
        Cadre.wCurve := 10;
      end;
    end;
  end;
end;

procedure TfrRoundRectForm.FormShow(Sender: TObject);
begin
  M1.SetFocus;
  UpdateSample;
  ChgColorButton(bColor, ShadowColor);
  ChgColorButton(bColor2, NormalColor);
  ChgColorButton(bColor3, ShadowColor);
end;

initialization
  frRoundRectForm := TfrRoundRectForm.Create(nil);
  frRegisterObject(TfrRoundRectView, frRoundRectForm.Image1.Picture.Bitmap,
    LoadStr(SInsRoundRect), frRoundRectForm);

finalization
  frRoundRectForm.Free;

end.
