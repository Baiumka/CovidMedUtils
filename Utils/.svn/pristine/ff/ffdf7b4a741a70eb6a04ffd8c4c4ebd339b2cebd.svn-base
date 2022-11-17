unit DBFUnit;

interface

uses
  SysUtils, Classes, DB, dbf;

type
  TdmDBF = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    FPath,
    FTableName : string;
    FID : Integer;
    FSource : TDbf;
    FDbfList : TList;
    FBookmarks : TStringList;
    procedure SetSource(ASource : TDbf; AClose : Boolean = True);
    function  GetFilter: string;
    procedure SetFilter(const Value: string);
    function  GetDbfByAlias(AAlias : string = '') : TDbf;
  public
    { Public declarations }
    procedure SetTableName(AName : string; AAlias : string = '');
    procedure UseAlias(AAlias : string);
    function  GetCurrentAlias : string;
    function  GetCurrentFileName : string;
    property  CurrentDBF : TDbf read FSource;
    //Only BySingle
    function LockFile(const aExclusive : Boolean = True; aAutoCreate : Boolean = False) : Boolean;
    function UnLockFile : Boolean;

    function AppendRow : Boolean;
    function DeleteRow : Boolean;
    function CancelAddNewRecord() : boolean;
    function CancelDeleteRecord() : boolean;

    function EmptyTable : Boolean;
    function PackTable : Boolean;
    function DeleteTable : Boolean;
    function SetLangId(ALangId : Byte) : boolean;
    function DeleteIndex(AName : string) : boolean;
    function SetIndex(AName : string; AKey : string = '') : boolean;
    function SetIndexFilter(AFrom, ATo : Variant; APartKey : Boolean = True) : Boolean;
    property Filter : string read GetFilter write SetFilter;
    function Locate(AKey : Variant; AIndex : string = ''; APartKey : Boolean = True) : Boolean;

    function AppendNewRow(ASource : TDataSet) : Boolean;
    function AppendNewRows(ASource : TDataSet; const FromFirst : Boolean = True) : Boolean;
    //with Alias
    function Field(const FieldName: string; AAlias : string = ''): TField;
    function HasField(const FieldName: string; AAlias : string = ''): Boolean;
    function IsEmpty(AAlias : string = '') : boolean;
    function First(AAlias : string = '') : boolean;
    function Next(AAlias : string = '') : boolean;
    function Prior(AAlias : string = '') : boolean;
    function Last(AAlias : string = '') : boolean;
    function Eof(AAlias : string = '') : boolean;
    function Bof(AAlias : string = '') : boolean;
    function Edit(AAlias : string = '') : boolean;
    function Post(AAlias : string = '') : boolean;

    function SaveBookmark(AAlias : string = '') : boolean;
    function RestoreBookmark(AAlias : string = '') : boolean;

    function CreateFileByInfo(sInfo : string; sPath : string = '') : Boolean;
  end;

function ActiveDMDBF(aError : Boolean = False) : Boolean;

var
  dmDBF: TdmDBF;

implementation

uses
 Variants, Forms, StrUtils;

{$R *.dfm}

function ActiveDMDBF(aError : Boolean = False) : Boolean;
begin
  if not Assigned(dmDBF) {аналог dmDBF = nil} then
     dmDBF := TdmDBF.Create(Application);
  Result := (dmDBF <> nil);

  if not Result and aError then
    raise Exception.Create('DBF unit is not active');
end;


procedure TdmDBF.DataModuleCreate(Sender: TObject);
begin
  FPath := '';
  FDbfList := TList.Create;
  FBookmarks := TStringList.Create;
end;

procedure TdmDBF.DataModuleDestroy(Sender: TObject);
var t : TDbf;
    i : Integer;
begin
  i := FDbfList.Count - 1;
  while i >= 0 do
  begin
    t := TDbf(FDbfList.Items[i]);
    t.Close;
    t.Free;
    Dec(i);
  end;

  FreeAndNil(FBookmarks);
  FreeAndNil(FDbfList);
end;

function TdmDBF.LockFile(const aExclusive : Boolean = True; aAutoCreate : Boolean = False) : Boolean;
begin
  //Result := False;
  if not Assigned(FSource) then
    raise Exception.Create('Not assigned Source');
  if FSource.Active then
  begin
    Result := True;
    Exit;
  end;
  FSource.Close;
 // FSource.TableName := FTableName;
  FSource.Exclusive := AExclusive;
  Result := FSource.HaveFile or aAutoCreate;
  if Result then
  begin
   // Result := False;
    FSource.Open;
    Result := FSource.Active;
  end;
end;

