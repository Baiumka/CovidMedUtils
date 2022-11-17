unit UtilsUnit;

interface

uses  Classes;

{$i Utils.inc}

type
   TMonthArray = array[0..2,1..12] of String[9];
   TPGVarArray = array of Variant;
  TFioRec = record
    f,
    i,
    o : string;
  end;
const
  MonthArrayRu       : TMonthArray =
                        (('Январь','Февраль','Март','Апрель',
                          'Май','Июнь','Июль','Август','Сентябрь',
                          'Октябрь','Ноябрь','Декабрь'),
                         ('января','февраля','марта','апреля',
                          'мая','июня','июля','августа','сентября',
                          'октября','ноября','декабря'),
                         ('января','февраля','марта','апреля',
                          'мая','июня','июля','августа','сентября',
                          'октября','ноября','декабря'));
  MonthArrayUA        : TMonthArray =
                        (('Січень','Лютий','Березень','Квітень',
                          'Травень','Червень','Липень','Серпень','Вересень',
                          'Жовтень','Листопад','Грудень'),
                         ('січня','лютого','березня','квітня',
                          'травня','червня','липня','серпня','вересня',
                          'жовтня','листопада','грудня'),
                         ('січні','лютому','березні','квітні',
                          'травні','червні','липні','серпні','вересні',
                          'жовтні','листопаді','грудні'));

  function NumberWords(AValue : Int64; Lng : Byte = 0; Gndr : byte = 0):string;
  function DateWords(AValue : TDateTime; Lng : byte = 0; Mode : Byte = 0) : String;
  function NumberText(AValue : Extended; Lng : Byte = 0; ValId : Integer = 980) : string;
  function LName(const AValue : string) : string;
  function NameCase(const AText: string; const AType: Integer = 1) : string;

  function FIO_Padeg(Value : string; CaseNum : byte; Lng : Byte = 0) : string;
  function Job_Padeg(Value : string; CaseNum : byte; Lng : Byte = 0) : string;

  function ToMoney(Value : Double) : Double;
  function EqualMoney(const a, b : Double) : Boolean;
  function EqualDouble(const a, b : Double) : Boolean;

  function S2D(Value : string) : Double;
  function S2Dt(const Value: String): TDateTime;

  function V2I(const Value : Variant) : Integer;
  function V2C(const Value : Variant) : Int64;
  function V2D(const Value : Variant) : Double;
  function V2Dt(const Value : Variant) : TDateTime;

  function I2V(const Value : integer) : Variant;
  function C2V(const Value : Int64) : Variant;
  function D2V(const Value : Double) : Variant;
  function S2V(const Value : String) : Variant;

  function PGDateToStr(const dt: TDateTime): string;

  function StringToArray(Value: string; aMode : Integer = 0 ): Variant;  //преобразует в постгресовский массив
  function IdInSet(const AId : Integer; const ASet : string) : Boolean;
  function NextIdInSet(const ASet : string; var Spos : integer) : integer;
  function FirstIdInSet(const ASet : string) : integer;
  function IntArrayToPGArray(aMas : array of Integer) : string;
  function StrListToPGArray(aMas : TStringList) : string;

  // Для работы с массивами PG
  function PGArrayToArray(Value: string; N : integer): Variant;
  function PGArrayCount(Value: string) : Integer;
  function VarArrayToPGArray(aMas : Variant) : string;

  function FindLetter(const AValue: String): Boolean;
  function GetNumberStr(const AValue : string) : string;

  function CreateDefaultDays(const ADays : Integer) : String;
  function GetHoursInDays(const AStr : string; ADay : integer = 0) : Double;
  function SetHoursInDays(AStr : string; ADay : integer; AHour : Double) : string;
  procedure GetDaysAndHours(AStr : string; var ADays : integer; var AHour : Double);

  function DecodeString(const Value, Pass: string): string;
  function EncodeString(const Value, Pass: string): string;

  function GetTempDir : string;
  //function GetMyDir : string;
  function CheckDir(ADir : string; AClear : Boolean = False) : Boolean;

  function WinDelFile(const AFile: string) : boolean;
  function WinCopyFile(const AFrom, ATo: String): Boolean;


  function DosStrToWin(Value : string) : string;
  function WinStrToDos(Value : string) : string;

  function TextIsNumeric(aText: String): Boolean;
  function FIO(Value : string) : TFioRec;

  function RomanNumerals(aValue : Integer): string;

const
  ShortWeek : array[1..7] of string[2] =
              ('ПН',  'ВТ',  'СР' , 'ЧТ' , 'ПТ', 'СБ' , 'ВС');
              //('ПНД', 'ВТР', 'СРД', 'ЧТВ', 'ПТН', 'СБТ', 'ВСК');
  D_W = 'Р';  // Day of Work     Рабочий
  D_R = 'В';  // Day of Rest     Выходной
  D_H = 'ПР'; // Day of Holiday  Праздник

  fDR = 0.00;
  fDH = 25.00;

const
  MSG_NO_DAY           = 'В месяце нет такого дня %d';

