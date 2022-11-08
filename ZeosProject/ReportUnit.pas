unit ReportUnit;

interface

uses
  SysUtils, Classes, InterfaceUnit, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, frxExportImage, frxExportODF, frxExportRTF,
  frxExportXML, frxExportXLS, frxExportPDF, frxChart, frxDCtrl, frxClass,
  frxDMPExport, frxChBox, frxCross, frxRich, frxDesgn, frxDBSet, frxVariables, ZSqlUpdate, Forms;

type
  TdmReport = class(TDataModule, IReport)
    zqrReports: TZQuery;
    frxReport: TfrxReport;
    frxDesigner1: TfrxDesigner;
    frxRichObject1: TfrxRichObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxDotMatrixExport1: TfrxDotMatrixExport;
    frxDialogControls1: TfrxDialogControls;
    frxChartObject1: TfrxChartObject;
    frxPDFExport1: TfrxPDFExport;
    frxXLSExport1: TfrxXLSExport;
    frxXMLExport1: TfrxXMLExport;
    frxRTFExport1: TfrxRTFExport;
    frxTIFFExport1: TfrxTIFFExport;
    frxODSExport1: TfrxODSExport;
    frxODTExport1: TfrxODTExport;
    frxJPEGExport1: TfrxJPEGExport;
    zuqReports: TZUpdateSQL;
    udsSimpleCount: TfrxUserDataSet;
    zqrReportSettings: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure frxReportGetValue(const VarName: String; var Value: Variant);
    function frxReportUserFunction(const MethodName: String;
      var Params: Variant): Variant;
  private
    { Private declarations }
    FMaster     : IMaster;

    FGlobalGetValue,
    FOnGetValue : TfrxGetValueEvent;
    FGlobalUserFunc,
    FOnUserFunc : TfrxUserFunctionEvent;
    FLastReport : String;
    FLoadFromDB : Boolean;
    FTemple     : TMemoryStream;
    FReportDate : TDateTime;
    FSaveFormat : TFormatSettings;
    FSavedFormat : Boolean;
    FLocalVar : TfrxVariables;

    function LoadFR3Template(const AName : String) : Boolean;
    function LoadFR3FromDB(const AName : String) : Boolean;
    function SaveToDB(const AName : String) : Boolean;

    //function  GetCorrectName(AName : String): string;
    function  HaveChange : Boolean;
  public
    { Public declarations }
    procedure ClearCash;
    procedure RegFunction(const Value : string);
    function  SetGlobalGetValue(AFunc : TReportValue) : Boolean;
    function  SetGlobalUserFunc(AFunc : TReportFunction) : Boolean;
    function  SetOnGetValue(AFunc : TReportValue) : Boolean;
    function  SetOnUserFunc(AFunc : TReportFunction) : Boolean;
    function  ShowReport(const AName : String; ADataset: array of const; const NoPrint : Boolean = False) : Boolean;
    function  ReportNameByKey(const AKey: String): String;
    procedure ReportDate(const dt: TDateTime);
    function  SetFormatSettings(Value : Pointer) : TFormatSettings;
    function  AddReportValue(aName : string; aValue : Variant) : Boolean;
  end;

var
  dmReport: TdmReport;

implementation

{$R *.dfm}
uses  ConstUnit, DataUnit, Variants, Math, SimpleDialog;

{ TdmReport }

procedure TdmReport.DataModuleCreate(Sender: TObject);
begin
  FMaster := Application.MainForm as IMaster;
  FReportDate := Date;
  FSavedFormat := False;
  FGlobalGetValue := nil;
  FGlobalUserFunc := nil;
  FOnGetValue := nil;
  FOnUserFunc := nil;

  FLocalVar := TfrxVariables.Create;
end;

procedure TdmReport.DataModuleDestroy(Sender: TObject);
begin
  FGlobalGetValue := nil;
  FGlobalUserFunc := nil;
  FOnGetValue := nil;
  FOnUserFunc := nil;
  FLocalVar.Free;
  if Assigned(FTemple) then
    FreeAndNil(FTemple);
  FMaster := nil;
end;

function TdmReport.HaveChange: Boolean;
var MS : TMemoryStream;
    n  : int64;
