unit SimpleDialog;

interface

type
  TChoiceProc = procedure(PressYes : Boolean) of object;

//Сообщения
function  ConfirmDlg(MsgNote: string): Boolean;
function  ConfirmDeletion(MsgNote: string): Boolean;
function  YesNoCancelDlg(MsgNote: string; var YesNo : Boolean; DoChoice : TChoiceProc = nil): Boolean;
function  YesNoCancelText(MsgNote: string; BtnCaption : array of const): Integer;
procedure ShowWarningDlg(MsgNote: string; aTimer : Boolean = False);
procedure ShowErrorDlg(MsgNote: string);
procedure ShowInfoDlg(MsgNote: string);
// Формы для ввода данных
function IntegerPromptDlg(ACaption, APrompt : String;
         var AValue : Integer; DefWidth : Byte = 150) : boolean;
function FloatPromptDlg(ACaption, APrompt : String;
         var AValue : Double; DefWidth : Byte = 150) : boolean;
function StringPromptDlg(ACaption, APrompt : String;
         var AValue : String; DefWidth : Byte = 150) : boolean;
function DatePromptDlg(ACaption, APrompt : String;
         var AValue : TDateTime; DefWidth : Byte = 150) : boolean;
function StrIntPromptDlg(ACaption, APrompt : String;
         var AValue : string; DefWidth : Byte = 150) : boolean;
function PasswordPromptDlg(ACaption, APrompt : String;
         var AValue : String; DefWidth : Byte = 150) : boolean;
function LargeIntPromptDlg(ACaption, APrompt : String;
         var AValue : Int64; DefWidth : Byte = 150) : boolean;

implementation
uses Dialogs, Forms, Controls, StdCtrls, Mask, Classes, Variants, Windows, Messages,
  SysUtils;

const
  RusTitle : array[TMsgDlgType] of String =
            ('Предупреждение','Ошибка','Сообщение','Подтвердите','');
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
  RusButtonCaptions: array[TMsgDlgBtn] of string = (
    'Да', 'Нет', 'ОК', 'Отмена', 'Прервать', 'Повторить', 'Пропуск', 'Все', 'Нет всем',
    'Да всем', 'Помощь');

var
  UserButtonCaptions : array of string;    

procedure AlignCenter(var Form : TForm);
var F : TForm;
begin
  with Form do
  begin
    F := Screen.ActiveForm;
    if F <> nil  then
    begin
      if F.FormStyle <> fsMDIChild then
      begin
        Left := F.Left + (F.Width  - Width)  div 2;
        Top  := F.Top  + (F.Height - Height) div 2;
      end
      else begin
        F := Application.MainForm;
        Left := F.Left + (F.Width  - Width)  div 2;
        Top  := F.Top  + (F.Height - Height) div 2;
      end;
      // исправление положения
      if Left < 0 then
        Left := 0
      else if Left > (Screen.Width - Width) then
        Left := Screen.Width - Width;
      if Top < 0 then
        Top := 0
      else if Top > (Screen.Height - Height) then
        Top := Screen.Height - Height;
    end
    else
      Position := poScreenCenter;
  end;
end;

var Form : TForm;
    ButOk : TButton;
    
procedure OnAutoCloseTimer(hwnd: HWND; uMsg: UINT; idEvent: UINT ; dwTime : DWORD); stdcall;
begin
  //Dec(TimerTag);
  Form.Tag  := Form.Tag - 1;

  if (ButOk <> nil) then
  begin
    ButOk.Caption := Format('%s (%d)',[RusButtonCaptions[mbOk], Form.Tag]);
   // Dec(TimerTag);
    //Application.ProcessMessages;
  end;
  if Form.Tag = 0 then
    Form.ModalResult := mrOk;
end;


function CreateDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons;
  FormAutoClose : Boolean = False) : Integer;
var B : TMsgDlgBtn;
    But : TButton;
    s : string;
    ChangeButtonCaption : Boolean;
    R : TRect;
    BGW, X : Integer;

    TimerId : UINT;
    TimerTag : Integer;
