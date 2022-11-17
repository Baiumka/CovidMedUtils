unit RuUnit;

interface
uses DeclinationUnit;

type

  TRuCore = class(TCore)
  public
    constructor Create; overload;
  protected
    function  RulesChain(Gender : TGender; RulesArray : array of Integer) : Boolean; override;
  protected
    // Мужские имена, оканчивающиеся на любой ь и -й,
    // склоняются так же, как обычные существительные мужского рода
    function ManRule1 : Boolean;
    // Мужские имена, оканчивающиеся на любой твердый согласный,
    // склоняются так же, как обычные существительные мужского рода
    function ManRule2 : Boolean;
    // Мужские и женские имена, оканчивающиеся на -а, склоняются, как и любые
    // существительные с таким же окончанием
    // Мужские и женские имена, оканчивающиеся иа -я, -ья, -ия, -ея, независимо от языка,
    // из которого они происходят, склоняются как существительные с соответствующими окончаниями
    function ManRule3 : Boolean;
    // Мужские фамилии, оканчивающиеся на -ь -й, склоняются так же,
    // как обычные существительные мужского рода
    function ManRule4 : Boolean;
    // Мужские фамилии, оканчивающиеся на -к
    function ManRule5 : Boolean;
    // Мужские фамили на согласный выбираем ем/ом/ым
    function ManRule6 : Boolean;
    // Мужские фамили на -а -я
    function ManRule7 : Boolean;
    // Не склоняются мужский фамилии
    function ManRule8 : Boolean;
    // Мужские и женские имена, оканчивающиеся на -а, склоняются,
    // как и любые существительные с таким же окончанием
    function WomanRule1 : Boolean;
    // Мужские и женские имена, оканчивающиеся иа -я, -ья, -ия, -ея, независимо от языка,
    // из которого они происходят, склоняются как существительные с соответствующими окончаниями
    function WomanRule2 : Boolean;
    // Русские женские имена, оканчивающиеся на мягкий согласный, склоняются,
    // как существительные женского рода типа дочь, тень
    function WomanRule3 : Boolean;
    // Женские фамилия, оканчивающиеся на -а -я, склоняются,
    // как и любые существительные с таким же окончанием
    function WomanRule4 : Boolean;
    function ManFirstName : Boolean; override;
    function ManSecondName : Boolean; override;
    function ManFatherName : Boolean; override;
    function WomanFirstName : Boolean; override;
    function WomanSecondName : Boolean; override;
    function WomanFatherName : Boolean; override;

    procedure GenderByFirstName(Word : TWord); override;
    procedure GenderBySecondName(Word : TWord); override;
    procedure GenderByFatherName(Word : TWord); override;

    procedure DetectNamePart(Word : TWord); override;
  end;

implementation

uses ExceptionUnit;

const
   FVowels : string = 'аеёиоуыэюя';
   FConsonant : string = 'бвгджзйклмнпрстфхцчшщ';
   FOvo : array[0..3] of string = ('ово', 'аго', 'яго', 'ирь');
   FIh : array[0..2] of string = ('их', 'ых', 'ко');


function Max(A,B : Double) : Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

type
   TDictRecord = record
     a : Char;
     c : string;
   end;

const
   FSplitSecondExclude : array[0..32] of TDictRecord =
     ((a:'а'; c : 'взйкмнпрстфя'),
      (a:'б'; c : 'а'),
      (a:'в'; c : 'аь'),
      (a:'г'; c : 'а'),
      (a:'д'; c : 'ар'),
      (a:'е'; c : 'бвгдйлмня'),
      (a:'ё'; c : 'бвгдйлмня'),
      (a:'ж'; c : ''),
      (a:'з'; c : 'а'),
      (a:'и'; c : 'гдйклмнопрсфя'),
      (a:'й'; c : 'ля'),
      (a:'к'; c : 'аст'),
      (a:'л'; c : 'аилоья'),
      (a:'м'; c : 'аип'),
      (a:'н'; c : 'ат'),
      (a:'о'; c : 'вдлнпртя'),
      (a:'п'; c : 'п'),
      (a:'р'; c : 'адикпть'),
      (a:'с'; c : 'атуя'),
      (a:'т'; c : 'аор'),
      (a:'у'; c : 'дмр'),
      (a:'ф'; c : 'аь'),
      (a:'х'; c : 'а'),
      (a:'ц'; c : 'а'),
      (a:'ч'; c : ''),
      (a:'ш'; c : 'а'),
      (a:'щ'; c : ''),
      (a:'ъ'; c : ''),
      (a:'ы'; c : 'дн'),
      (a:'ь'; c : 'я'),
      (a:'э'; c : ''),
      (a:'ю'; c : ''),
      (a:'я'; c : 'нс'));