implementation

uses SysUtils, Windows, Variants, StrUtils, ShellAPI
{$IFDEF USE_FIO_JOB_CASE}
  ,DeclinationUnit, RuUnit, UaUnit, JobUaUnit, JobRuUnit, ExceptionUnit, GlobalDataUnit
{$ENDIF}
{$IFDEF USE_DM_GLOBAL}
  ,GlobalDataUnit
{$ENDIF}, VarUtils;

function DateWords(AValue : TDateTime; Lng : byte = 0; Mode : Byte = 0) : String;
var Y,M,D : Word;
    Mas : TMonthArray;
begin
  Result := '';
  if AValue = 0.0 then Exit;
  DecodeDate(AValue, Y,M,D);
  if Lng = 0 then
    Mas := MonthArrayRu
  else
    Mas := MonthArrayUa;
  case Mode of
    0 : Result := Format('%s %d',[Mas[0,M], Y]);
    1 : Result := Format('%d %s %d',[D,Mas[1,M], Y]);
    2 : Result := Format('%.2d.%.2d.%4d',[D,M,Y]);
    3 : Result := Format('%.2d.%.2d.%.2d',[D,M,Y mod 1000]);
    4 : Result := Format('%s',[Mas[0,M]]);
    5 : Result := Format('%s',[Mas[1,M]]);
    6 : Result := Format('"%.2d" %s %d',[D,Mas[1,M], Y]);
    7 : Result := Format('%.2d%.2d%4d',[D,M,Y]);
    8 : Result := Format('%s %d',[Mas[2,M], Y]); 
  end;
end;


function NumberWords(AValue : Int64; Lng : Byte = 0; Gndr : byte = 0):string;
const NumWords : array[0..2, 0..50] of string[15] =
      (// ru или 0
       ('ноль ','один ','одна ','два ','две ','три ','четыре ','пять ','шесть ',
        'семь ','восемь ','девять ','десять ','одиннадцать ','двенадцать ',
        'тринадцать ','четырнадцать ','пятнадцать ','шестнадцать ',
        'семнадцать ','восемнадцать ','девятнадцать ','двадцать ','тридцать ',
        'сорок ','пятьдесят ','шестьдесят ','семьдесят ','восемьдесят ',
        'девяносто ','сто ','двести ','триста ','четыреста ','пятьсот ',
        'шестьсот ','семьсот ','восемьсот ','девятьсот ','тысяча ','тысячи ',
        'тысяч ','миллион ','миллиона ','миллионов ','миллиард ','миллиарда ',
        'миллиардов ','триллион ','триллиона ','триллионов '),
       // ua или 1
       ('нуль ','один ','одна ','два ','дві ','три ','чотири ','п''ять ','шість ',
        'сім ','вісім ','дев''ять ','десять ','одинадцять ','дванадцять ',
        'тринадцять ','чотирнадцять ','п''ятнадцять ','шістнадцять ',
        'сімнадцять ','вісімнадцять ','дев''ятнадцять ','двадцять ','тридцять ',
        'сорок ','п''ятдесят ','шістдесят ','сімдесят ','вісімдесят ',
        'дев''яносто ','сто ','двісті ','триста ','чотириста ','п''ятсот ',
        'шістсот ','сімсот ','вісімсот ','дев''ятсот ','тисяча ','тисячі ',
        'тисяч ','мільйон ','мільйона ','мільйонів ','мільярд ','мільярда ',
        'мільярдів ','триліон ','триліона ','триліонів '),
        // en или 2
        ('zero ','one ','one ','two ','two ','three ','four ','five ','six ',
        'seven ','eight ','nine ','ten ','eleven ','twelve ',
        'thirteen ','fourteen ','fifteen ','sixteen ',
        'seventy ','eighty ','ninety ','twenty ','thirty ',
        'forty ','fifty ','sixty ','seventy ','eighty ',
        'ninety ','one hundred ','two hundred ','three hundred ','four hundred ','five hundred ',
        'six hundred ','seven hundred ','eight hundred ','nine hundred ','thousand ','thousand ',
        'thousand ','million ','million ','million ','billion ','billion ',
        'billion ','trillion ','trillion ','trillion '));
