unit JobRuUnit;

interface
uses Classes, SysUtils, ValueListUnit;

type
  TDeclExt = class
  private
     prevWord : String;
     memoTerm : boolean;
     comma : boolean;
     terminate : boolean;
     ends : array[1..7] of string;

     procedure setEndings(c1, c2, c3, c4, c5, c6 : string);
     procedure clearEndings();
     function abbreviation( s : string; num : integer) : boolean;
     function pointAbbreviation(s : String) : boolean;
     function adjective(s : string) : boolean;
     function plural(s : string) : boolean;
     function restoreWordView(ethalon, s : string) : string;
     function isOrderNumber(s : string):boolean;
     function declNumeral(s : string; padeg : integer; isSoul : boolean) : string;
     function formatChar( s : string; ch : char) : string;
     function isNumeral(s : String) : boolean;
     function formatParameter( s : String) : string;
     function processWord( anyWord : string; padeg : integer; isSoul, hyphen : boolean) : string;
     function getDeclension( s : string; padeg : integer; isSoul : boolean) : string;
  public
     function getAppointment( s : String; padeg : integer) : string;
     function getOffice(s : String; padeg : integer) : string;
     function getOfficeList(s : string) : TStringList;
     function getFullAppointment(appointment, office : string; padeg : integer) : string;
  end;

  procedure LoadExceptList;

implementation

uses SyllableUnit, Forms, StrUtils, ExceptionUnit;

var
  ExceptList : TValueList;

procedure LoadExceptList;
var s : string;
begin
  ValueListUnit.FreeExceptList(ExceptList);
  s := ExtractFilePath(Application.ExeName) +'MainRu.dic';
  ExceptList := ValueListUnit.LoadExceptList(s);
end;

function present(Value, Key : string) : boolean;
var item : TValueList;
begin
  Result := False;
  if Assigned(ExceptList) then
  begin
    item := TValueList(ExceptList.GetValueByKey(Key));
    if Assigned(item) then
      Result := (Item.FindKey(AnsiLowerCase(Value)) > 0);
  end;
end;

function getRightPart(leftPart, section : string) : string;
var item : TValueList;
begin
  result := '';
  if Assigned(ExceptList) then
  begin
    item := TValueList(ExceptList.GetValueByKey(Section));
    if Assigned(item) then
      Result := Item.Values[AnsiLowerCase(leftPart)];
  end;
end;

{ STRUtils}

type
  TBorder = record
    left,right : integer;
  end;

  TBorderArray = array of TBorder;

function wordPosition(n : integer; s, wordDelims : string) : integer;
var count, i : integer;
begin
  count := 0;
  i := 1;
  result := -1;
  while (i < length(s)) and (count < n) do
  begin
    while ((i < length(s)) and (Pos(s[i], wordDelims) > 0)) do
      inc(i);
    if (i < length(s)) then
      inc(count);

    if (count < n) then
    begin
      while ((i < length(s)) and (Pos(s[i], wordDelims) = 0)) do
        inc(i);
    end
    else
      result := i;
  end;
end;

function extractWord(n : integer; s, wordDelims : string) : string;
var i, j : integer;
begin
  result := '';
  i := wordPosition(n, s, wordDelims);
  if (i >= 0) then
  begin
    j := i;
    while ((j < length(s)) and (Pos(s[j], wordDelims) = 0)) do
      inc(j);
    result := copy(s,i, j-i+1);
  end;
end;

function wordCount(s, wordDelims : String) : integer;
var i, len : integer;
begin
  result := 0;
  i := 1;
  len := length(s);
  while (i < len) do
  begin
    while ((i < len) and (Pos(s[i], wordDelims) > 0)) do
      inc(i);
    if (i < len) then
      inc(result);
    while ((i < len) and (Pos(s[i], wordDelims) = 0)) do
      inc(i);
  end;
end;

