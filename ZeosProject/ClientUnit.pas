unit ClientUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ToolWin, ImgList, ActnList,
  InterfaceUnit, Menus, DB, EhLibZEOS, Mask, DBCtrlsEh, ExtCtrls;

type
  TEditMode = (emNone, emInsert, emModify, emDelete, emSome);

  TEditRec = record
    mode : Integer;
    id : Int64;
    dt : TDate;
  end;

  TfmSimpleClient = class(TForm)
    alBase: TActionList;
    actRefresh: TAction;
    ilBase: TImageList;
    actCanselSelected: TAction;
    pnlCommand: TPanel;
    sbtnRefresh: TSpeedButton;
    edtCalcDay: TDBDateTimeEditEh;
    lblCalcDate: TLabel;
    actForm: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actCanselSelectedExecute(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DefaultKeyPress(Sender: TObject; var Key: Char); dynamic;
    procedure QueryAbortBefore(DataSet: TDataSet);
    procedure DefaultDatasetPost(Sender : TDataSet);
    procedure edtCalcDayExit(Sender: TObject);
    procedure lblCalcDateClick(Sender: TObject);
    procedure edtCalcDayKeyPress(Sender: TObject; var Key: Char);
    procedure edtCalcDayEnter(Sender: TObject);
  private
    { Private declarations }
    FShowed,
    FActivated,
    FInClosed  : boolean;
    FNextInsertId : Integer;
    procedure AddImageToPopupMenu;
  protected
    FMaster   : IMaster;

    FSelected,
    FCanselSelect,
    FBeginSelect,
    FNotRefreshYet,
    FModify : Boolean;
    FSelectedRecord : TSelectedRecord;

    FDontCheck,
    FInInserting,
    FInPosting,
    FInEditing,
    FInRefreshing,
    FFirstRefreshRef,
    FRefreshWhenChangeCalcDay : Boolean;

    procedure SetDoubleBuffered; dynamic;
  protected
    FRequiredControl : TWinControl;
    FEditMode : TEditMode;
    FEditRec  : TEditRec;
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; State: TOwnerDrawState);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    function  GetNextInsertId(const DataSet : TDataSet = nil) : Int64; dynamic;
    function  IsNumeric(F : TFieldType) : Boolean;
    procedure OnBeforeSelect; dynamic;
    procedure OnAfterSelect; dynamic;
    function  GetSQByDataSet(DataSet : TDataSet) : String; dynamic;
    procedure UpdatedCalcDate; dynamic;
    procedure SetRequiredState(Sender : TWinControl);
    procedure OnCheckRequiredState(Sender: TObject; var DrawState: Boolean);
    procedure OnCheckRequiredStateGrid(Sender: TObject; Text: String; var DrawState: Boolean);
    function  CheckRequiredField(Dataset : TDataSet) : Boolean;
    function  CheckEmptyRow(const Dataset : TDataSet; const ACancel : Boolean = False ) : Boolean;
    function  NameCase(const AText : string; const AType : Integer = 1) : string;
    function  WorkDate : TDate;
    function  WorkMonth : TDate;
    procedure LoadAccess; dynamic;
    procedure RefreshAfterLoadAccess; dynamic;
    procedure CloseDatasets;
    function  FindControls(AOwner : TWinControl; AConrolName : string) : TControl;
    procedure ShowWarningAndSetFocus(const ACon : TWinControl; const AMsg : string);
  public
    { Public declarations }
    AutoRefresh : Boolean;
    function  SetFilter(cds : TDataSet; const AFilter : string; const Args: array of const) : Boolean;
    function  SelectObject(var ARecord : TSelectedRecord) : Boolean;
    procedure RefreshReference(const ARef : integer); dynamic;
    function  SendParams(const AKey : string;  const ARecord : Pointer) : Boolean; dynamic;
    property  FormInClosed : boolean read FInClosed;
  end;

var
  fmSimpleClient: TfmSimpleClient;

implementation