function GetSplitSecondExclude(a : char) : string;
var i : Integer;
begin
  Result := '';
  for i := 0 to 32 do
    if FSplitSecondExclude[i].a = a then
    begin
      Result := FSplitSecondExclude[i].c;
      Exit;
    end;
end;

{ TRuCore }

constructor TRuCore.Create;
begin
  inherited;
  FLanguageBuild := '11072716';
  FCaseCount := 6;
end;

procedure TRuCore.DetectNamePart(Word: TWord);
var name :string;
    length_ : Integer;
    first, second, father, max_ : Double;
    s : string;
begin
  name := word.Name;
  length_ := Length(name);
  SetWorkingWord(name);
  //Считаем вероятность
  first := 0;
  second := 0;
  father := 0;
  //если смахивает на отчество
  if (In_(Last(3), ['вна', 'чна', 'вич', 'ьич'])) then
    father := father + 3;
  //если смахивает на имя
  if (In_(Last(2), 'ша')) then
    first := first + 0.5;
  // буквы на которые никогда не закнчиваются имена
  if (In_(Last(1), 'еёжхцочшщъыэю')) then
    second := second + 0.3;
  // Используем массив характерных окончаний
  //if (In_(Last(2, 1), Fvowels+Fconsonant)) then
  s := GetSplitSecondExclude(Last(2, 1)[1]);
  if s <> '' then
  begin
      if (not In_(Last(1), s)) then
        second := second + 0.4;
  end;
  // Сохкращенные ласкательные имена типя Аня Галя и.т.д.
  if (Last(1) = 'я') and (In_(Last(3, 1), fvowels)) then
    first := first + 0.5;
  // Не бывает имет с такими предпоследними буквами
  if (In_(Last(2, 1), 'жчщъэю')) then
    second := second + 0.3;
  // Слова на мягкий знак. Существует очень мало имен на мягкий знак. Все остальное фамилии
  if (Last(1) = 'ь') then
  begin
    // Имена типа нинЕЛь адЕЛь асЕЛь
    if (Last(3, 2) = 'ел') then
      first := first + 0.7
    // Просто исключения
    else if (InNames(name, ['лазарь', 'игорь', 'любовь'])) then
      first := first + 10
    // Если не то и не другое, тогда фамилия
    else
      second := second + 0.3;
  end
  // Если две последних букв согласные то скорее всего это фамилия
  else if (In_(Last(1), Fconsonant + 'ь')) and (In_(Last(2, 1), fconsonant + 'ь')) then
  begin
      // Практически все кроме тех которые оканчиваются на следующие буквы
      if (not In_(Last(2), ['др', 'кт', 'лл', 'пп', 'рд', 'рк', 'рп', 'рт', 'тр'])) then
        second := second + 0.25;
  end;
  // Слова, которые заканчиваются на тин
  if (Last(3) = 'тин') and (In_(Last(4, 1), 'нст')) then
    first := first + 0.5;
  //Исключения
  if (InNames(name, ['лев', 'яков', 'маша', 'ольга', 'еремей', 'исак', 'исаак', 'ева', 'ирина', 'элькин', 'мерлин'])) then
    first := first + 10;
  // Фамилии которые заканчиваются на -ли кроме тех что типа натАли и.т.д.
  if (Last(2) = 'ли') and (Last(3, 1) <> 'а') then
    second := second + 0.4;
  // Фамилии на -як кроме тех что типа Касьян Куприян + Ян и.т.д.
  if (Last(2) = 'ян') and (length_ > 2) and (not In_(Last(3, 1), 'ьи')) then
    second := second + 0.4;
  // Фамилии на -ур кроме имен Артур Тимур
  if (Last(2) = 'ур') then
  begin
    if (not InNames(name, ['артур', 'тимур'])) then
      second := second + 0.4;
  end;
  // Разбор ласкательных имен на -ик
  if (Last(2) = 'ик') then
  begin
    // Ласкательные буквы перед ик
    if (In_(Last(3, 1), 'лшхд')) then
      first := first + 0.3
    else
      second := second + 0.4;
  end;
  // Разбор имен и фамилий, который заканчиваются на ина
  if (Last(3) = 'ина') then
  begin
    // Все похожие на Катерина и Кристина
    if (In_(Last(7), ['атерина', 'ристина'])) then
      first := first + 10
    // Исключения
    else if (InNames(name, ['мальвина', 'антонина', 'альбина', 'агриппина', 'фаина',
                            'карина', 'марина', 'валентина', 'калина', 'аделина',
                            'алина', 'ангелина', 'галина', 'каролина', 'павлина',
                            'полина', 'элина', 'мина', 'нина']))
    then
      first := first + 10
    // Иначе фамилия
    else
      second := second + 0.4;
  end;
  // Имена типа Николай
  if (Last(4) = 'олай') then
    first := first + 0.6;
  // Фамильные окончания
  if (In_(Last(2), ['ов', 'ин', 'ев', 'ёв', 'ый', 'ын', 'ой', 'ук', 'як', 'ца',
                    'ун', 'ок', 'ая', 'га', 'ёк', 'ив', 'ус', 'ак', 'яр', 'уз', 'ах', 'ай']))
  then
    second := second + 0.4;

  if (In_(Last(3), ['ова', 'ева', 'ёва', 'ына', 'шен', 'мей', 'вка', 'шир', 'бан',
                    'чий', 'кий', 'бей', 'чан', 'ган', 'ким', 'кан', 'мар']))
  then
    second := second + 0.4;

  if (In_(Last(4), 'шена')) then
    second := second + 0.4;

  max_ := Max(Max(first, second), father);

  if (first = max_) then
    word.NamePart := npFirstName
  else if (second = max_) then
    word.NamePart := npSecondName
  else
    word.NamePart := npFatherName;