function TdmDBF.UnLockFile: Boolean;
begin
  //Result := False;
  if not Assigned(FSource) then
    raise Exception.Create('Not assigned Source');

  if not FSource.Active then
  begin
    Result := True;
    Exit;
  end;
  FSource.Close;
  FSource := nil;
  Result := True;
end;

function TdmDBF.CancelAddNewRecord: boolean;
begin
  Result := False;
  if not FSource.Active then Exit;
  FSource.PhysicalRecNo := FID;
  if FSource.PhysicalRecNo <> FID then
    raise Exception.Create('ќшибка отмены добавлени€ строчки!');
  FSource.Delete;
end;

function TdmDBF.CancelDeleteRecord: boolean;
begin
  Result := False;
  if not FSource.Active then Exit;
  FSource.ShowDeleted := True;
  try
    FSource.PhysicalRecNo := FID;
    if FSource.PhysicalRecNo <> FID then
      raise Exception.Create('ќшибка отмены удалени€ строчки!');
    if FSource.IsDeleted then
      FSource.Undelete;
  finally
    FSource.ShowDeleted := False;
  end;
end;

procedure TdmDBF.UseAlias(AAlias: string);
var t : TDbf;
    i : Integer;
begin
  t := nil;
  i := -1;
  if AAlias <> '' then
  begin
    AAlias := 'dbf'+AnsiUpperCase(AAlias);

    i := FDbfList.Count - 1;
    while i >= 0 do
    begin
      t := TDbf(FDbfList.Items[i]);
      if t.Name = AAlias then
        Break;
      Dec(i);
    end;
  end;
  if i = -1 then
    raise Exception.CreateFmt('Ќе найден алиас таблицы %s',[AAlias]);

  SetSource(t, False);
end;

procedure TdmDBF.SetTableName(AName: string; AAlias : string = '');
var t : TDbf;
    i : Integer;
begin
  FTableName := AName;
  t := nil;
  i := FDbfList.Count - 1;
  if i >= 0 then
  begin
    if AAlias = '' then
    begin
      t := TDbf(FDbfList.Items[0]);
      AAlias := 'dbf0';
      t.Close;
    end
    else begin
      AAlias := 'dbf'+AnsiUpperCase(AAlias);
      while i >= 0 do
      begin
        t := TDbf(FDbfList.Items[i]);
        if t.Name = AAlias then
          Break;
        Dec(i);
      end;

      if i = -1 then
        t := nil
      else
        t.Close;
    end;
  end
  else if AAlias = '' then
    AAlias := 'dbf0'
  else
    AAlias := 'dbf'+AnsiUpperCase(AAlias);

  if t = nil then
  begin
    i := FDbfList.Add(TDbf.Create(Self));
    t := TDbf(FDbfList.Items[i]);
    t.Name := AAlias;
    //t.TableName := AName;
  end;

  SetSource(t);
end;

procedure TdmDBF.SetSource(ASource: TDbf; AClose : Boolean = True);
begin
  FSource := ASource;

  if AClose then
  begin
    FSource.Close;
    FSource.Storage   := stoFile;
    FSource.OpenMode  := omAutoCreate;
    FSource.Filter    := '';
    FSource.Filtered  := False;
    FSource.IndexName := '';
    FSource.TableName := FTableName;
    FSource.LanguageID := 0;
  end;
end;

function TdmDBF.AppendNewRow(ASource: TDataSet): Boolean;
var i : Integer;
    tF, sF : TField;
begin
  FSource.Append;
  for i := 0 to FSource.FieldCount - 1 do
  begin
    tF := FSource.Fields[i];
    sF := ASource.FindField(tF.FieldName);
    if Assigned(sF) then
    begin
      if sF.IsNull then
        tF.Value := Null
      else begin
        case tF.DataType of
          ftString:   tF.AsString   := sF.AsString;
          ftSmallint,
          ftInteger,
          ftWord:     tF.AsInteger  := sF.AsInteger;
          ftFloat,
          ftCurrency: tF.AsFloat    := sF.AsFloat;
          ftDate,
          ftDateTime: tF.AsDateTime := sF.AsDateTime;
        else
          tF.Value := sF.Value;
        end;
      end;
    end;
  end;
  FSource.Post;
  Result := True;
end;

function TdmDBF.AppendNewRows(ASource: TDataSet;
  const FromFirst: Boolean): Boolean;
begin
  Result := False;

  if ASource.IsEmpty then Exit;

  if FromFirst then
    ASource.First;

  while not ASource.Eof do
  begin
    AppendNewRow(ASource);
    ASource.Next;
  end;

  Result := True;