begin
  Result := -1; TimerId := 0;
  Form := CreateMessageDialog(Msg, DlgType, Buttons);
  if Form <> nil then
  begin
    ChangeButtonCaption := (Length(UserButtonCaptions) = (Integer(High(TMsgDlgBtn)) - Integer(Low(TMsgDlgBtn)) + 1));
    with Form do
    try
      FormStyle := fsStayOnTop;
      Caption := RusTitle[DlgType];

      BGW := 0;
      for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      begin
        S := ButtonNames[B];
        But := TButton(FindComponent(s));
        if But <> nil then
        begin
          if not ChangeButtonCaption then
            But.Caption := RusButtonCaptions[B]
          else begin
            But.Caption := UserButtonCaptions[Integer(B)];
            R := Rect(0,0,0,0);
            s := But.Caption;
            Windows.DrawText(Canvas.Handle, PChar(s), -1, R, DT_CALCRECT or DT_LEFT or DT_SINGLELINE);
            R.Right := R.Right - R.Left + 10;
            if But.Width < R.Right then
              But.Width := R.Right;
            BGW := BGW + But.Width + 4;
          end;
        end;
      end;
      if ChangeButtonCaption then
      begin
        BGW := BGW - 4;
        if ClientWidth < (BGW + 16) then
          ClientWidth := BGW + 16;
        X := (ClientWidth - BGW) div 2;
        for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
          if B in Buttons then
          begin
            S := ButtonNames[B];
            But := TButton(FindComponent(s));
            if But <> nil then
            begin
              But.Left := X;
              X := X + But.Width + 4;
            end;
          end;
      end;
      AlignCenter(Form);

      if FormAutoClose then
      begin
        TimerId := SetTimer(0, 0, 1000, @OnAutoCloseTimer);
        if TimerId > 0 then
        begin
          ButOk := TButton(FindComponent(ButtonNames[mbOk]));
          Form.Tag := 11;
          if Assigned(ButOk) then
          begin
            ButOk.Caption := Format('%s (%d)',[RusButtonCaptions[mbOk], Form.Tag]);
            ButOk.Tag := Form.Tag;
          end;
        end;
      end;

      Result := ShowModal;
    finally
      SetLength(UserButtonCaptions, 0);
      if FormAutoClose and (TimerId > 0) then
        KillTimer(0, TimerId);
      Free;
    end;
  end;
end;

function ConfirmDlg(MsgNote: string): Boolean;
begin
  Result := CreateDlg(MsgNote, mtConfirmation, [mbYes, mbNo]) = mrYes;
end;

function ConfirmDeletion(MsgNote: string): Boolean;
begin
  Result := CreateDlg(MsgNote, mtWarning, [mbYes, mbNo]) = mrYes;
end;

function  YesNoCancelDlg(MsgNote: string; var YesNo : Boolean; DoChoice : TChoiceProc = nil): Boolean;
var res : Integer;
begin
  res := CreateDlg(MsgNote, mtConfirmation, [mbYes, mbNo, mbCancel]);
  Result := res <> mrCancel;
  YesNo  := res = mrYes;
  if Assigned(DoChoice) and (Result) then
    DoChoice(YesNo);
end;

function  YesNoCancelText(MsgNote: string; BtnCaption : array of const): Integer;
var n : Integer;
begin
  if Length(BtnCaption) = 3 then
  begin
    n := Integer(High(TMsgDlgBtn)) - Integer(Low(TMsgDlgBtn)) + 1;
    SetLength(UserButtonCaptions, n);
    UserButtonCaptions[Integer(mbYes)]    := BtnCaption[Low(BtnCaption)].VPChar;
    UserButtonCaptions[Integer(mbNo)]     := BtnCaption[Low(BtnCaption)+1].VPChar;
    UserButtonCaptions[Integer(mbCancel)] := BtnCaption[Low(BtnCaption)+2].VPChar;
  end;
  Result := CreateDlg(MsgNote, mtConfirmation, [mbYes, mbNo, mbCancel]);
  case Result of
    1 : Result := 2;
    7 : Result := 1;
  else
    Result := 0;
  end;
end;

procedure ShowWarningDlg(MsgNote: string; aTimer : Boolean = False);
begin
  CreateDlg(MsgNote, mtWarning, [mbOk], aTimer);
end;

procedure ShowErrorDlg(MsgNote: string);
begin
  CreateDlg(MsgNote, mtError, [mbOk]);
end;

procedure ShowInfoDlg(MsgNote: string);
begin
  CreateDlg(MsgNote, mtInformation, [mbOk]);
end;