end;

procedure TRuCore.GenderByFatherName(Word: TWord);
begin
  SetWorkingWord(word.Name);
  if (Last(2) = 'ич') then
    word.GenderProbability := TGenderProbability.Create(10, 0)  // мужчина
  else if (Last(2) = 'на') then
    word.GenderProbability := TGenderProbability.Create(0, 12); // женщина
end;

procedure TRuCore.GenderByFirstName(Word: TWord);
var prob : TGenderProbability;
begin
  SetWorkingWord(Word.Name);
  prob := TGenderProbability.Create;
  //Попробуем выжать максимум из имени
  //Если имя заканчивается на й, то скорее всего мужчина
  if (Last(1) = 'й') then
    prob.ManAdd(0.9);
  if (In_(Last(2), ['он', 'ов', 'ав', 'ам', 'ол', 'ан', 'рд', 'мп'])) then
    prob.ManAdd(0.3);
  if (In_(Last(1), Fconsonant)) then
    prob.ManAdd(0.01);
  if (Last(1) = 'ь') then
    prob.ManAdd(0.02);
  if (In_(Last(2), ['то', 'ма'])) then
    prob.ManAdd(0.01);
  if (In_(Last(3), ['лья', 'вва', 'ока', 'ука', 'ита'])) then
    prob.ManAdd(0.2);

  if (In_(Last(2), ['вь', 'фь', 'ль'])) then
    prob.WomanAdd(0.1);
  if (In_(Last(2), 'ла')) then
    prob.WomanAdd(0.04);
  if (In_(Last(3), 'има')) then
    prob.WomanAdd(0.15);
  if (In_(Last(3), ['лия', 'ния', 'сия', 'дра', 'лла', 'кла', 'опа'])) then
    prob.WomanAdd(0.5);
  if (In_(Last(4), ['льда', 'фира', 'нина', 'лита', 'алья'])) then
    prob.WomanAdd(0.5);

  Word.GenderProbability := prob;