end;

function TdmDBF.AppendRow: Boolean;
begin
  Result := Assigned(FSource) and FSource.Active;
  if not Result then Exit;

  FSource.Append;
  FSource.Post;
  FID := FSource.PhysicalRecNo;
  FSource.Edit;
end;

function TdmDBF.DeleteRow: Boolean;
begin
  Result := FSource.Active and not FSource.IsEmpty;
  if not Result then Exit;
  
  FID := FSource.PhysicalRecNo;
  FSource.Delete;
end;

function TdmDBF.EmptyTable: Boolean;
begin
  Result := False;
  if not FSource.Active then Exit;
  if FSource.Exclusive then
    FSource.EmptyTable
  else begin
    FSource.TryExclusive;
    try
      FSource.EmptyTable;
    finally
      FSource.EndExclusive;
    end;
  end;
  Result := True;
end;

function TdmDBF.PackTable: Boolean;
begin
  Result := False;
  if not FSource.Active then Exit;
  if FSource.Exclusive then
    FSource.PackTable
  else begin
    FSource.TryExclusive;
    try
      FSource.PackTable;
    finally
      FSource.EndExclusive;
    end;
  end;
  Result := True;
end;

function TdmDBF.Field(const FieldName: string; AAlias : string = ''): TField;
begin
  Result := GetDbfByAlias(AAlias).FieldByName(FieldName);
end;

function TdmDBF.SetLangId(ALangId : Byte) : boolean;
begin
  Result := False;
  if FSource.Active then Exit;
  if FileExists(FTableName) then
    with TFileStream.Create(FTableName, fmOpenReadWrite or fmShareExclusive) do
    try
      Result := (Seek($1D, soBeginning) > 0);
      if Result then
      begin
        Result := (Write(ALangId, 1) = 1);
      end;
    finally
      Free;
    end;
end;

function TdmDBF.DeleteIndex(AName: string): boolean;
begin
  Result := False;
  if not Assigned(FSource) or not FSource.Active then
    Exit;

  FSource.DeleteIndex(AName);
  FSource.IndexName := '';
  Result := True;
end;

function TdmDBF.SetIndex(AName : string; AKey : string = ''): boolean;
begin
  Result := False;
  if not Assigned(FSource) or not FSource.Active then
    Exit;

  if FSource.Indexes.GetIndexByName(AName) = nil then
  begin
    if AKey <> '' then
      FSource.AddIndex(AName, AKey, [])
    else
      raise Exception.CreateFmt('Index Key for %s is empty', [AName]);
  end;
  FSource.IndexName := AName ;

  Result := True;
end;

function TdmDBF.IsEmpty(AAlias : string = ''): boolean;
begin
  Result := GetDbfByAlias(AAlias).IsEmpty;
end;

function TdmDBF.GetFilter: string;
begin
  Result := '';
  if not Assigned(FSource) or not FSource.Active then
    Exit;

  Result := FSource.Filter;
end;

procedure TdmDBF.SetFilter(const Value: string);
begin
  if not Assigned(FSource) or not FSource.Active then
    Exit;

  if FSource.IndexName <> '' then
    FSource.CancelRange;
    
  FSource.Filter   := Value;
  FSource.Filtered := (Value <> '');
end;

function TdmDBF.First(AAlias : string = ''): boolean;
begin
  GetDbfByAlias(AAlias).First;
  Result := True;
end;

function TdmDBF.Last(AAlias : string = ''): boolean;
begin
  GetDbfByAlias(AAlias).Last;
  Result := True;
end;

function TdmDBF.Next(AAlias : string = ''): boolean;
begin
  GetDbfByAlias(AAlias).Next;
  Result := True;
end;

function TdmDBF.Prior(AAlias : string = ''): boolean;
begin
  GetDbfByAlias(AAlias).Prior;
  Result := True;
end;

function TdmDBF.Eof(AAlias : string = ''): boolean;
begin
  Result := GetDbfByAlias(AAlias).Eof;
end;

function TdmDBF.GetDbfByAlias(AAlias: string): TDbf;
var i : Integer;
begin
  Result := nil;
  
  if AAlias = '' then
  begin
    Result := FSource;
    if not Assigned(Result) then
      raise Exception.Create('FSource is nil!');
  end
  else begin
    i := FDbfList.Count - 1;
    AAlias := 'dbf'+AnsiUpperCase(AAlias);
    while i >= 0 do
    begin
      Result := TDbf(FDbfList.Items[i]);
      if Result.Name = AAlias then
        Break;
      Dec(i);
    end;

    if i = -1 then
      raise Exception.CreateFmt('Alias "%s" is not found!', [AAlias]);
  end;

  if not Result.Active then
    raise Exception.CreateFmt('Alias "%s" is not active!', [AAlias]);
