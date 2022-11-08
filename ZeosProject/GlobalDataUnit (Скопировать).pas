unit GlobalDataUnit;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, InterfaceUnit,
  ZSqlUpdate;

type
  TdmGlobalData = class(TDataModule)
    zqrAny: TZQuery;
    zuqEmpty: TZUpdateSQL;
    zqrImportFiles: TZQuery;
    zqrNKorr: TZQuery;
    zqrCashKeyItem: TZQuery;
    zqrTaxH: TZQuery;
    zqrTaxD: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FMaster : IMaster;
  protected
    procedure OnGetValue(const VarName: String; var Value: Variant);
    function  OnUserFunction(const MethodName: String; var Params: Variant): Variant;
  public
    { Public declarations }
    function  ClearCash : Boolean;
    property  Master : IMaster read FMaster;
  public
    function GetImportFilePath(const AKodord, AType : Integer; const AClear : Boolean = True) : string;
    function GetImportFileMap(const AKodord, AType : Integer) : string;

    function SetMapValues(Map : TStringList; ATarget, ASource : TObject) : Boolean;

    function  OpenNKorr(Refresh : Boolean = False) : Boolean;

    function  DatasetPost(DataSet : TDataSet; ACancel : Boolean = False) : Boolean;
    function  DatasetCancel(DataSet : TDataSet) : Boolean;
    function  DataSetEdit(DataSet : TDataSet) : Boolean;
    function  DatasetInEdit(Dataset : TDataset) : Boolean;
    function  DatasetAppend(Dataset : TDataset) : Boolean;

    function  LoadFromCashKeyItem(const KeyWord, SQL : string; Sender : TObject; const ID_NAME : Boolean = False) : Boolean; overload;
    function  LoadFromCashKeyItem(const KeyWord, SQL : string; Key,Item : TStrings; const ID_NAME : Boolean = False) : Boolean; overload;

    procedure FillKeyItemList(DataSet : TDataSet; ItemValue, KeyValue : TStrings; ID_NAME : Boolean = False);
    procedure FillItemList(DataSet : TDataSet; ItemValue : TStrings; AFieldName : string);

    procedure SetDateParam(Param : TParam; Value : Variant);

    procedure DefaultItemList(Sender : TObject; const ASQL : string; AFieldName : string = '');

    function PrintTax(const Aid : Int64; const AType : integer) : Boolean;
    function ExportTax(const Aid : Int64) : Boolean;

    function ExportToMedocOut(const dt : TDateTime) : Boolean;
    function ExportToMedocIn(const dt : TDateTime) : Boolean;
  end;

var
  dmGlobalData: TdmGlobalData;

implementation

{$R *.dfm}

uses Forms, Math, ConstUnit, Variants, StrUtils, UtilsUnit, DataUnit, DBGridEh, DBCtrlsEh,
     FileCtrl, DBFNalUnit;

function TdmGlobalData.ClearCash: Boolean;
var i : Integer;
begin
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i] is TZQuery then
    begin
      TZQuery(Self.Components[i]).Close;
    end;
  end;

  FMaster.RefreshReference('');
  Result := True;
end;

procedure TdmGlobalData.DataModuleCreate(Sender: TObject);
begin
  FMaster := Application.MainForm as IMaster;

  if not Assigned(FMaster) then
    raise Exception.Create('Can find IMaster form');

  FMaster.Report.SetGlobalGetValue(OnGetValue);
  FMaster.Report.SetGlobalUserFunc(OnUserFunction);
  FMaster.Report.RegFunction('function GetDeptExt(const dept_id : integer) : string');
end;

function TdmGlobalData.DatasetAppend(Dataset: TDataset): Boolean;
begin
  Result := dmSimpleClient.DatasetAppend(DataSet);
end;

function TdmGlobalData.DatasetCancel(DataSet: TDataSet): Boolean;
begin
  Result := dmSimpleClient.DatasetCancel(DataSet);
end;

function TdmGlobalData.DataSetEdit(DataSet: TDataSet): Boolean;
begin
  Result := dmSimpleClient.DataSetEdit(DataSet);
end;

