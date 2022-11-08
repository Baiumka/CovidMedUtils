unit ExtraFunction;

interface
uses SysUtils, Classes, fs_iinterpreter;

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

implementation
uses UtilsUnit, Variants, frxDBSet, ZAbstractDataset, DB;

const ctExtra = '�������������� �������';

{ TFunctions }

constructor TFunctions.Create;
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddMethod('function NumberWords(Value : Extended; Lng : integer = 0; Gndr : integer = 0) : string', CallMethod, ctExtra, '����� ��������');
    AddMethod('function NumberText(Value : Extended; Lng : integer = 0; ValID : integer = 980) : string', CallMethod, ctExtra, '����� ��������');
    AddMethod('function DateWords(Value : TDateTime; Lng : integer = 0; Mode : integer = 0) : string', CallMethod, ctExtra, '���� ��������');
    AddMethod('function LName(Value : string) : string', CallMethod, ctExtra, '�������� �����');
    AddMethod('function NameCaseF(Value : string; Type : integer) : string', CallMethod, ctExtra, '������� ������ �������');
    AddMethod('function FIO_Padeg(Value : string; CaseNum : Byte; Lng : Byte) : string', CallMethod, ctExtra, '��������� �������');
    AddMethod('function Job_Padeg(Value : string; CaseNum : Byte; Lng : Byte) : string', CallMethod, ctExtra, '��������� ���������');
    AddMethod('function FirstUpper(Value : string) : string', CallMethod, ctExtra, '������ ����� � ������� ��� ��������� � ���������');
    AddMethod('function FirstLower(Value : string) : string', CallMethod, ctExtra, '������ ����� � ��������� ��� ��������� ��� ����');
    AddMethod('function GetDecimalSeparator : char', CallMethod, ctExtra, '����� ����������� ����� � ������� �����');
    AddMethod('function SetDecimalSeparator(Value : char) : char', CallMethod, ctExtra, '���������� ����������� ����� � ������� �����');
    AddMethod('function ToMoney(Value : Double) : Double', CallMethod, ctExtra, '���������� �� ������');
    AddMethod('function DBSetIndex(Value : TfrxDataset; IndexStr : string) : boolean', CallMethod, ctExtra, '��������� ������� � ������ ������');
    AddMethod('function DBSetFilter(Value : TfrxDataset; FilterStr : string) : boolean', CallMethod, ctExtra, '��������� ������� � ������ ������');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; var Params: Variant): Variant;
var i : Int64;
    s : string;
    v : Variant;
    a : TfrxDBDataset;
    z : TDataSet;
begin
  if MethodName = 'NUMBERWORDS' then
  begin
    i := Trunc(Params[0]);
    Result := NumberWords(i, Params[1], Params[2]);
  end
  else if MethodName = 'NUMBERTEXT' then
  begin
    Result := NumberText(Params[0], Params[1], Params[2]);
  end
  else if MethodName = 'DATEWORDS' then
  begin
    Result := DateWords(Params[0], Params[1], Params[2]);
  end
  else if MethodName = 'LNAME' then
  begin
    Result := LName(VarToStrDef(Params[0],''));
  end
  else if MethodName = 'NAMECASEF' then
  begin
    Result := NameCase(VarToStrDef(Params[0],''), Params[1]);
  end
  else if MethodName = 'FIO_PADEG' then
  begin
    Result := FIO_Padeg(Params[0], Params[1], Params[2] )
  end
  else if MethodName = 'JOB_PADEG' then
  begin
    Result := Job_Padeg(Params[0], Params[1], Params[2] )
  end
  else if MethodName = 'FIRSTUPPER' then
  begin
    s := VarToStrDef(Params[0],'');
    if Length(s) > 0 then
      s[1] := AnsiUpperCase(s[1])[1];
    Result := s;
  end
  else if MethodName = 'FIRSTLOWER' then
  begin
    s := VarToStrDef(Params[0],'');
    if Length(s) > 0 then
      s[1] := AnsiLowerCase(s[1])[1];
    Result := s;
  end
  else if MethodName =  'GETDECIMALSEPARATOR' then
    Result := DecimalSeparator
  else if MethodName =  'SETDECIMALSEPARATOR' then
  begin
    Result := DecimalSeparator;
    s := VarToStrDef(Params[0],'');
    if (s <> '') then
      DecimalSeparator := s[1];
  end
  else if MethodName =  'TOMONEY' then
  begin
    Result := ToMoney(V2D(Params[0]))
  end
  else if MethodName = 'DBSETINDEX' then
  begin
    v := Params[0];
    a := TfrxDBDataset(Integer(v));
    Result := False;
    if Assigned(a) then
    begin
      z := a.GetDataSet;
      if Assigned(z) and (z is TZAbstractDataset) then
      begin
        TZAbstractDataset(z).SortedFields := Params[1];
        Result := True;
      end;
    end;
  end
  else if MethodName = 'DBSETFILTER' then
  begin
    v := Params[0];
    a := TfrxDBDataset(Integer(v));
    Result := False;
    if Assigned(a) then
    begin
      z := a.GetDataSet;
      if Assigned(z) and (z is TZAbstractDataset) then
      begin
        TZAbstractDataset(z).Filter   := Params[1];
        TZAbstractDataset(z).Filtered := (TZAbstractDataset(z).Filter <> '');
        Result := True;
      end;
    end;
  end;
end;

initialization
  fsRTTIModules.Add(TFunctions);

end.