end;

function TdmDBF.SetIndexFilter(AFrom, ATo : Variant;
  APartKey: Boolean): Boolean;
begin
  Result := Assigned(FSource) and
            FSource.Active and
            (FSource.IndexName <> '');

  if not Result then
    Exit;

  if VarIsNull(ATo) then
    ATo := AFrom;

  FSource.Filtered := False;
  FSource.Filter   := '';

  FSource.MasterPartialKey := APartKey;
  FSource.SetRange(AFrom, ATo);

  Result := not FSource.Eof;
end;

function TdmDBF.Locate(AKey: Variant; AIndex : string; APartKey: Boolean): Boolean;
var lOp : TLocateOptions;
begin
  Result := Assigned(FSource) and
            FSource.Active and
            (FSource.IndexName <> '');

  if not Result then
    Exit;
  if APartKey then
    lOp := [loPartialKey]
  else
    lOp := [];

  if AIndex = '' then
    AIndex := FSource.IndexName;

  Result := FSource.Locate(AIndex, AKey, lOp);
end;

function TdmDBF.Bof(AAlias: string): boolean;
begin
  Result := GetDbfByAlias(AAlias).Bof;
end;

function TdmDBF.GetCurrentAlias: string;
begin
  Result := '';
  if Assigned(FSource) then
  begin
    Result := FSource.Name;
    Result := Copy(Result,4,255);
    if Result = '0' then
      Result := '';
  end;
end;

function TdmDBF.RestoreBookmark(AAlias: string): boolean;
var T : TDbf;
begin
  T := GetDbfByAlias(AAlias);
  T.Bookmark := FBookmarks.Values[T.Name];
  Result := True;
end;

function TdmDBF.SaveBookmark(AAlias: string): boolean;
var T : TDbf;
begin
  T := GetDbfByAlias(AAlias);
  FBookmarks.Values[T.Name] := T.Bookmark;
  Result := True;
end;

function TdmDBF.Edit(AAlias: string): boolean;
begin
  GetDbfByAlias(AAlias).Edit;
  Result := True;
end;

function TdmDBF.Post(AAlias: string): boolean;
begin
  GetDbfByAlias(AAlias).Post;
  Result := True;
end;

function TdmDBF.HasField(const FieldName: string; AAlias: string): Boolean;
var F : TField;
begin
  F := GetDbfByAlias(AAlias).FindField(FieldName);
  Result := (F <> nil);
end;

function TdmDBF.GetCurrentFileName: string;
begin
  Result := '';
  if Assigned(FSource) then
  begin
    Result := FSource.FilePathFull + FSource.TableName;
  end;
end;

function TdmDBF.DeleteTable: Boolean;
var f : string;
begin
  Result := False;
  if Assigned(FSource) and FSource.Active then
    Exit;

  f := FSource.AbsolutePath + FSource.TableName;
  Result := SysUtils.DeleteFile(f);
end;

function TdmDBF.CreateFileByInfo(sInfo: string; sPath : string = ''): Boolean;
var n,j,i,nField : Integer;
    sTable, sField, sType,
    sSize, sPrec,
    sCP : string;
    Y,M,D : Word;

