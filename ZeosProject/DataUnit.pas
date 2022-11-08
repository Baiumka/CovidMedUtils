unit DataUnit;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, InterfaceUnit, Forms,
  ZSqlMonitor, ZAbstractTable, ZSqlUpdate, ActnList, ZSequence;

type
  TUserInfo = record
    id,
    tn,
    is_prog : Integer;
    fio,
    job,
    phone : string;
  end;

  TdmSimpleClient = class(TDataModule)
    conDB: TZConnection;
    dsMessages: TDataSource;
    mntrQuery: TZSQLMonitor;
    zqrMessage: TZQuery;
    zuqEmpty: TZUpdateSQL;
    zqrAny: TZQuery;
    zqrRealAccess: TZQuery;
    zuqRealAccess: TZUpdateSQL;
    zsqNextValue: TZSequence;
    zqrNextValue: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure mntrQueryTrace(Sender: TObject; Event: TZLoggingEvent;
      var LogTrace: Boolean);
  private
    { Private declarations }
    FMaster      : IMaster;
    FErrSQLMsg   : String;
    FAddedMessage,
    FUsedMessage,
    FReconnectedServer : Boolean;
    procedure LoadIniData;
    function  GetUserInfo(Lgn, Pswd : string) : Boolean;
    function  GetReadableSQLMessage(const Value : string) : string;
  public
    { Public declarations }
    UserInfo : TUserInfo;
    function  GetQueryData(AQuery : TZQuery; HaveResult : Boolean = True;
                AReadOnly : Boolean = False; ARequired : Boolean = False) : Boolean;
    function  CheckCloseConnectionMessage(var Value : string) : Boolean;
    function  AddMessage(AText : String; AColor : Integer; AType : Integer = 0) : boolean;
    function  GetFontColor : Integer;
    function  GetMessageText(OnlyText : Boolean = True; All : Boolean = False) : String;
    function  EmptyMessages : Boolean;
    function  ConnectToServer : Boolean;
    function  DisconnectFromServer : Boolean;
    function  ReconnectToServer : Boolean;
    function  TranslateDBMessage(AValue : String) : string;
    function  CheckConnection(Lgn, Pswd : string) : Boolean;
    function  GetUsersInfo: String;
    function  LoadAccessInfo : Boolean;
    function  HaveAccess(const fmName, ctlName: string; const KeyState: Byte;
                const ShowMessage: Boolean): Boolean;
    //======================================//
    function  DatasetPost(DataSet : TDataSet; ACancel : Boolean = False) : Boolean;
    function  DatasetCancel(DataSet : TDataSet) : Boolean;
    function  DataSetEdit(DataSet : TDataSet) : Boolean;
    function  DatasetInEdit(Dataset : TDataset) : Boolean;
    function  DatasetAppend(Dataset : TDataset) : Boolean;
    //======================================//
    function  GetCalcDate : TDateTime;        
    function  GetNextSQValue(AName : string; var NextID : Int64) : Boolean;
    //======================================//
    function  GetActLstState(AActLst : TActionList) : Boolean;
    function  GetActionState(AAction : TAction) : Boolean;
    function  SetActionHelpContext(const AAction : TAction;
                const AName : string = ''; const AForm : string = '') : Boolean;
    function  SetActLstToReadOnly(AActLst : TActionList) : Boolean;
    //======================================//
    procedure FillKeyItemList(DataSet : TDataSet; ItemValue, KeyValue : TStrings; ID_NAME : Boolean = False);
    procedure FillItemList(DataSet : TDataSet; ItemValue : TStrings; AFieldName : string);
    //======================================//
  end;

  function CloseAllConnection : Boolean;

var
  dmSimpleClient: TdmSimpleClient;

implementation
uses  Variants, ConstUnit, StrUtils, ZDbcLogging, DateUtils, Md5Unit, UtilsUnit, ZDbcIntfs;

{$R *.dfm}