function countWords(s, wordDelims : string; max : integer) : TBorderArray; overload;
var i, len, n : integer;
begin
  n := 0;
  SetLength(Result, n);
  i := 1;
  len := length(s);
  while (i <= len) do
  begin
    while ((i <= len) and (Pos(s[i], wordDelims) > 0)) do
      inc(i);
    if (i <= len) then
    begin
      inc(n);
      SetLength(Result, n);
      Result[n-1].left := i;
      inc(i);
      while ((i <= len) and (Pos(s[i], wordDelims) = 0)) do
        inc(i);
      Result[n-1].right := i-Result[n-1].left;
      if ((max > 0) and (n >= max)) then
        exit;
    end;
  end;
end;

function countWords(s, wordDelims : string) : TBorderArray; overload;
begin
  result := countWords(s, wordDelims, 0);
end;

function properCase(s, wordDelims : String) : string;
var i, len :integer;
begin
  result := AnsiLowerCase(s);
  i := 1;
  len := length(result);
  while i < len do
  begin
    while ((i < len) and (Pos(s[i], wordDelims) > 0)) do
      inc(i);
    if (i < len) then
    begin
      while ((i < len) and (Pos(s[i], wordDelims) = 0)) do
      begin
        s[i] := AnsiUpperCase(s[i])[1];
        inc(i);
      end;
    end;
  end;
end;

function EndsWith(s1,s2 : string) : boolean;
var i , j : integer;
begin
  i := length(s1);
  j := length(s2);
  result := false;
  if (i >= j) and (j>0) and (j>0) then
  begin
    if copy(s1, i-j+1, j) = s2 then
      result := True;
  end;
end;

//////////////////////////////////////

{ TDeclExt }

procedure TDeclExt.setEndings(c1, c2, c3, c4, c5, c6 : string);
begin
  ends[1] := c1;
  ends[2] := c2;
  ends[3] := c3;
  ends[4] := c4;
  ends[5] := c5;
  ends[6] := c6;
end;

procedure TDeclExt.clearEndings();
begin
  setEndings('', '', '', '', '', '');
end;

function TDeclExt.abbreviation( s : string; num : integer) : boolean;
var n, vocCnt, conCnt, len, i : integer;
    s1 : string;
begin
  n := 0;
  vocCnt := 0;
  conCnt := 0;
  s1 := AnsiUpperCase(s);
  len := length(s);
  for i := 1 to len do
  begin
    if Pos(s[i], '-.,') > 0 then
      break;
    if (s[i] = s1[i]) then
      Inc(n);
    if (n >= num) then
      break;
    if Pos(s[i], 'аоуыэяеёюи') > 0 then
      inc(vocCnt);
    if Pos(s[i],'бвгджзйклмнпрстфхцчшщ') > 0 then
      Inc(conCnt);
  end;
  if (((vocCnt = len) or (conCnt = len)) and (len >= num)) then
    n := num;
  Result := (n >= num);
end;

function TDeclExt.pointAbbreviation(s : String) : boolean;
begin
  Result := present(s,'PointAbbreviation');
end;

function TDeclExt.adjective(s : string) : boolean;
var cEnd2, cEnd3, cEnd4 : string;
    len : integer;
begin
  cEnd2 := '';
  cEnd3 := '';
  cEnd4 := '';
  len := Length(s);
  s := AnsiLowerCase(s);
  result := false;
  if (len > 2) then
    cEnd2 := Copy(s, len - 1, 2);
  if (len > 3) then
    cEnd3 := Copy(s, len - 2, 3);
  if (len > 4) then
    cEnd4 := Copy(s, len - 3, 4);
  if (s='прочие') or (s='третий') or (s='божье') or (s='охотничье') then
    result := true
  else if (cEnd4='иеся') then
    result := true
  else if (cEnd2='ие') then
  begin
    if (cEnd3='щие') or (cEnd3='шие') then
      result := true
    else if (cEnd3='тие') or (cEnd4='яние') then
      result := false
    else if (cEnd4='нние') then
      result := true
    else if (cEnd4='ение') or (cEnd4='ание') then
      result := false
    else if (cEnd3='ние') or (cEnd4='ские') or (cEnd3='кие') then
      result := true;
  end
  else if (cEnd2='ий') then
  begin
    if (cEnd3='щий') or (cEnd3='ший') or (cEnd3='чий') then
      result := true
    else if (cEnd3='ций') or (cEnd4='ытий') or (cEnd4='яний') or (cEnd4='оний') then
      result := false
    else if (cEnd4='нний') then
      result := true
    else if (cEnd4='ений') or (cEnd4='аний') then
      result := false
    else if (cEnd3='ний') then
      result := true
    else if (cEnd4='илий') then
      result := false
    else if (cEnd4='ский') or (cEnd3='кий') or (cEnd3='жий') then
      result := true;
  end
  else if (cEnd2='ый') or (cEnd2='ой') or (cEnd2='ее') or (cEnd2='ое') or
          (cEnd2='ые') or (cEnd2='ая') or (cEnd2='яя')
  then
    result := true;

  if result and present(s, 'NonAdjective') then
    result := false;