var
  Decline : boolean;
  TValue: int64;

  procedure Num(Value: byte);
  begin
    case Value of
      1:  if Decline and (Gndr=0) then
            Result := Result + NumWords[Lng,1]
          else
            Result := Result + NumWords[Lng,2];
      2:  if Decline and (Gndr=0) then
            Result := Result + NumWords[Lng,3]
          else
            Result := Result + NumWords[Lng,4];
      3:  Result := Result + NumWords[Lng,5];
      4:  Result := Result + NumWords[Lng,6];
      5:  Result := Result + NumWords[Lng,7];
      6:  Result := Result + NumWords[Lng,8];
      7:  Result := Result + NumWords[Lng,9];
      8:  Result := Result + NumWords[Lng,10];
      9:  Result := Result + NumWords[Lng,11];
      10: Result := Result + NumWords[Lng,12];
      11: Result := Result + NumWords[Lng,13];
      12: Result := Result + NumWords[Lng,14];
      13: Result := Result + NumWords[Lng,15];
      14: Result := Result + NumWords[Lng,16];
      15: Result := Result + NumWords[Lng,17];
      16: Result := Result + NumWords[Lng,18];
      17: Result := Result + NumWords[Lng,19];
      18: Result := Result + NumWords[Lng,20];
      19: Result := Result + NumWords[Lng,21];
    end
  end;

  procedure Num10(Value: byte);
  begin
    case Value of
      2: Result := Result + NumWords[Lng,22];
      3: Result := Result + NumWords[Lng,23];
      4: Result := Result + NumWords[Lng,24];
      5: Result := Result + NumWords[Lng,25];
      6: Result := Result + NumWords[Lng,26];
      7: Result := Result + NumWords[Lng,27];
      8: Result := Result + NumWords[Lng,28];
      9: Result := Result + NumWords[Lng,29];
    end;
  end;

  procedure Num100(Value: byte);
  begin
    case Value of
      1: Result := Result + NumWords[Lng,30];
      2: Result := Result + NumWords[Lng,31];
      3: Result := Result + NumWords[Lng,32];
      4: Result := Result + NumWords[Lng,33];
      5: Result := Result + NumWords[Lng,34];
      6: Result := Result + NumWords[Lng,35];
      7: Result := Result + NumWords[Lng,36];
      8: Result := Result + NumWords[Lng,37];
      9: Result := Result + NumWords[Lng,38];
    end
  end;

  procedure Num00;
  begin
    Num100(TValue div 100);
    TValue := TValue mod 100;
    if TValue < 20 then
      Num(TValue)
    else begin
      Num10(TValue div 10);
      TValue := TValue mod 10;
      Num(TValue);
    end;
  end;

  procedure NumMult(Mult: int64; s1, s2, s3: string);
  var ValueRes: int64;
  begin
    if AValue >= Mult then
    begin
      TValue := AValue div Mult;
      ValueRes := TValue;
      Num00;
      if TValue = 1 then
        Result := Result + s1
      else if TValue in [1..4] then
        Result := Result + s2
      else
        Result := Result + s3;
      AValue := AValue - Mult * ValueRes;
    end;
  end;
begin
  if (AValue = 0) then
    Result := NumWords[Lng,0]
  else begin
    Result := '';
    Decline := true;
    NumMult(1000000000000, NumWords[Lng,48], NumWords[Lng,49], NumWords[Lng,50]);
    NumMult(1000000000, NumWords[Lng,45], NumWords[Lng,46], NumWords[Lng,47]);
    NumMult(1000000, NumWords[Lng,42], NumWords[Lng,43], NumWords[Lng,44]);
    Decline := false;
    NumMult(1000, NumWords[Lng,39], NumWords[Lng,40], NumWords[Lng,41]);
    Decline := true;
    TValue := AValue;
    Num00;
  end;
end;

function ToMoney(Value : Double) : Double;
var e, f : Extended;
    i : integer;
begin
  if Value >= 0 then
  begin
    f := Value*100;
    Result := Trunc(f);
    e := f - Result;
    e := Round(e*1e9);
    i := Trunc((e/1e8)+1e-9);
    if i >= 5 then
      Result := Result + 1;
  end
  else begin
    f := -Value*100;
    Result := Trunc(f);
    e := f - Result;
    e := Round(e*1e9);
    i := Trunc((e/1e8)+1e-9);

    if i >= 5 then
      Result := Result + 1;

    Result := -Result;
  end;
  Result := Result / 100;
end;

function EqualMoney(const a, b : Double) : Boolean;
var f : Double;
begin
  f := a - b;
  f := Abs(f);
  Result := EqualDouble(ToMoney(f),  0.00);
end;

function EqualDouble(const a, b : Double) : Boolean;
var f : Double;
begin
  f := a - b;
  f := Abs(f);
  Result := (f < 1e-6);
end;

function S2D(Value : string) : Double;
var i, n : Integer;
    L : Boolean;
begin
  Result := 0;
  n := Length(Value);
  if n = 0 then Exit;
  L := False;
  for i := n downto 0 do
  begin
    if (not L) and (Value[i] in [',','.']) then
    begin
      Value[i] := DecimalSeparator;
      L := True;
    end
    else if Value[i] in [',','.',' '] then
      Value[i] := ThousandSeparator;
  end;
  Value := StringReplace(Value, ThousandSeparator, '',  [rfReplaceAll]);
  Result := StrToFloatDef(Value,0);
end;

function V2I(const Value : Variant) : Integer;
var s :string;
begin
  if VarIsOrdinal(Value)  then
    Result := Value
  else if VarIsFloat(Value) then
    Result := Trunc(Value)
  else if VarIsStr(Value) then
  begin
    s := VarToStr(Value);
    Result := StrToIntDef(s,0);
  end
  else
    Result := 0;
end;