function CloseAllConnection : Boolean;
begin
  Result := (dmSimpleClient <> nil);
  if Result and dmSimpleClient.conDB.Connected then
  begin
    dmSimpleClient.EmptyMessages;
    Result := dmSimpleClient.DisconnectFromServer;
  end;
end;

{ TdmClient }

procedure TdmSimpleClient.DataModuleCreate(Sender: TObject);
begin
  FAddedMessage      := False;
  FUsedMessage       := False;
  FReconnectedServer := False;

  FMaster := Application.MainForm as IMaster;

  with UserInfo do
  begin
    id      := 0;
    tn      := 0;
    is_prog := 0;
    fio     := '';
    job     := '';
    phone   := '';
  end;

  LoadIniData;
end;

procedure TdmSimpleClient.DataModuleDestroy(Sender: TObject);
begin
  //EmptyMessages;
  DisconnectFromServer;
  FMaster := nil;
end;

function TdmSimpleClient.CheckCloseConnectionMessage(
  var Value: string): Boolean;
var i : Integer;  
begin
  Result := False;
  i := PosEx('FATAL:', Value);
  if i > 0 then
  begin
    FMaster.ShowErrorDlg('Получена команда администратора на выход из задачи!',[]);
    //DisconnectFromServer;
    Value := '';
    Result := True;
    FMaster.AppTerminate;
  end
  else begin
    i := PosEx('server closed', Value);
    if i = 0 then
    begin
      i := PosEx('no connection to the server', Value);
      if i = 0 then
        i := PosEx('abort', Value);
    end;
    if i > 0 then
    begin
      ReconnectToServer;
      Value := 'Ошибка соединения с "СЕРВЕРОМ". Автоматическое переподключение!';
      Result := False;
    end;
  end;
end;

function TdmSimpleClient.GetReadableSQLMessage(
  const Value: string): string;
var i,j : Integer;
begin
  Result :=  Value;

  if CheckCloseConnectionMessage(Result) then Exit;

  if FMaster.DebugMode then Exit;
  i := PosEx('ERROR:', Result);
  if i > 0 then
  begin
    Delete(Result,1,i+7);
    i := PosEx('LINE', Result);
    j := PosEx('CONTEXT',Result, i);

    if (i > 0) then
    begin
      if j = 0 then
        SetLength(Result,i-2)
      else
        Result := Copy(Result,1,i-2)+#13#10+Copy(Result,j+10,255);
    end
    else if j > 0 then
    begin
      SetLength(Result,j-1);
    end;
  end;
end;

function TdmSimpleClient.GetQueryData(AQuery : TZQuery; HaveResult : Boolean = True;
               AReadOnly : Boolean = False; ARequired : Boolean = False) : Boolean;
var F : TField;
    P : TParam;
    i : Integer;
    BM : TBookmarkStr;

    OldBeforeScroll,
    OldAfterScroll : TDataSetNotifyEvent;