begin
  Result := False;
  if not FLoadFromDB then Exit;
  MS := TMemoryStream.Create;
  try
    frxReport.SaveToStream(MS);
    MS.Position := 0;
    FTemple.Position    := 0;
    Result := (MS.Size <> FTemple.Size);
    if not Result then
    begin
      n := Min(MS.Size, FTemple.Size);
      Result := not CompareMem(MS.Memory, FTemple.Memory, n);
    end;
  finally
    if Result then
    begin
      FTemple.Clear;
      FTemple.Free;
      FTemple := MS;
    end
    else begin
      MS.Clear;
      MS.Free;
    end;
  end;
end;

function TdmReport.SetOnGetValue(AFunc: TReportValue): Boolean;
begin
  if Assigned(AFunc) then
    FOnGetValue := AFunc
  else
    FOnGetValue := nil;
  Result := True;
end;

function TdmReport.SetOnUserFunc(AFunc: TReportFunction): Boolean;
begin
  if Assigned(AFunc) then
    FOnUserFunc := AFunc
  else
    FOnUserFunc := nil;
  Result := True;
end;

function TdmReport.ShowReport(const AName: String;
  ADataset: array of const; const NoPrint : Boolean = False): Boolean;
var frxdbList : array of TfrxDBDataset;
    i,n : Integer;
    FDataSet : TDataSet;
    F : TFormatSettings;
begin
  if not FSavedFormat then
  begin
    F := SetFormatSettings(nil);
    F.DecimalSeparator := ',';
    SetFormatSettings(@F);
  end;

  frxReport.EnabledDataSets.Clear;
  frxReport.DataSets.Clear;
  n := High(ADataset);
  SetLength(frxdbList,n+1);
  for i:= 0 to n do
    frxdbList[i] := nil;

  try
    for i:= 0 to n do
    begin
      frxdbList[i] := TfrxDBDataset.Create(Self);
      FDataSet := TDataSet(ADataset[i].VObject);
      frxdbList[i].Name := Format('frxdb%d',[i+1]);
      frxdbList[i].UserName := FDataSet.Name;
      if FDataSet.Owner is TFrame then
        frxdbList[i].UserName := FDataSet.Owner.Name + '_'+ FDataSet.Name;
      frxdbList[i].DataSet := FDataSet;
      frxdbList[i].Enabled := True;
      frxdbList[i].OpenDataSource := False;
      frxdbList[i].CloseDataSource := False;
      frxReport.DataSets.Add(frxdbList[i]);
    end;
    //i := frxReport.DataSets.Count;
    Result := LoadFR3Template(AName);
    if not Result then Exit;

    {if frxReport.DataSets.Count = 0 then
      for i:= 0 to n do
         frxReport.DataSets.Add(frxdbList[i])
    else if n = -1 then
      frxReport.DataSets.Clear
    else begin
      for i:= 0 to Min(n, frxReport.DataSets.Count-1) do
        if frxReport.DataSets[i].DataSetName <> frxdbList[i].UserName then
        begin
          frxReport.DataSets[i].DataSet     := frxdbList[i];
          frxReport.DataSets[i].DataSetName := frxdbList[i].UserName;
        end;
    end;}
    frxReport.DataSets.Clear;
    for i:= 0 to n do
      frxReport.DataSets.Add(frxdbList[i]);
    frxReport.DataSets.Add(udsSimpleCount);

    if FLocalVar.Count > 1 then
      frxReport.Variables.Assign(FLocalVar);

    if FMaster.DebugMode and ((dmSimpleClient.UserInfo.id = 0) or (dmSimpleClient.UserInfo.is_prog = 1)) then
    begin
      //frxReport.PreviewOptions.Buttons := frxReport.PreviewOptions.Buttons + [pbEdit];
      if FLoadFromDB  then
      begin
        FTemple.Clear;
        frxReport.SaveToStream(FTemple);
      end;
      frxReport.DesignReport;
      SaveToDB(AName);
      Result := True;
    end
    else begin
      Result := frxReport.PrepareReport;
      //frxReport.PreviewOptions.Buttons := frxReport.PreviewOptions.Buttons - [pbEdit];
      if Result then
      begin
        if NoPrint then
          frxReport.PreviewOptions.Buttons := frxReport.PreviewOptions.Buttons - [pbPrint]
        else
          frxReport.PreviewOptions.Buttons := frxReport.PreviewOptions.Buttons + [pbPrint];

        frxReport.ShowPreparedReport;
      end;
    end;
  finally
    FLocalVar.Clear;
    
    frxReport.DataSets.Clear;
    for i:= 0 to n do
    begin
      if Assigned(frxdbList[i]) then
      begin
        frxdbList[i].DataSet := nil;
        frxdbList[i].Free;
      end;
    end;
    SetLength(frxdbList,0);
    FOnGetValue := nil;
    FOnUserFunc := nil;
    if Assigned(FTemple) then
      FTemple.Clear;
    FReportDate := Date;
    if FSavedFormat then
    begin
      SetFormatSettings(@FSaveFormat);
      FSavedFormat := False;
    end;
  end;

