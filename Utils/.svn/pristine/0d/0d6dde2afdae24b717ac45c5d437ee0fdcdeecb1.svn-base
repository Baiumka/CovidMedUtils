unit DBFNalUnit;

interface

{$I Utils.inc}

uses
  SysUtils, Classes, DB, dbf;

type
  TdmDBFNAL = class(TDataModule)
    dbfNal: TDbf;
    dbfTemp: TDbf;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FPath,
    FTableName : string;
    FID : Integer;
    FSource : TDbf;
    procedure SetSource(ASource : TDbf);
    procedure GetNalPath;
  public
    { Public declarations }
    function LockFile(const AExclusive : Boolean = True) : Boolean;
    function UnLockFile : Boolean;
    // For NAL DBF
    function SetWorkDate(const dt : TDateTime) : Boolean;
    function SetNalPath(const Value : String) : Boolean;
    function GetNewNumber(const doc : string; const dt : TDateTime; const root : Integer; const r_dt : TDateTime) : Integer;
    function CancelAddNewRecord(id : integer) : boolean;
    function DeleteNumber(const id : integer; const dt : TDateTime) : Boolean;
    function UnDeleteNumber(const id : integer; const dt : TDateTime) : Boolean;

    //For Other Tables
    procedure SetTableName(AName : string);
    function  HaveFile : Boolean;
    function  SetLangId(ALangId : Byte) : boolean;

    function AppendNewRow(ASource : TDataSet) : Boolean;
    function AppendNewRows(ASource : TDataSet; const FromFirst : Boolean = True) : Boolean; 
  end;

var
  dmDBFNAL: TdmDBFNAL;

implementation

{$IFDEF USE_DM_GLOBAL_PATH}
uses GlobalDataUnit, Variants;
{$ELSE}
uses ConstUnit, Variants;
{$ENDIF}

{$R *.dfm}

procedure TdmDBFNAL.DataModuleCreate(Sender: TObject);
begin
  FPath := '';
end;

function TdmDBFNAL.LockFile(const AExclusive : Boolean = True) : Boolean;
begin
  if not Assigned(FSource) then
    raise Exception.Create('Not assigned Source');
  if FSource.Active then
  begin
    Result := True;
    Exit;
  end;
  FSource.Close;
  FSource.TableName := FTableName;
  FSource.Exclusive := AExclusive;
  FSource.Open;
  Result := True;
end;

function TdmDBFNAL.UnLockFile: Boolean;
begin
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

function TdmDBFNal.SetLangId(ALangId : Byte) : boolean;
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

function TdmDBFNAL.SetWorkDate(const dt: TDateTime): Boolean;
var Y,M,D : Word;
begin
  GetNalPath;
  if dbfNal.Active then
    raise Exception.Create('File already active, unlock before');
  DecodeDate(dt, Y,M,D);
  FTableName := Format('%sN%.4d%.2d.DBF',[FPath, Y,M]);
  FSource := dbfNal;
  Result := True;
end;

function TdmDBFNAL.GetNewNumber(const doc : string; const dt : TDateTime;
  const root : Integer; const r_dt : TDateTime): Integer;
var i : Integer;
begin
  dbfTemp.Close;
  dbfTemp.FieldDefs.Clear;
  dbfTemp.FieldDefs.Add('ID', ftInteger);
  dbfTemp.OpenMode := omAutoCreate;
  dbfTemp.Storage := stoMemory;
  dbfTemp.Open;
  dbfTemp.AddIndex('ID','ID',[]);
  dbfTemp.IndexName := 'ID';
  try
    dbfNal.First;
    while not dbfNal.Eof do
    begin
      dbfTemp.AppendRecord([dbfNal.Fields[0].AsInteger]);
      dbfNal.Next;
    end;
    i := 1;
    dbfTemp.First;
    while not dbfTemp.Eof and (dbfTemp.Fields[0].AsInteger = i) do
    begin
      Inc(i);
      dbfTemp.Next;
    end;
  finally
    dbfTemp.Close;
  end;

  dbfNal.Append;
  dbfNal.FieldByName('NAK').AsInteger   := i;
  dbfNal.FieldByName('DV').AsDateTime   := dt;
  dbfNal.FieldByName('PUT').AsString    := doc;
  dbfNal.FieldByName('DATE').AsDateTime := Date;
  if root > 0 then
  begin
    dbfNal.FieldByName('KOR_NAK').AsInteger    := root;
    dbfNal.FieldByName('KOR_DTNAK').AsDateTime := r_dt;
  end;
  dbfNal.Post;
  FID := dbfNal.PhysicalRecNo;
  Result := i;