begin
  OldBeforeScroll := nil;
  OldAfterScroll  := nil;

  Result := False;
  FErrSQLMsg := '';
  with AQuery do
  try
    OldBeforeScroll := BeforeScroll;
    OldAfterScroll  := AfterScroll;

    BeforeScroll := nil;
    AfterScroll  := nil;

    if Connection = nil then
      Connection := conDB;

    if not Connection.Connected then
    begin
      if not Self.ConnectToServer then Exit;
    end;

    if ReadOnly then
      AReadOnly := True;

    BM := '';

    if Active then
    begin
      BM := Bookmark;
      Close;
    end;
    if SQL.Text <> '' then
    try
      Screen.Cursor := -17;
      P := Params.FindParam(API_LNG);
      if Assigned(P) and P.IsNull then
        P.AsInteger := DEF_LNG;

      P := Params.FindParam(API_USER_ID);
      if Assigned(P) and P.IsNull then
        P.AsInteger := UserInfo.id;

      //Connection.AutoCommit := False;
      Connection.StartTransaction;
      if HaveResult then
      begin
        Open;
        Result := Active and
                  (FieldCount > 0);
        if Result and not IsEmpty then
        begin
          if RecordCount = 1 then
          begin
            F := FindField(API_ERROR);
            if Assigned(F) and (F.DataType = ftInteger) then
              Result := (F.AsInteger = 0);
          end;
        end;
        if Result then
          for i := 0 to Fields.Count - 1 do
          begin
            if Fields[i].ReadOnly then
              Fields[i].ReadOnly := AReadOnly;
            if (not ARequired) and Fields[i].Required then
              Fields[i].Required := False;
          end;
      end
      else begin
        ExecSQL;
        Result := True;
      end;
      Connection.Commit;
    except
      on E:Exception do
      begin
        AQuery.Close;
        Result := False;
        FErrSQLMsg := GetReadableSQLMessage(E.Message);
        if FUsedMessage then
          FMaster.ShowError(FErrSQLMsg,[])
        else
          FMaster.ShowErrorDlg(FErrSQLMsg,[]);
        Connection.Rollback;
      end;
    end
    else
      Result := False;
  finally
    Connection.AutoCommit := True;
    Screen.Cursor := 0;
    BeforeScroll := OldBeforeScroll;
    AfterScroll  := OldAfterScroll;
    if Active and Result then
    begin
      if (BM <> '') and (BookmarkValid(TBookmark(BM))) then
        Bookmark := BM
      else //if not Bof then
        First;
    end;
  end;
end;

function TdmSimpleClient.AddMessage(AText: String;
  AColor: Integer; AType : Integer = 0): boolean;
begin
  if not FAddedMessage then
  try
    FAddedMessage := True;
    if not FReconnectedServer and FUsedMessage and
       (conDB <> nil) and conDB.Connected and
       (AText <> '') and zqrMessage.Active
    then begin
      with zqrMessage do
      begin
        if AType <> 0 then
        begin
          if FieldByName(API_TYPE).AsInteger = AType then
            zqrMessage.Delete;
        end;
        AppendRecord([Now, AText, AColor, AType]);
      end;
      Result := True;
    end
    else
      Result := False;
  finally
    FAddedMessage := False;
  end
  else
    Result := False;
end;

function TdmSimpleClient.GetFontColor: Integer;
begin
  if zqrMessage.Active then
    Result := zqrMessage.Fields[2].AsInteger
  else
    Result := 0;
end;

function TdmSimpleClient.EmptyMessages: Boolean;
begin
  FUsedMessage := False;
  if conDB.Connected then
  begin
    zqrMessage.Close;
    zqrMessage.SQL.Text := QR_EMPTY_MESSAGE;
    if GetQueryData(zqrMessage) then
      FUsedMessage := True;
  end;
  Result := True;
end;

function TdmSimpleClient.ConnectToServer: Boolean;
var sql : string;
begin
  if conDB.Connected then
    DisconnectFromServer;
  mntrQuery.Active := True;
  conDB.Connect;
  Result := conDB.Connected;

  zqrAny.Close;
  zqrAny.SQL.Text := 'Show all';
  if GetQueryData(zqrAny, True) then
  begin
    sql := 'SET client_min_messages=NOTICE;';
    if zqrAny.Locate('name', 'application_name', []) then
      sql := sql  + #13#10 +
             'SET application_name=:name;';
    zqrAny.Close;
    zqrAny.SQL.Text := sql;
    if zqrAny.Params.Count > 0 then
      zqrAny.Params[0].AsString := AppSecretWord;
    GetQueryData(zqrAny, False);
  end;
  zqrAny.Close;
  FMaster.ShowConnected(Result);
end;

function TdmSimpleClient.DisconnectFromServer: Boolean;
begin
  if conDB.Connected then
    conDB.Disconnect;
  Result := not conDB.Connected;
  mntrQuery.Active := not Result;
  FMaster.ShowConnected(not Result);
end;