end;

function TdmReport.LoadFR3Template(const AName: String): Boolean;
var f : string;
begin          

  Result := LoadFR3FromDB(AName);
  if not Result then
  begin
    if ExtractFileDrive(AName) = '' then
      f := ExtractFilePath(Application.ExeName)+'Report\'+AName
    else
      f := AName;
    if ExtractFileExt(f) = EmptyStr then
      f := f + '.fr3';
      
    FLoadFromDB := False;
    Result := frxReport.LoadFromFile(f);
    if not Result then
      FMaster.ShowWarningDlg(DLG_NO_FILE,[f]);
  end;
  if Result then
    FLastReport := f;
end;

function TdmReport.LoadFR3FromDB(const AName: String): Boolean;
var fn : string;
    Find : Boolean;

  function LocateByKey(const AKey : string) : Boolean;
  {var i, k, n : Integer;
      s : string;}
  begin
    zqrReports.Filter := Format('%s=''%s''',[API_KEYWORD, AKey]);
    zqrReports.Filtered := True;
    zqrReports.First;
    Result := not zqrReports.IsEmpty;
    {n := zqrReports.RecordCount;
    if n < 10 then
      Result := zqrReports.Locate(API_KEYWORD, AKey, [])
    else begin
      k := 1;
      Result := False;
      repeat
        i := (k+n) div 2;
        zqrReports.RecNo := i;
        s := zqrReports.FieldByName(API_KEYWORD).AsString;
        if AKey > s then
          k := i+1
        else if AKey < s then
          n := i-1
        else
          Result := True;
      until (not Result) or (k>n);
      if Result then
      begin
        i := zqrReports.RecNo;
        while not zqrReports.Bof and
             (zqrReports.FieldByName(API_KEYWORD).AsString = AKey)
        do zqrReports.Prior;
        if not zqrReports.Bof then
          zqrReports.Next;
      end;
    end;}
  end;

begin
  Result := False;
  fn := AnsiLowerCase(Trim(AName));
  with zqrReports do
  begin
    if not Active then
    begin
      if FNC_REPORTS_LIST = '' then Exit;
      
      zqrReports.SQL.Text := FNC_REPORTS_LIST;
      //zqrReports.SQL.Add('WHERE 1=2');
      zqrReports.ParamByName(API_KEYWORD).AsString := '';
      if not FMaster.GetData(zqrReports) {or zqrReports.IsEmpty} then Exit;
      zqrReports.SortedFields := Format('%s;%s',[API_KEYWORD, API_DF]);
      zuqReports.InsertSQL.Text  := QR_EMPTY;
      zuqReports.ModifySQL.Text  := QR_REPORTS_MODIFY;
      zuqReports.DeleteSQL.Text  := QR_EMPTY;
      zuqReports.RefreshSQL.Text := QR_EMPTY;
    end;
    //Find := False;

    Find := LocateByKey(fn);
    {First;
    while not Eof do
    begin
      Find := (fn = zqrReports.FieldByName(API_KEYWORD).AsString);
      if Find then break;
      Next;
    end;}

    if not Find then
    begin
      with dmSimpleClient.zqrAny do
      try
        Close;
        SQL.Text := FNC_REPORTS_LIST;
        ParamByName(API_KEYWORD).AsString := fn;
        if FMaster.GetData(dmSimpleClient.zqrAny) and
           not IsEmpty then
        begin
          while not dmSimpleClient.zqrAny.Eof do
          begin
            zqrReports.Append;
            zqrReports.FieldByName(API_ID).Value         := FieldByName(API_ID).Value;
            zqrReports.FieldByName(API_NAME).AsString    := FieldByName(API_NAME).AsString;
            zqrReports.FieldByName(API_KEYWORD).AsString := AnsiLowerCase(Trim(FieldByName(API_KEYWORD).AsString));
            zqrReports.FieldByName(API_DATA).Assign(FieldByName(API_DATA));
            zqrReports.FieldByName(API_DF).Value         := FieldByName(API_DF).Value;
            zqrReports.FieldByName(API_DT).Value         := FieldByName(API_DT).Value;
            zqrReports.Post;
            dmSimpleClient.zqrAny.Next;
          end;
          Find := True;

        end;
      finally
        Close;
        if dmSimpleClient.DatasetInEdit(zqrReports) then
          dmSimpleClient.DatasetCancel(zqrReports);
      end;
    end;

    if Find then
    begin
      zqrReports.First;
      while not zqrReports.Eof do
      begin
        if (zqrReports.FieldByName(API_DF).AsDateTime <= FReportDate) and
           ((zqrReports.FieldByName(API_DT).IsNull) or
            (zqrReports.FieldByName(API_DT).AsDateTime >= FReportDate))
        then Break;
        zqrReports.Next;
      end;
      FLoadFromDB := True;
      frxReport.Clear;
      if not Assigned(FTemple) then
        FTemple := TMemoryStream.Create;
      try
        TBlobField(zqrReports.FieldByName(API_DATA)).SaveToStream(FTemple);
        FTemple.Position := 0;
        frxReport.LoadFromStream(FTemple);
        frxReport.FileName := Format('%s от %s',[fn, zqrReports.FieldByName(API_DF).AsString]);
        Result := True;
      except
        FTemple.Clear;
        Result := False;
      end;
    end;
  end;