end;

function TDeclExt.plural(s : string) : boolean;
begin
  result := present(s,'Plural');
end;

function TDeclExt.restoreWordView(ethalon, s : string) : string;
var i,p,n, l : integer;
begin
  n := length(ethalon);
  l := length(s);
  p := Pos('-', ethalon);
  i := p+1;
  while (i < n) do
  begin
    if (i >= l) or (s[i] <> AnsiLowerCase(ethalon[i])[1]) then
      break;
    inc(i);
  end;
  result := Copy(ethalon,1 ,i) + copy(s,i,l-i);
end;

function TDeclExt.isOrderNumber(s : string):boolean;
const
  numFlag :array[1..8] of string[10] =('сто','дцать','сорок','ьдесят','триста','четыреста','ьсот','тысяча');
var i : integer;
begin
  result := False;
  for i := 1 to 8 do
    if Pos(numFlag[i], s)> 0 then
    begin
      result := true;
      exit;
    end;
end;

function TDeclExt.declNumeral(s : string; padeg : integer; isSoul : boolean) : string;
var s1, s2 : string;
    i : integer;
    three, female : boolean;
begin
  result := '';
  s1 := extractWord(1, s, '-');
  i := StrToIntDef(s1,0);
  s2 := extractWord(2, s, '-');
  three := ((i mod 10) = 3);
  female := EndsWith(s2, 'я');
  if (three) then
  begin
    if (female) then
      setEndings(s2, 'ей', 'ей', 'ю', 'ей', 'ей')
    else
      setEndings(s2, 'его', 'ему', 'его', 'им', 'ем');
  end
  else if (female) then
    setEndings(s2, 'ой', 'ой', 'ую', 'ой', 'ой')
  else
    setEndings(s2, 'ого', 'ому', 'ого', 'ым', 'ом');

  if (({not} isSoul) and (not female)) then
    Self.ends[4] := Self.ends[1];

  result :=  IntToStr(i) + '-' + Self.ends[padeg];
end;

function TDeclExt.formatChar( s : string; ch : char) : string;
var i : integer;
begin
  result := trim(s);
  if length(result) > 0 then
  begin
    i := Pos(ch, result);
    if (i > 0) then
      result := trim(copy(result, 1, i)) + ch + formatChar(copy(result,i+1, length(Result)), ch);

  end;
end;

function TDeclExt.isNumeral(s : String) : boolean;
var suffix : string;
    len : integer;
    ch_l, ch_p : char;
begin
  result := false;
  try
    if StrToIntDef(extractWord(1, s, '-'), 0) = 0 then Exit;
    suffix := extractWord(2, s, '-');
    len := length(suffix);
    if (len = 0) then Exit;
    ch_l := suffix[len];
    if len > 1 then
      ch_p := suffix[len-1]
    else
      ch_p := ' ';
    if (((ch_l = 'й') and ((len = 1) or (Pos(ch_p,'ыио') > 0))) or
        ((ch_l = 'я') and ((len = 1) or (ch_p = 'а'))) or
        ((ch_l = 'е') and ((len = 1) or (ch_p = 'о'))))
    then
      result := true;
  except
    result := False;
  end;