begin
  //Result := False;
  if Assigned(FSource) and FSource.Active then
    raise Exception.Create('≈сть подключенна€ таблица DBF!');
  {—труктура описани€ формата
    YYYY - год типа 2021
    YY   - год типа 21
    MM   - мес€ц типа 01-12
    DD   - день типа 01-31

    файл(file)(=) "1_YYMMDD.DBF"
    cpcode (=) win(dos)
    пол€(fields):
    A	String	14
    B	Integer	4
    C	Float	12.2
    D Date 8

    может быть разделитель строк ;
    файл(file) "1_YYMMDD.DBF";cpcode (=) win(dos);пол€(fields): A	String	14;B	Integer	4;C	Float	12.2;D Date 8;
  }
  n := Length(sInfo);
  //определ€ем sTable (им€ таблицы)
  sTable := '';
  i := PosEx('file', sInfo, 1);
  if i < 1 then
    i := PosEx('файл', sInfo, 1);
  if i > 0 then
  begin
    //ищем первую "
    while (i <= n) and (sInfo[i] <> '"') do Inc(i);
    Inc(i);
    j := i;
    //ищем вторую "
    while (i <= n) and (sInfo[i] <> '"') do Inc(i);
    if i < n then
      sTable := Copy(sInfo, j, i-j);
  end;
  j := i + 1;
  if sTable = '' then
    raise Exception.Create('Ќе правильное описание формата DBF (нет имени)');
  //√енерируем правильное полное им€ файла
  DecodeDate(Date, Y,M,D);
  sTable := StringReplace(sTable, 'YYYY', Format('%.4d',[Y]), [rfIgnoreCase]);
  sTable := StringReplace(sTable, 'MM',   Format('%.2d',[M]), [rfIgnoreCase]);
  sTable := StringReplace(sTable, 'DD',   Format('%.2d',[D]), [rfIgnoreCase]);
  sTable := StringReplace(sTable, 'YY',   Format('%.2d',[(Y mod 100)]), [rfIgnoreCase]);
  if sPath = '' then
    sTable := ExtractFilePath(Application.ExeName) + sTable
  else begin
    if sPath[Length(sPath)] <> PathDelim then
      sTable := sPath + PathDelim + sTable
    else
      sTable := sPath + sTable;
  end;

  SetTableName(sTable);

  if FSource.HaveFile then
  begin
    // если файл есть то просто его открываеми очищаем
    Result := LockFile(True) and EmptyTable();
    Exit;
  end;

  i := PosEx('cpcode', sInfo, j);     //кодировка
  if i > 0 then
  begin
    Inc(i,6);
    while (i<=n) and (sInfo[i] in [' ','=']) do Inc(i);   //пропустим = и ' '
    j := i;
    while (i<=n) and (sInfo[i] in ['w','i','n','W','I','N']) do Inc(i);
    sCP := Copy(sInfo, j, i-j);   //считываем слово 'WIN'
    sCP := UpperCase(sCP);
    if sCP = 'WIN' then
      dmDBF.CurrentDBF.LanguageID  := $c9;
    j := i+1;
  end;
  //читаем структуру полей
  FSource.DbfFieldDefs.Clear;
  nField := 0;
  i := PosEx('fields:', sInfo, j);
  if i < 1 then
  begin
    i := PosEx('пол€:', sInfo, j);
    if i < 1 then
      raise Exception.Create('Ќе правильное описание формата DBF (нет полей)')
    else
      Inc(i,5);
  end
  else
    Inc(i,7);
  //теперь сами пол€
  while i <= n do
  begin
    sField := '';
    sType  := '';
    sSize  := '';
    sPrec  := '';

    while (i <= n) and (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);  //пропускаем пока не начнетс€ название пол€
    if i > n then Break;

    j := i;
    while (i <= n) and not (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);
    sField := Copy(sInfo,j,i-j);                                               // считываем название пол€

    while (i <= n) and (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);      //пропускаеи
    j := i;
    while (i <= n) and not (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);
    sType := Copy(sInfo,j,i-j);                                            // считываем тип

    while (i <= n) and (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);
    j := i;
    while (i <= n) and not (sInfo[i] in [' ',#13,#10,#9,'+','-',';']) do Inc(i);
    sSize := Copy(sInfo,j,i-j);                                               // размер

    j := PosEx('.', sSize);
    if j > 0 then
    begin
      sPrec := Copy(sSize, j+1, 255);
      SetLength(sSize, j-1);
    end;
    //формируем структуру полей
    if sField = '' then
      raise Exception.Create('Ќе правильное описание формата DBF (нет имени пол€)');
    sField := UpperCase(sField);
    sType  := LowerCase(sType);
    if sType = 'string' then
      dmDBF.CurrentDBF.DbfFieldDefs.Add(sField, ftString, StrToIntDef(sSize, 0))
    else if sType = 'integer' then
      dmDBF.CurrentDBF.DbfFieldDefs.Add(sField, ftInteger, StrToIntDef(sSize, 0))
    else if sType = 'date' then
      dmDBF.CurrentDBF.DbfFieldDefs.Add(sField, ftDate, 0)
    else if sType = 'float' then
    begin
      dmDBF.CurrentDBF.DbfFieldDefs.Add(sField, ftFloat, StrToIntDef(sSize, 0));
      dmDBF.CurrentDBF.DbfFieldDefs.Items[nField].Precision := StrToIntDef(sPrec, 0);
    end
    else
      raise Exception.Create('Ќе правильное описание формата DBF (неправильный тип пол€)');

    Inc(nField);   //количество полей (колонок)
  end;

  if nField = 0 then
    raise Exception.Create('Ќе правильное описание формата DBF (нет полей)');

  if not LockFile(True, True) then
    raise Exception.CreateFmt('Ќе возможно получить монопольный доступ к файлу %s',[sTable]);

  Result := EmptyTable;
end;

end.