function V2C(const Value : Variant) : Int64;
var s :string;
begin
  if VarIsOrdinal(Value)  then
    Result := Value
  else if VarIsFloat(Value) then
    Result := Trunc(Value)
  else if VarIsStr(Value) then
  begin
    s := VarToStr(Value);
    Result := StrToIntDef(s,0);
  end
  else
    Result := 0;
end;

function V2D(const Value : Variant) : Double;
var s :string;
begin
  if VarIsOrdinal(Value)  then
    Result := Value
  else if VarIsFloat(Value) then
    Result := Value
  else if VarIsStr(Value) then
  begin
    s := VarToStr(Value);
    Result := S2D(s);
  end
  else
    Result := 0;
end;

function V2Dt(const Value : Variant) : TDateTime;
begin
  if VarIsNull(Value) then
    Result := 0
  else if VarIsNumeric(Value) then
    Result := TDateTime(V2D(Value))
  else
    Result := S2DT(Trim(VarToStr(Value)));
end;

function I2V(const Value : integer) : Variant;
begin
  if Value = 0 then
    Result := Null
  else
    Result := Value;
end;

function C2V(const Value : Int64) : Variant;
begin
  if Value = 0 then
    Result := Null
  else
    Result := Value;
end;

function D2V(const Value : Double) : Variant;
begin
  if Value = 0 then
    Result := Null
  else
    Result := Value;
end;

function S2V(const Value : String) : Variant;
begin
  if (Value = '') or (Trim(Value) = '') then
    Result := Null
  else
    Result := Trim(Value);
end;

function StringToArray(Value: string; aMode : Integer = 0): Variant;  //преобразует в постгресовский массив
var n : Integer;
begin
  if aMode = 1 then
    Result := '{}'
  else
    Result := null;
  n := Length(Value);
  if n > 0 then
  begin
    if n > 1 then
    begin
      if Value[1] = ',' then
        Value[1] := '{';
      if Value[n] = ',' then
        Value[n] := '}';

      if  (Value[1] = '{') and (Value[n] = '}') then
        Result := Value
      else if (Value[1] = '{')  then
        Result := Value + '}'
      else if (Value[n] = '}') then
        Result := '{'+Value
      else
        Result := '{'+Value+'}';
    end
    else if not (Value[1] in ['{', '}', ',', '.']) then
      Result := '{'+Value+'}';
  end;
end;

function IdInSet(const AId : Integer; const ASet : string) : Boolean;
var i, j, n : integer;
    s : string;
begin
  Result := False;
  n := Length(ASet);
  i := 1;
  while i <= n do
  begin
    while (i <= n) and not (ASet[i] in ['0'..'9']) do Inc(i);
    j := i;
    while (i <= n) and (ASet[i] in ['0'..'9']) do Inc(i);
    if (i>j) then
    begin
      s := Copy(ASet, j, i-j);
      if AId = StrToIntDef(s, 0) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;

function NextIdInSet(const ASet : string; var Spos : integer) : integer;
var j, n : integer;
    s : string;
begin
  Result := 0;
  n := Length(ASet);
  while Spos <= n do
  begin
    while (Spos <= n) and not (ASet[SPos] in ['0'..'9']) do Inc(Spos);
    j := Spos;
    while (Spos <= n) and (ASet[SPos] in ['0'..'9']) do Inc(Spos);
    if (Spos>j) then
    begin
      s := Copy(ASet, j, Spos-j);
      Result := StrToIntDef(s, 0);
      Exit;
    end;
  end;
end;

function FirstIdInSet(const ASet : string) : integer;
var i : integer;
begin
  i := 1;
  Result := NextIdInSet(ASet, i);
end;

function FindLetter(const AValue: String): Boolean;
var n : Integer;
begin
  Result := False;
  n      := Length(AValue);
  while (not Result) and (n > 0) do
  begin
    Result := not (AValue[n] in ['0'..'9']);
    Dec(n);
  end;
end;

function GetNumberStr(const AValue : string) : string;
var i, n : Integer;
begin
  Result := AValue;
  n := Length(Result);
  for i := 1 to n do
  begin
    if not (Result[i] in ['0'..'9','.',',','+','-']) then
      Result[i] := ' ';
  end;
  Result := Trim(Result);
  i := 1;
  while i > 0 do
  begin
    i := PosEx('  ', Result, i);
    if i > 0 then
      Delete(Result,i,1);
  end;
  i := PosEx(' ', Result, 1);
  if i > 0 then
    SetLength(Result, i-1);
end;

function CreateDefaultDays(const ADays : Integer) : String;
var i : Integer;
    OldC : Char;
begin
  OldC := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Result := '{';
    for i := 1 to ADays do
      Result := Result + Format('%.2f,',[fDR]);
    i := Length(Result);
    Result[i] := '}';
  finally
    DecimalSeparator := OldC;
  end;
end;

