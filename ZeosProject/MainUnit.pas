unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, ActnList, InterfaceUnit,
  DBCtrlsEh, Mask, DBGridEh, Tabs, Grids, ImgList, Buttons;

type
  TStatusBar = class(ComCtrls.TStatusBar)
    private
      procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
  end;

  TfmMain = class(TForm, IMaster)
    mmMenu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    sbMain: TStatusBar;
    alMain: TActionList;
    dbgConsole: TDBGridEh;
    N5: TMenuItem;
    actClearConsole: TAction;
    actHideConsole: TAction;
    actShowConsole: TAction;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    pmConsole: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    splConcole: TSplitter;
    aniStatus: TAnimate;
    actCopyConsoleRow: TAction;
    N11: TMenuItem;
    actCopyConsoleAll: TAction;
    N12: TMenuItem;
    N13: TMenuItem;
    Reconnect1: TMenuItem;
    tcChild: TTabControl;
    ilChildIcon: TImageList;
    edtCalcDate: TDBDateTimeEditEh;
    actDebug: TAction;
    miDebug: TMenuItem;
    miN14: TMenuItem;
    miClearCash: TMenuItem;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actClearConsoleExecute(Sender: TObject);
    procedure actHideConsoleExecute(Sender: TObject);
    procedure actShowConsoleExecute(Sender: TObject);
    procedure actCopyConsoleRowExecute(Sender: TObject);
    procedure actCopyConsoleAllExecute(Sender: TObject);
    procedure Reconnect1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure sbMainResize(Sender: TObject);
    procedure dbgConsoleGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure dbgConsoleDblClick(Sender: TObject);
    procedure splConcolePaint(Sender: TObject);
    procedure tcChildResize(Sender: TObject);
    procedure tcChildMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tcChildChange(Sender: TObject);
    procedure sbMainClick(Sender: TObject);
    procedure sbMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edtCalcDateExit(Sender: TObject);
    procedure edtCalcDateKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure actDebugExecute(Sender: TObject);
    procedure miClearCashClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FChildList    : TList;
    FHintIndex    : Integer;
    FLogined,
    FDebug,
    FReportFinded,
    FClosedApp : Boolean;
    FReport : IReport;
    FGlobal : IGlobal;
    FCalcDate, FOriginDate : TDate;

    FError2Dlg,
    FWarning2Dlg : Boolean;

    procedure ChangeFormScale(const Sender : Pointer);
    procedure LoadIniData;
    function  GetIniData(const Section, Ident: string; const Key : Char): Variant;
    function  SetIniData(const Section, Ident: string; Value : Variant): boolean;
    function  GetIniDataSection(const Section: string): string;
  private
    FLockUpdateCount,
    FDefLng : Integer;
    procedure LockUpdateClient;
    procedure UnLockUpdateClient(const AClearLock : Boolean = False);
  protected
    procedure CreateCustomMenu;
    procedure CreateAndShowChildForm(var AForm : TForm; AFormClass : TFormClass;
                                     ACaption : String);
    procedure DeleteFromTabs(AForm: Pointer);
    procedure ActiveFormTabs(AForm: Pointer);
    function  ActiveTabForm: Pointer;

    procedure CheckTabsVisible;
    procedure OnAppException(Sender: TObject; E: Exception);
    procedure ShowConnected(AValue: Boolean);
    procedure EnabledAction(const AAction : Pointer; const AValue : Boolean = True);
    procedure VisibleAction(const AAction : Pointer; const AValue : Boolean = True);
    function  ReadOnlyAction(const AAction : Pointer) : Boolean;
    function  SetActionHelpContext(const AAction : Pointer;
                const AName : string = ''; const AForm : string = ''): Boolean;
    procedure GetFormWhenNil(var AForm : TForm);
    procedure RefreshReference(const ARef: integer); dynamic;
    procedure ReCheckMainMenuItem;
    function  GetCalcDateText(Value : TDateTime) : string; dynamic;
    function  GetCorrectWorkDate(Value : TDateTime) : TDateTime; dynamic;
  public
    { Public declarations }
    function CloseQuery: Boolean; override;
    function GetData(AQuery : Pointer; HaveResult : Boolean = True;
                AReadOnly : Boolean = False; ARequired : Boolean = False): Boolean;
    procedure ShowAniStatus;
    procedure HideAniStatus;
    // to Concole
    procedure ShowError(AText: String; const Args: array of const);
    procedure ShowInfo(AText: String; const Args: array of const);
    procedure ShowWarning(AText: String; const Args: array of const);
    procedure ShowScrWarning(AText : String; const Args: array of const);
    procedure ShowDebug(AText : String; const Args: array of const);
    // to Message
    procedure ShowErrorDlg(AText : String; const Args: array of const);
    procedure ShowWarningDlg(AText : String; const Args: array of const);
    procedure ShowInfoDlg(AText : String; const Args: array of const);

    function  GetModuleName(const AName : String) : string;
    function  GetModuleAction(const AName : String) : Pointer;
    function  GetModuleForm(const AName : String) : Pointer;

    //function
    function  OpenNewReport : Boolean;
    function  OpenReportByID(AId : Integer) : Boolean;
    function  OpenReportByKeyWord(AKeyWord : String) : Boolean;

    function  Report : IReport;
    function  Global : IGlobal;
    function  ClearReport: Boolean;
    function  DebugMode: Boolean;
    function  CheckConnection(Lgn: String; Pswd: String): Boolean; dynamic;
    function  GetUsersInfo: String; virtual;
    function  GetCalcDate(Origin: Boolean = False): TDateTime;
    function  GetActiveFormCalcDate : TDateTime;
    procedure ClearCalcDate;
    function  HaveAccess(const fmName, ctlName : string; const KeyState : Byte;
      const ShowMessage : Boolean = False) : Boolean;
    procedure LoadAccess; dynamic;
    function  IsAppClosed: Boolean;
    procedure AppTerminate;
    function  DefaultLNG : Integer;
  end;

