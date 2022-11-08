unit DBNewNav;

interface

uses
  Windows, SysUtils, Classes, Messages, Controls, ExtCtrls, Types, DB, DBCtrls;

type
  TNavigateBtn = DBCtrls.TNavigateBtn;
  TButtonSet   = DBCtrls.TButtonSet;

  TNewNavDataLink = class;

  TDBNewNav = class (TCustomPanel)
  private
    FDataLink: TNewNavDataLink;
    FVisibleButtons: TButtonSet;
    FHints: TStrings;
    FDefHints: TStrings;
    ButtonWidth: Integer;
    MinBtnSize: TPoint;
    FOnNavClick: ENavClick;
    FBeforeAction: ENavClick;
    FocusedButton: TNavigateBtn;
    FConfirmDelete: Boolean;
    FFlat: Boolean;
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClickHandler(Sender: TObject);
    function GetDataSource: TDataSource;
    function GetHints: TStrings;
    procedure HintsChanged(Sender: TObject);
    procedure InitButtons;
    procedure InitHints;
    procedure SetDataSource(Value: TDataSource);
    procedure SetFlat(Value: Boolean);
    procedure SetHints(Value: TStrings);
    procedure SetSize(var W: Integer; var H: Integer);
    procedure SetVisible(Value: TButtonSet);
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    function  GetDisableButton(Index: TNavigateBtn): Boolean;
    procedure SetDisableButton(Index: TNavigateBtn; const Value: Boolean);
  protected
    Buttons: array[TNavigateBtn] of TNavButton;
    FDisableButton : array[TNavigateBtn] of Boolean;
    FOnChange : TNotifyEvent;
    FAppend : Boolean;
    procedure DataChanged;
    procedure EditingChanged;
    procedure ActiveChanged;
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure CalcMinSize(var W, H: Integer);
    procedure DoChange; virtual;
  public
    PromtDeleteMsg : string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure BtnClick(Index: TNavigateBtn); virtual;
    property DisableButton[Index : TNavigateBtn] : Boolean read GetDisableButton write SetDisableButton;
  published
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property VisibleButtons: TButtonSet read FVisibleButtons write SetVisible
      default [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete,
        nbEdit, nbPost, nbCancel, nbRefresh];
    property Align;
    property Anchors;
    property Append : Boolean read FAppend write FAppend default False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Flat: Boolean read FFlat write SetFlat default False;
    property Ctl3D;
    property Hints: TStrings read GetHints write SetHints;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ConfirmDelete: Boolean read FConfirmDelete write FConfirmDelete default True;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property BeforeAction: ENavClick read FBeforeAction write FBeforeAction;
    property OnClick: ENavClick read FOnNavClick write FOnNavClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

  TNewNavDataLink = class(TDataLink)
  private
    FNewNav: TDBNewNav;
  protected
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure ActiveChanged; override;
  public
    constructor Create(ANav: TDBNewNav);
    destructor Destroy; override;
  end;


procedure Register;

implementation
uses Dialogs, Math;
{$R dbnav.res}

procedure Register;
begin
  RegisterComponents('Data Controls', [TDBNewNav]);
end;

{ TDBNewNav }

const
  BtnTypeName: array[TNavigateBtn] of PChar = ('FIRST', 'PRIOR', 'NEXT',
    'LAST', 'INSERT', 'DELETE', 'EDIT', 'POST', 'CANCEL', 'REFRESH');
  BtnHint: array[TNavigateBtn] of PChar = ('Первая', 'Предыдущая', 'Следующая',
    'Последняя', 'Добавить', 'Удалить', 'Редактировать', 'Принять', 'Отменить', 'Обновить');

constructor TDBNewNav.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  if not NewStyleControls then ControlStyle := ControlStyle + [csFramed];
  FDataLink := TNewNavDataLink.Create(Self);
  FVisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbInsert,
    nbDelete, nbEdit, nbPost, nbCancel, nbRefresh];
  FHints := TStringList.Create;
  TStringList(FHints).OnChange := HintsChanged;
  FAppend := False;
  InitButtons;
  InitHints;
  BevelOuter := bvNone;
  BevelInner := bvNone;
  Width := 241;
  Height := 25;
  ButtonWidth := 0;
  FocusedButton := nbFirst;
  FConfirmDelete := True;
  FullRepaint := False;
  ShowHint := True;
  Enabled := False;
  Enabled := True;
  PromtDeleteMsg := 'Удалить выбранную запись?';