end;

procedure TRuCore.GenderBySecondName(Word: TWord);
var prob : TGenderProbability;
begin
  SetWorkingWord(word.Name);
  prob := TGenderProbability.Create;

  if (In_(Last(2), ['ов', 'ин', 'ев', 'ий', 'ёв', 'ый', 'ын', 'ой'])) then
    prob.ManAdd(0.4);

  if (In_(Last(3), ['ова', 'ина', 'ева', 'ёва', 'ына', 'мин'])) then
    prob.WomanAdd(0.4);
  if (In_(Last(2), ['ая'])) then
    prob.WomanAdd(0.4);

  word.GenderProbability := prob;
end;

function TRuCore.ManFatherName: Boolean;
begin
  //Проверяем действительно ли отчество
  if (InNames(FworkingWord, 'ильич')) then
  begin
    WordForms(fworkingWord, ['а', 'у', 'а', 'ом', 'е']);
    Result := true;
  end
  else if (Last(2) = 'ич') then
  begin
    WordForms(FworkingWord, ['а', 'у', 'а', 'ем', 'е']);
    Result := true;
  end
  else
    Result := false;
end;

function TRuCore.ManFirstName: Boolean;
begin
  Result := RulesChain(gndMan, [1, 2, 3]);
end;

function TRuCore.ManRule1: Boolean;
begin
  Result := False;
  if (In_(Last(1), 'ьй')) then
  begin
    if (Last(2, 1) <> 'и') then
    begin
      WordForms(FWorkingWord, ['я', 'ю', 'я', 'ем', 'е'], 1);
      Rule(101);
    end
    else begin
      WordForms(FWorkingWord, ['я', 'ю', 'я', 'ем', 'и'], 1);
      Rule(102);
    end;
    Result  := True;
  end;
end;

function TRuCore.ManRule2: Boolean;
begin
  Result := False;
  if (In_(Last(1), FConsonant)) then
  begin
    if (InNames(FWorkingWord, 'павел')) then
    begin
      FLastResult.DelimitedText := 'павел,павла,павлу,павла,павлом,павле';
      Rule(201);
      Result := true;
    end
    else if (InNames(FWorkingWord, 'лев')) then
    begin
      FLastResult.DelimitedText := 'лев,льва,льву,льва,львом,льве';
      Rule(202);
      Result := true;
    end
    else begin
      WordForms(FworkingWord, ['а', 'у', 'а', 'ом', 'е']);
      Rule(203);
      Result := true;
    end;
  end;
end;

function TRuCore.ManRule3: Boolean;
begin
  Result := False;
  if (Last(1) = 'а') then
  begin
    if (not In_(Last(2, 1), 'кшгх')) then
    begin
      WordForms(FWorkingWord, ['ы', 'е', 'у', 'ой', 'е'], 1);
      Rule(301);
      Result := true;
    end
    else begin
      WordForms(FworkingWord, ['и', 'е', 'у', 'ой', 'е'], 1);
      Rule(302);
      Result := true;
    end;
  end
  else if (Last(1) = 'я') then
  begin
    WordForms(FworkingWord, ['и', 'е', 'ю', 'ей', 'е'], 1);
    Rule(303);
    Result := true;
  end;
end;