end;

function TdmDBFNAL.CancelAddNewRecord(id : integer): boolean;
begin
  Result := False;
  if not dbfNal.Active then Exit;
  dbfNal.PhysicalRecNo := FID;
  if dbfNal.Fields[0].AsInteger <> id then
    raise Exception.Create('Ошибка отмены добавления строчки в список налоговых!');
  dbfNal.Delete;
end;

function TdmDBFNAL.DeleteNumber(const id : integer; const dt : TDateTime): Boolean;
var s : string;
begin
  Result := False;
  if not dbfNal.Active then Exit;
  dbfNal.First;
  while not dbfNal.Eof and
       ((dbfNal.Fields[0].AsInteger <> id) or
        (dbfNal.Fields[3].AsDateTime <> dt))
  do dbfNal.Next;

  if (dbfNal.Fields[0].AsInteger = id)  and
     (dbfNal.Fields[3].AsDateTime = dt)
  then begin
    s := dbfNal.FieldByName('PUT').AsString;
    {if Pos('billings',s) = 0 then
      raise Exception.Create('Налоговая выписана в другой программе!');}

    FID := dbfNal.PhysicalRecNo;
    dbfNal.Delete;
    Result := True;
  end;
end;

function TdmDBFNAL.UnDeleteNumber(const id: integer;
  const dt: TDateTime): Boolean;
begin
  Result := False;
  if not dbfNal.Active then Exit;
  dbfNal.ShowDeleted := True;
  try
    dbfNal.Refresh;
    dbfNal.PhysicalRecNo := FID;

    if (dbfNal.Fields[0].AsInteger = id)  and
       (dbfNal.Fields[3].AsDateTime = dt)
    then begin
      dbfNal.Undelete;
      Result := True;
    end;
  finally
    dbfNal.ShowDeleted := False;
  end;
end;

procedure TdmDBFNAL.SetTableName(AName: string);
begin
  FTableName := AName;
  SetSource(dbfTemp);
end;

procedure TdmDBFNAL.SetSource(ASource: TDbf);
begin
  FSource          := ASource;
  FSource.Storage  := stoFile;
  FSource.OpenMode := omAutoCreate;
end;

procedure TdmDBFNAL.GetNalPath;
begin
  if FPath <> '' then Exit;
{$IFDEF USE_DM_GLOBAL_PATH}
  dmGlobalData.zqrAny.Close;
  dmGlobalData.zqrAny.SQL.Text := 'select tax_register.p_dbf_nal_path()';
  if dmGlobalData.Master.GetData(dmGlobalData.zqrAny) then
    FPath := dmGlobalData.zqrAny.Fields[0].AsString
  else
    raise Exception.Create('Nal Path not set');
{$ELSE}
  FPath := DEFAULT_NAL_PATH;
{$ENDIF}
end;

function TdmDBFNAL.AppendNewRow(ASource: TDataSet): Boolean;
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

function TdmDBFNAL.AppendNewRows(ASource: TDataSet;
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

function TdmDBFNAL.SetNalPath(const Value: String): Boolean;
begin
  FPath := Value;
  Result := (FPath <> '');
end;

function TdmDBFNAL.HaveFile: Boolean;
begin
  Result := False;
  if not Assigned(FSource) then
    Exit;

  if FSource.Active then
    Result := True
  else
    Result := FileExists(FTableName);
end;

end.