var
  fmMain: TfmMain;

implementation
{$i Utils.inc}

uses DataUnit, ConstUnit, Clipbrd, DateUtils, AboutUnit,
     (*{$IFDEF USE_LOCAL_REPORT}
     LocalReportUnit, {$ELSE} ReportUnit,
     {$ENDIF}*)
     ClientUnit, SimpleDialog, IniFiles, StrUtils, ZDataset,
     DebugUnit, UtilsUnit ;

{$R *.dfm}

{ TStatusBar }

procedure TStatusBar.CMHintShow(var Message: TCMHintShow);
begin
  inherited;
  //with Message.HintInfo^ do
  //  HintStr := Format('%d x %d',[CursorPos.X, CursorPos.Y]);
end;

{ TfmMain }

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FLockUpdateCount := 0;
  FClosedApp := False;
  //FDebug        := True;
  //tcChild.DoubleBuffered := True;
  FReport       := nil;
  FGlobal       := nil;
  FReportFinded := False;
  DecimalSeparator := '.';
  ChangeFormScale(Self);
  LoadIniData;
  ShowConnected(False);
  FHintIndex := -1;
  FLogined   := False;
  Application.Title := AppTitle;
  Application.OnException := OnAppException;
  Caption := AppTitle + AppVersion;
  CreateCustomMenu;
  //actHideConsole.Execute;
  FChildList := TList.Create;

  FOriginDate := 0;
  FCalcDate   := 0;

  edtCalcDate.Visible := False;
  edtCalcDate.Parent  := sbMain;
  edtCalcDate.Top     := 3;
  edtCalcDate.Left    := aniStatus.Left;

  actHideConsole.Execute;
  actShowConsole.Execute;

  FDefLng := 0;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FChildList.Free;
end;

procedure TfmMain.LockUpdateClient;
begin
  if FLockUpdateCount = 0 then
    SendMessage(Self.ClientHandle, WM_SETREDRAW, 0, 0) ;
  Inc(FLockUpdateCount);
end;

procedure TfmMain.UnLockUpdateClient(const AClearLock : Boolean = False);
begin
  Dec(FLockUpdateCount) ;
  if AClearLock and (FLockUpdateCount <> 0) then
    FLockUpdateCount := 0;
  if FLockUpdateCount = 0 then
  begin
    SendMessage(Self.ClientHandle, WM_SETREDRAW, 1, 0) ;
    RedrawWindow(Self.ClientHandle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_NOINTERNALPAINT)
    //Self.ActiveMDIChild.Refresh;
  end;
end;

procedure TfmMain.CreateCustomMenu;

  function StrWithOutAmpersand(const AValue : String) : string;
  var n : Integer;
  begin
    n      := Length(AValue);
    Result := AValue;
    while n > 0 do
    begin
      if Result[n] = '&' then
        Delete(Result, n, 1);
      Dec(n);
    end;
  end;

var i,j,k,n,l,
    iAfter   : integer;
    mItem    : TMenuItem;
    actItem  : TAction;
    Category : string;
    mmCount  : integer;
begin
  mmCount := mmMenu.Items.Count;
  for i := 0 to alMain.ActionCount - 1 do
  begin
    actItem  := TAction(alMain.Actions[i]);
    Category := actItem.Category;
    k := Length(Category);
    if (k = 0) or ((Category[1] = '<') and (Category[k] = '>')) then
      Continue;
    // определение категории экшена
    k      := -1;
    iAfter := -1;
    l := 99;
    if Category[1] in ['0'..'9'] then
    begin
      n := PosEx('_', Category);
      l := StrToIntDef(Copy(Category,1,n-1), 0);
      Category := Copy(Category, n+1, 255);
    end;
    for j := 1 to mmCount - 2 do
    begin
      n := mmMenu.Items[j].Tag - l;
      if n = 0 then
        n := AnsiCompareStr(StrWithOutAmpersand(mmMenu.Items[j].Caption), Category);
      if n = 0 then
      begin
        k := j;
        Break;
      end
      else if n > 0 then
      begin
        iAfter := j;
        Break;
      end;
    end;
    // автоматическое создание категории
    if k = -1 then
    begin
      mItem         := TMenuItem.Create(mmMenu);
      mItem.Caption := Category;
      mItem.Tag     := l;
      if iAfter = - 1 then
        mmMenu.Items.Insert(mmCount-1, mItem)
      else
        mmMenu.Items.Insert(iAfter, mItem);
      inc(mmCount);
      k := mItem.MenuIndex;
    end;
    mItem := TMenuItem.Create(mmMenu);
    mItem.Action := actItem ;
    // определение в какую позицию втавить
    iAfter := -1;
    for j := 0 to mmMenu.Items[k].Count - 1 do
    begin
      n := 0;
      if Assigned(mItem.Action) then
      begin
        if Assigned(mmMenu.Items[k].Items[j].Action) then
          n := mmMenu.Items[k].Items[j].Action.Tag-mItem.Action.Tag
        else
          n := -mItem.Action.Tag;
      end;
      if n = 0 then
        n := AnsiCompareStr(StrWithOutAmpersand(mmMenu.Items[k].Items[j].Caption),
                            StrWithOutAmpersand(mItem.Caption));
      if n >= 0 then
      begin
        iAfter := j;
        Break;
      end;
    end;
    if iAfter = -1 then
      iAfter := mmMenu.Items[k].Count;
    mmMenu.Items[k].Insert(iAfter, mItem);
    if actItem.HelpKeyword = '' then
      actItem.HelpKeyword := 'FM'+UpperCase(Copy(actItem.Name, 4, 255));
  end;