end;

procedure TdmReport.RegFunction(const Value: string);
begin
  frxReport.AddFunction(Value,'Глобальные и пользовательские функции');
end;

function TdmReport.SaveToDB(const AName: String): Boolean;
var fn : string;
begin
  Result := False;
  if not FLoadFromDB then Exit;
  if HaveChange then
  begin
    fn := AnsiLowerCase(Trim(AName));
    with zqrReports do
    begin
      if fn <> AnsiLowerCase(Trim(FieldByName(API_KEYWORD).AsString)) then
        raise Exception.CreateFmt(MSG_NOT_FOUND_REPORT,[AName]);
      if FieldByName(API_ID).IsNull then
      begin
        FMaster.ShowDebug(MSG_NOT_EDIT_REPORT,[AName]);
        Exit;
      end;
    end;

    if ConfirmDlg('Сохранить изменения в отчете!') then
    begin
      FTemple.Position := 0;
      dmSimpleClient.DataSetEdit(zqrReports);
      TBlobField(zqrReports.FieldByName(API_DATA)).LoadFromStream(FTemple);
      dmSimpleClient.DatasetPost(zqrReports);
    end;
  end
  else
    FTemple.Clear;
  Result := True;
end;

procedure TdmReport.frxReportGetValue(const VarName: String;
  var Value: Variant);
var s : string;
begin
  s := AnsiUpperCase(VarName);
  { Add Global Consts }
  if VarIsEmpty(Value) and Assigned(FGlobalGetValue) then
    FGlobalGetValue(s, Value);

  if VarIsEmpty(Value) and Assigned(FOnGetValue) then
    FOnGetValue(s, Value);
end;

function TdmReport.frxReportUserFunction(const MethodName: String;
  var Params: Variant): Variant;
var s : string;
begin
  s := AnsiUpperCase(MethodName);
  Result := Unassigned;
  { Add Global Consts }
  if VarIsEmpty(Result) and Assigned(FGlobalUserFunc) then
    Result := FGlobalUserFunc(s, Params);
  if VarIsEmpty(Result) and Assigned(FOnUserFunc) then
    Result := FOnUserFunc(s, Params);
end;

procedure TdmReport.ClearCash;
begin
  //zqrReports.EmptyDataSet;
  if zqrReportSettings.Active then
    zqrReportSettings.Refresh;
  zqrReports.Filtered := False;
  zqrReports.Filter   := '';
  //zqrReports.EmptyDataSet;
  while not zqrReports.Eof do zqrReports.Delete;
end;