function GetHoursInDays(const AStr : string; ADay : integer = 0) : Double;
var i,j,n : Integer;
begin
  Result := 0;
  if AStr = '' then Exit;
  if ADay = 0 then
  begin

  end
  else if (ADay < 1) then
    raise Exception.CreateFmt(MSG_NO_DAY,[ADay])
  else begin
    n := Length(AStr);
    i := 1;
    while (i<n) and (ADay > 0) do
    begin
      if AStr[i] in ['{',',','}'] then
        Dec(ADay);
      Inc(i);
    end;
    if ADay > 0 then
      raise Exception.CreateFmt(MSG_NO_DAY,[ADay]);
    j := i;
    while (j<n) and not (AStr[j] in ['{',',','}']) do Inc(j);
    Result := S2D(Copy(AStr,i,j-i));
  end;
end;

function SetHoursInDays(AStr : string; ADay : integer; AHour : Double) : string;
var s : string;
    i,j,n : Integer;
    OldC : Char;
begin
  if (ADay < 1) then
    raise Exception.CreateFmt(MSG_NO_DAY,[ADay]);
  s := AStr;
  if s = '' then
    s := CreateDefaultDays(31);
  n := Length(s);
  i := 1;
  while (i<n) and (ADay > 0) do
  begin
    if s[i] in ['{',',','}'] then
      Dec(ADay);
    Inc(i);
  end;
  if ADay > 0 then
    raise Exception.CreateFmt(MSG_NO_DAY,[ADay]);
  j := i;
  while (j<n) and not (s[j] in ['{',',','}']) do Inc(j);
  Delete(s,i,j-i);
  OldC := DecimalSeparator;
  DecimalSeparator := '.';
  try
    Insert(Format('%.2f',[AHour]), s, i);
  finally
    DecimalSeparator := OldC;
  end;
  Result := s;
end;

procedure GetDaysAndHours(AStr : string; var ADays : integer; var AHour : Double);
var i,j,n : Integer;
    h : Double;
begin
  ADays := 0;
  AHour := 0;
  if AStr <> '' then
  begin
    n := Length(AStr);
    i := 2;
    while i < n do
    begin
      j := i;
      while (j<n) and not (AStr[j] in ['{',',','}']) do Inc(j);
      h := S2D(Copy(AStr,i,j-i));
      if h > 0 then
      begin
        Inc(ADays);
        AHour := AHour+ h;
      end;
      Inc(i);
    end;
  end;
end;

function DecodeString(const Value, Pass: string): string;
var LValue, LPass,  // length input string
    cn : integer;
    k,l : Byte;     // ord values string char
    s : string;
begin
  LValue := Length(Value);
  LPass  := Length(Pass);
  cn := 1;
  Result := '';
  while cn <= LValue do
  begin
    s := '$'+copy(Value,cn,2);
    k := StrToInt(s);
    l := Ord(Pass[((cn div 2) mod LPass)+1]);
    k := k xor l;
    Result := Result + chr(k);
    Inc(cn,2);
  end;
end;

function EncodeString(const Value, Pass: string): string;
var LValue, LPass,  // length input string
    cn : integer;
    k,l : Byte;     // ord values string char
begin
  Result := '';
  LValue := Length(Value);
  LPass  := Length(Pass);
  for cn := 1 To LValue do
  begin
    k := Ord(Value[cn]);
    l := Ord(Pass[((cn-1) mod LPass)+1]);
    k := k xor l;
    Result := Format('%s%.2x',[Result, k]);
  end;
end;

function GetLongPathName(lpszShortName: LPCTSTR; lpszLongName: LPTSTR;
    cchBuffer: DWORD): DWORD; stdcall; external kernel32 name 'GetLongPathNameA';

function GetTempDir : string;
var Buffer: array[0..MAX_PATH] of Char;
    len : integer;
begin
  len := GetTempPath(SizeOf(Buffer) - 1, Buffer);
  if Len > 0 then
  begin
    Result := StrPas(Buffer);
    len := GetLongPathName(PChar(Result), Buffer, MAX_PATH);
    if len > 0  then
      Result := StrPas(Buffer);
  end;
  if len = 0 then
    Result := '';
end;

function CheckDir(ADir : string; AClear : Boolean = False) : Boolean;
begin
  Result := DirectoryExists(ADir);
  if not Result then
    Result := CreateDir(ADir)
  else begin
    if AClear then
      Result := WinDelFile(ADir+'*.*');
  end;
end;

function NumberText(AValue : Extended; Lng : Byte = 0; ValId : Integer = 980) : string;
type
  TValRec = record
    code : Integer;
    gndr, lng : byte;
    s1, s2 : array[1..3] of string[12];
    s3 : string[3];
  end;