type
  TPromptType = (ptUnknow, ptInteger, ptFloat, ptDate, ptString, ptStrInt, ptLargeInt, ptPassword);
  TMaskEdit = class(Mask.TMaskEdit)
    private
      FAlignment : TAlignment;
      FInputMode : TPromptType;
      procedure SetInputMode(const Value: TPromptType);
    protected
      procedure SetAlignment(Value: TAlignment);
      procedure CreateParams(var Params : TCreateParams); override;
      procedure KeyPress(var Key : Char); override;
      procedure WMPaste(var Message: TMessage); message WM_PASTE;
    public
      property Alignment : TAlignment read FAlignment write SetAlignment;
      property InputMode : TPromptType read FInputMode write SetInputMode;
  end;

{ TMaskEdit Begin}
procedure TMaskEdit.CreateParams(var Params: TCreateParams);
begin
  inherited createParams(Params);
  case fAlignment of
    taRightJustify:
      Params.Style := Params.Style or ES_RIGHT;
    taLeftJustify :
      Params.Style := Params.Style or ES_LEFT;
    taCenter :
      Params.Style := Params.Style or ES_CENTER;
  end;
end;

procedure TMaskEdit.KeyPress(var Key: Char);
begin
  if InputMode in [ptInteger, ptFloat, ptStrInt, ptLargeInt] then
  begin
    if not (Key in ['0'..'9', ',', '.', Char(VK_BACK)]) then
      Key := #0
    else begin
      if Key in [',', '.'] then
      begin
         if (InputMode = ptFloat) and (Pos(DecimalSeparator, Text) = 0) then
           Key := DecimalSeparator
         else Key := #0;
      end;
    end;
  end
  else if InputMode = ptDate then
  begin
    if (Key in ['0'..'9', ',', '.', Char(VK_BACK)]) then
    begin
      if Key in [',', '.'] then
        Key := DateSeparator;
    end
    else
      Key := #0;
  end;
  inherited KeyPress(Key);
end;

procedure TMaskEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TMaskEdit.SetInputMode(const Value: TPromptType);
begin
  if FInputMode <>  Value then
  begin
    FInputMode := Value;
    case FInputMode of
      ptInteger, ptFloat, ptStrInt, ptLargeInt :
        Alignment := taRightJustify;
      else 
        Alignment := taLeftJustify;
    end;

    case FInputMode of
      ptDate : EditMask := '!99/99/9999;1;_';
    else
      EditMask := '';
    end;

    case FInputMode of
      ptPassword  :  PasswordChar := '*';
    else
      PasswordChar := #0;
    end;

    case FInputMode of
      ptInteger  :
        MaxLength := 10;
      ptLargeInt  :
        MaxLength := 20;
    else
      MaxLength := 0;
    end;                    
  end;
end;

procedure TMaskEdit.WMPaste(var Message: TMessage);
var SOld,s : string;
    n : Integer;
begin
  SOld := Text;
  inherited;
  try
    case InputMode of
      ptInteger: begin
        StrToInt(Text);
      end;
      ptLargeInt: begin
        StrToInt64(Text);
      end;
      ptStrInt: begin
        s := Text;
        n := Length(s);
        while n > 0 do
        begin
          if not (s[n] in ['0'..'9']) then
            raise Exception.Create('');
          Dec(n);
        end;
      end;
      ptDate: begin
        StrToDate(Text);
      end;
      ptFloat: begin
        StrToFloat(Text);
      end;
    end;
  except
    Text := SOld;
    SelectAll;
    if CanFocus then
      SetFocus;
  end;
end;
{ TMaskEdit End }

function CustomPromptDlg(ACaption, APrompt : String;
         var AValue : Variant; AMode : TPromptType = ptUnknow; DefWidth : Byte = 150;
         FormAutoClose : Boolean = False) : boolean;