function TRuCore.ManRule4: Boolean;
begin
  Result := False;
  if (In_(Last(1), 'ьй')) then
  begin
    //Слова типа Воробей
    if (Last(3) = 'бей') then
    begin
      WordForms(FworkingWord, ['ья', 'ью', 'ья', 'ьем', 'ье'], 2);
      Rule(400);
    end
    else if (Last(3, 1) = 'а') or (In_(Last(2, 1), 'ел')) then
    begin
      WordForms(FworkingWord, ['я', 'ю', 'я', 'ем', 'е'], 1);
      Rule(401);
    end
    //Толстой -» ТолстЫм
    else if (Last(2, 1) = 'ы') or (Last(3, 1) = 'т') then
    begin
      WordForms(FworkingWord, ['ого', 'ому', 'ого', 'ым', 'ом'], 2);
      Rule(402);
    end
    //Лесничий
    else if (Last(3) = 'чий') then
    begin
      WordForms(FworkingWord, ['ьего', 'ьему', 'ьего', 'ьим', 'ьем'], 2);
      Rule(403);
    end
    else if (not In_(Last(2, 1), FVowels)) or (Last(2, 1) = 'и') then
    begin
      WordForms(FworkingWord, ['ого', 'ому', 'ого', 'им', 'ом'], 2);
      Rule(404);
    end
    else begin
      MakeResultTheSame();
      Rule(405);
    end;
    Result := True;
  end;
end;

function TRuCore.ManRule5: Boolean;
begin
  Result := False;
  if (Last(1) = 'к') then
  begin
    //Если перед слово на ок, то нужно убрать о
    if (Last(2, 1) = 'о') then
    begin
      WordForms(FworkingWord, ['ка', 'ку', 'ка', 'ком', 'ке'], 2);
      Rule(501);
    end
    else if (Last(2, 1) = 'е') then
    begin
      WordForms(FworkingWord, ['ька', 'ьку', 'ька', 'ьком', 'ьке'], 2);
      Rule(502);
    end
    else begin
      WordForms(FworkingWord, ['а', 'у', 'а', 'ом', 'е']);
      Rule(503);
    end;
    Result := True;
  end;
end;

function TRuCore.ManRule6: Boolean;
begin              
  if (Last(1) = 'ч') then
  begin
    WordForms(FworkingWord, ['а', 'у', 'а', 'ем', 'е']);
    Rule(601);
    Result := True;
  end
  //е перед ц выпадает
  else if (Last(2) = 'ец') then
  begin
    WordForms(FworkingWord, ['ца', 'цу', 'ца', 'цом', 'це'], 2);
    Rule(604);
    Result := True;
  end
  else if (In_(Last(1), 'цсршмхт')) then
  begin
    WordForms(FWorkingWord, ['а', 'у', 'а', 'ом', 'е']);
    Rule(602);
    Result := True;
  end
  else if (In_(Last(1), Fconsonant)) then
  begin
    WordForms(FworkingWord, ['а', 'у', 'а', 'ым', 'е']);
    Rule(603);
    Result := True;
  end
  else
    Result := False;
end;

function TRuCore.ManRule7: Boolean;
begin
  if (Last(1) = 'а') then
  begin
    //Если основа на ш, то нужно и, ей
    if (Last(2, 1) = 'ш') then
    begin
      WordForms(FworkingWord, ['и', 'е', 'у', 'ей', 'е'], 1);
      Rule(701);
    end
    else if (In_(Last(2, 1), 'хкг')) then
    begin
      WordForms(FworkingWord, ['и', 'е', 'у', 'ой', 'е'], 1);
      Rule(702);
    end
    else begin
      WordForms(FworkingWord, ['ы', 'е', 'у', 'ой', 'е'], 1);
      Rule(703);
    end;
    Result := True;
  end
  else if (Last(1) = 'я') then
  begin
    WordForms(FworkingWord, ['ой', 'ой', 'ую', 'ой', 'ой'], 2);
    Rule(704);
    Result := True;
  end
  else
    Result := false;
end;

function TRuCore.ManRule8: Boolean;
begin
  if (In_(Last(3), Fovo)) or (In_(Last(2), Fih)) then
  begin
    Rule(8);
    MakeResultTheSame();
    Result := true;
  end
  else
    Result := false;
end;

function TRuCore.ManSecondName: Boolean;
begin
  Result := RulesChain(gndMan, [8, 4, 5, 6, 7]);
end;

function TRuCore.RulesChain(Gender: TGender;
  RulesArray: array of Integer): Boolean;
var i, n : integer;
    r : Byte;
