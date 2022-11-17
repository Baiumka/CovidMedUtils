unit ExceptionUnit;

interface
uses Classes;

type
  TExceptionFunc = function(const Value : string; Lng : integer) : string of object;

  TExceptionList = class(TStringList)
  public
    OnExcept : TExceptionFunc;
    function CheckWord(const Value : string; Lng, Pages : integer) : Boolean;
  end;

var
   SimpleExceptList : TExceptionList;
implementation

uses SysUtils;

{ TExceptionList }

function TExceptionList.CheckWord(const Value: string; Lng,
  Pages: integer): Boolean;
var s, s1 : string;
    i, j, n : Integer;
begin
  Result := False;
  Clear;
  if Assigned(Self.OnExcept) then
  begin
    s := Self.OnExcept(AnsiLowerCase(Value), Lng);
    Result := (s <> '');
    if Result then
    begin
      Self.Clear;
      n := length(s);
      i := 1;
      while i <= n do
      begin
        while (i <= n) and (s[i] = ';') do Inc(i);
        j:= i;
        while (j <=n) and (s[j] <> ';') do Inc(j);
        s1 := Copy(s, i, j-i);
        if s1 <> '' then
          Self.Add(s1);
        i := j
      end;  
    end;
  end;
end;

initialization
  SimpleExceptList := TExceptionList.Create;
finalization
  FreeAndNil(SimpleExceptList);
end.
