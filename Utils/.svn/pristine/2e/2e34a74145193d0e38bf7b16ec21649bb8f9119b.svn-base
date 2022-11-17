unit SyllableUnit;

interface
uses Classes, Windows, SysUtils;
const
  vocalic = 'àîóûýÿå¸þè';
  legalChar = 'àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';


type
  TLocals = record
    i, j, nSyllable : integer;
    outStr : string;
    vocalicExist : boolean;
  end;

  TSyllable = class
  private
    function sonic(index : char) : char;
  public
    class function countSyllable( anyWord : string) : integer;
  private
    function isLegalChar(ch : char) : boolean;
  public
    function strToSonic( value : string) : string ;
  private
    procedure setCut(var l : TLocals); overload;
    procedure copyChar( anyWord : string; inStrL : string; var l : TLocals); overload;
  public
    class function divideOnSyllable( anyWord : String) : string;
  private
    function divideOnSyllableOld( anyWord : String) : string;
  private
    i,
    j,
    nSyllable : integer;

    outStr : string;
    vocalicExist : Boolean;
    inString : string;
    lowChars : string;
    procedure InitClass;
  private
    procedure setCut(); overload;
    procedure copyChar(); overload;
  public
    function divideOnSyllableInt(anyWord : string) : string;
  end;

implementation

function TSyllable.sonic(index : char) : char;
const sSonic = '31111311321222312113111111^3^333';
var i : byte;
begin
  i := Ord(index) - ord('à');
  Result := sSonic[I+1];
end;

class function TSyllable.countSyllable( anyWord : string) : integer;
var i : integer;
begin
  result := 0;
  anyWord := AnsilowerCase(anyWord);
  for i := 1 to length(anyWord) do
    if (Pos(anyWord[i], vocalic) > 0) then
      inc(result);
end;

function TSyllable.isLegalChar(ch : char) : boolean;
begin
  result := (Pos(ch,legalChar) > 0);
end;

function TSyllable.strToSonic( value : string) : string ;
var i : integer;
    ch : char;
begin
  result := '';
  value := AnsiLowerCase(value);
  for i:=1 to length(value) do
  begin
    ch := value[i];
    if ch = '¸' then
      ch := 'å';
    if (isLegalChar(ch)) then
    begin
      ch := sonic(ch);
      if (ch <> '^') then
        result := result + ch;
    end;
  end;
end;

procedure TSyllable.setCut(var l : TLocals);
begin
  if (l.nSyllable > 0) and (l.vocalicExist) and
     ((l.outStr = '') or (l.outStr[length(l.outStr)] <> '-')) then
  begin
    l.outStr := l.outStr + '-';
    dec(l.nSyllable);
    inc(l.i);
    l.vocalicExist := false;
  end;
end;

procedure TSyllable.copyChar( anyWord : string; inStrL : string; var l : TLocals);
begin
  if (l.j >= length(anyWord)) then Exit;

  l.outStr := l.outStr + anyWord[l.j];
  if (Pos(inStrL[l.j], vocalic) > 0) then
    l.vocalicExist := true;
  inc(l.j);
  if ((l.j < length(inStrL)) and (Pos(inStrL[l.j], 'úü') > 0)) then
    copyChar(anyWord, inStrL, l);
end;

class function TSyllable.divideOnSyllable( anyWord : String) : string;
var t : TSyllable;
begin
  t := TSyllable.Create;
  t.InitClass;
  result := t.divideOnSyllableInt(anyWord);
  t.Free;
end;

procedure TSyllable.InitClass;
begin
  i := 0;
  j := 0;
  nSyllable := 0;

  outStr := '';
  vocalicExist := False;
  inString := '';
  lowChars := '';
end;

function TSyllable.divideOnSyllableOld( anyWord : String) : string;
var l : TLocals;
    separator : integer;
    inStrL, sonicStr : string;
begin
  separator := Pos('-', anyWord);
  if (separator > 0) then
  begin
    result := divideOnSyllable(Copy(anyWord, separator + 1, length(anyWord)));
    result := divideOnSyllable(Copy(anyWord,1, separator)) + '--' + result;
    exit;
  end;

  l.vocalicExist := false;
  l.nSyllable := countSyllable(anyWord);
  if (l.nSyllable > 1) then
  begin
    dec(l.nSyllable);
    inStrL := AnsiLowerCase(anyWord);

    sonicStr := strToSonic(anyWord);

    l.i := 1;
    l.j := 1;
    repeat
      if (sonicStr[l.i] < sonicStr[(l.i + 1)]) then
      begin
        copyChar(anyWord, inStrL, l);
        inc(l.i);
      end
      else if (sonicStr[l.i] = sonicStr[(l.i + 1)]) then
      begin
        case (sonicStr[l.i]) of
          '1': begin
            if (l.i = 0) then
            begin
              copyChar(anyWord, inStrL, l);
              inc(l.i);
            end
            else if (inStrL[l.j] = inStrL[(l.j + 1)]) then
            begin
              copyChar(anyWord, inStrL, l);
              setCut(l);
            end
            else if (l.vocalicExist) then
            begin
              setCut(l);
              copyChar(anyWord, inStrL, l);
            end
            else begin
              copyChar(anyWord, inStrL, l);
              inc(l.i);
            end;
          end;
          '2': begin
            if (sonicStr[(l.i + 1)] < sonicStr[(l.i + 2)]) then
            begin
              copyChar(anyWord, inStrL, l);
              setCut(l);
            end
            else
              inc(l.i);
          end;
          '3': begin
           copyChar(anyWord, inStrL, l);
           setCut(l);
          end;
        end;
      end
      else if (sonicStr[l.i] > sonicStr[(l.i + 1)]) then
      begin
        copyChar(anyWord, inStrL, l);
        if (inStrL[l.j] = 'é') then
        begin
          copyChar(anyWord, inStrL, l);
          setCut(l);
          inc(l.i);
        end
        else if (sonicStr[(l.i + 1)] > sonicStr[(l.i + 2)]) then
        begin
          inc(l.i);
        end
        else if (sonicStr[(l.i + 1)] < sonicStr[(l.i + 2)]) then
        begin
          if ((inStrL[(l.j + 1)] = 'ü') and (l.j > 2) and (Pos(inStrL[(l.j + 2)], vocalic) = 0) and (sonicStr[(l.i + 1)] <> '1')) then
          begin
            copyChar(anyWord, inStrL, l);
            setCut(l);
            inc(l.i);
          end
          else if (l.vocalicExist) then
            setCut(l)
          else
            inc(l.i);
        end
        else
          inc(l.i);
      end;
      if (not isLegalChar(inStrL[l.j])) then
        copyChar(anyWord, inStrL, l);
    until (l.nSyllable <= 0);
    l.i := l.j;
    while l.i < length(inStrL) do
    begin
      copyChar(anyWord, inStrL, l);
      inc(l.i);
    end;
    result := l.outStr;
  end
  else
    result := anyWord;