end;

function TDeclExt.formatParameter( s : String) : string;
var i : integer;

begin
  result := '';
  for i := 1 to length(s) do
  begin
    result := result + s[i];
    if (i> 1) and (i < length(s) - 1) then
    begin
      if (s[i + 1] = '(')  then
        result := result + ' ';
      if ((s[i] = '.') and (s[i + 1] <> ',') and
         ((Pos(s[i+1], '0123456789') = 0) or (Pos(s[i-1],'0123456789') = 0)))
      then
        result := result + ' ';
      if ((s[i] = ',') and
          ((Pos(s[i+1],'0123456789') = 0) or (Pos(s[i-1],'0123456789') = 0)))
      then
        result := result + ' ';
    end;
  end;
end;

function TDeclExt.processWord( anyWord : string; padeg : integer; isSoul, hyphen : boolean) : string;
var s, cEnd : string;
    len : integer;
    last, prev : char;
begin
  s := AnsiLowerCase(Trim(anyWord));
  Self.terminate := false;

  if ((padeg = 1) or (isOrderNumber(s))) then
  begin
    result := anyWord;
    exit;
  end;
  if (s = 'по') or (s = 'на') then
  begin
    Self.terminate := true;
    result := anyWord;
    exit;
  end;
  if ((abbreviation(anyWord, 2)) or (pointAbbreviation(s))) then
  begin
    self.terminate := true;
    result := anyWord;
    exit;
  end;
  if ((hyphen) and (present(anyWord, 'NonDeclBeforeHyphen'))) then
  begin
    self.terminate := true;
    result := anyWord;
    exit;
  end;
  len := length(s);
  if len = 0 then
  begin
    result := anyWord;
    exit;
  end;

  if Assigned(ExceptionUnit.SimpleExceptList) then
  begin
    if ExceptionUnit.SimpleExceptList.CheckWord(anyWord, 1, padeg) then
    begin
      Result := ExceptionUnit.SimpleExceptList.Strings[padeg-1];
      Exit;
    end;
  end;

  last := s[len];
  if ((len <= 2) and (last <> '.')) then
  begin
    result := anyWord;
    exit;
  end;
  if (last <> '.') then
    Self.prevWord := '';
  clearEndings();

  result := anyWord;
  if (endsWith(s,'ство')) then
  begin
    setEndings('о', 'а', 'у', 'а', 'ом', 'е');
    if ({not} isSoul) then
      Self.ends[4] := Self.ends[1];
    result := copy(anyWord, 1, len - 1) + Self.ends[padeg];
    Self.terminate := true;
    exit;
  end;
  if len < 2 then
    cEnd := s[1]
  else
    cEnd := Copy(s,len-1,2);
  if (Pos(last, 'бвгджзйклмнпрстфхцчшщь.,') > 0) then
  begin
    if (cEnd = 'ый') or (cEnd = 'ой') then
    begin
      setEndings(cEnd, 'ого', 'ому', 'ого', 'ым', 'ом');
      result := copy(anyWord,1, len - 2);
      if len > 2 then
        prev := s[len - 3]
      else
        prev := ' ';

      if ((Pos(prev,'гкх') > 0) or (Pos(prev,'цш') > 0) or (Pos(prev,'чщ') > 0) or (prev = 'ж')) then
        Self.ends[5] := 'им';
      Self.terminate := (not adjective(s));
    end
    else if (cEnd = 'ий') then
    begin
      Self.terminate := (not adjective(s));
      if len > 2 then
        prev := s[len - 3]
      else
        prev := ' ';
      if (Self.terminate) then
      begin
        if ((Pos(prev,'цш') > 0) or (Pos(prev,'чщ') > 0) or (prev = 'ж')) then
        begin
          setEndings('ий', 'его', 'ему', 'его', 'им', 'ем');
          result := copy(anyWord,1,len - 2);
        end
        else begin
          result := copy(anyWord,1, len - 1);
          setEndings('й', 'я', 'ю', 'й', 'ем', 'и');
        end;
      end
      else begin
        if (Pos(prev,'гкх') > 0) then
          setEndings('ий', 'ого', 'ому', 'ого', 'им', 'ом')
        else
          setEndings('ий', 'его', 'ему', 'его', 'им', 'ем');

        result := COpy(anyWord, 1, len - 2);
        if ((s = 'третий')) and (padeg > 1) then
          result := result + 'ь';
      end;
    end
    else if (cEnd = 'ок') then
    begin
      if (((padeg <> 1) and (isSoul)) or ((padeg <> 1) and (padeg <> 4) and (not isSoul))) then
        result := copy(anyWord,1, len - 2) + 'к'
      else
        result := anyWord;
      setEndings('', 'а', 'у', 'а', 'ом', 'е');
      Self.terminate := true;
    end
    else if (cEnd = 'ец') then
    begin
      result := anyWord;
      setEndings('', 'а', 'у', 'а', 'ом', 'е');
      case s[len - 3] of
        'а':;
        'е':;
        'и':;
        'о':;
        'у': begin
          Self.ends[5] := 'ем';
          result := copy(anyWord,1,len - 2) + 'йц';
        end;
        'л': begin
          if (Pos(s[len - 4],'аоуыэяеёюи') >= 0) then
            result := copy(anyWord,1, len - 2) + 'ьц'
          else begin
            Self.ends[5] := 'ем';
            if (s[len - 4] = 'й') then
              Self.ends[5] := 'ом';
          end;
        end;
        'д':;
        'н': begin
          if ((Pos(s[len-4], 'аоуыэяеёюи') > 0) and
             (TSyllable.countSyllable(anyWord) > 2))
          then
            result := copy(anyWord,1,len - 2) + 'ц';
        end;
        'п': begin
          if (len > 3) then
          begin
            if (Pos(s[len - 4],'аоуыэяеёюи') > 0) then
            begin
              Self.ends[5] := 'ем';
              result := copy(anyWord,1,len - 2) + 'ц';
            end;
          end
          else
            Self.ends[5] := 'ем';
        end;
        'б':;
        'в':;
        'г':;
        'ж':;
        'з':;
        'й':;
        'к':;
        'м':;
        'р':;
        'с':;
        'т':;
        else
          result := copy(anyWord,1, len - 2) + 'ц';
      end;
      if ((padeg = 4) and ({not} isSoul)) then
        result := anyWord;
      Self.terminate := true;
    end
    else if (cEnd = 'ть') then
    begin
      setEndings('ь', 'и', 'и', 'ь', 'ью', 'и');
      result := copy(anyWord,1, len - 1);
      Self.terminate := true;
    end
    else if (last = 'й') then
    begin
      if (len = 1) then
        result := anyWord
      else begin
        result := copy(anyWord,1,len - 1);
        setEndings('й', 'я', 'ю', 'й', 'ем', 'е');
        Self.terminate := true;
      end;
    end
    else if (last = '.') then
    begin
      result := anyWord;
      Self.prevWord := Self.prevWord + s;
      if pointAbbreviation(Self.prevWord) then
      begin
        Self.terminate := true;
        Self.prevWord := '';
      end;
    end
    else if (last = ',') then
    begin
      result := processWord(copy(anyWord,1, len - 1), padeg, isSoul, hyphen) + ',';
      clearEndings();
      if (not Self.comma) then
      begin
        Self.memoTerm := Self.terminate;
        Self.comma := true;
        Self.terminate := false;
      end
      else
        Self.terminate := Self.memoTerm;
    end
    else if (last = 'ь') then
    begin
      setEndings('ь', 'я', 'ю', 'я', 'ем', 'е');
      result := copy(anyWord,1, len - 1);
      Self.terminate := true;
      if (s = 'вновь') then
      begin
        result := anyWord;
        clearEndings();
      end;
    end
    else begin
      setEndings('', 'а', 'у', 'а', 'ом', 'е');
      result := anyWord;
      Self.terminate := true;
    end;
    if ({not} isSoul) then
      Self.ends[4] := Self.ends[1];

  end
  else begin
    if endsWith(s,'иеся') then
    begin
      setEndings('е', 'х', 'м', 'е', 'ми', 'х');
      result := copy(anyWord,1, len - 3) + Self.ends[padeg] + copy(anyWord,len - 2, len);
      exit;
    end;
    if (plural(s)) then
    begin
      if ((cEnd = 'ии') or (cEnd = 'ия')) then
      begin
        setEndings(cEnd, 'ий', 'иям', cEnd, 'иями', 'иях');
        result := copy(anyWord,1, len - 2);
      end
      else if (cEnd = 'ие') then
      begin
        setEndings('е', 'х', 'м', 'х', 'ми', 'х');
        result := copy(anyWord,1, len - 1);
      end
      else if (cEnd = 'ли') then
      begin
        setEndings('и', 'ей', 'ям', 'ей', 'ями', 'ях');
        result := copy(anyWord,1,len - 1);
      end
      else if (last = 'ы') then
      begin
        setEndings('ы', 'ов', 'ам', 'ов', 'ами', 'ах');
        if (anyWord = 'плиты') then
          Self.ends[2] := '';
        result := copy(anyWord,1, len - 1);
      end;
      if ({not }isSoul) then
        Self.ends[4] := Self.ends[1];
      Self.terminate := true;
    end
    else if (cEnd = 'ое') then
    begin
      setEndings('ое', 'ого', 'ому', 'ому', 'ым', 'ом');
      if (Pos(s[len - 3], 'гкх') > 0) then
        Self.ends[5] := 'им';
      if ({not} isSoul) then
        Self.ends[4] := Self.ends[1];
      result := copy(anyWord,1,len - 2);
    end
    else if (cEnd = 'ее') then
    begin
      setEndings('ее', 'его', 'ему', 'ему', 'им', 'ем');
      if ({not }isSoul) then
        Self.ends[4] := Self.ends[1];
      result := copy(anyWord,1,len - 2);
    end
    else if (cEnd = 'ие') then
    begin
      Self.terminate := (not adjective(s));
      if (Self.terminate) then
        setEndings('е', 'я', 'ю', 'е', 'ем', 'и')
      else
        setEndings('е', 'х', 'м', 'х', 'ми', 'х');
      result := copy(anyWord,1, len - 1);
      if ({not} isSoul) then
        Self.ends[4] := Self.ends[1];
    end
    else if (cEnd = 'ые') then
    begin
      setEndings('е', 'х', 'м', 'х', 'ми', 'х');
      if (not isSoul) then
        Self.ends[4] := Self.ends[1];
      result := copy(anyWord,1, len - 1);
    end
    else if (cEnd = 'ье') then
    begin
      if (isSoul) then
      begin
        Self.terminate := true;
        exit;
      end;
      Self.terminate := (not adjective(s));
      if (Self.terminate) then
        setEndings('е', 'я', 'ю', 'е', 'ем', 'и')
      else
        setEndings('е', 'его', 'ему', 'е', 'им', 'ем');
      result := copy(anyWord,1,len - 1);
    end
    else if (cEnd = 'ои') then
    begin
      setEndings('и', 'ев', 'ям', 'и', 'ями', 'ях');
      result := copy(anyWord,1, len - 1);
      Self.terminate := true;
    end
    else begin
      prev := s[len - 2];
      if ((last = 'а') and (Pos(prev, 'бвгджзйклмнпрстфхцчшщ') > 0)) then
      begin
        setEndings('а', 'ы', 'е', 'у', 'ой', 'е');
        if ((Pos(prev, 'чщ') > 0) or (Pos(prev,'гкх') > 0) or (Pos(prev,'жш') > 0)) then
          Self.ends[2] := 'и';
        if ((Pos(prev,'чщ') > 0) or (Pos(prev,'цш') > 0) or (Pos(prev,'ж') > 0)) then
          Self.ends[5] := 'ей';
        result := copy(anyWord,1,len - 1);
        Self.terminate := true;
      end
      else if (last = 'я') then
      begin
        if (s = 'учащийся') then
        begin
          setEndings('ий', 'его', 'ему', 'его', 'им', 'ем');
          result := copy(anyWord,1, len - 4) + Self.ends[padeg] + copy(anyWord,len - 2, len);
          Self.terminate := true;
          exit;
        end;
        setEndings('я', 'и', 'е', 'ю', 'ей', 'е');
        Self.terminate := true;
        result := copy(anyWord,1, len - 1);
        if (prev = 'и') then
        begin
          Self.ends[3] := 'и';
          Self.ends[6] := 'и';
        end
        else if (prev = 'а') then
        begin
          result := copy(anyWord,1,len - 2);
          setEndings('ая', 'ой', 'ой', 'ую', 'ой', 'ой');
          if (Pos(s[len - 3], 'чщ') > 0) then
            setEndings('ая', 'ей', 'ей', 'ую', 'ей', 'ей');
          Self.terminate := (not adjective(s));
        end
        else if (prev = 'я') then
        begin
          setEndings('яя', 'ей', 'ей', 'юю', 'ей', 'ей');
          result := copy(anyWord,1, len - 2);
          Self.terminate := false;
        end;
      end
      else if (last = 'о') then
      begin
        result := anyWord;
        Self.terminate := true;
      end
      else if ((last = 'и') and (anyWord = 'ясли')) then
      begin
        setEndings('и', 'ей', 'ям', 'и', 'ями', 'ях');
        result := copy(anyWord, 1, len - 1);
        Self.terminate := true;
      end
      else
        result := anyWord;
    end;
  end;
  result := result + Self.ends[padeg];