uses ConstUnit, SimpleDialog, DataUnit, DBGridEh, DateUtils, UtilsUnit, ZDataset;

{$R *.dfm}

procedure TfmSimpleClient.FormCreate(Sender: TObject);
begin
  FMaster := Application.MainForm as IMaster;
  if FMaster = nil then
    raise Exception.Create('Can find IMaster form');
  //================================================//
  //SetDoubleBuffered;
  FMaster.ChangeFormScale(Self);
  //================================================//
  FEditMode      := emNone;
  FShowed        := False;
  FActivated     := False;
  AutoRefresh    := False;
  FNotRefreshYet := True;
  FModify        := False;

  FFirstRefreshRef := False;

  FRefreshWhenChangeCalcDay := False;

  FNextInsertId  := 0;
  AddImageToPopupMenu;
  LoadAccess;
  RefreshAfterLoadAccess;
  FDontCheck     := False;
  FInClosed      := False;
  edtCalcDay.Tag := 0;
  edtCalcDay.EditFormat := 'DD/MM/YYYY';
  edtCalcDay.Value := FMaster.GetCalcDate;
  edtCalcDayExit(nil);
end;

procedure TfmSimpleClient.FormDestroy(Sender: TObject);
begin
  CloseDatasets;
  FMaster := nil;
end;

procedure TfmSimpleClient.SetDoubleBuffered;
begin
  pnlCommand.DoubleBuffered := True;
end;

procedure TfmSimpleClient.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Self.FormStyle = fsMDIChild then
  begin
    Action := caFree;
    if Assigned(FMaster) and not FMaster.IsAppClosed then
      FMaster.DeleteFromTabs(Pointer(Self));
  end;
end;

procedure TfmSimpleClient.FormActivate(Sender: TObject);
begin
  if not Assigned(FMaster) or FMaster.IsAppClosed then Exit;
  FMaster.ActiveFormTabs(Pointer(Self));
  FRequiredControl := nil;
  if AutoRefresh and FNotRefreshYet then
  begin
    RefreshReference(RFR_ALL);
    Application.ProcessMessages;
    Sleep(100);
    Application.ProcessMessages;
    actRefresh.Execute;
  end;
end;

procedure TfmSimpleClient.AddImageToPopupMenu;
var i     : Integer;
    pmItem  : TPopupMenu;

  procedure AddInfo(Sender : TObject);
  var j,n : Integer;
      mnItem  : TMenuItem;
  begin
    if Sender is TPopupMenu then
      n := pmItem.Items.Count - 1
    else
      n := TMenuItem(Sender).Count - 1;
    for j := 0 to n do
    begin
      if Sender is TPopupMenu then
        mnItem  := pmItem.Items[j]
      else
        mnItem  := TMenuItem(Sender).Items[j];

      if mnItem.Caption = cLineCaption then Continue;
      if mnItem.Count = 0 then
      begin
        mnItem.OnAdvancedDrawItem := AdvancedDrawItem;
        mnItem.OnMeasureItem      := MeasureItem;
      end
      else
        AddInfo(mnItem);
    end;
  end;

begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TPopupMenu then
    begin
      pmItem := TPopupMenu(Components[i]);
      if pmItem.Tag = PopupMenuOwnerDraw then
      begin
        pmItem.OwnerDraw := True;
        AddInfo(pmItem);
      end;
    end;
  end
end;

type TMyItem = class(TMenuItem);

procedure TfmSimpleClient.AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var ilItem  : TImageList;
    actItem : TAction;
    S       : string;
    BM      : TBitmap;