end;

destructor TDBNewNav.Destroy;
begin
  FDefHints.Free;
  FDataLink.Free;
  FHints.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TDBNewNav.InitButtons;
var
  I: TNavigateBtn;
  Btn: TNavButton;
  X: Integer;
  ResName: string;
begin
  MinBtnSize := Point(20, 18);
  X := 0;
  for I := Low(Buttons) to High(Buttons) do
  begin
    Btn := TNavButton.Create (Self);
    Btn.Flat := Flat;
    Btn.Index := I;
    Btn.Visible := I in FVisibleButtons;
    Btn.Enabled := True;
    Btn.SetBounds (X, 0, MinBtnSize.X, MinBtnSize.Y);
    FmtStr(ResName, 'dbr_%s', [BtnTypeName[I]]);
    Btn.Glyph.LoadFromResourceName(HInstance, ResName);
    Btn.NumGlyphs := 2;
    Btn.Enabled := False;
    Btn.Enabled := True;
    Btn.OnClick := ClickHandler;
    Btn.OnMouseDown := BtnMouseDown;
    Btn.Parent := Self;
    Buttons[I] := Btn;
    X := X + MinBtnSize.X;
    DisableButton[I] := False;
  end;
  Buttons[nbPrior].NavStyle := Buttons[nbPrior].NavStyle + [nsAllowTimer];
  Buttons[nbNext].NavStyle  := Buttons[nbNext].NavStyle + [nsAllowTimer];
end;

procedure TDBNewNav.InitHints;
var
  I: Integer;
  J: TNavigateBtn;
begin
  if not Assigned(FDefHints) then
  begin
    FDefHints := TStringList.Create;
    for J := Low(Buttons) to High(Buttons) do
      FDefHints.Add(BtnHint[J]);
  end;
  for J := Low(Buttons) to High(Buttons) do
    Buttons[J].Hint := FDefHints[Ord(J)];
  J := Low(Buttons);
  for I := 0 to (FHints.Count - 1) do
  begin
    if FHints.Strings[I] <> '' then Buttons[J].Hint := FHints.Strings[I];
    if J = High(Buttons) then Exit;
    Inc(J);
  end;
end;

procedure TDBNewNav.HintsChanged(Sender: TObject);
begin
  InitHints;
end;

procedure TDBNewNav.SetFlat(Value: Boolean);
var
  I: TNavigateBtn;
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Flat := Value;
  end;
end;

procedure TDBNewNav.SetHints(Value: TStrings);
begin
  if Value.Text = FDefHints.Text then
    FHints.Clear else
    FHints.Assign(Value);
end;

function TDBNewNav.GetHints: TStrings;
begin
  if (csDesigning in ComponentState) and not (csWriting in ComponentState) and
     not (csReading in ComponentState) and (FHints.Count = 0) then
    Result := FDefHints else
    Result := FHints;
end;

procedure TDBNewNav.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TDBNewNav.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TDBNewNav.SetVisible(Value: TButtonSet);
var
  I: TNavigateBtn;
  W, H: Integer;
begin
  W := Width;
  H := Height;
  FVisibleButtons := Value;
  for I := Low(Buttons) to High(Buttons) do
    Buttons[I].Visible := I in FVisibleButtons;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  Invalidate;
end;

procedure TDBNewNav.CalcMinSize(var W, H: Integer);
var
  Count: Integer;
  I: TNavigateBtn;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  W := Max(W, Count * MinBtnSize.X);
  H := Max(H, MinBtnSize.Y);

  if Align = alNone then W := (W div Count) * Count;
end;

procedure TDBNewNav.SetSize(var W: Integer; var H: Integer);
var
  Count: Integer;
  I: TNavigateBtn;
  Space, Temp, Remain: Integer;
  X: Integer;