end;

function TDeclExt.getDeclension( s : string; padeg : integer; isSoul : boolean) : string;
var tmpI, wrdCount, currWrd, defWrdCount, i, j : integer;
    b, def_b : TBorderArray;
    breakDecl : Boolean;
    tmpS, subWrd, wrdNext : string;
begin
  self.comma := false;
  self.memoTerm := false;
  if (not (padeg in [1..6])) then
   raise Exception.create('Wrong padeg');

  tmpI := Pos(' - ', s);
  if ((tmpI > 0) and (not isSoul)) then
  begin
    result := getDeclension(copy(s,1, tmpI - 1), padeg, isSoul);
    result := result + ' - ' + getDeclension(copy(s,tmpI + 3, length(s)), padeg, isSoul);
    exit;
  end;
  s := formatParameter(s);
  s := formatChar(s, '-');
  b := countWords(s, ' ');
  wrdCount := length(b);
  currWrd := 0;
  self.prevWord := '';
  breakDecl := false;
  result := '';
  for i := 0 to wrdCount-1 do
  begin
    tmpS := copy(s,b[i].left, b[i].right);
    if (Pos('-', tmpS) > 0) then
    begin
      if (isNumeral(tmpS)) then
        result := result + ' ' + declNumeral(tmpS, padeg, isSoul)
      else if (getRightPart(tmpS, 'HyphenAbbreviation') = tmpS) then
      begin
        subWrd := getRightPart(tmpS, 'HyphenAbbreviation');
        self.terminate := breakDecl;
        subWrd := processWord(subWrd, padeg, isSoul, false);
        breakDecl := self.terminate;
        result := result + ' ' + restoreWordView(tmpS, subWrd);
      end
      else begin
        result := result+' ';
        def_b := countWords(tmpS, '-');
        defWrdCount := length(def_b);
        for j := 0 to defWrdCount -1 do
        begin
          subWrd := copy(tmpS,def_b[j].left, def_b[j].right);
          self.terminate := breakDecl;
          result := result + processWord(subWrd, padeg, isSoul, true);
          breakDecl := self.terminate;
          if (j < defWrdCount - 1) then
            result := result + '-';
        end;
      end;
    end
    else begin
      self.terminate := breakDecl;
      result := result + ' ' + processWord(tmpS, padeg, isSoul, false);
      breakDecl := self.terminate;
      if ((breakDecl) and (AnsiLowerCase(tmpS)<>'по')) then
      begin
        tmpI := 0;
        for j := i + 1 to wrdCount - 1 do
        begin
          wrdNext := Copy(s, b[j].left, b[j].right);
          if (not adjective(wrdNext)) then
            inc(tmpI);
          if (wrdNext='и') then
          begin
            dec(tmpI);
            if ((j = i + 1) or ((tmpI = 0) and (j = wrdCount - 2))) then
            begin
              tmpI := 0;
              break;
            end;
          end
          else if (wrdNext='в') then
          begin
            Dec(tmpI);
            if (tmpI = 0) then
            begin
              tmpI := 1;
              break;
            end;
          end;
        end;
        breakDecl := (tmpI <> 0);
      end;
    end;
    currWrd := i;
    if (breakDecl) then
      break;

  end;
  if (currWrd < wrdCount - 1) then
    result := result + ' ' + Copy(s,b[(currWrd + 1)].left, Length(s));
  Result := Trim(Result);
  {
  String res = result.toString();
  res = formatChar(res, ' ').trim();
  res = res.replace('. )', '.)');
  return res;}