function TdmSimpleClient.GetMessageText(OnlyText : Boolean = True; All : Boolean = False): String;
var BM : TBookmarkStr;
begin
  Result := '';
  with zqrMessage do
    if Active and not IsEmpty then
    begin
      if not All then
      begin
        if not OnlyText then
          Result := Fields[0].AsString+';';
        Result := Result + Fields[1].AsString;
      end
      else try
        BM := Bookmark;
        DisableControls;
        First;
        while not Eof do
        begin
         if not OnlyText then
          Result := Result + Fields[0].AsString+';';
         Result := Result + Fields[1].AsString + ENDL;
         Next;
        end;
      finally
        Bookmark := BM;
        EnableControls;
      end;
    end;
end;

function TdmSimpleClient.ReconnectToServer: Boolean;
begin
  {Result := DisconnectFromServer;
  if Result then
    Result := ConnectToServer;}
  if conDB.Connected then
  begin
    if not FReconnectedServer then
    try
      FReconnectedServer := True;
      conDB.Reconnect;
    finally
      FReconnectedServer := False;
    end;
  end
  else
    ConnectToServer;

  Result := conDB.Connected;
end;

function TdmSimpleClient.TranslateDBMessage(AValue: String): string;
var i:Integer;
begin
  i := Pos(#$A, AValue);
  if i > 0 then
    Result := Copy(AValue, 1, i)
  else
    Result := AValue;

  i := Pos('SQL Error: ERROR:', Result);
  if i > 0 then
    Delete(Result, i, 17);
end;

function TdmSimpleClient.CheckConnection(Lgn, Pswd: string): Boolean;
begin
  Result := True;
  if conDB.Connected then
    Result := DisconnectFromServer;
  if Result then
  begin
    try
      Result := ConnectToServer;
      if Result then
      begin
        if Result then
          Result := GetUserInfo(Lgn, Pswd);
        {if not Result and (FErrSQLMsg <> '') then
          raise Exception.Create(FErrSQLMsg);}
        EmptyMessages;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        FMaster.ShowErrorDlg(E.Message,[]);
        //DB.Disconnect;
        Abort;
      end;
    end;
  end;
end;

procedure TdmSimpleClient.mntrQueryTrace(Sender: TObject;
  Event: TZLoggingEvent; var LogTrace: Boolean);
var s,s1 : string;
    IsNotice : Boolean;
    i, IsScr : integer;
begin
  IsScr := 0;

  if Event.Category = lcOther then
  begin
    //s := Copy(Event.Message,1,6);
    if Pos('NOTICE', Event.Protocol) > 0 then
    begin
      s        := Trim(Copy(Event.Message, Pos(':', Event.Message)+1, 255));
      IsNotice := True;
    end
    else begin
      s        := Event.Message;
      IsNotice := False;
    end;
    if IsNotice then
    begin
      s1 := UpperCase(Copy(s,1,2));
      if s1 = 'N:' then
      begin
        s := Copy(s,3,255);
        i := PosEx('CONTEXT:', s);
        if i > 0 then
          s := trim(Copy(s,1,i - 1));
      end
      else if s1 = 'L:' then
      begin
        s := Copy(s,3,255);
        i := PosEx('CONTEXT:', s);
        if i > 0 then
          s := trim(Copy(s,1,i - 1));
        IsScr := 1;  
      end
      else if not FMaster.DebugMode then
        s := '';
    end;
    if IsScr = 0 then
      FMaster.ShowWarning(s,[])
    else
      FMaster.ShowScrWarning(s,[]);
  end;
  LogTrace := FMaster.DebugMode;
end;

function TdmSimpleClient.DatasetCancel(DataSet: TDataSet): Boolean;
begin
  try
    if DataSet.state in [dsEdit, dsInsert] then
      DataSet.Cancel;
    Result := True;
  except
    on E : EAbort do
      Result := False;
    on E : Exception do
    begin
      Result := False;
      FMaster.ShowError(GetReadableSQLMessage(E.Message),[]);
    end;
  end;
end;

function TdmSimpleClient.DataSetEdit(DataSet: TDataSet): Boolean;
begin
  Result := False;
  
  if DataSet.Active then
  try
    if not DatasetInEdit(DataSet) then
      DataSet.Edit;
    Result := True;
  except
    on E : EAbort do
      Result := False;
    on E : Exception do
    begin
      Result := False;
      FMaster.ShowError(GetReadableSQLMessage(E.Message),[]);
    end;
  end;
end;

function TdmSimpleClient.DatasetInEdit(Dataset: TDataset): Boolean;
begin
  Result := Dataset.Active and (DataSet.state in dsEditModes);
end;

function TdmSimpleClient.DatasetPost(DataSet: TDataSet;
  ACancel: Boolean): Boolean;
begin
  //Result := False;
  if DataSet.Active then
  try
    if DatasetInEdit(DataSet) then
      DataSet.Post;
    Result := True;
  except
    on E : EAbort do
    begin
      Result := False;
    end;
    on E : Exception do
    begin
      Result := False;
      if ACancel then
        DataSet.Cancel;
      FMaster.ShowError(GetReadableSQLMessage(E.Message),[]);
    end;
  end
  else
    Result := True;

end;

function TdmSimpleClient.DatasetAppend(Dataset: TDataset): Boolean;
begin
  Result := False;

  if Dataset.Active then
  begin
    if DatasetInEdit(DataSet) then
      Result := DatasetPost(DataSet)
    else
      Result := True;
    if Result then
      Dataset.Append;
  end;
end;

procedure TdmSimpleClient.LoadIniData;
const
   UsedProctocol : array[1..7] of string[15] =
   ('firebird-1.0', 'firebird-1.5', 'firebird-2.0', 'firebird-2.1',
    'postgresql', 'postgresql-7', 'postgresql-8');
   UsedLevel : array[1..5] of string[20] =
   ('tinone', 'tireaduncommitted', 'tireadcommitted',
    'tirepeatableread', 'tiserializable');

var f : String;
    i : Integer;
begin
  f := AnsiLowerCase(FMaster.GetIniData('connection','protocol', 's'));
  if f = '' then
    f := UsedProctocol[7];
  for i := 1 to 7 do
  begin
    if f = UsedProctocol[i] then
    begin
      conDB.Protocol := f;
      Break;
    end;
  end;

  f := AnsiLowerCase(FMaster.GetIniData('connection','level', 's'));
  if (f = '') or (f = UsedLevel[1]) then
    conDB.TransactIsolationLevel := tiNone
  else if (f = UsedLevel[2]) then
    conDB.TransactIsolationLevel := tiReadUncommitted
  else if (f = UsedLevel[3]) then
    conDB.TransactIsolationLevel := tiReadCommitted
  else if (f = UsedLevel[4]) then
    conDB.TransactIsolationLevel := tiRepeatableRead
  else if (f = UsedLevel[5]) then
    conDB.TransactIsolationLevel := tiSerializable;

  f := FMaster.GetIniDataSection('connection_option');
  conDB.Properties.Text := f;

  conDB.HostName := FMaster.GetIniData('main','hostname', 's');
  conDB.Port     := FMaster.GetIniData('main','port', 'i');
  conDB.Database := FMaster.GetIniData('main','database', 's');

  f := FMaster.GetIniData('main', 'ConLogin', 's');
  if f = '' then
    f := ConLogin;
  conDB.User     := UtilsUnit.DecodeString(f, AppSecretWord);

  f := FMaster.GetIniData('main', 'ConPass', 's');
  if f = '' then
    f := ConPass;
  conDB.Password := UtilsUnit.DecodeString(f, AppSecretWord);

  f := FMaster.GetIniData('main','log', 's');
  if ExtractFileDrive(f) = '' then
    f := ExtractFilePath(Application.ExeName)+f;
  mntrQuery.FileName := f;

  UserInfo.is_prog := FMaster.GetIniData('user','admin', 'i');
end;

function TdmSimpleClient.GetUserInfo(Lgn, Pswd : string) : Boolean;
begin
  //Result := False;
  if FMaster.GetIniData('USER','NO_USE_MD5','i') = 0 then
    Pswd := MD5(Pswd);
  with zqrAny do
  try
    Close;
    SQL.Text := FNC_USER_INFO;
    ParamByName(API_LOGIN).AsString := Lgn;
    ParamByName(API_PASS).AsString  := Pswd;
    Result := GetQueryData(zqrAny) and not IsEmpty;
    if Result then
    begin
      UserInfo.id      := FieldByName(API_ID).AsInteger;
      UserInfo.fio     := FieldByName(API_FIO).AsString;
      UserInfo.job     := FieldByName(API_JOB).AsString;
      UserInfo.phone   := FieldByName(API_PHONE).AsString;
      UserInfo.tn      := FieldByName(API_TN).AsInteger;
      UserInfo.is_prog := FieldByName(API_IS_PROG).AsInteger;
    end;
  finally
    Close;
  end;
end;

function TdmSimpleClient.GetCalcDate: TDateTime;
begin
  Result := Date;
  //Exit;
  if conDB.Connected then
  begin
    with zqrAny do
    try
      Close;
      SQL.Text := QR_GET_CALCDATE;
      if FMaster.GetData(zqrAny) then
        Result := FieldByName(API_DT).AsDateTime;
    finally
      Close;
    end;
  end;
end;

function TdmSimpleClient.HaveAccess(const fmName, ctlName: string;
  const KeyState: Byte; const ShowMessage: Boolean): Boolean;
begin
  Result := False;
  if not LoadAccessInfo then Exit;
  Result := Boolean(KeyState and KS_READONLY);
  if zqrRealAccess.Locate('fmname;name', VarArrayOf([fmName, ctlName]),[loCaseInsensitive]) then
  begin
    Result := True;
    if (KeyState and KS_ALL) = KS_NONE then
      Result := False;
    if (KeyState and KS_ENABLE) = KS_ENABLE then
      Result := Result and (zqrRealAccess.FieldByName(API_ENABLE).AsInteger = 1);
    if (KeyState and KS_VISIBLE) = KS_VISIBLE then
      Result := Result and (zqrRealAccess.FieldByName(API_VISIBLE).AsInteger = 1);
    if (KeyState and KS_READONLY) = KS_READONLY then
      Result := Result and (zqrRealAccess.FieldByName(API_READONLY).AsInteger = 1);
  end;
  if not Result and ShowMessage then
    FMaster.ShowWarningDlg('Нет доступа!',[]);
end;

function TdmSimpleClient.LoadAccessInfo: Boolean;
begin
  Result := zqrRealAccess.Active;
  if not Result and (FNC_GET_ACCESS <> '') then
  begin
    zqrRealAccess.SQL.Text := FNC_GET_ACCESS;
    zqrRealAccess.Params[0].AsInteger := UserInfo.id;
    if GetQueryData(zqrRealAccess) then
    begin
      zqrRealAccess.SortedFields := 'fmname;name';
      Result := zqrRealAccess.Active;
      zuqRealAccess.InsertSQL.Text := FNC_INSERT_CONTROL;
      zuqRealAccess.Params.ParamByName(API_USER_ID).AsInteger := UserInfo.id;
    end;
  end;
end;

function TdmSimpleClient.GetUsersInfo: String;
var P : TParam;
begin
  Result := '';
  if DisconnectFromServer then
    if ConnectToServer then
    try
      zqrAny.Close;
      zqrAny.SQL.Text := FNC_USERS_LIST;
      P := zqrAny.Params.FindParam(API_ACTIVE);
      if Assigned(P) then
        P.AsInteger := 1;
      if GetQueryData(zqrAny) then
      begin
        zqrAny.First;
        while not zqrAny.Eof do
        begin
          Result := Format('%s%s=%s~',[Result,
                                       zqrAny.FieldByName(API_LOGIN).AsString,
                                       zqrAny.FieldByName(API_FIO).AsString]);
          zqrAny.Next;
        end;
      end;
    finally
      zqrAny.Close;
      DisconnectFromServer;
    end;
end;

function TdmSimpleClient.GetNextSQValue(AName: string;
  var NextID: Int64): Boolean;
begin
  Result := False;
  if AName <> '' then
  begin
    if FCN_GET_NEXT_VALUE <> '' then
    begin
      zqrAny.Close;
      zqrAny.SQL.Text := FCN_GET_NEXT_VALUE;
      zqrAny.ParamByName(API_SQ_NAME).AsString := AName;
      Result := FMaster.GetData(zqrAny) and
               (not zqrAny.IsEmpty);
      if Result then
        NextID := V2C(zqrAny.Fields[0].Value);
       zqrAny.Close;
    end
    else begin
      zsqNextValue.SequenceName := AName;
      NextID := zsqNextValue.GetNextValue;
    end;
    Result := (NextID > 0);
  end;
end;

function TdmSimpleClient.GetActionState(AAction: TAction): Boolean;
begin
  Result := LoadAccessInfo;
  if Result then
  begin
    if not SetActionHelpContext(AAction) then
    begin
      if Boolean(UserInfo.is_prog) then
      begin
        AAction.HelpContext := API_ACTION_HIDDEN or API_ACTION_VISIBLE or API_ACTION_ENABLED;

        zqrRealAccess.Append;
        zqrRealAccess.FieldByName(API_READONLY).AsInteger := 0;
        zqrRealAccess.FieldByName(API_ENABLE).AsInteger   := 1;
        zqrRealAccess.FieldByName(API_VISIBLE).AsInteger  := 1;
        zqrRealAccess.FieldByName(API_NAME).AsString      := AAction.Name;
        zqrRealAccess.FieldByName(API_CAPTION).AsString   := AAction.Category + '->' + AAction.Caption;
        zqrRealAccess.FieldByName(API_FMNAME).AsString    := AAction.ActionList.Owner.Name;
        if AAction.ActionList.Owner is TForm then
        begin
          if AAction.ActionList.Owner = Application.MainForm then
            zqrRealAccess.FieldByName(API_FORMNAME).AsString := AppTitle
          else
            zqrRealAccess.FieldByName(API_FORMNAME).AsString := TForm(AAction.ActionList.Owner).Caption
        end
        else
          zqrRealAccess.FieldByName(API_FORMNAME).AsString := AAction.ActionList.Owner.Name;
        zqrRealAccess.FieldByName(API_FULLNAME).Value     := Null;
        zqrRealAccess.Post;
      end;
    end;

    FMaster.VisibleAction(AAction, AAction.Visible);
    FMaster.EnabledAction(AAction, AAction.Enabled);
  end;
end;

function TdmSimpleClient.GetActLstState(AActLst: TActionList): Boolean;
var i : integer;
    s1, s2 : string;
begin

  for i := 0 to AActLst.ActionCount - 1 do
  begin
    s1 := AActLst.Actions[i].Category;
    s2 := TAction(AActLst.Actions[i]).Caption;
    if (s1 = '') or (s1[1] = '<') or
       (s2 = '-') or (s2 = '') or (TAction(AActLst.Actions[i]).HelpContext < 0)
    then
      Continue;
    Result := GetActionState(TAction(AActLst.Actions[i]));
    if not Result then Exit;
  end;
  Result := True;
end;

function TdmSimpleClient.SetActionHelpContext(const AAction: TAction;
  const AName, AForm: string): Boolean;
var s1,s2 : string;
    aR, aV, aE : Byte;
begin
  Result := False;
  if AName = '' then
    s1 := AnsiUpperCase(AAction.Name)
  else
    s1 := AnsiUpperCase(AName);
  if AForm = '' then
    s2 := AnsiUpperCase(AAction.ActionList.Owner.Name)
  else
    s2 := AnsiUpperCase(AForm);

  if not zqrRealAccess.Active then
    if not LoadAccessInfo then Exit;

  Result := zqrRealAccess.Locate('fmname;name', VarArrayOf([s2, s1]),[loCaseInsensitive]);
  if Result then
  begin
    aR := zqrRealAccess.FieldByName(API_READONLY).AsInteger;
    aV := zqrRealAccess.FieldByName(API_VISIBLE).AsInteger;
    aE := zqrRealAccess.FieldByName(API_ENABLE).AsInteger;
    AAction.HelpContext := (aR * API_ACTION_READONLY) or
                           (aV * API_ACTION_VISIBLE) or
                           (aE * API_ACTION_ENABLED) or
                           API_ACTION_HIDDEN;
  end
  else begin
    AAction.HelpContext := (1 * API_ACTION_READONLY) or
                           (0 * API_ACTION_VISIBLE) or
                           (0 * API_ACTION_ENABLED) or
                           API_ACTION_HIDDEN;
  end;

end;

function TdmSimpleClient.SetActLstToReadOnly(
  AActLst: TActionList): Boolean;
var i : integer;
    s : string;
begin
  for i := 0 to AActLst.ActionCount - 1 do
  begin
    s := AActLst.Actions[i].Category;
    if (s = '') or (s[1] = '<') or
       (TAction(AActLst.Actions[i]).Caption = '-') or
       (TAction(AActLst.Actions[i]).Caption = '') or
       not (TAction(AActLst.Actions[i]).HelpContext in [API_ACTION_HIDDEN..API_ACTION_ALL])
    then
      Continue;
    TAction(AActLst.Actions[i]).HelpContext := TAction(AActLst.Actions[i]).HelpContext and API_ACTION_READONLY;
  end;
  Result := True;
end;

procedure TdmSimpleClient.FillItemList(DataSet: TDataSet;
  ItemValue: TStrings; AFieldName: string);
var FItem: TField;
begin
  try
    ItemValue.BeginUpdate;
    ItemValue.Clear;
    if DataSet.IsEmpty then Exit;
    with DataSet do
    try
      DisableControls;
      FItem := FindField(AFieldName);
      if Assigned(FItem) then
      begin
        First;
        while not Eof do
        begin
          ItemValue.Add(FItem.AsString);
          Next;
        end;
      end;
    finally
      EnableControls;
    end;
  finally
    ItemValue.EndUpdate;
  end;
end;

procedure TdmSimpleClient.FillKeyItemList(DataSet: TDataSet; ItemValue,
  KeyValue: TStrings; ID_NAME: Boolean);
var FItem, FKey : TField;
begin
  try
    ItemValue.BeginUpdate;
    ItemValue.Clear;
    if Assigned(KeyValue) then
    begin
      KeyValue.BeginUpdate;
      KeyValue.Clear;
    end;
    if DataSet.IsEmpty then Exit;
    with DataSet do
    try
      DisableControls;
      FKey  := FindField(API_ID);
      if not Assigned(FKey) then
        FKey := Fields[0];
      FItem := FindField(API_NAME);
      if not Assigned(FItem) then
      begin
        FItem := FindField(API_NAME_R);
        if not Assigned(FItem) then
        begin
          FItem := FindField(API_NAME_U);
          if not Assigned(FItem) then
            FItem := Fields[1];
        end;
      end;
      First;
      while not Eof do
      begin
        if KeyValue <> ItemValue then
          if Assigned(KeyValue) then
            KeyValue.Add(FKey.AsString);
        if not ID_NAME then
          ItemValue.Add(FItem.AsString)
        else
          ItemValue.Add(FKey.AsString + ' ' + FItem.AsString);
        Next;
      end;
    finally
      EnableControls;
    end;
  finally
    ItemValue.EndUpdate;
    if Assigned(KeyValue) then
      KeyValue.EndUpdate;
  end;
end;

end.