begin
  if (csLoading in ComponentState) then Exit;
  if Buttons[nbFirst] = nil then Exit;

  CalcMinSize(W, H);

  Count := 0;
  for I := Low(Buttons) to High(Buttons) do
    if Buttons[I].Visible then
      Inc(Count);
  if Count = 0 then Inc(Count);

  ButtonWidth := W div Count;
  Temp := Count * ButtonWidth;
  if Align = alNone then W := Temp;

  X := 0;
  Remain := W - Temp;
  Temp := Count div 2;
  for I := Low(Buttons) to High(Buttons) do
  begin
    if Buttons[I].Visible then
    begin
      Space := 0;
      if Remain <> 0 then
      begin
        Dec(Temp, Remain);
        if Temp < 0 then
        begin
          Inc(Temp, Count);
          Space := 1;
        end;
      end;
      Buttons[I].SetBounds(X, 0, ButtonWidth + Space, Height);
      Inc(X, ButtonWidth + Space);
    end
    else
      Buttons[I].SetBounds (Width + 1, 0, ButtonWidth, Height);
  end;
end;

procedure TDBNewNav.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  if not HandleAllocated then SetSize(W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TDBNewNav.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;
  W := Width;
  H := Height;
  SetSize(W, H);
end;

procedure TDBNewNav.WMWindowPosChanging(var Message: TWMWindowPosChanging);
begin
  inherited;
  if (SWP_NOSIZE and Message.WindowPos.Flags) = 0 then
    CalcMinSize(Message.WindowPos.cx, Message.WindowPos.cy);
end;

procedure TDBNewNav.ClickHandler(Sender: TObject);
begin
  BtnClick (TNavButton (Sender).Index);
end;

procedure TDBNewNav.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  OldFocus: TNavigateBtn;
begin
  OldFocus := FocusedButton;
  FocusedButton := TNavButton (Sender).Index;
  if TabStop and (GetFocus <> Handle) and CanFocus then
  begin
    SetFocus;
    if (GetFocus <> Handle) then
      Exit;
  end
  else if TabStop and (GetFocus = Handle) and (OldFocus <> FocusedButton) then
  begin
    Buttons[OldFocus].Invalidate;
    Buttons[FocusedButton].Invalidate;
  end;
end;

procedure TDBNewNav.BtnClick(Index: TNavigateBtn);
begin
  if (DataSource <> nil) and (DataSource.State <> dsInactive) then
  begin
    if not (csDesigning in ComponentState) and Assigned(FBeforeAction) then
      FBeforeAction(Self, Index);
    with DataSource.DataSet do
    try
      case Index of
        nbPrior: Prior;
        nbNext: Next;
        nbFirst: First;
        nbLast: Last;
        nbInsert:
          if not Self.Append then
            Insert
          else
            Append;
        nbEdit: Edit;
        nbCancel: Cancel;
        nbPost: Post;
        nbRefresh: Refresh;
        nbDelete:
          if not FConfirmDelete or
            (MessageDlg(PromtDeleteMsg, mtConfirmation, mbOKCancel, 0) <> idCancel)
          then Delete;
      end;
    except
      on EAbort do ;
      else raise;
    end;
  end;
  if not (csDesigning in ComponentState) and Assigned(FOnNavClick) then
    FOnNavClick(Self, Index);
end;

procedure TDBNewNav.WMSetFocus(var Message: TWMSetFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBNewNav.WMKillFocus(var Message: TWMKillFocus);
begin
  Buttons[FocusedButton].Invalidate;
end;

procedure TDBNewNav.KeyDown(var Key: Word; Shift: TShiftState);
var
  NewFocus: TNavigateBtn;
  OldFocus: TNavigateBtn;
begin
  OldFocus := FocusedButton;
  case Key of
    VK_RIGHT:
      begin
        if OldFocus < High(Buttons) then
        begin
          NewFocus := OldFocus;
          repeat
            NewFocus := Succ(NewFocus);
          until (NewFocus = High(Buttons)) or (Buttons[NewFocus].Visible);
          if Buttons[NewFocus].Visible then
          begin
            FocusedButton := NewFocus;
            Buttons[OldFocus].Invalidate;
            Buttons[NewFocus].Invalidate;
          end;
        end;
      end;
    VK_LEFT:
      begin
        NewFocus := FocusedButton;
        repeat
          if NewFocus > Low(Buttons) then
            NewFocus := Pred(NewFocus);
        until (NewFocus = Low(Buttons)) or (Buttons[NewFocus].Visible);
        if NewFocus <> FocusedButton then
        begin
          FocusedButton := NewFocus;
          Buttons[OldFocus].Invalidate;
          Buttons[FocusedButton].Invalidate;
        end;
      end;
    VK_SPACE:
      begin
        if Buttons[FocusedButton].Enabled then
          Buttons[FocusedButton].Click;
      end;
  end;
end;

procedure TDBNewNav.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TDBNewNav.DataChanged;
var
  UpEnable, DnEnable: Boolean;
begin
  UpEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.BOF;
  DnEnable := Enabled and FDataLink.Active and not FDataLink.DataSet.EOF;
  Buttons[nbFirst].Enabled := UpEnable and not DisableButton[nbFirst];
  Buttons[nbPrior].Enabled := UpEnable and not DisableButton[nbPrior];
  Buttons[nbNext].Enabled := DnEnable and not DisableButton[nbNext];
  Buttons[nbLast].Enabled := DnEnable and not DisableButton[nbLast];
  Buttons[nbInsert].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and not DisableButton[nbInsert];
  Buttons[nbEdit].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and not DisableButton[nbEdit];
  Buttons[nbDelete].Enabled := Enabled and FDataLink.Active and
    FDataLink.DataSet.CanModify and
    not (FDataLink.DataSet.BOF and FDataLink.DataSet.EOF)
    and not DisableButton[nbDelete];
  DoChange;
end;

procedure TDBNewNav.EditingChanged;
var
  CanModify: Boolean;
begin
  CanModify := Enabled and FDataLink.Active and FDataLink.DataSet.CanModify;
  Buttons[nbInsert].Enabled := CanModify and not DisableButton[nbInsert];
  Buttons[nbEdit].Enabled := CanModify and not FDataLink.Editing
                             and not DisableButton[nbEdit];
  Buttons[nbPost].Enabled := CanModify and FDataLink.Editing
                             and not DisableButton[nbPost];
  Buttons[nbCancel].Enabled := CanModify and FDataLink.Editing
                               and not DisableButton[nbCancel];
  Buttons[nbRefresh].Enabled := Enabled and FDataLink.Active and not DisableButton[nbRefresh];
  DoChange;
end;

procedure TDBNewNav.ActiveChanged;
var
  I: TNavigateBtn;
begin
  if not (Enabled and FDataLink.Active) then
  begin
    for I := Low(Buttons) to High(Buttons) do
      Buttons[I].Enabled := False;
    DoChange;  
  end
  else
  begin
    DataChanged;
    EditingChanged;
  end;
end;

procedure TDBNewNav.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  if not (csLoading in ComponentState) then
    ActiveChanged;
end;

procedure TDBNewNav.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if not (csLoading in ComponentState) then
    ActiveChanged;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TDBNewNav.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TDBNewNav.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  SetSize(W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
  InitHints;
  ActiveChanged;
end;

function TDBNewNav.GetDisableButton(Index: TNavigateBtn): Boolean;
begin
  Result := FDisableButton[Index];
end;

procedure TDBNewNav.SetDisableButton(Index: TNavigateBtn;
  const Value: Boolean);
begin
  if FDisableButton[Index] <> Value then
  begin
    FDisableButton[Index] := Value;
    ActiveChanged;
  end;
end;

procedure TDBNewNav.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TNewNavDataLink }

constructor TNewNavDataLink.Create(ANav: TDBNewNav);
begin
  inherited Create;
  FNewNav := ANav;
  VisualControl := True;
end;

destructor TNewNavDataLink.Destroy;
begin
  FNewNav := nil;
  inherited Destroy;
end;

procedure TNewNavDataLink.EditingChanged;
begin
  if FNewNav <> nil then FNewNav.EditingChanged;
end;

procedure TNewNavDataLink.DataSetChanged;
begin
  if FNewNav <> nil then FNewNav.DataChanged;
end;

procedure TNewNavDataLink.ActiveChanged;
begin
  if FNewNav <> nil then FNewNav.ActiveChanged;
end;


end.