begin
  if Sender is TMenuItem then
  begin
    ACanvas.FillRect(ARect);
    S := TMenuItem(Sender).Caption;
    if odDisabled in State then
      ACanvas.Font.Color := clBtnShadow;
    if odDefault in State then
      ACanvas.Font.Style := ACanvas.Font.Style + [fsBold];

    if (TMenuItem(Sender).Action <> nil) and
       (TAction(TMenuItem(Sender).Action).ActionList.Images <> nil) and
       (TAction(TMenuItem(Sender).Action).ImageIndex > -1)
    then begin
      actItem := TAction(TMenuItem(Sender).Action);
      ilItem  := TImageList(actItem.ActionList.Images);

      BM := TBitmap.Create;
      try
        BM.Width  := ilItem.Height;
        BM.Height := ilItem.Height;
        if actItem.Enabled then
          ilItem.Draw(BM.Canvas, 0, 0, actItem.ImageIndex)
        else
          ilItem.Draw(BM.Canvas, -BM.Width, 0, actItem.ImageIndex);
        ACanvas.Draw(ARect.Left+1, ARect.Top+1, BM);
      finally
        BM.Free;
      end;

      ARect.Left := ARect.Left + ilItem.Height + 5;
      //ACanvas.FillRect(ARect);
      //ARect.Left := ARect.Left + 4;
      //DrawText(ACanvas.Handle, PChar(S), -1, ARect,DT_LEFT or DT_SINGLELINE	 or DT_VCENTER);
      TMyItem(Sender).DoDrawText(ACanvas, S, ARect, odSelected in State, DT_LEFT or DT_SINGLELINE	 or DT_VCENTER);
    end
    else if TMenuItem(Sender).GroupIndex > 0 then
    begin
      BM := TBitmap.Create;
      try
        BM.Transparent := True;
        BM.Handle := LoadBitmap(0, PChar(OBM_CHECK));
        if TMenuItem(Sender).Checked then
          ACanvas.Draw(ARect.Left + 1, ARect.Top + 1, BM);
        ARect.Left := ARect.Left + BM.Width + 5;
      finally
        BM.Free;
      end;
      TMyItem(Sender).DoDrawText(ACanvas, S, ARect, odSelected in State, DT_LEFT or DT_SINGLELINE	 or DT_VCENTER);
    end
    else begin
      //DrawText(ACanvas.Handle, PChar(S), -1, ARect,DT_LEFT or DT_SINGLELINE	 or DT_VCENTER);
      ARect.Left := ARect.Left + 5;
      TMyItem(Sender).DoDrawText(ACanvas, S, ARect, odSelected in State, DT_LEFT or DT_SINGLELINE	 or DT_VCENTER);
    end;
  end;
end;

procedure TfmSimpleClient.MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
var W,delta : integer;
    s : string;
    BM : TBitmap;
begin
  if Sender is TMenuItem then
  begin
    S := TMenuItem(Sender).Caption;
    W := ACanvas.TextWidth(s) + 5;
    if (TMenuItem(Sender).Action <> nil) and
       (TAction(TMenuItem(Sender).Action).ActionList.Images <> nil) and
       (TAction(TMenuItem(Sender).Action).ImageIndex > -1)
    then begin
      delta := TAction(TMenuItem(Sender).Action).ActionList.Images.Height;
      inc(Width, delta+5);
      if Height < delta + 2 then
        Height := delta + 2;
    end
    else if TMenuItem(Sender).GroupIndex > 0 then
    begin
      BM := TBitmap.Create;
      try
        BM.Handle := LoadBitmap(0, PChar(OBM_CHECK));
        Inc(W, BM.Width + 5);
        if Height < BM.Height + 2 then
          Height := BM.Height + 2;
      finally
        BM.Free;
      end;
    end;
    if Width < W then
      Width := W;
  end;

  if TMenuItem(Sender).Count > 0 then
    Inc(Width, 5);
end;

procedure TfmSimpleClient.actRefreshExecute(Sender: TObject);
begin
  if FNotRefreshYet then
  begin
    FNotRefreshYet := False;
    if not AutoRefresh and not FFirstRefreshRef then
      RefreshReference(RFR_ALL);
  end;
  FModify := False;
end;

procedure TfmSimpleClient.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if FBeginSelect then
    FCanselSelect := True;
  FInClosed := True;  
end;