end;

procedure TSyllable.setCut();
begin
  if ((self.nSyllable > 0) and (self.vocalicExist) and
     ((self.outStr = '') or (self.outStr[Length(Self.outStr)] <> '-')))
  then begin
    self.outStr := Self.outStr + '-';
    dec(self.nSyllable);
    inc(self.i);
    self.vocalicExist := false;
  end;
end;

procedure TSyllable.copyChar();
begin
  if (self.j >= length(self.inString)) then exit;

  self.outStr := self.outStr + self.inString[self.j];
  if (Pos(self.lowChars[self.j], vocalic) > 0) then
    self.vocalicExist := true;
  inc(self.j);
  if ((self.j < length(self.lowChars)) and (Pos(self.lowChars[self.j], 'úü') > 0)) then
  begin
    self.outStr := self.outStr + self.inString[self.j];
    inc(self.j);
  end;
end;

function TSyllable.divideOnSyllableInt(anyWord : string) : string;
var separator : integer;
    sonicChars : string;
begin
  separator := Pos('-', anyWord);
  if (separator > 0) then
  begin
    result := divideOnSyllableInt(copy(anyWord,separator + 1, length(anyWord)));
    result := divideOnSyllableInt(Copy(anyWord,1, separator)) + '--' + result;
    exit;
  end;
  self.nSyllable := countSyllable(anyWord);
  if (self.nSyllable > 1) then
  begin
    dec(self.nSyllable);
    self.vocalicExist := false;
    self.inString := anyWord;
    self.lowChars := AnsiLowerCase(anyWord);
    sonicChars := strToSonic(anyWord);

    self.i := 1;
    self.j := 1;
    repeat
      if (sonicChars[self.i] < sonicChars[(self.i + 1)]) then
      begin
        copyChar();
        inc(self.i);
      end
      else if (sonicChars[self.i] = sonicChars[(self.i + 1)]) then
      begin
        case (sonicChars[self.i]) of
          '1': begin
            if (self.i = 0) then
            begin
              copyChar();
              inc(self.i);
            end
            else if (self.lowChars[self.j] = self.lowChars[(self.j + 1)]) then
            begin
              copyChar();
              setCut();
            end
            else if (self.vocalicExist) then
            begin
              setCut();
              copyChar();
            end
            else begin
              copyChar();
              inc(self.i);
            end;
          end;
          '2': begin
            if (sonicChars[(self.i + 1)] < sonicChars[(self.i + 2)]) then
            begin
              copyChar();
              setCut();
            end
            else
              inc(self.i);
          end;
          '3': begin
            copyChar();
            setCut();
          end;
        end;
      end
      else if (sonicChars[self.i] > sonicChars[(self.i + 1)]) then
      begin
        copyChar();
        if (self.lowChars[self.j] = 'é') then
        begin
          copyChar();
          setCut();
          inc(self.i);
        end
        else if (sonicChars[(self.i + 1)] > sonicChars[(self.i + 2)]) then
          inc(self.i)
        else if (sonicChars[(self.i + 1)] < sonicChars[(self.i + 2)]) then
        begin
          if ((self.lowChars[(self.j + 1)] = 'ü') and (self.j > 2) and
             (Pos(self.lowChars[(self.j + 2)], vocalic) = 0) and (sonicChars[(self.i + 1)] <> '1'))
          then begin
            copyChar();
            setCut();
            inc(self.i);
          end
          else if (self.vocalicExist) then
            setCut()
          else
            inc(self.i);
        end
        else
          inc(self.i);
      end;
      if (not isLegalChar(self.lowChars[self.j])) then
      begin
        self.outStr := self.outStr + self.inString[self.j];
        inc(self.j);
      end
    until (self.nSyllable = 0);
    if (self.j < length(self.inString)) then
      self.outStr := self.outStr + copy(self.inString,self.j, length(self.inString));
    result := self.outStr;
  end
  else
    Result := anyWord;
end;

end.