const
  RecCount = 8;
  ValRecs : array[1..RecCount] of TValRec =
    ((code : 980; gndr : 1; lng : 0;
      s1 : ('грн.','грн.','грн.');
      s2 : ('коп.','коп.','коп.');
      s3 : ''),
     (code : 980; gndr : 1; lng : 1;
      s1 : ('грн.','грн.','грн.');
      s2 : ('коп.','коп.','коп.');
      s3 : ''),
     (code : 840; gndr : 0; lng : 0;
      s1 : ('дол. США','дол. США','дол. США');
      s2 : ('цент','цента','центов');
      s3 : 'и'),
     (code : 840; gndr : 0; lng : 1;
      s1 : ('дол. США','дол. США','дол. США');
      s2 : ('цент','цента','центів');
      s3 : 'та'),
     (code : 840; gndr : 0; lng : 2;
      s1 : ('dollars USA','dollars USA','dollars USA');
      s2 : ('cent','cent','cents');
      s3 : 'and'),
     (code : 978; gndr : 0; lng : 0;
      s1 : ('евро','евро','евро');
      s2 : ('цент','цента','центов');
      s3 : 'и'),
     (code : 978; gndr : 0; lng : 1;
      s1 : ('евро','евро','евро');
      s2 : ('цент','цента','центів');
      s3 : 'та'),
     (code : 978; gndr : 0; lng : 2;
      s1 : ('EURO','EURO','EURO');
      s2 : ('cent','cent','cents');
      s3 : 'and')
    );

var ValRec : TValRec;
    i, j : Integer;
    Found : boolean;

    A : int64;
    B : Integer;
begin
  Found := False;
  Result := '';
  for i := 1 to RecCount do
    if (ValRecs[i].code = ValId) and (ValRecs[i].lng = Lng) then
    begin
      Found := True;
      ValRec := ValRecs[i];
      Break;
    end;
  if not Found then Exit;
  A := Trunc(AValue);
  B := Round((AValue - A)*100);
  Result := NumberWords(A, Lng, ValRec.gndr);
  i := A mod 100;
  j := A mod 10;
  if (i in [11..20]) then
    Result := Result + ValRec.s1[3]
  else
    case j  of
      1:    Result := Result + ValRec.s1[1];
      2..4: Result := Result + ValRec.s1[2];
      else  Result := Result + ValRec.s1[3];
    end;
  Result := Result + ' ' + ValRec.s3 + ' ';
  Result := Result + Format('%.2d ',[B]);
  i := B mod 100;
  j := B mod 10;
  if (i in [11..20]) then
    Result := Result + ValRec.s2[3]
  else
    case j  of
      1:    Result := Result + ValRec.s2[1];
      2..4: Result := Result + ValRec.s2[2];
      else  Result := Result + ValRec.s2[3];
    end;
end;

function LName(const AValue : string) : string;
var i : Integer;
begin
  Result := AValue;
  if Result = '' then Exit;
  i := PosEx(' ',AValue);
  if i = 0 then
    i := PosEx(Chr(160), AValue);
  if i = 0 then Exit;

  Result := Copy(AValue,i+1,255)+' '+Copy(AValue,1,i-1);
end;

function FIO(Value: string): TFioRec;
var i,j,l : Integer;
begin
  if Value = '' then Exit;
  l := Length(Value);
  i := 1;
  while (i<=l) and (Value[i] in [' ','.', Chr(160)]) do
    inc(i);
  j := i;
  while (i<=l) and not (Value[i] in [' ', '.', Chr(160)]) do
    inc(i);
  if (i<=l) and (Value[i] = '.') then
    Inc(i);
  Result.f := Copy(Value, j, i-j);
  while (i<=l) and (Value[i] in [' ','.', Chr(160)]) do
    inc(i);
  j := i;
  while (i<=l) and not (Value[i] in [' ', '.', Chr(160)]) do
    inc(i);
  if (i<=l) and (Value[i] = '.') then
    Inc(i);
  Result.i := Copy(Value, j, i-j);
  while (i<=l) and (Value[i] in [' ','.', Chr(160)]) do
    inc(i);
  Result.o := Copy(Value, i, l-i+1);
end;

function NameCase(const AText: string; const AType: Integer = 1) : string;
begin
  Result := AText;
  if AText <> '' then
    with FIO(AText) do
    begin
      case AType of
        0: begin
          Result := AnsiUpperCase(f[1]) + AnsiLowerCase(Copy(f,2,255)) + ' ' +
                    AnsiUpperCase(i[1]) + AnsiLowerCase(Copy(i,2,255)) + ' ' +
                    AnsiUpperCase(o[1]) + AnsiLowerCase(Copy(o,2,255));
        end;
        1: begin
          Result := AnsiUpperCase(f[1]) + AnsiLowerCase(Copy(f,2,255)) + Chr(160) +
                    AnsiUpperCase(i[1]) + '.' +
                    AnsiUpperCase(o[1]) + '.';
        end;
        2: begin
          Result := AnsiUpperCase(i[1]) + '.' +
                    AnsiUpperCase(o[1]) + '.' + Chr(160) +
                    AnsiUpperCase(f[1]) + AnsiLowerCase(Copy(f,2,255));
        end;
        3: begin
          Result := AnsiUpperCase(f) + ' ' +
                    AnsiUpperCase(i[1]) + AnsiLowerCase(Copy(i,2,255));
        end;
        4: begin
          Result := AnsiUpperCase(i[1]) + AnsiLowerCase(Copy(i,2,255)) + ' ' +
                    AnsiUpperCase(f);
        end;
      end;
    end;