function TfmSimpleClient.GetNextInsertId(const DataSet : TDataSet = nil): Int64;
var NextId : int64;
    SQName : string;
begin
  NextId := 0;
  if DataSet <> nil then
  begin
    SQName := GetSQByDataSet(DataSet);
    if (SQName <> '') then
    begin
      if (not dmSimpleClient.GetNextSQValue(SQName, NextId)) then
      begin
        //DataSet.Cancel;
        FMaster.ShowWarning(MSG_BAD_SQ, [SQName]);
        Abort;
      end;
    end
    else begin
      FMaster.ShowWarning(MSG_NO_SQ, [DataSet.Owner.Name+'.'+DataSet.Name]);
      Abort;
    end;
  end
  else begin
    Dec(FNextInsertId);
    NextId := FNextInsertId;
  end;
  Result := NextId;
end;

function TfmSimpleClient.SetFilter(cds: TDataSet;
  const AFilter: string; const Args: array of const): Boolean;
var S,
    BM : string;
begin
  S  := Format(AFilter, Args);
  BM := EmptyStr;
  with cds do
  try
    DisableControls;
    if not Filtered or (Filter <> S) then
    begin
      BM := Bookmark;
      Filter := S;
      if not Filtered then
        Filtered := True;
    end;
  finally
    if (BM <> EmptyStr) and BookmarkValid(TBookMark(BM)) then
      Bookmark := BM;
    EnableControls;
    Result := Filtered;
  end;
end;

function TfmSimpleClient.SelectObject(
  var ARecord: TSelectedRecord): Boolean;
begin
  FSelected     := False;
  FCanselSelect := False;
  FBeginSelect  := True;
  //Result := False;
  try
    Screen.Cursor := crHelp;
    if FNotRefreshYet then
      actRefresh.Execute;
    OnBeforeSelect;
    while (not FSelected) and (not FCanselSelect) and (not Application.Terminated) do
    begin
      Application.ProcessMessages;
      Sleep(200);
    end;
    Result := FSelected;
    if Result then
      ARecord := FSelectedRecord;
  finally
    if not FInClosed then
      OnAfterSelect;
    FBeginSelect  := False;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfmSimpleClient.actCanselSelectedExecute(Sender: TObject);
begin
  if FBeginSelect then
    FCanselSelect := True;
end;

procedure TfmSimpleClient.FormDeactivate(Sender: TObject);
begin
  actCanselSelected.Execute;
end;

function TfmSimpleClient.IsNumeric(F: TFieldType): Boolean;
begin
  Result := F in [ftSmallint, ftInteger, ftWord, ftAutoInc, ftLargeint];
end;

procedure TfmSimpleClient.DefaultKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Sender := FindNextControl(TWinControl(Sender), True, True, False);
    if Sender <> nil then
      TWinControl(Sender).SetFocus;
  end;
end;