function TdmGlobalData.DatasetInEdit(Dataset: TDataset): Boolean;
begin
  Result := dmSimpleClient.DatasetInEdit(DataSet);
end;

function TdmGlobalData.DatasetPost(DataSet: TDataSet;
  ACancel: Boolean): Boolean;
begin
  Result := dmSimpleClient.DatasetPost(DataSet, ACancel);
end;

procedure TdmGlobalData.DefaultItemList(Sender: TObject; const ASQL: string;
  AFieldName: string);
var IL : TStrings;
begin
  if Sender is TCustomDBComboBoxEh then
    IL := TCustomDBComboBoxEh(Sender).Items
  else if Sender is TColumnEh then
    IL := TColumnEh(Sender).PickList
  else Exit;

  if Assigned(IL) then
  with zqrAny do
  try
    SQL.Text := ASQL;
    if FMaster.GetData(zqrAny) then
    begin
      if AFieldName = '' then
      begin
        if Fields.Count = 1 then
          AFieldName := Fields[0].FieldName
        else if Fields.Count = 2 then
          AFieldName := Fields[1].FieldName
        else if FindField(API_NAME_U) <> nil then
          AFieldName := API_NAME_U
        else
          AFieldName := API_NAME;
      end;
      FillItemList(zqrAny, IL, AFieldName);
    end;
  finally
    Close;
  end;
end;

function TdmGlobalData.ExportTax(const Aid: Int64): Boolean;
var dir : string;
begin
  dir := '';
  if (Aid <> 0) and SelectDirectory('Укажите путь', '', dir) then
  begin
    dir := dir+'\';
    SysUtils.DeleteFile(dir+'j1201004.xml');
    SysUtils.DeleteFile(dir+'j1201204.xml');
    zqrAny.Close;
    zqrAny.SQL.Text := FNC_TAX_EXPORT_XML;
    zqrAny.ParamByName('id').AsString   := UtilsUnit.StringToArray(IntToStr(AId));
    zqrAny.ParamByName('all').AsInteger := 1;
    zqrAny.ParamByName('fio').Value     := null;
    if FMaster.GetData(zqrAny) then
    begin
      if (zqrAny.FieldByName('cnt1').AsInteger > 0) or
         (zqrAny.FieldByName('cnt2').AsInteger > 0)
      then begin
        if (zqrAny.FieldByName('cnt1').AsInteger > 0) then
        begin
          TBlobField(zqrAny.FieldByName('xml1')).SaveToFile(dir+'j1201004.xml');
        end;
        if (zqrAny.FieldByName('cnt2').AsInteger > 0) then
        begin
          TBlobField(zqrAny.FieldByName('xml2')).SaveToFile(dir+'j1201204.xml');
        end;
        FMaster.ShowInfo('Экспортировано: Основных - %d Коррегирующих - %d',
                         [zqrAny.FieldByName('cnt1').AsInteger,
                          zqrAny.FieldByName('cnt2').AsInteger]);
      end;
    end;
    zqrAny.Close;
  end;
  Result := True;
end;