var Form : TForm;
    Prompt: TLabel;
    Edit: TMaskEdit;
    ButtonTop, ButtonLeft,
    ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  if VarIsNull(AValue) then
    AValue := '';
  if AMode = ptUnknow then
  begin
    if VarIsOrdinal(AValue) then
      AMode := ptInteger
    else if VarIsFloat(AValue) then
      AMode := ptFloat
    else
      AMode := ptString;
  end;

  Form := TForm.Create(Application);

  if Form <> nil then
    with Form do
    try
      Font.Assign(Application.MainForm.Font);
      Canvas.Font := Font;
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := DefWidth;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent  := Form;
        Caption := APrompt;
        Left    := 8;
        Top     := 8;
        Constraints.MaxWidth := Form.ClientWidth - 2*Left;
        WordWrap := True;
      end;
      Edit := TMaskEdit.Create(Form);
      with Edit do
      begin
        Parent    := Form;
        Left      := Prompt.Left;
        Top       := Prompt.Top + Prompt.Height + 5;
        Width     := Form.ClientWidth - 2* Left;
        MaxLength := 255;
        InputMode := AMode;
        Text      := AValue;
        SelectAll;
      end;
      ButtonWidth  := 60;
      ButtonHeight := 25;

      ButtonLeft   := (ClientWidth - 2*ButtonWidth - 10) div 2;

      ButtonTop    := Edit.Top + Edit.Height + 15;
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := RusButtonCaptions[mbYes];
        ModalResult := mrOk;
        Default     := True;
        SetBounds(ButtonLeft, ButtonTop, ButtonWidth, ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := RusButtonCaptions[mbNo];
        ModalResult := mrCancel;
        Cancel      := True;
        SetBounds(Form.ClientWidth - ButtonWidth - ButtonLeft, ButtonTop,
                  ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;

      if ShowModal = mrOk then
      begin
        AValue := Edit.Text;
        if (AValue <> '') and (AValue <> '  .  .    ') then
          Result := True;
      end;
    finally
      Form.Free;
    end;
end;

function IntegerPromptDlg(ACaption, APrompt : String;
var AValue : Integer; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptUnknow, DefWidth);
  if Result then
  begin
     if varValue > MaxInt then
       AValue := MaxInt;
    AValue := varValue;
  end
end;

function FloatPromptDlg(ACaption, APrompt : String;
         var AValue : Double; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptFloat, DefWidth);
  if Result then
    AValue := varValue;
end;

function StringPromptDlg(ACaption, APrompt : String;
         var AValue : String; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptString, DefWidth);
  if Result then
    AValue := varValue;
end;

function DatePromptDlg(ACaption, APrompt : String;
         var AValue : TDateTime; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
    s1 : string;
    Y,M,D,
    Yc,Mc,Dc, N : Word;
begin
  if AValue = 0 then
    s1 := DateToStr(Now)
  else
    s1 := DateToStr(AValue);

  varValue := s1;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptDate, DefWidth);
  if Result then
  begin
    s1  := varValue;
    D := StrToIntDef(Trim(Copy(s1,1,2)), 0);
    M := StrToIntDef(Trim(Copy(s1,4,2)), 0);
    Y := StrToIntDef(Trim(Copy(s1,7,4)), 0);
    if (D = 0) and (M = 0) and (Y = 0) then
    begin
      Result := False;
      Exit;
    end
    else if (D = 0) or (M = 0) or (Y = 0) or (Y < 1000) then
    begin
      DecodeDate(Date, Yc,Mc,Dc);
      if D = 0 then
        D := Dc;
      if M = 0 then
        M := Mc;
      if Y = 0 then
        Y := Yc
      else if Y < 100 then
      begin
        N := Yc - 60;
        Inc(Y, N div 100 * 100);
        if (Y < N) then
          Inc(Y, 100);
      end
      else Inc(Y, Yc div 1000 * 1000);
    end;
    AValue := EncodeDate(Y,M,D);
  end;
end;

function StrIntPromptDlg(ACaption, APrompt : String;
         var AValue : string; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptStrInt, DefWidth);
  if Result then
    AValue := varValue;
end;

function PasswordPromptDlg(ACaption, APrompt : String;
         var AValue : String; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptPassword, DefWidth);
  if Result then
    AValue := varValue;
end;

function LargeIntPromptDlg(ACaption, APrompt : String;
         var AValue : Int64; DefWidth : Byte = 150) : boolean;
var varValue : Variant;
begin
  varValue := AValue;
  Result   := CustomPromptDlg(ACaption, APrompt, varValue, ptLargeInt, DefWidth);
  if Result then
  begin
     if varValue > MaxLongInt then
       AValue := MaxLongInt;
    AValue := varValue;
  end
end;

initialization
  SetLength(UserButtonCaptions, 0);

finalization
  SetLength(UserButtonCaptions, 0);

end.