end;

function TDeclExt.getAppointment( s : String; padeg : integer) : string;
begin
  result := getDeclension(s, padeg, true);
end;

function TDeclExt.getOffice(s : String; padeg : integer) : string;
begin
  result := getDeclension(s, padeg, false);
end;

function TDeclExt.getFullAppointment(appointment, office : string; padeg : integer) : string;
var off_b, app_b : TBorderArray;
    anyWord, appLastWord : string;
    appWordCount, memoPadeg, i : Integer;
begin
  if (not (padeg in [1..6])) then
    raise Exception.create('Wrong padeg');

  off_b := countWords(office, ' ');
  if Length(off_b) < 1 then
    anyWord := ''
  else
    anyWord := Copy(office, off_b[0].left, off_b[0].right);
  if ((not abbreviation(anyWord, 2)) and (not present(anyWord, 'OfficeNoLowerCase')) and (length(office) >= 1)) then
    office[1] := AnsiUpperCase(office[1])[1];

  appointment := AnsiReplaceStr(appointment, '.', '. ');

  app_b := countWords(appointment, ' ');
  appWordCount := length(app_b);
  if appWordCount < 1 then
    appLastWord := ''
  else
    appLastWord := Copy(appointment, app_b[appWordCount - 1].left, app_b[appWordCount - 1].right);


  memoPadeg := 0;
  for i := 0 to appWordCount - 1 do
  begin
    anyWord := Copy(office, off_b[i].left, off_b[i].right);
    if (getOffice(anyWord, 2) = appLastWord) then
    begin
      memoPadeg := 2;
      break;
    end;
    if (getOffice(anyWord, 5) = appLastWord) then
    begin
      memoPadeg := 5;
      break;
    end;
  end;
  if (memoPadeg > 0) then
    Dec(appWordCount)
  else
    memoPadeg := 2;
  anyWord := appLastWord;
  if ((length(anyWord) >= 8) and (AnsiLowerCase(Copy(anyWord, 1, 8)) = 'заведующ')) then
    memoPadeg := 5;
  result := '';
  if (appWordCount >= 1) then
  begin
    for i := 0 to Length(app_b)-1 do
      result := Result + Copy(appointment, app_b[i].left, app_b[i].right) + ' ';
    result := Result + getOffice(office, memoPadeg);
    Result := getAppointment(result, padeg);
    Exit;
  end;
  result := Result + getOffice(office, memoPadeg);
end;

function TDeclExt.getOfficeList(s: string): TStringList;
begin
  Result := TStringList.Create;
  Result.Add(getOffice(s, 2));
  Result.Add(getOffice(s, 3));
  Result.Add(getOffice(s, 4));
  Result.Add(getOffice(s, 5));
  Result.Add(getOffice(s, 6));
end;

end.