end;

procedure TfmMain.N3Click(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.actDebugExecute(Sender: TObject);
var i : integer;
begin
  for i := 0 to FChildList.Count-1 do
    if TForm(FChildList.Items[i]).Visible and
       (TForm(FChildList.Items[i]).Name = Screen.ActiveForm.Name)
    then begin
      DebugUnit.ShowDebugForm(TForm(FChildList.Items[i]));
      Break;
    end;
end;

procedure TfmMain.CreateAndShowChildForm(var AForm: TForm;
  AFormClass: TFormClass; ACaption : String);
begin
  if AForm = nil then
  begin
    try
      LockUpdateClient;
      AForm     := AFormClass.Create(Self);
      AForm.WindowState := wsMaximized;
    finally
      UnLockUpdateClient;
    end;
    FChildList.Add(AForm);

    tcChild.Tabs.AddObject(ACaption, AForm);
    if not AForm.Icon.Empty then
      ilChildIcon.AddIcon(AForm.Icon)
    else
      ilChildIcon.AddIcon(Application.Icon);
    tcChild.TabIndex := tcChild.Tabs.Count-1;
    CheckTabsVisible;
  end;
  AForm.Show;
end;

function TfmMain.GetData(AQuery : Pointer; HaveResult : Boolean = True;
                AReadOnly : Boolean = False; ARequired : Boolean = False): Boolean;
var CanHide : Boolean;
begin
  CanHide := not aniStatus.Active;
  aniStatus.Active  := True;
  aniStatus.Visible := True;
  //Application.ProcessMessages;
  try
    Result := dmSimpleClient.GetQueryData(AQuery, HaveResult, AReadOnly, ARequired);
    //Sleep(1000);
  finally
    if CanHide then
    begin
      aniStatus.Visible := False;
      aniStatus.Active  := False;
    end;
  end;
end;

procedure TfmMain.HideAniStatus;
begin
  aniStatus.Visible := False;
  aniStatus.Active  := False;
  Application.ProcessMessages;
end;

procedure TfmMain.ShowAniStatus;
begin
  aniStatus.Active  := True;
  aniStatus.Visible := True;
  Application.ProcessMessages;
end;

procedure TfmMain.ShowError(AText: String; const Args: array of const);
begin
  if AText <> '' then
  begin
    if FError2Dlg then
      ShowErrorDlg(AText, Args);

    dmSimpleClient.AddMessage(Format(AText, Args), clError);
    actShowConsole.Execute;
  end;
end;

procedure TfmMain.ShowInfo(AText: String; const Args: array of const);
begin
  if AText <> '' then
  begin
    dmSimpleClient.AddMessage(Format(AText, Args), clInfo);
    actShowConsole.Execute;
  end;
end;

procedure TfmMain.ShowWarning(AText: String; const Args: array of const);
begin
  if AText <> '' then
  begin
    if FWarning2Dlg then
      ShowWarning(AText, Args);

    dmSimpleClient.AddMessage(Format(AText, Args), clWarning);
    actShowConsole.Execute;
  end;
end;

procedure TfmMain.ShowScrWarning(AText: String;
  const Args: array of const);
begin
  if AText <> '' then
  begin
    dmSimpleClient.AddMessage(Format(AText, Args), clWarning, 1);
    actShowConsole.Execute;
  end;
end;

procedure TfmMain.ShowDebug(AText: String; const Args: array of const);
begin
  if FDebug then
  begin
    dmSimpleClient.AddMessage(Format('Debug: ' + AText, Args), clDebug);
    actShowConsole.Execute;
  end;
end;

procedure TfmMain.dbgConsoleGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  AFont.Color := dmSimpleClient.GetFontColor;
end;

type TMyTabs = class(TCustomTabControl);

procedure TfmMain.DeleteFromTabs(AForm : Pointer);
var i : Integer;
begin
  if AForm = nil then Exit;

  i := tcChild.Tabs.IndexOfObject(AForm);
  if (i >= 0) and (i < tcChild.Tabs.Count) then
  begin
    tcChild.Tabs.Delete(i);
    ilChildIcon.Delete(i);
    FChildList.Extract(AForm);
    TMyTabs(tcChild).UpdateTabImages;
    CheckTabsVisible;
  end;
end;

procedure TfmMain.tcChildChange(Sender: TObject);
var F : TForm;
begin
  try
    LockUpdateClient;
    F := TForm(tcChild.Tabs.Objects[tcChild.TabIndex]);
    with F do
    begin
      Show;
    end;
  finally
    UnLockUpdateClient;
  end;
end;

procedure TfmMain.dbgConsoleDblClick(Sender: TObject);
begin
  actHideConsole.Execute;
end;

procedure TfmMain.actClearConsoleExecute(Sender: TObject);
begin
  {if}
  dmSimpleClient.EmptyMessages;// then
  //actHideConsole.Execute;
end;

procedure TfmMain.actHideConsoleExecute(Sender: TObject);
begin
  if dbgConsole.Visible then
  begin
    splConcole.Visible := False;
    dbgConsole.Visible := False;
  end;
end;

procedure TfmMain.actShowConsoleExecute(Sender: TObject);
begin
  if not dbgConsole.Visible then
  begin
    dbgConsole.Visible := True;
    splConcole.Visible := True;
  end;
  Application.ProcessMessages;
end;

procedure TfmMain.OnAppException(Sender: TObject; E: Exception);

  function GridColumn(AGrid : TDBGridEh; const AFieldName : string) : TColumnEh;
  var i : Integer;
  begin
    Result := nil;
    for i := 0 to AGrid.FieldCount - 1 do
      if AnsiCompareText(AFieldName, AGrid.Columns[i].FieldName) = 0 then
      begin
        Result := AGrid.Columns[i];
        if not Result.Visible then
          Result := nil;
        Break;
      end;
  end;

  function ConvertFromDBGridError(AValue : String): String;
  var FN : String;
      i,j,n : Integer;
  const
    DBInsertError    = 'Field '''' must have a value';
    RusDBInsertError = 'Поле ''%s'' необходимо заполнить!';
  begin
    Result := '';
    // Example: Field 'knu' must have a value
    i  := 1;
    n  := Length(AValue);
    while (i<=n) and (AValue[i] <> '''') do Inc(i);
    j  := i + 1;
    while (j<=n) and (AValue[j] <> '''') do Inc(j);
    FN := Copy(AValue, i+1, j-i-1);
    if FN <> '' then
    begin
      Result := AValue;
      Delete(Result, i+1, j-i-1);
      if (Result = DBInsertError) then
      begin
       if (Sender is TDBGridEh) then
          with TDBGridEh(Sender) do
            Result := Format(RusDBInsertError,[Columns[SelectedIndex].Title.Caption]);
      end
      else
        Result := AValue;
    end
    else
      Result := AValue;
  end;

  function ConvertFromDBGridErrorZ(AValue : String): String;
  var FN : String;
      i,j,n : Integer;
      C : TColumnEh;
  const
    DBInsertError    = 'Field '''' must have a value';
    RusDBInsertError = 'Поле ''%s'' необходимо заполнить!';
  begin
    Result := AValue;
    // Example: SQL Error: ОШИБКА:  нулевое значение в колонке "..." нарушает ограничение NOT NULL
    //          DETAIL:  Ошибочная строка содержит (...).
    FN := Copy(AValue,1,10);
    if AnsiUpperCase(FN) <> 'SQL ERROR:' then Exit;
    Delete(Result,1,10);
    i  := PosEx('DETAIL:', Result);
    n  := Length(Result);
    if i > 0 then
      Delete(Result,i,n-i+1);
    Result := Trim(Result);
    FN := '';
    i := 1;
    n  := Length(Result);
    while (i<=n) and (Result[i] <> '"') do Inc(i);
    j  := i + 1;
    while (j<=n) and (Result[j] <> '"') do Inc(j);
    FN := Copy(Result, i+1, j-i-1);
    if (FN <> '') and (Sender is TDBGridEh) then
    begin

      C := GridColumn(TDBGridEh(Sender), FN);
      if Assigned(C) then
      begin
        Delete(Result, i+1, j-i-1);
        Insert(C.Title.Caption,Result,i+1);
      end;
    end;
  end;

var S1,S2,S3 : string;
begin
  S1 := UpperCase(Sender.ClassName);
  S2 := UpperCase(E.ClassName);

  S3 := E.Message;

  if dmSimpleClient.CheckCloseConnectionMessage(S3) then Exit;

  if (S1 = 'TDBGRIDEH') then
  begin
    if (S2 = 'EDATABASEERROR') then
      ShowError(ConvertFromDBGridError(E.Message),[])
    else if (S2 = 'EZDATABASEERROR') then
      ShowError(ConvertFromDBGridErrorZ(E.Message),[])
    else
      ShowError(E.Message,[]);
  end
  else if S1 = '' then
  begin

  end
  else
    ShowError(E.Message,[]);
end;

procedure TfmMain.ActiveFormTabs(AForm: Pointer);
var i : integer;
begin
  if AForm <> nil then
  begin
    //i := FChildList.IndexOf(AForm);
    i := tcChild.Tabs.IndexOfObject(AForm);
    with tcChild do
      if (i >= 0) and (i <= Tabs.Count - 1) and (i <> TabIndex) then
        TabIndex := i;
  end;
  if edtCalcDate.Visible then
    edtCalcDate.Perform(WM_CHAR, ord(VK_ESCAPE),0);
end;

function TfmMain.ActiveTabForm: Pointer;
begin
  Result := nil;
  if tcChild.TabIndex > -1 then
    Result :=  tcChild.Tabs.Objects[tcChild.TabIndex];
end;

procedure TfmMain.splConcolePaint(Sender: TObject);
var X,Y,R : Integer;
begin
  with splConcole do
  begin
    X := Width div 2;
    Y := Height div 2;
    R :=  Y - Y div 4;
    Canvas.Pen.Color   := clRed;
    Canvas.Brush.Color := clRed;
    Canvas.Ellipse(X-R,Y-R, X+R, Y+R);
    Canvas.Ellipse(X-4*R,Y-R, X-2*R, Y+R);
    Canvas.Ellipse(X+2*R,Y-R, X+4*R, Y+R);
  end;
end;

procedure TfmMain.ShowConnected(AValue: Boolean);
begin
  if AValue then
    sbMain.Panels[0].Text := 'Подключено ('+dmSimpleClient.conDB.HostName+')'
  else
    sbMain.Panels[0].Text := 'Отключено';

  sbMain.Panels[0].Width := sbMain.Canvas.TextWidth(sbMain.Panels[0].Text)+10;
  sbMainResize(sbMain);
end;

procedure TfmMain.sbMainResize(Sender: TObject);
//var d : Integer;
begin
  //exit;
  with sbMain do
  begin
    {if Top < dbgConsole.Top then
    begin
      d := Top;
      Top := dbgConsole.Top + 5;
      dbgConsole.Top := d;
    end;}
    aniStatus.Left := sbMain.Width - aniStatus.Width - 15;
    Panels[1].Width := aniStatus.Left - Panels[0].Width - 5;
    edtCalcDate.Left  := aniStatus.Left;
    edtCalcDate.Width := aniStatus.Width;
  end;
end;

procedure TfmMain.actCopyConsoleRowExecute(Sender: TObject);
begin
  Clipboard.AsText := dmSimpleClient.GetMessageText;
end;

procedure TfmMain.actCopyConsoleAllExecute(Sender: TObject);
begin
  Clipboard.AsText := dmSimpleClient.GetMessageText(False, True);
end;

procedure TfmMain.Reconnect1Click(Sender: TObject);
begin
  //if tcChild.Tabs.Count = 0 then
    dmSimpleClient.ReconnectToServer
  //else
  //  ShowWarningDlg('Закройте все вкладки! и повторите',[]);
end;

procedure TfmMain.tcChildResize(Sender: TObject);
var H : Integer;
    TempC : TCanvas;
begin
  TempC := TCanvas.Create;
  if TempC <> nil then
  try
    TempC.Handle := tcChild.Canvas.Handle;
    TempC.Font := tcChild.Font;
    H := TempC.TextHeight('W');
    H := (H+5)*tcChild.RowCount + 6;
    if tcChild.Height <> H then
      tcChild.Height := H;
  finally
    TempC.Free;
  end;
end;

procedure TfmMain.tcChildMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i : Integer;
begin
  i := tcChild.IndexOfTabAt(x,y);
  if i <> FHintIndex then
  begin
    Application.CancelHint;
    if i > -1 then
    begin
      tcChild.Hint := TForm(FChildList.Items[i]).Caption;
    end
    else
      tcChild.Hint := '';
    FHintIndex := i;
  end;
end;

procedure TfmMain.CheckTabsVisible;
begin
  with tcChild do
    Visible := (Tabs.Count > 1);
end;

procedure TfmMain.EnabledAction(const AAction: Pointer; const AValue: Boolean);
begin
  if TAction(AAction).HelpContext in [API_ACTION_HIDDEN .. API_ACTION_ALL] then
    TAction(AAction).Enabled := ((TAction(AAction).HelpContext and API_ACTION_ENABLED) = API_ACTION_ENABLED) and AValue
  else
    TAction(AAction).Enabled := AValue;
end;

procedure TfmMain.VisibleAction(const AAction: Pointer; const AValue: Boolean);
begin
  if TAction(AAction).HelpContext in [API_ACTION_HIDDEN .. API_ACTION_ALL] then
    TAction(AAction).Visible := ((TAction(AAction).HelpContext and API_ACTION_VISIBLE)= API_ACTION_VISIBLE) and AValue
  else
    TAction(AAction).Visible := AValue;
end;

function TfmMain.ReadOnlyAction(const AAction: Pointer): Boolean;
begin
  if TAction(AAction).HelpContext in [API_ACTION_HIDDEN .. API_ACTION_ALL] then
    Result := ((TAction(AAction).HelpContext and API_ACTION_READONLY) = API_ACTION_READONLY)
  else
    Result := False;
end;

function TfmMain.SetActionHelpContext(const AAction: Pointer; const AName,
  AForm: string): Boolean;
begin
  Result := dmSimpleClient.SetActionHelpContext(TAction(AAction), AName, AForm);
end;

procedure TfmMain.N5Click(Sender: TObject);
begin
  ShowAboutForm;
end;

procedure TfmMain.GetFormWhenNil(var AForm: TForm);
begin
  if AForm = nil then
    AForm := Screen.ActiveForm;
end;

function TfmMain.GetModuleName(const AName: String): string;
var S : string;
    i : Integer;
begin
  S := UpperCase(AName);
  if S = '' then
  begin
    Result := MSG_API_AUTO_CREATE;
    Exit;
  end;
  for i := 0 to alMain.ActionCount - 1 do
    if S = TAction(alMain.Actions[i]).HelpKeyword then
    begin
      Result := TAction(alMain.Actions[i]).Caption;
      Exit;
    end;
  {if S = UpperCase(dmGlobalData.Name) then
    Result := MSG_API_GLOBAL
  else}
    Result := AName;
end;

function TfmMain.GetModuleAction(const AName: String): Pointer;
var S : string;
    i : Integer;
begin
  Result := nil;
  S := AnsiUpperCase(AName);
  if S = '' then
    Exit;
  for i := 0 to alMain.ActionCount - 1 do
    if (S = AnsiUpperCase(TAction(alMain.Actions[i]).HelpKeyword)) and
       (TAction(alMain.Actions[i]).Enabled)
    then begin
      Result := TAction(alMain.Actions[i]);
      Exit;
    end;
end;

function TfmMain.GetModuleForm(const AName: String): Pointer;
var S : string;
    i : Integer;
begin
  Result := nil;
  S := AnsiUpperCase(AName);
  if S = '' then
    Exit;
  for i := 0 to FChildList.Count - 1 do
    if S = AnsiUpperCase(TForm(FChildList.Items[i]).Name) then
    begin
      Result := TForm(FChildList.Items[i]);
      Exit;
    end;
end;

function TfmMain.OpenNewReport: Boolean;
begin
  Result := False;
end;

function TfmMain.OpenReportByID(AId: Integer): Boolean;
begin
  Result := False;
end;

function TfmMain.OpenReportByKeyWord(AKeyWord: String): Boolean;
begin
  Result := False;
end;

function TfmMain.Report: IReport;
var i : Integer;
begin
  Result := FReport;
  if (Result = nil) and (not FReportFinded) then
  begin
    // Необходимо определить есть ли модуль с IReport
    for i := 0 to Screen.DataModuleCount - 1 do
    begin
      if Supports(Screen.DataModules[i], IReport, FReport) then
        Break;
    end;
    Result        := FReport;
    FReportFinded := True;
  end;
  if Result = nil then
    raise Exception.Create(MSG_NOT_FOUND_REPORT);
end;

function TfmMain.ClearReport: Boolean;
begin
  FReport := nil;
  Result  := True;
end;

function TfmMain.DebugMode: Boolean;
begin
  Result := FDebug;
end;

function TfmMain.CheckConnection(Lgn, Pswd: String): Boolean;
begin
  if (Lgn <> '') and (Pswd <> '') then
  begin
    Result := dmSimpleClient.CheckConnection(Lgn, Pswd);

    if Result then
    begin
      sbMain.Panels[1].Text := dmSimpleClient.UserInfo.fio;
      DefaultLNG;
    end;
  end
  else
    Result := False;

  sbMain.Panels[2].Text := GetCalcDateText(GetCalcDate());  
end;

function TfmMain.GetUsersInfo: String;
begin
  Result := dmSimpleClient.GetUsersInfo;
end;

function TfmMain.IsAppClosed: Boolean;
begin
  Result := FClosedApp;
end;

procedure TfmMain.AppTerminate;
begin
  //Application.Terminate;
  FClosedApp := True;
  Self.Perform(WM_CLOSE, 0,0);
end;

function TfmMain.DefaultLNG: Integer;
begin
  if FDefLng = 0 then
  begin
    FDefLng := GetIniData('main', 'deflng', 'i');
    if FDefLng = 0 then
    begin
      dmSimpleClient.zqrAny.Close;
      dmSimpleClient.zqrAny.SQL.Text := QR_DEF_LANG;
      if GetData(dmSimpleClient.zqrAny) then
        FDefLng := dmSimpleClient.zqrAny.Fields[0].AsInteger;
      if FDefLng = 0 then
        FDefLng := DEF_LNG;
    end;
  end;
  Result := FDefLng;
end;

function TfmMain.CloseQuery: Boolean;
var i : Integer;
begin
  if not FClosedApp then
  begin
    FClosedApp := True;
    if (FChildList.Count > 0) then
    begin
    // если есть открытые формы задавать вопрос
      FClosedApp := ConfirmDlg(DLG_MAY_EXIT);
      if FClosedApp then
      begin
        for i := FChildList.Count - 1 downto 0 do
        begin
          try
            TForm(FChildList.Items[i]).Close;
          except
            FClosedApp := False;
            Break;
          end;
        end;
      end;
    end;
  end;
  
  Result := FClosedApp;
  if Result then
  begin
    // необходимость чтобы пользователь увидел
    // что могло поменяться сообщение

    Application.ProcessMessages;
    Sleep(10);
    Result := inherited CloseQuery;
    FGlobal := nil;
    FReport := nil;
  end;
end;

procedure TfmMain.ShowErrorDlg(AText: String; const Args: array of const);
begin
  SimpleDialog.ShowErrorDlg(Format(AText,Args));
end;

procedure TfmMain.ShowInfoDlg(AText: String; const Args: array of const);
begin
  SimpleDialog.ShowInfoDlg(Format(AText,Args));
end;

procedure TfmMain.ShowWarningDlg(AText: String;
  const Args: array of const);
begin
  SimpleDialog.ShowWarningDlg(Format(AText,Args));
end;

procedure TfmMain.ChangeFormScale(const Sender : Pointer);
begin
  Exit;
  if Assigned(Sender) and
    (Screen.Width >= 1024) and (Screen.Height >= 768)
  then begin
    TForm(Sender).ScaleBy(32,25);
    TForm(Sender).Width  := 1024;
    TForm(Sender).Height := 768;
  end;
end;

procedure TfmMain.LoadIniData;
var f : string;
begin
  FDebug := GetIniData('main','debug', 'b');
  f := GetIniData('main','logo','s');
  if ExtractFileDrive(f) = '' then
    f := ExtractFilePath(Application.ExeName)+f;
  if FileExists(f) then
  begin
    aniStatus.CommonAVI := aviNone;
    aniStatus.FileName  := f;
  end
  else begin
    aniStatus.CommonAVI := aviFindComputer;
  end;
  aniStatus.Visible := False;
  aniStatus.Parent  := sbMain;
  aniStatus.Top     := 3;
  aniStatus.Left    := sbMain.Width - aniStatus.Width - 15;

  f := GetIniData('main', 'show','s');
  f := LowerCase(f);
  if f = 'max' then
    Self.WindowState := wsMaximized;

  FError2Dlg   := GetIniData('Console', 'Error2Dlg', 'b');
  FWarning2Dlg := GetIniData('Console', 'Warning2Dlg', 'b');
end;

function TfmMain.GetIniData(const Section, Ident: string; const Key : Char): Variant;
var f : string;
begin
  if ParamCount = 1 then
  begin
    f := ParamStr(1);
    if ExtractFilePath(f) = '' then
      f := ExtractFilePath(Application.ExeName) + ExtractFileName(f);
    f := ChangeFileExt(f,'.ini');
  end
  else
    f := ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(f) do
  try
    case Key of
      'i','I' : Result := ReadInteger(Section,Ident, 0);
      'b','B' : Result := ReadBool(Section,Ident, False);
      'd','D' : Result := ReadDate(Section,Ident, 0);
      'f','F' : Result := ReadFloat(Section,Ident, 0);
      't','T' : Result := ReadTime(Section,Ident, 0);
      'p','P' : begin
        f := ReadString(Section,Ident, '');
        if (Length(f) > 2) then
        begin
          if f[Length(f)] <> PathDelim then
            f := f + PathDelim;
          Result := f;
        end
        else
          Result := '';
      end;
    else
      Result := ReadString(Section,Ident, '');
    end;
  finally
    Free;
  end;
end;

function TfmMain.SetIniData(const Section, Ident: string;
  Value: Variant): boolean;
var f : string;
    V : PVarData;
begin
  if ParamCount = 1 then
  begin
    f := ParamStr(1);
    if ExtractFilePath(f) = '' then
      f := ExtractFilePath(Application.ExeName) + ExtractFileName(f);
    f := ChangeFileExt(f,'.ini');
  end
  else
    f := ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(f) do
  try
    V := FindVarData(Value);
    WriteString(Section,Ident, Value);

    if V.VType in [varSmallInt, varInteger, varShortInt,
                   varByte, varWord]
    then
      WriteInteger(Section,Ident, V2I(Value))
    else if V.VType in [varBoolean] then
      WriteBool(Section,Ident, Value)
    else if V.VType in [varLongWord, varInt64] then
      WriteString(Section,Ident, VarToStr(Value))
    else if V.VType in [varSingle, varDouble, varCurrency] then
      WriteFloat(Section,Ident, V2D(Value))
    else if V.VType in [varDate] then
      WriteDateTime(Section,Ident, V2Dt(Value))
    else
      WriteString(Section,Ident, VarToStr(Value));
  finally
    Free;
  end;

  Result := True;
end;

function TfmMain.GetIniDataSection(const Section: string): string;
var tSL : TStringList;
    f : string;
begin
  if ParamCount = 1 then
  begin
    f := ParamStr(1);
    if ExtractFilePath(f) = '' then
      f := ExtractFilePath(Application.ExeName) + ExtractFileName(f);
    f := ChangeFileExt(f,'.ini');
  end
  else
    f := ChangeFileExt(Application.ExeName,'.ini');
  tSL := TStringList.Create;
  try
    with TIniFile.Create(f) do
    try
      ReadSectionValues(Section, tSL);

      Result := tSL.Text;
    finally
      Free;
    end;
  finally
    tSL.Free;
  end;
end;

function TfmMain.GetCalcDate(Origin: Boolean): TDateTime;
begin
  if FOriginDate = 0 then
  begin
    FOriginDate := dmSimpleClient.GetCalcDate;
    FCalcDate   := FOriginDate;
  end;
  if Origin then
    Result := FOriginDate
  else
    Result := FCalcDate;
end;

procedure TfmMain.ClearCalcDate;
begin
  FOriginDate := 0;
  sbMain.Panels[2].Text := GetCalcDateText(GetCalcDate());
end;

procedure TfmMain.sbMainClick(Sender: TObject);
begin
  if edtCalcDate.Tag > 0 then
  begin
    edtCalcDate.Value   := GetCalcDate;
    edtCalcDate.Visible := True;
    edtCalcDate.SetFocus;
  end;
end;

procedure TfmMain.sbMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edtCalcDate.Tag := 0;
  X := X - edtCalcDate.Left;
  Y := Y - edtCalcDate.Top;
  if ((X >0) and (X<=edtCalcDate.Width)) and
     ((Y >0) and (Y<=edtCalcDate.Height))
  then
    edtCalcDate.Tag := X;
end;

procedure TfmMain.sbMainMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if edtCalcDate.Tag = 0 then Exit;
  edtCalcDate.Tag := 0;
  X := X - edtCalcDate.Left;
  Y := Y - edtCalcDate.Top;
  if ((X >0) and (X<=edtCalcDate.Width)) and
     ((Y >0) and (Y<=edtCalcDate.Height))
  then
    edtCalcDate.Tag := X;
end;

procedure TfmMain.edtCalcDateExit(Sender: TObject);
begin
  edtCalcDate.Visible := False;
  FCalcDate := edtCalcDate.Value;
  sbMain.Panels[2].Text := GetCalcDateText(GetCalcDate());
end;

procedure TfmMain.edtCalcDateKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13)  then
  begin
    if VarIsNull(edtCalcDate.Value) then
      edtCalcDate.Reset;
    edtCalcDateExit(nil);
  end
  else if (Key = #27) then
  begin
    edtCalcDate.Reset;
    edtCalcDateExit(nil);
    Key := #0;
  end;
end;

procedure TfmMain.FormShow(Sender: TObject);
var Layout: array [0.. KL_NAMELENGTH] of char;
begin
  GetKeyboardLayoutName(Layout);
  if Layout <> '00000419' then
    LoadKeyboardLayout('00000419',KLF_ACTIVATE);
  //dbgConsole.Top := Self.ClientHeight;
  actHideConsole.Execute;
  actShowConsole.Execute;
end;

function TfmMain.HaveAccess(const fmName, ctlName: string;
  const KeyState: Byte; const ShowMessage: Boolean): Boolean;
begin
  Result := dmSimpleClient.HaveAccess(fmName, ctlName, KeyState, ShowMessage);
end;

procedure TfmMain.RefreshReference(const ARef: integer);
var i : Integer;
begin
  if IsAppClosed then Exit;
  for i := 0 to FChildList.Count - 1 do
  begin
    if not TfmSimpleClient(FChildList.Items[i]).FormInClosed then
      TfmSimpleClient(FChildList.Items[i]).RefreshReference(ARef);
  end;
  Application.ProcessMessages;
end;

procedure TfmMain.LoadAccess;
begin
  if dmSimpleClient.GetActLstState(alMain) then
  begin
    // reCheck Main menu Item
    ReCheckMainMenuItem;
  end;
end;

procedure TfmMain.miClearCashClick(Sender: TObject);
begin
  if Global <> nil then
    Global.ClearCash;
  if Report <> nil then
    Report.ClearCash;
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  if (Self.Width > Round(Self.Constraints.MinWidth*1.5)) then
    if dbgConsole.Height < Round(dbgConsole.Constraints.MinHeight*2) then
    begin
      actHideConsole.Execute;
      //dbgConsole.Height := Round(dbgConsole.Constraints.MinHeight*2);
      //Self.Realign;
      actShowConsole.Execute;
      //fmMain.ShowWarning('%d',[dbgConsole.top]);
    end;
end;

function TfmMain.GetActiveFormCalcDate: TDateTime;
var P : TForm;
begin
  P := ActiveMDIChild;
  if (P = nil) or (P <> Screen.ActiveForm) then
    P := Screen.ActiveForm;
  if Assigned(P) and (P is TfmSimpleClient) then
    Result := TfmSimpleClient(P).edtCalcDay.Value
  else
    Result := GetCalcDate(False);
end;

procedure TfmMain.ReCheckMainMenuItem;
var i, j{, n} : Integer;
    mVisible : Boolean;
begin
  for i := 0 to mmMenu.Items.Count - 1 do
  begin
    mVisible := False;
    j := mmMenu.Items[i].Count - 1;

    while not mVisible and (j >= 0) do
    begin
      if mmMenu.Items[i].Items[j].Caption <> '-' then
        mVisible := mVisible or mmMenu.Items[i].Items[j].Visible;
      Dec(j);
    end;

    mmMenu.Items[i].Visible := mVisible;
  end;
end;

function TfmMain.GetCalcDateText(Value: TDateTime): string;
begin
  if Value > 0 then
    Result := ' ' + UtilsUnit.DateWords(Value) + ' '
  else
    Result := LBL_NO_DATE;
end;

function TfmMain.GetCorrectWorkDate(Value: TDateTime): TDateTime;
begin
  Result := StartOfTheMonth(Value);
end;

function TfmMain.Global: IGlobal;
var i : Integer;
begin
  Result := FGlobal;
  if (Result = nil) then
  begin
    // Необходимо определить есть ли модуль с IGlobal
    for i := 0 to Screen.DataModuleCount - 1 do
    begin
      if Supports(Screen.DataModules[i], IGlobal, FGlobal) then
        Break;
    end;
    Result        := FGlobal;
  end;
end;

end.