function TdmReport.SetGlobalGetValue(AFunc: TReportValue): Boolean;
begin
  if Assigned(AFunc) then
    FGlobalGetValue := AFunc
  else
    FGlobalGetValue := nil;
  Result := True;
end;

function TdmReport.SetGlobalUserFunc(AFunc: TReportFunction): Boolean;
begin
  if Assigned(AFunc) then
    FGlobalUserFunc := AFunc
  else
    FGlobalUserFunc := nil;
  Result := True;
end;

function TdmReport.ReportNameByKey(const AKey: String): String;
var s : string;
begin
  Result := '';
  s := AnsiLowerCase(Trim(AKey));
  with zqrReportSettings do
  begin
    if not Active then
    begin
      SQL.Text := QR_REPORT_SETTINGS;
      if not FMaster.GetData(zqrReportSettings) then Exit;
    end;
    if Locate(API_KEY, s, [loCaseInsensitive]) then
      Result := FieldByName(API_KEYWORD).AsString;
  end;
end;

procedure TdmReport.ReportDate(const dt: TDateTime);
begin
  FReportDate := dt;
end;

function TdmReport.SetFormatSettings(Value: Pointer): TFormatSettings;
var i : Integer;
    F : ^TFormatSettings;
begin
  Result.CurrencyFormat    := CurrencyFormat;
  Result.NegCurrFormat     := NegCurrFormat;
  Result.ThousandSeparator := ThousandSeparator;
  Result.DecimalSeparator  := DecimalSeparator;
  Result.CurrencyDecimals  := CurrencyDecimals;
  Result.DateSeparator     := DateSeparator;
  Result.TimeSeparator     := TimeSeparator;
  Result.ListSeparator     := ListSeparator;
  Result.CurrencyString    := CurrencyString;
  Result.ShortDateFormat   := ShortDateFormat;
  Result.LongDateFormat    := LongDateFormat;
  Result.TimeAMString      := TimeAMString;
  Result.TimePMString      := TimePMString;
  Result.ShortTimeFormat   := ShortTimeFormat;
  Result.LongTimeFormat    := LongTimeFormat;
  for i := 1 to 12 do
  begin
    Result.ShortMonthNames[i] := ShortMonthNames[i];
    Result.LongMonthNames[i]  := LongMonthNames[i];
  end;
  for i := 1 to 7 do
  begin
    Result.ShortDayNames[i] := ShortDayNames[i];
    Result.LongDayNames[i]  := LongDayNames[i];
  end;
  Result.TwoDigitYearCenturyWindow := TwoDigitYearCenturyWindow;

  if Assigned(Value) then
  begin
    if not FSavedFormat then
    begin
      FSaveFormat  := Result;
      FSavedFormat := True;
    end;
    
    F := Value;
    CurrencyFormat    := F^.CurrencyFormat;
    NegCurrFormat     := F^.NegCurrFormat;
    ThousandSeparator := F^.ThousandSeparator;
    DecimalSeparator  := F^.DecimalSeparator;
    CurrencyDecimals  := F^.CurrencyDecimals;
    DateSeparator     := F^.DateSeparator;
    TimeSeparator     := F^.TimeSeparator;
    ListSeparator     := F^.ListSeparator;
    CurrencyString    := F^.CurrencyString;
    ShortDateFormat   := F^.ShortDateFormat;
    LongDateFormat    := F^.LongDateFormat;
    TimeAMString      := F^.TimeAMString;
    TimePMString      := F^.TimePMString;
    ShortTimeFormat   := F^.ShortTimeFormat;
    LongTimeFormat    := F^.LongTimeFormat;
    for i := 1 to 12 do
    begin
      ShortMonthNames[i] := F^.ShortMonthNames[i];
      LongMonthNames[i]  := F^.LongMonthNames[i];
    end;
    for i := 1 to 7 do
    begin
      ShortDayNames[i] := F^.ShortDayNames[i];
      LongDayNames[i]  := F^.LongDayNames[i];
    end;
    TwoDigitYearCenturyWindow := F^.TwoDigitYearCenturyWindow;
  end;                        
end;

function TdmReport.AddReportValue(aName: string; aValue: Variant): Boolean;
begin
  if FLocalVar.Count = 0 then
    FLocalVar.Variables[' LocalVar'] := null;

  FLocalVar.AddVariable('LocalVar',aName, aValue);
  Result := True;
end;

end.