function TdmGlobalData.ExportToMedocIn(const dt: TDateTime): Boolean;
var dir : string;
begin
  dir := '';
  if (dt > 0) and SelectDirectory('Укажите путь', '', dir) then
  begin
    dir := dir+'\MedocInFile.dbf';
    SysUtils.DeleteFile(dir);
    zqrAny.Close;
    zqrAny.SQL.Text := FNC_MEDOC_IN_FILE;
    zqrAny.ParamByName(API_DT).AsDate := dt;
    if FMaster.GetData(zqrAny) then
    begin
      if not Assigned(dmDBFNAL) then
        dmDBFNAL := TdmDBFNAL.Create(Self);
      try
        dmDBFNAL.SetTableName(dir);
        with dmDBFNAL.dbfTemp.DbfFieldDefs do
        begin
          Clear;
          Add('npp', ftInteger);
          Items[Count- 1].Size := 8;
          Add('datev', ftDate);
          Add('num', ftString, 50);
          Add('nazp', ftString, 200);
          Add('ipn', ftString, 20);
          Add('zagsum', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vart7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sum8', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vart9', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sum10', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vart11', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sum12', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vart13', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sum14', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('rkred', ftInteger);
          Items[Count- 1].Size := 3;
          Add('nrez', ftInteger);
          Items[Count- 1].Size := 2;
          Add('kor', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtype', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtypestr', ftString, 5);
          Add('dtvp', ftDate);
          Add('utoch', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtyplit1', ftString, 1);
          Add('wmdtyplit2', ftString, 1);
          Add('dkor', ftDate);
          Add('d1_num', ftString, 20);
          Add('pid', ftString, 250);
          Add('zvvrt7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('zvpdv7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('nprvrt7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('nprpdv7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('chastka', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vrt7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('pdv7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('vrt0', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('pdv0', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('wmdtyplit3', ftString, 1);
        end;
        if dmDBFNAL.LockFile() then
        try
          dmDBFNAL.AppendNewRows(zqrAny);
        finally
          dmDBFNAL.UnLockFile;
        end;
      finally
        FreeAndNil(dmDBFNAL);
      end;
    end;
    FMaster.ShowInfo('Файл MedocInFile.dbf создан! (Записей %d)',[zqrAny.RecordCount]);
    zqrAny.Close;
  end;
  Result := True;
end;

function TdmGlobalData.ExportToMedocOut(const dt: TDateTime): Boolean;
var dir : string;
begin
  dir := '';
  if (dt > 0) and SelectDirectory('Укажите путь', '', dir) then
  begin
    dir := dir+'\MedocOutFile.dbf';
    SysUtils.DeleteFile(dir);
    zqrAny.Close;
    zqrAny.SQL.Text := FNC_MEDOC_OUT_FILE;
    zqrAny.ParamByName(API_DT).AsDate := dt;
    if FMaster.GetData(zqrAny) then
    begin
      if not Assigned(dmDBFNAL) then
        dmDBFNAL := TdmDBFNAL.Create(Self);
      try
        dmDBFNAL.SetTableName(dir);
        with dmDBFNAL.dbfTemp.DbfFieldDefs do
        begin
          Clear;
          Add('npp', ftInteger);
          Items[Count- 1].Size := 8;
          Add('datev', ftDate);
          Add('num', ftString, 50);
          Add('nazp', ftString, 200);
          Add('ipn', ftString, 20);
          Add('zagsum', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('bazop20', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sumpdv', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('bazop0', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('zviln', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('export', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('pzob', ftInteger);
          Items[Count- 1].Size := 3;
          Add('nrez', ftInteger);
          Items[Count- 1].Size := 2;
          Add('kor', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtype', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtypestr', ftString, 5);
          Add('utoch', ftInteger);
          Items[Count- 1].Size := 2;
          Add('wmdtypexec', ftString, 2);
          Add('wmdtyplit', ftString, 1);
          Add('delivery', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('dkor', ftDate);
          Add('d1_num', ftString, 20);
          Add('dotr', ftDate);
          Add('pid', ftString, 250);
          Add('bazop7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('sumpdv7', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
          Add('neop', ftFloat);
          Items[Count- 1].Size := 16;
          Items[Count- 1].Precision := 2;
        end;
        if dmDBFNAL.LockFile() then
        try
          dmDBFNAL.AppendNewRows(zqrAny);
        finally
          dmDBFNAL.UnLockFile;
        end;
      finally
        FreeAndNil(dmDBFNAL);
      end;
    end;
    FMaster.ShowInfo('Файл MedocOutFile.dbf создан! (Записей %d)',[zqrAny.RecordCount]);
    zqrAny.Close;
  end;
  Result := True;
end;

procedure TdmGlobalData.FillItemList(DataSet: TDataSet;
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

procedure TdmGlobalData.FillKeyItemList(DataSet: TDataSet; ItemValue,
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

function TdmGlobalData.GetImportFileMap(const AKodord,
  AType: Integer): string;
begin
  Result := '';
  if not zqrImportFiles.Active then
  begin
    zqrImportFiles.Close;
    zqrImportFiles.SQL.Text := QR_IMPORT_FILES;
    if not FMaster.GetData(zqrImportFiles) then Exit;
    zqrImportFiles.SortedFields := Format('%s;%s',[API_KODORD, API_TYPE_ID]);
  end;
  if zqrImportFiles.Locate(zqrImportFiles.SortedFields, VarArrayOf([AKodord, AType]), []) then
  begin
    Result := zqrImportFiles.FieldByName(API_MAP).AsString;
  end;
end;

function TdmGlobalData.GetImportFilePath(const AKodord, AType : Integer; const AClear : Boolean = True): string;
begin
  Result := '';
  if not zqrImportFiles.Active then
  begin
    zqrImportFiles.Close;
    zqrImportFiles.SQL.Text := QR_IMPORT_FILES;
    if not FMaster.GetData(zqrImportFiles) then Exit;
    zqrImportFiles.SortedFields := Format('%s;%s',[API_KODORD, API_TYPE_ID]);
  end;
  if zqrImportFiles.Locate(zqrImportFiles.SortedFields, VarArrayOf([AKodord, AType]), []) then
  begin
    Result := zqrImportFiles.FieldByName(API_FILENAME).AsString;
    if AClear and
       ( (PosEx('%Y', Result) > 0) or
         (PosEx('%M', Result) > 0) or
         (PosEx('%D', Result) > 0))
    then
      Result := ExtractFilePath(Result);
  end;
end;

function TdmGlobalData.LoadFromCashKeyItem(const KeyWord, SQL: string;
  Sender: TObject; const ID_NAME: Boolean): Boolean;
begin
  if Sender is TColumnEh then
    Result := LoadFromCashKeyItem(KeyWord, SQL, TColumnEh(Sender).KeyList, TColumnEh(Sender).PickList, ID_NAME)
  else if Sender is TCustomDBComboBoxEh then
    Result := LoadFromCashKeyItem(KeyWord, SQL, TCustomDBComboBoxEh(Sender).KeyItems, TCustomDBComboBoxEh(Sender).Items, ID_NAME)
  else
    Result := False;
end;

function TdmGlobalData.LoadFromCashKeyItem(const KeyWord, SQL: string; Key,
  Item: TStrings; const ID_NAME: Boolean): Boolean;
begin
  Result := zqrCashKeyItem.Active;
  if not Result then
  begin
    zqrCashKeyItem.UpdateObject := zuqEmpty;
    zqrCashKeyItem.SQL.Text := 'select null::varchar keyword, null::integer id, null::varchar "name"' + #13#10 +
                               'where 1=2';
    Result := FMaster.GetData(zqrCashKeyItem);
    if not Result then Exit;
    zqrCashKeyItem.EmptyDataSet;
  end;
  
  zqrCashKeyItem.Filter   := Format('%s=''%s''',[API_KEYWORD, AnsiUpperCase(KeyWord)]);
  zqrCashKeyItem.Filtered := True;

  if zqrCashKeyItem.IsEmpty then
  begin
    zqrAny.Close;
    zqrAny.SQL.Text := SQL;
    if FMaster.GetData(zqrAny) then
    begin
      zqrAny.First;
      while not zqrAny.Eof do
      begin
        zqrCashKeyItem.AppendRecord([AnsiUpperCase(KeyWord),zqrAny.Fields[0].AsInteger, zqrAny.Fields[1].AsString]);
        zqrAny.Next;
      end;
    end;
  end;
  Result := not zqrCashKeyItem.IsEmpty;
  if Result then
    FillKeyItemList(zqrCashKeyItem,Item, Key, ID_NAME);
end;

procedure TdmGlobalData.OnGetValue(const VarName: String;
  var Value: Variant);
begin

end;

function TdmGlobalData.OnUserFunction(const MethodName: String;
  var Params: Variant): Variant;
begin

end;

function TdmGlobalData.OpenNKorr(Refresh: Boolean): Boolean;
begin
  Result := zqrNKorr.Active;
  if not Result or Refresh then
  begin
    zqrNKorr.SQL.Text := QR_NKORR_SELECT;
    zqrNKorr.ReadOnly := True;
    Result := FMaster.GetData(zqrNKorr);
  end;
end;

function TdmGlobalData.PrintTax(const Aid : Int64; const AType : integer): Boolean;
var rName : string;
begin
  Result := (Aid > 0);
  if not Result then Exit;

  case AType of
    0,2 : begin
      zqrTaxH.SQL.Text := FNC_TAX_HEADER_A;
      zqrTaxD.SQL.Text := FNC_TAX_DETAIL_A;
      rName := 'TaxA';
    end;
    1,3 : begin
      zqrTaxH.SQL.Text := FNC_TAX_HEADER_B;
      zqrTaxD.SQL.Text := FNC_TAX_DETAIL_B;
      rName := 'TaxB';
    end;
    else begin
      Result := False;
      Exit;
    end;
  end;

  zqrTaxH.ParamByName(API_ID).Value := Aid;
  zqrTaxD.ParamByName(API_ID).Value := Aid;

  if FMaster.GetData(zqrTaxH) and
     FMaster.GetData(zqrTaxD) and
     not zqrTaxH.IsEmpty
  then begin
    FMaster.Report.ReportDate(zqrTaxH.FieldByName(API_DT).AsDateTime);
    FMaster.Report.ShowReport(rName, [zqrTaxH, zqrTaxD]);
  end;
end;

procedure TdmGlobalData.SetDateParam(Param: TParam; Value: Variant);
var dt : TDateTime;
begin
  dt := V2Dt(Value);
  Param.DataType := ftDate;
  if dt = 0 then
    Param.Value := Null
  else
    Param.AsDate := dt;
end;

function TdmGlobalData.SetMapValues(Map: TStringList; ATarget,
  ASource: TObject): Boolean;
var i, j : Integer;
    F : TFields;
    P : TParams;
    s1, s2, s3 : string;
begin
  Result := False;
  P := TParams(ATarget);
  F := TFields(ASource);

  for i := 0 to P.Count - 1 do
  begin
    s1 := p.Items[i].Name;
    s2 := AnsiUpperCase(Map.Values[s1]);
    if s2 = '' then
      s2 := AnsiUpperCase(s1)
    else begin
      j := PosEx('#', s2);
      if j > 1 then
      begin
        s3 := Copy(s2, j, 3);
        if s3 = MAP_DATATYPE_INTEGER then
          p.Items[i].DataType := ftInteger
        else if s3 = MAP_DATATYPE_LOND then
          p.Items[i].DataType := ftLargeint
        else if s3 = MAP_DATATYPE_STRING then
          p.Items[i].DataType := ftString
        else if s3 = MAP_DATATYPE_DATE then
          p.Items[i].DataType := ftDate
        else if s3 = MAP_DATATYPE_FLOAT then
          p.Items[i].DataType := ftFloat
        else if s3 = MAP_DATATYPE_TIME then
          p.Items[i].DataType := ftTime
        else
          p.Items[i].DataType := ftString;

        Delete(s2, j, 3);
        s2 := Trim(s2);
      end;
    end;

    if s2 = MAP_NULL then
      P.Items[i].Value := null
    else if s2 = MAP_TABLENAME then
      P.Items[i].AsString := Map.Values[MAP_TABLENAME]
    else if s2 = MAP_DATE then
      P.Items[i].AsDate := Date
    else if F.FindField(s2) <> nil then
    begin
      case p.Items[i].DataType of
        ftString   : P.Items[i].AsString   := F.FieldByName(s2).AsString;
        ftInteger  : P.Items[i].AsInteger  := F.FieldByName(s2).AsInteger;
        ftLargeint,
        ftWord     : P.Items[i].Value      := V2C(F.FieldByName(s2).Value);
        ftFloat    : P.Items[i].AsFloat    := F.FieldByName(s2).AsFloat;
        ftDate     : P.Items[i].AsDate     := F.FieldByName(s2).AsDateTime;
        ftDateTime : P.Items[i].AsDateTime := F.FieldByName(s2).AsDateTime;
      else
        P.Items[i].Value := F.FieldByName(s2).Value;
      end;
    end
    else
     P.Items[i].Value := null;
  end;
end;

end.