procedure TfmSimpleClient.QueryAbortBefore(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfmSimpleClient.OnAfterSelect;
begin
  //
end;

procedure TfmSimpleClient.OnBeforeSelect;
begin
  //
end;

function TfmSimpleClient.GetSQByDataSet(DataSet : TDataSet): String;
begin
  Result := '';
end;

procedure TfmSimpleClient.edtCalcDayExit(Sender: TObject);
begin
  if not VarIsNull(edtCalcDay.Value) then
  begin
    edtCalcDay.Value := FMaster.GetCorrectWorkDate(edtCalcDay.Value);
    lblCalcDate.Caption := FMaster.GetCalcDateText(edtCalcDay.Value);
  end
  else
    lblCalcDate.Caption := LBL_NO_DATE;
  edtCalcDay.Visible := False;
  if (Sender = edtCalcDay) and (not VarIsNull(edtCalcDay.Value)) and
     (edtCalcDay.Tag = 1)
  then begin
    edtCalcDay.Tag := 0;
    Application.ProcessMessages;
    UpdatedCalcDate;
  end;
end;

procedure TfmSimpleClient.lblCalcDateClick(Sender: TObject);
var w : Integer;
begin
  if lblCalcDate.Cursor <> crHandPoint then Exit;
  edtCalcDay.Font.Size := lblCalcDate.Font.Size;

  edtCalcDay.Top   := (lblCalcDate.Height - edtCalcDay.Height) div 2;
  w := lblCalcDate.Canvas.TextWidth(lblCalcDate.Caption);
  if w < 90 then w := 90;
  edtCalcDay.Left  := lblCalcDate.BoundsRect.Right -  w - 1;
  edtCalcDay.Width := w + 2;
  
  edtCalcDay.Visible := True;
  edtCalcDay.SetFocus;
end;

procedure TfmSimpleClient.edtCalcDayKeyPress(Sender: TObject;
  var Key: Char);
begin
  case Ord(Key) of
    VK_RETURN : begin
      if VarIsNull(edtCalcDay.Value) then
        edtCalcDay.Reset;
      edtCalcDayExit(edtCalcDay);
    end;
    VK_ESCAPE : begin
      edtCalcDay.Reset;
      edtCalcDayExit(nil);
    end;
  end;
end;

procedure TfmSimpleClient.UpdatedCalcDate;
begin
  //
  if FRefreshWhenChangeCalcDay then
    actRefresh.Execute;
end;

procedure TfmSimpleClient.edtCalcDayEnter(Sender: TObject);
begin
  edtCalcDay.Tag := 1;
end;

type TMyDBEditEh = class(TCustomDBEditEh);

procedure TfmSimpleClient.SetRequiredState(Sender : TWinControl);
var i : Integer;
begin
  if Sender is TCustomDBEditEh then
  begin
    with TCustomDBEditEh(Sender) do
      if (not ReadOnly) and  Assigned(DataSource) and
         Assigned(DataSource.DataSet) and (DataField <> '')
      then begin
        TMyDBEditEh(Sender).HighlightRequired := True;
        TMyDBEditEh(Sender).OnCheckDrawRequiredState := OnCheckRequiredState;
      end;
  end
  else if Sender is TCustomDBGridEh then
  begin
     with TDBGridEh(Sender) do
      if (not ReadOnly) and Assigned(DataSource) and
         Assigned(DataSource.DataSet) and (Columns.Count > 0)
      then begin
        for i := 0 to Columns.Count - 1 do
          if (not Columns[i].ReadOnly) and (Columns[i].FieldName <> '') then
          begin
            Columns[i].HighlightRequired := True;
            Columns[i].OnCheckDrawRequiredState := OnCheckRequiredStateGrid;
          end;
      end;
  end
  else if Sender.ControlCount > 0 then
  begin
    for i := 0 to Sender.ControlCount - 1 do
    begin
      if Sender.Controls[i] is TWinControl then
        SetRequiredState(TWinControl(Sender.Controls[i]));
    end;
  end;
end;

procedure TfmSimpleClient.OnCheckRequiredState(Sender: TObject;
  var DrawState: Boolean);
begin
  if (Sender is TCustomDBEditEh) then
    with TCustomDBEditEh(Sender) do
    begin
      if Assigned(DataSource) and
         Assigned(DataSource.DataSet) and
         Assigned(Field)
      then
        DrawState := DataSource.DataSet.Active and
          Field.Required and (Field.AsString = '');
    end;
end;

procedure TfmSimpleClient.OnCheckRequiredStateGrid(Sender: TObject;
  Text: String; var DrawState: Boolean);
begin
  if DrawState then
    DrawState := (Text = '');
end;

function TfmSimpleClient.CheckRequiredField(Dataset: TDataSet) : Boolean;
  function GetNeedControl(Sender : TWinControl; AFieldName : string) : TObject;
  var i : Integer;
  begin
    Result := nil;
    if Sender is TCustomDBEditEh then
    begin
      with TCustomDBEditEh(Sender) do
        if Assigned(DataSource) and Assigned(DataSource.DataSet) and
           (DataSource.DataSet = Dataset) and AnsiSameText(DataField,AFieldName) and
           (not ReadOnly)
        then begin
          Result := Sender;
          Exit;
        end;
    end
    else if Sender is TCustomDBGridEh then
    begin
       with TDBGridEh(Sender) do
        if Assigned(DataSource) and Assigned(DataSource.DataSet) and
           (Columns.Count > 0) and (DataSource.DataSet = Dataset) and
           (not ReadOnly) and (alopUpdateEh in AllowedOperations)
        then
          for i := 0 to Columns.Count - 1 do
            if AnsiSameText(Columns[i].FieldName, AFieldName) then
            begin
              Result := Columns[i];
              Exit;
            end;
    end
    else if Sender.ControlCount > 0 then
    begin
      for i := 0 to Sender.ControlCount - 1 do
        if Sender.Controls[i] is TWinControl then
        begin
          Result := GetNeedControl(TWinControl(Sender.Controls[i]), AFieldName);
          if Assigned(Result) then Exit;
        end;
    end;
  end;

  function GetLabel(Sender : TWinControl) : TLabel;
  var i : integer;
      AName : string;
  begin
    Result := nil;
    if not (Sender is TCustomDBEditEh) then Exit;
    AName := TCustomDBEditEh(Sender).Name;

    if Sender is TCustomDBDateTimeEditEh then    // edt
      AName := 'lbl'+Copy(AName,4,255)
    else if Sender is TCustomDBComboBoxEh then   // cb
      AName := 'lbl'+Copy(AName,3,255)
    else if Sender is TCustomDBNumberEditEh then // ned
      AName := 'lbl'+Copy(AName,4,255)
    else                                         // ed
      AName := 'lbl'+Copy(AName,3,255);

    Sender := Sender.Parent;
    for i := 0 to Sender.ControlCount - 1 do
      if (Sender.Controls[i] is TLabel) and
         AnsiSameText(TLabel(Sender.Controls[i]).Name,AName)
      then begin
        Result := TLabel(Sender.Controls[i]);
        Exit;
      end;
  end;
var i : integer;
    AControl : TObject;
    ALbl : TLabel;
    s : string;
begin
  Result := True;
  FRequiredControl := nil;
  if Dataset.IsEmpty then Exit;
  for i := 0 to Dataset.FieldCount - 1 do
  begin
    if Dataset.Fields[i].Required and
       not Dataset.Fields[i].ReadOnly and
       not Dataset.Fields[i].IsBlob and
       (Dataset.Fields[i].AsString = '')
    then begin
      AControl := GetNeedControl(Self, Dataset.Fields[i].FieldName);
      if not Assigned(AControl) then
      begin
        FMaster.ShowWarning(MSG_REQUIRED_FIELD,[Dataset.Fields[i].FieldName]);
      end
      else if AControl is TCustomDBEditEh then
      begin
        ALbl := GetLabel(TWinControl(AControl));
        if Assigned(ALbl) then
        begin
          s := ALbl.Caption;
          if ALbl.Parent is TGroupBox then
            s := TGroupBox(ALbl.Parent).Caption + ' ' + s;
          FMaster.ShowWarning(MSG_REQUIRED_FIELD,[s]);
        end
        else
         FMaster.ShowWarning(MSG_REQUIRED_FIELD,[Dataset.Fields[i].FieldName]);
        FRequiredControl := TWinControl(AControl);
      end
      else if AControl is TColumnEh then
      begin
        FMaster.ShowWarning(MSG_REQUIRED_FIELD,[TColumnEh(AControl).Title.Caption]);
        FRequiredControl := TColumnEh(AControl).Grid;
        TCustomDBGridEh(FRequiredControl).SelectedField := TColumnEh(AControl).Field;
      end;
      Result := False;
      if Assigned(FRequiredControl) then
      begin
        if FRequiredControl.CanFocus then
          FRequiredControl.SetFocus;
      end;
      Exit;
    end;
  end;
end;

function TfmSimpleClient.CheckEmptyRow(const Dataset : TDataSet; const ACancel : Boolean = False): Boolean;
var i : Integer;
begin
  Result := Dataset.IsEmpty;
  if not Result then
  begin
    i := 0;
    while (i < Dataset.FieldCount) and (Dataset.Fields[i].IsNull) do inc(i);
    Result := (i = Dataset.FieldCount);
  end;
  if Result and ACancel then
  begin
    Dataset.Cancel;
    Abort;
  end;
end;

function TfmSimpleClient.NameCase(const AText: string;
  const AType: Integer): string;
begin
  Result := UtilsUnit.NameCase(AText, AType);
end;

function TfmSimpleClient.WorkDate: TDate;
begin
  Result := edtCalcDay.Value;
end;

function TfmSimpleClient.WorkMonth: TDate;
begin
  Result := WorkDate;
  Result := StartOfTheMonth(Result);
end;

procedure TfmSimpleClient.RefreshReference(const ARef : integer);
begin
  if not FFirstRefreshRef then
    FFirstRefreshRef := True;
end;

procedure TfmSimpleClient.LoadAccess;
var actTemp : TAction;
begin
  dmSimpleClient.GetActLstState(alBase);

  actTemp := TAction(FMaster.GetModuleAction(Self.Name));
  if Assigned(actTemp) then
  begin
    actForm.Assign(actTemp);
    actForm.OnExecute := nil;
    actForm.OnHint    := nil;
    actForm.OnUpdate  := nil;
  end;
end;

procedure TfmSimpleClient.RefreshAfterLoadAccess;
var i : integer;
begin
  if FMaster.ReadOnlyAction(actForm) then
  begin
    dmSimpleClient.SetActLstToReadOnly(alBase);
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TDataSet then
        TZQuery(Components[i]).ReadOnly := True;
    end;

    Self.Caption := Self.Caption + ' (ÐÅÆÈÌ òîëüêî ×ÒÅÍÈÅ!)';
  end;
end;

procedure TfmSimpleClient.DefaultDatasetPost(Sender: TDataSet);
begin
  CheckEmptyRow(Sender, True);

  if (Sender.FindField(API_ID) <> nil) and Sender.FieldByName(API_ID).IsNull then
  begin
    Sender.FieldByName(API_ID).Value := C2V(GetNextInsertId(Sender));
  end;

  if not CheckRequiredField(Sender) then
    Abort;

  FModify := True;
end;

function TfmSimpleClient.SendParams(const AKey: string; const ARecord: Pointer): Boolean;
var PRec : ^TEditRec;
begin
  PRec := ARecord;
  FEditRec := PRec^;
  Result := True;
end;

procedure TfmSimpleClient.CloseDatasets;
var i, n : Integer;
begin
  n := ComponentCount - 1;
  for i := 0 to n do
  begin
    if Components[i] is TDataSet then
      TDataSet(Components[i]).Close;
  end;
end;

function TfmSimpleClient.FindControls(AOwner: TWinControl;
  AConrolName: string): TControl;
var i : Integer;
begin
  Result := nil;
  if not Assigned(AOwner) then
    AOwner := Self;
  AConrolName := AnsiUpperCase(AConrolName);
  for i := 0 to AOwner.ControlCount - 1 do
  begin
    if AnsiUpperCase(AOwner.Controls[i].Name) = AConrolName then
    begin
      Result := AOwner.Controls[i];
      Break;
    end
    else if (AOwner.Controls[i] is TWinControl) and
            (TWinControl(AOwner.Controls[i]).ControlCount > 0)
    then begin
      Result := FindControls(TWinControl(AOwner.Controls[i]), AConrolName);
      if Assigned(Result) then
        Break;
    end;
  end;
end;

procedure TfmSimpleClient.ShowWarningAndSetFocus(const ACon: TWinControl;
  const AMsg: string);
begin
  if ACon.CanFocus then
    ACon.SetFocus;
  ShowWarningDlg(AMsg);
  Abort;
end;

end.