begin
  Result := False;
  if Assigned(SimpleExceptList) then
  begin
    Result := SimpleExceptList.CheckWord(FWorkingWord, 1, 0);
    if Result then
    begin
      FLastResult.Clear;
      FLastResult.AddStrings(SimpleExceptList);
      Exit;
    end;
  end;

  n := Length(RulesArray) - 1;
  case Gender of
    gndMan:
      for i := 0 to n do
      begin
        r := Byte(RulesArray[i]);
        case r of
          1: Result := ManRule1;
          2: Result := ManRule2;
          3: Result := ManRule3;
          4: Result := ManRule4;
          5: Result := ManRule5;
          6: Result := ManRule6;
          7: Result := ManRule7;
          8: Result := ManRule8;
        end;
        if Result then
          Exit;
      end;
    gndWoman:
      for i := 0 to n do
      begin
        r := Byte(RulesArray[i]);
        case r of
          1: Result := WomanRule1;
          2: Result := WomanRule2;
          3: Result := WomanRule3;
          4: Result := WomanRule4;
        end;
        if Result then
          Exit;
      end;
  else
    Result := inherited RulesChain(Gender, RulesArray);
  end;
end;

function TRuCore.WomanFatherName: Boolean;
begin
  //Проверяем действительно ли отчество
  if (Last(2) = 'на') then
  begin
    WordForms(FworkingWord, ['ы', 'е', 'у', 'ой', 'е'], 1);
    Result := true;
  end
  else
    Result := false;
end;

function TRuCore.WomanFirstName: Boolean;
begin
  Result := RulesChain(gndWoman, [1, 2, 3]);
end;

function TRuCore.WomanRule1: Boolean;
begin
  if (Last(1) = 'а') and (Last(2, 1) <> 'и') then
  begin
    if (not In_(Last(2, 1), 'шхкг')) then
    begin
      WordForms(FworkingWord, ['ы', 'е', 'у', 'ой', 'е'], 1);
      Rule(101);
    end
    else begin
      //ей посля шиплячего
      if (Last(2, 1) = 'ш') then
      begin
        WordForms(FworkingWord, ['и', 'е', 'у', 'ей', 'е'], 1);
        Rule(102);
      end
      else begin
        WordForms(FworkingWord, ['и', 'е', 'у', 'ой', 'е'], 1);
        Rule(103);
      end
    end;
    Result := True;
  end
  else
    Result := false;
end;

function TRuCore.WomanRule2: Boolean;
begin
  if (Last(1) = 'я') then
  begin
    if (Last(2, 1) <> 'и') then
    begin
      WordForms(FworkingWord, ['и', 'е', 'ю', 'ей', 'е'], 1);
      Rule(201);
    end
    else begin
      WordForms(FworkingWord, ['и', 'и', 'ю', 'ей', 'и'], 1);
      Rule(202);
    end;
    Result := True;
  end
  else
    Result := False;
end;

function TRuCore.WomanRule3: Boolean;
begin
  if (Last(1) = 'ь') then
  begin
    WordForms(fworkingWord, ['и', 'и', 'ь', 'ью', 'и'], 1);
    Rule(3);
    Result := true;
  end
  else
    Result := false;
end;

function TRuCore.WomanRule4: Boolean;
begin
  if (Last(1) = 'а') then
  begin
    if (In_(Last(2, 1), 'гк')) then
    begin
      WordForms(FworkingWord, ['и', 'е', 'у', 'ой', 'е'], 1);
      Rule(401);
    end
    else if (In_(Last(2, 1), 'ш')) then
    begin
      WordForms(FworkingWord, ['и', 'е', 'у', 'ей', 'е'], 1);
      Rule(402);
    end
    else begin
      WordForms(fworkingWord, ['ой', 'ой', 'у', 'ой', 'ой'], 1);
      Rule(403);
    end;
    Result := true;
  end
  else if (Last(1) = 'я') then
  begin
    WordForms(fworkingWord, ['ой', 'ой', 'ую', 'ой', 'ой'], 2);
    Rule(404);
    Result := true;
  end
  else
    Result := false;
end;

function TRuCore.WomanSecondName: Boolean;
begin
  Result := RulesChain(gndWoman, [4]);
end;

end.