end;

function FIO_Padeg(Value : string; CaseNum : byte; Lng : Byte = 0) : string;
{$IFDEF USE_FIO_JOB_CASE}
var TempCore : TCore;
{$ENDIF}
begin
{$IFDEF USE_FIO_JOB_CASE}
  if Lng = 0 then
    TempCore := TRuCore.Create
  else if Lng = 1 then
    TempCore := TUaCore.Create
  else begin
    Result := Value;
    Exit;
  end;
  if Assigned(ExceptionUnit.SimpleExceptList) then
    ExceptionUnit.SimpleExceptList.OnExcept := {$IFDEF USE_DM_GLOBAL}dmGlobalData.GetInDecl{$ELSE}nil{$ENDIF};

  try
    Result := TempCore.FIO(Value, TPadeg(CaseNum-1));
  finally
    TempCore.Free;
  end;
{$ELSE}
  Result := Value;
{$ENDIF}
end;

function Job_Padeg(Value : string; CaseNum : byte; Lng : Byte = 0) : string;
begin
{$IFDEF USE_FIO_JOB_CASE}

  if Assigned(ExceptionUnit.SimpleExceptList) then
    ExceptionUnit.SimpleExceptList.OnExcept := {$IFDEF USE_DM_GLOBAL}dmGlobalData.GetInDecl{$ELSE}nil{$ENDIF};
  if Lng = 1 then
  begin
    JobUaUnit.LoadExceptList;
    Result := JobUaUnit.ToJob(Value,'','м', CaseNum, 'UA' );
  end
  else begin
    JobRuUnit.LoadExceptList;
    with JobRuUnit.TDeclExt.Create do
    try
      Result := getOffice(Value,CaseNum);
    finally
      Free;
    end;
  end;
{$ELSE}
  Result := Value;
{$ENDIF}
end;

function S2Dt(const Value: String): TDateTime;
var Y,M,D, n : Word;
    Error : Boolean;
begin
  n := Length(Value);
  Error := False;
  Y := 0; M := 0; D := 0;
  if n = 6 then
  begin
    Y := StrToIntDef(Copy(Value,1,4),0);
    M := StrToIntDef(Copy(Value,5,2),0);
    D := 1;
    if (Y < 1978) or not (M in [1..12]) then
    begin
      M := StrToIntDef(Copy(Value,1,2),0);
      Y := StrToIntDef(Copy(Value,3,4),0);
      if (Y < 1978) or not (M in [1..12]) then
        Error := True;
    end;
  end
  else if n= 8 then
  begin
    //YYYYMMDD
    Y := StrToIntDef(Copy(Value,1,4),0);
    M := StrToIntDef(Copy(Value,5,2),0);
    D := StrToIntDef(Copy(Value,7,2),0);
    if not (M in [1..12]) or not (D in [1..31]) then
    begin
      //DDMMYYYY
      D := StrToIntDef(Copy(Value,1,2),0);
      M := StrToIntDef(Copy(Value,3,2),0);
      Y := StrToIntDef(Copy(Value,5,4),0);
      if not (M in [1..12]) or not (D in [1..31]) or (Y = 0) then
      begin
        //DD.MM.YY
        D := StrToIntDef(Copy(Value,1,2),0);
        M := StrToIntDef(Copy(Value,4,2),0);
        Y := StrToIntDef(Copy(Value,7,2),0);
        if not (M in [1..12]) or not (D in [1..31]) or (Y = 0) then
          Error := True
        else if Y >  80 then
          Y := 1900 + Y
        else
          Y := Y + 2000;
      end;
    end;
  end
  else if n = 10 then
  begin
    D := StrToIntDef(Copy(Value,1,2),0);
    M := StrToIntDef(Copy(Value,4,2),0);
    Y := StrToIntDef(Copy(Value,7,4),0);
    if (Y < 1978) or not (M in [1..12]) or not (D in [1..31]) then
    begin
      Y := StrToIntDef(Copy(Value,1,4),0);
      M := StrToIntDef(Copy(Value,6,2),0);
      D := StrToIntDef(Copy(Value,9,2),0);
      if (Y < 1978) or not (M in [1..12]) or not (D in [1..31]) then
        Error := True;
    end;
  end
  else Error := True;
  if Error then
    raise Exception.CreateFmt('Wrong date %s', [Value]);
  Result := EncodeDate(Y,M,D);
end;

function WinDelFile(const AFile: string) : boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  From : array [0..255] of Char;
  s : string;
begin
  //Exit;
  s := AFile;
  FillMemory(@From[0], 256, 0);
  CopyMemory(@From[0], @s[1], Length(s));
  with SHFileOpStruct do
  begin
    Wnd                   := GetActiveWindow;
    wFunc                 := FO_DELETE;
    pFrom                 := @From[0];
    pTo                   := nil;
    fFlags                := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
    fAnyOperationsAborted := False;
    hNameMappings         := nil;
    lpszProgressTitle     := nil;
  end;
  Result := (SHFileOperation(SHFileOpStruct) = 0);
