unit ValueListUnit;

interface
uses Classes, SysUtils;
type
  TValueList = class(TStringList)
  public
    procedure SetValue(AKey : string; Value : TObject);
    function  GetValueByKey(AKey: String): TObject;
    function  FindKey(AKey : String) : Integer;
  end;


  procedure FreeExceptList(Value : TValueList);
  function  LoadExceptList(FileName : string) : TValueList;
implementation

{ TValueList }

function TValueList.FindKey(AKey: String): Integer;
begin
  Result := IndexOf(AKey)+1;
end;

function TValueList.GetValueByKey(AKey: String): TObject;
var i: integer;
begin
  i := IndexOf(AKey);
  if i >= 0 then
    Result := Self.Objects[i]
  else
    Result := nil;
end;

procedure TValueList.SetValue(AKey: string; Value: TObject);
var i: integer;
begin
  i := IndexOf(AKey);
  if i >= 0 then
    Objects[i] := Value
  else
	  AddObject(AKey, Value);
end;

procedure FreeExceptList(Value : TValueList);
var i : integer;
    Item : TValueList;
begin
  if Assigned(Value) then
  begin
    for i := 0 to Value.Count - 1 do
    begin
      Item := TValueList(Value.Objects[i]);
      if Assigned(Item) then
        Item.Free;
    end;
    Value.Clear;
    Value.Free;
    //Value := nil;
  end;
end;

function LoadExceptList(FileName : string) : TValueList;
var F : TextFile;
    //i : Integer;
    Item : TValueList;
    s : string;

	//n,
  //k,
  pCom: Integer;

  sec: String;

begin
  Item := nil;
  Result := TValueList.Create;
  if not FileExists(FileName) then Exit;
	AssignFile(F, FileName);
  Reset(F);
  while not Eof(F) do
  begin
    Readln(f,s);
		pCom := Pos(';', s);
		If pCom > 0 then begin
			s := Copy(s,1, pCom - 1);
		end;
		s := Trim(s);
    If s = '' then
    	Continue;
		if (Copy(s,1,1) = '[') and (Copy(s, Length(s),  1) = ']') then
    begin
			sec := Copy(s, 2, Length(s) - 2);
			If Trim(sec) = '' then begin
				Continue;
			end;
			Item := TValueList.Create;
			Result.AddObject(sec, Item);
			Continue;
		end;
		If Trim(sec) = '' then begin
			Continue;
		end;
    if Assigned(Item) then
  		Item.Add(AnsiLowerCase(s));
	end;
end;

end.