end;

function WinCopyFile(const AFrom, ATo: String): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  CFrom, CTo : array [0..255] of Char;
begin
  //Exit;
  FillMemory(@CFrom[0], 256, 0);
  CopyMemory(@CFrom[0], @AFrom[1], Length(AFrom));
  FillMemory(@CTo[0], 256, 0);
  CopyMemory(@CTo[0], @ATo[1], Length(ATo));
  with SHFileOpStruct do
  begin
    Wnd                   := GetActiveWindow;
    wFunc                 := FO_COPY;
    pFrom                 := @CFrom[0];
    pTo                   := @CTo[0];
    fFlags                := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR;
    fAnyOperationsAborted := False;
    hNameMappings         := nil;
    lpszProgressTitle     := nil;
  end;
  Result := (SHFileOperation(SHFileOpStruct) = 0);
end;

function DosStrToWin(Value : string) : string;
var j, n : Integer;
begin
  Result := Value;
  n := Length(Result);
  for j := 1 to n do
  begin
    if Result[j] = chr($49) then
      Result[j] := chr($B2)
    else if Result[j] = chr($69) then
      Result[j] := Chr($B3);
  end;
end;

function WinStrToDos(Value : string) : string;
var j, n : Integer;
begin
  Result := Value;
  n := Length(Result);
  for j := 1 to n do
  begin
    if Result[j] = chr($B2) then
      Result[j] := chr($49)
    else if Result[j] = Chr($B3) then
      Result[j] := chr($69);
  end;
end;

function PGDateToStr(const dt: TDateTime): string;
var Y,M,D : Word;
begin
  DecodeDate(dt,Y,M,D);
  Result := Format('%.4d.%.2d.%.2d',[Y,M,D]);
end;

function StrListToPGArray(aMas : TStringList) : string;
var i : Integer;
    s : string;
begin
  Result := '';
  s := '';
  for i := 0 to (aMas.Count-1) do
  begin
    s := s+aMas[i] + ',';
  end;
  
  i := Length(s);
  if i > 0 then
  begin
    s[i] := '}';
    Result := '{'+s;
  end;
end;

function IntArrayToPGArray(aMas : array of Integer) : string;
var i : Integer;
    s : string;
begin
  Result := '';
  s := '';
  for i := Low(aMas) to High(aMas) do
  begin
    s := s+IntToStr(aMas[i]) + ',';
  end;
  i := Length(s);
  if i > 0 then
  begin
    s[i] := '}';
    Result := '{'+s;
  end;
end;

function PGArrayToArray(Value: string; N : integer): Variant;
var i,j,k,l  : Integer;
    s : string;
begin
  Result := Null;
  //SetLength(Result, 0);
  k := Length(Value);

  if N = 0 then
    N :=  PGArrayCount(Value);

  if (N = 0) then Exit;

  Result := VarArrayCreate([1, N], varVariant);
  //SetLength(Result, N);
  if (k <= 2) then Exit;

  i := 2; l := 0;
  while (i < k) and (l < N) do
  begin
    j := i;
    while (i<=k) and not (Value[i] in [',', '}']) do Inc(i);
    s := Copy(Value,j, i - j);
    Inc(l);
    if s = 'NULL' then
      Result[l] := null
    else
      Result[l] := s;
    Inc(i);
  end;
end;

function PGArrayCount(Value: string) : Integer;
var i,k  : Integer;
begin
  Result := 0;

  k := Length(Value);

  if (k <= 2) then Exit;

  i := 2;
  while (i < k) do
  begin
    while (i<=k) and not (Value[i] in [',', '}']) do Inc(i);
    Inc(Result);
    Inc(i);
  end;
end;

function VarArrayToPGArray(aMas : Variant) : string;
var i,n : Integer;
   OldDecimalSeparator : Char;
begin
  Result := '{}';
  if not VarIsArray(aMas) then Exit;
  n := VarArrayHighBound(aMas, 1);
  i := VarArrayLowBound(aMas, 1);

  if (i <= n) then
  begin
    Result := '{';
    OldDecimalSeparator := DecimalSeparator;
    DecimalSeparator := '.';
    try
      while i <= n do
      begin
        Result := Result + VarToStr(aMas[i]);
        if i < n then
          Result := Result + ',';
        inc(i);
      end;
      Result := Result + '}';
    finally
      DecimalSeparator := OldDecimalSeparator;
    end;
  end;
end;

function TextIsNumeric(aText: String): Boolean;
var n : Integer;
begin
  Result := True;
  n := Length(aText);
  while Result and (n>0) do
  begin
    Result := (aText[n] in ['0'..'9']);
    Dec(n);
  end;
end;

function RomanNumerals(aValue: Integer): string;
begin
  case aValue of
    1 : Result := 'I';
    2 : Result := 'II';
    3 : Result := 'III';
    4 : Result := 'IV';
  else
    Result := '';
  end;
end;

end.
