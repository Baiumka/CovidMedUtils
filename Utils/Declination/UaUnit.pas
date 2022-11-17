unit UaUnit;

interface
uses DeclinationUnit;

type

  TUaCore = class(TCore)
  public
    constructor Create; overload;
  private
    // Чергування українських приголосних
    // Чергування г к х —» з ц с
    function inverseGKH(Letter : String) : string;
    // Перевіряє чи символ є апострофом чи не є
    function isApostrof(Letter : string) : Boolean;
    // Чергування українських приголосних
    // Чергування г к —» ж ч
    function inverse2(Letter : string) : string;
    // Визначення групи для іменників 2-ї відміни
    // 1 - тверда
    // 2 - мішана
    // 3 - м’яка
    //
    // Правило:
    // - Іменники з основою на твердий нешиплячий належать до твердої групи:
    // береза, дорога, Дніпро, шлях, віз, село, яблуко.
    // - Іменники з основою на твердий шиплячий належать до мішаної групи:
    // пожеж-а, пущ-а, тиш-а, алич-а, вуж, кущ, плющ, ключ, плече, прізвище.
    // - Іменники з основою на будь-який м"який чи пом"якше­ний належать до м"якої групи:
    // земля [земл"а], зоря [зор"а], армія [арм"ійа], сім"я [с"імйа], серпень, фахівець,
    // трамвай, сузір"я [суз"ірйа], насіння [насін"н"а], узвишшя Іузвиш"ш"а
    function detect2Group(Word : String) : Integer;
    // Шукаємо першу з кінця літеру з переліку
    function FirstLastVowel(Word : string; Vowels : string) : string;
    // Отримуємо основу слова за правилами української мови
    function getOsnova(Word : string) : string;
  protected
    // Українські чоловічі та жіночі імена, що в називному відмінку однини закінчуються на -а (-я),
    // відмінються як відповідні іменники І відміни.
    // Примітка 1. Кінцеві приголосні основи г, к, х у жіночих іменах
    // у давальному та місцевому відмінках однини перед закінченням -і
    // змінюються на з, ц, с: Ольга - Ользі, Палажка - Палажці, Солоха - Солосі.
    // Примітка 2. У жіночих іменах типу Одарка, Параска в родовому відмінку множини
    // в кінці основи між приголосними з"являється звук о: Одарок, Парасок.
    function ManRule1 : Boolean;
    // Імена, що в називному відмінку закінчуються на -р, у родовому мають закінчення -а:
    // Віктор - Віктора, Макар - Макара, але: Ігор - Ігоря, Лазар - Лазаря.
    function ManRule2 : Boolean;
    // Українські чоловічі імена, що в називному відмінку однини закінчуються на приголосний та -о,
    // відмінюються як відповідні іменники ІІ відміни.
    function ManRule3 : Boolean;
    // Якщо слово закінчується на і, то відмінюємо як множину
    function ManRule4 : Boolean;
    // Якщо слово закінчується на ий або ой
    function ManRule5 : Boolean;
    // Українські чоловічі та жіночі імена, що в називному відмінку однини закінчуються на -а (-я),
    // відмінються як відповідні іменники І відміни.
    // - Примітка 1. Кінцеві приголосні основи г, к, х у жіночих іменах
    // у давальному та місцевому відмінках однини перед закінченням -і
    // змінюються на з, ц, с: Ольга - Ользі, Палажка - Палажці, Солоха - Солосі.
    // - Примітка 2. У жіночих іменах типу Одарка, Параска в родовому відмінку множини
    // в кінці основи між приголосними з"являється звук о: Одарок, Парасок
    function WomanRule1 : Boolean;
    // Українські жіночі імена, що в називному відмінку однини закінчуються на приголосний,
    // відмінюються як відповідні іменники ІІІ відміни
    function WomanRule2 : Boolean;
    // Якщо слово на ськ або це російське прізвище
    function WomanRule3 : Boolean;

    function ManFirstName : Boolean; override;
    function ManSecondName : Boolean; override;
    function ManFatherName : Boolean; override;

    function WomanFirstName : Boolean; override;
    function WomanSecondName : Boolean; override;
    function WomanFatherName : Boolean; override;
  protected
    function  RulesChain(Gender : TGender; RulesArray : array of Integer) : Boolean; override;
    procedure GenderByFirstName(Word : TWord); override;
    procedure GenderBySecondName(Word : TWord); override;
    procedure GenderByFatherName(Word : TWord); override;
    procedure DetectNamePart(Word : TWord); override;
  end;

implementation

uses SysUtils, StrUtils, ExceptionUnit;

const
   FVowels = 'аеиоуіїєюя';
   FConsonant = 'бвгджзйклмнпрстфхцчшщ';
   FShyplyachi = 'жчшщ';
   FNeshyplyachi = 'бвгдзклмнпрстфхц';
   FMyaki = 'ьюяєї';
   FGubni = 'мвпбф';

function PosRev(const SubStr, S: string; Offset: Cardinal = 1) : integer;
var
  I,X: Integer;
  Len, LenSubStr: Integer;
begin
  I := Offset;
  LenSubStr := Length(SubStr);
  Len := Length(S) - LenSubStr + 2 - i;
  while Len > 0 do
  begin
    if S[Len] = SubStr[1] then
    begin
      X := 1;
      while (X < LenSubStr) and (S[Len + X] = SubStr[X + 1]) do
        Inc(X);
      if (X = LenSubStr) then
      begin
        Result := Len;
        Exit;
      end;
    end;
    Dec(Len);
  end;
  Result := 0;
end;

function Max(A,B : Double) : Double;
begin
  if A > B then
    Result := A
  else
    Result := B;
end;

{ TUaCore }

constructor TUaCore.Create;
begin
  inherited;
  FLanguageBuild := '11071222';
  FCaseCount := 7;
end;

function TUaCore.detect2Group(Word: String): Integer;
var osnova, stack, last_, osnovaEnd : string;
    stacksize : Integer;
begin
  osnova := word;
  stack  := '';
  //Ріжемо слово поки не зустрінемо приголосний і записуемо в стек всі голосні які зустріли
  while (In_(Last(osnova, 1), FVowels + 'ь')) do
  begin
    stack := Last(osnova, 1) + stack;
    SetLength(osnova, Length(osnova) - 1);
  end;

  stacksize := Length(stack);
  last_ := 'Z'; //нульове закінчення
  if (stacksize>0) then
    last_ := stack[1];

  osnovaEnd := Last(osnova, 1);
  if (In_(osnovaEnd, FNeshyplyachi) and not In_(last_, FMyaki)) then
    Result := 1
  else if (In_(osnovaEnd, FShyplyachi) and not In_(last_, FMyaki)) then
    Result := 2
  else
    Result := 3;
end;

procedure TUaCore.DetectNamePart(Word: TWord);
var namepart : string;
    first_, second_, father_,
    max_ : Double;
begin
  namepart := word.Name;
  SetWorkingWord(namepart);
  //Считаем вероятность
  first_  := 0;
  second_ := 0;
  father_ := 0;
  //если смахивает на отчество
  if (In_(Last(3), ['вна', 'чна', 'ліч']) or In_(Last(4), ['ьмич', 'ович'])) then
    father_ := father_+3;
  //Похоже на имя
  if (In_(Last(3), 'тин') or In_(Last(4), ['ьмич', 'юбов', 'івна', 'явка', 'орив', 'кіян'])) then
    first_ := first_+0.5;
  //Исключения
  if (InNames(namepart, ['лев', 'гаїна', 'афіна', 'антоніна', 'ангеліна', 'альвіна',
                         'альбіна', 'аліна', 'павло', 'олесь', 'микола', 'мая',
                         'англеліна', 'елькін', 'мерлін']))
  then
    first_ := first_+10;
  //похоже на фамилию
  if (In_(Last(2), ['ов', 'ін', 'ев', 'єв', 'ий', 'ин', 'ой', 'ко', 'ук', 'як', 'ца',
                    'их', 'ик', 'ун', 'ок', 'ша', 'ая', 'га', 'єк', 'аш', 'ив', 'юк',
                    'ус', 'це', 'ак', 'бр', 'яр', 'іл', 'ів', 'ич', 'сь', 'ей', 'нс',
                    'яс', 'ер', 'ай', 'ян', 'ах', 'ць', 'ющ', 'іс', 'ач', 'уб', 'ох',
                    'юх', 'ут', 'ча', 'ул', 'вк', 'зь', 'уц', 'їн', 'де', 'уз', 'юр',
                    'ік', 'іч', 'ро' ]))
  then
    second_ := second_+0.4;
  if (In_(Last(3), ['ова', 'ева', 'єва', 'тих', 'рик', 'вач', 'аха', 'шен', 'мей',
                    'арь', 'вка', 'шир', 'бан', 'чий', 'іна', 'їна', 'ька', 'ань',
                    'ива', 'аль', 'ура', 'ран', 'ало', 'ола', 'кур', 'оба', 'оль',
                    'нта', 'зій', 'ґан', 'іло', 'шта', 'юпа', 'рна', 'бла', 'еїн',
                    'има', 'мар', 'кар', 'оха', 'чур', 'ниш', 'ета', 'тна', 'зур',
                    'нір', 'йма', 'орж', 'рба', 'іла', 'лас', 'дід', 'роз', 'аба',
                    'чан', 'ган']))
  then
    second_ := second_+0.4;
  if (In_(Last(4), ['ьник', 'нчук', 'тник', 'кирь', 'ский', 'шена', 'шина', 'вина',
                    'нина', 'гана', 'гана', 'хній', 'зюба', 'орош', 'орон', 'сило',
                    'руба', 'лест', 'мара', 'обка', 'рока', 'сика', 'одна', 'нчар',
                    'вата', 'ндар', 'грій']))
  then
    second_ := second_+0.4;
  if (Last(1) = 'і') then
    second_ := second_+0.2;

  max_ := Max(Max(first_, second_), father_);

  if (first_ = max_) then
    Word.NamePart := npFirstName
  else if (second_ = max_) then
    Word.NamePart := npSecondName
  else
    Word.NamePart := npFatherName;
end;

function TUaCore.FirstLastVowel(Word, Vowels: string): string;
var n : Integer;
    Letter : string;
begin
  n := Length(Word);
  Result := '';
  while n >0  do
  begin
    Letter := Word[n];
    if (In_(Letter, Vowels)) then
    begin
      Result := Letter;
      Exit;
    end;
    Dec(n);
  end;
end;

procedure TUaCore.GenderByFatherName(Word: TWord);
begin
  SetWorkingWord(Word.Name);
  if (Last(2) = 'ич') then
    Word.GenderProbability := TGenderProbability.Create(10, 0)  // мужчина
  else if (Last(2) = 'на') then
    Word.GenderProbability := TGenderProbability.Create(0, 12); // женщина
end;

procedure TUaCore.GenderByFirstName(Word: TWord);
var prob : TGenderProbability;
begin
  SetWorkingWord(Word.Name);
  prob := TGenderProbability.Create(0,0);
  //Попробуем выжать максимум из имени
  //Если имя заканчивается на й, то скорее всего мужчина
  if (Last(1) = 'й') then
    prob.ManAdd(0.9);
  if (InNames(FWorkingWord, ['петро', 'микола'])) then
    prob.ManAdd(30);
  if (In_(Last(2), ['он', 'ов', 'ав', 'ам', 'ол', 'ан', 'рд', 'мп', 'ко', 'ло'])) then
    prob.ManAdd(0.5);
  if (In_(Last(3), ['бов', 'нка', 'яра', 'ила', 'опа'])) then
    prob.WomanAdd(0.5);
  if (In_(Last(1), FConsonant)) then
    prob.ManAdd(0.01);
  if (Last(1) = 'ь') then
    prob.ManAdd(0.02);
  if (In_(Last(2), ['дь', 'на'])) then
    prob.WomanAdd(0.1);
  if (In_(Last(3), ['ель'{, 'бов'}])) then
    prob.WomanAdd(0.4);
  word.GenderProbability := prob;
end;

procedure TUaCore.GenderBySecondName(Word: TWord);
var prob : TGenderProbability;
begin
  SetWorkingWord(Word.Name);
  prob := TGenderProbability.Create(0,0);
  if (In_(Last(2), ['ов', 'ин', 'ев', 'єв', 'ін', 'їн', 'ий', 'їв', 'ів', 'ой', 'ей'])) then
    prob.ManAdd(0.4);
  if (In_(Last(3), ['ова', 'ина', 'ева', 'єва', 'іна', 'міна'])) then
    prob.WomanAdd(0.4);
  if (In_(Last(2), 'ая')) then
    prob.WomanAdd(0.4);
  Word.GenderProbability := prob;
end;

function TUaCore.getOsnova(Word: string): string;
begin
  Result := word;
  //Ріжемо слово поки не зустрінемо приголосний
  while (In_(Last(Result, 1), FVowels + 'ь')) do
  begin
    SetLength(Result, Length(Result) - 1);
  end;
end;

function TUaCore.inverse2(Letter: string): string;
begin
  if Letter = 'к' then
    Result := 'ч'
  else if Letter = 'г' then
    Result :=  'ж'
  else
    Result := Letter;
end;

function TUaCore.inverseGKH(Letter: String): string;
begin
  if Letter = 'г' then
    Result := 'з'
  else if Letter = 'к' then
    Result := 'ц'
  else if Letter = 'х' then
    Result := 'с'
  else
    Result := Letter;
end;

function TUaCore.isApostrof(Letter: string): Boolean;
begin
  if In_(Letter, ' ' + FConsonant + FVowels) then
    Result := False
  else
    Result := True;
end;

function TUaCore.ManFatherName: Boolean;
begin
  if (In_(Last(2), ['ич', 'іч'])) then
  begin
    WordForms(FWorkingWord, ['а', 'у', 'а', 'ем', 'у', 'у']);
    Result := True;
  end
  else
    Result := False;
end;

function TUaCore.ManFirstName: Boolean;
begin
  Result := RulesChain(gndMan, [1, 2, 3]);
end;

function TUaCore.ManRule1: Boolean;
var beforeLast : string;
    Buffer : array[0..5] of string;
begin
  //Предпоследний символ
  beforeLast := Last(2, 1);
  //Останні літера або а
  if (Last(1) = 'а') then
  begin
    Buffer[0] := beforeLast + 'и';
    Buffer[1] := inverseGKH(beforeLast) + 'і';
    Buffer[2] := beforeLast + 'у';
    Buffer[3] := beforeLast + 'ою';
    Buffer[4] := inverseGKH(beforeLast) + 'і';
    Buffer[5] := beforeLast + 'о';

    WordForms(FWorkingWord, Buffer, 2);
    Rule(101);
    Result := True;
  end
  //Остання літера я
  else if (Last(1) = 'я') then
  begin
    //Перед останньою літерою стоїть я
    if (beforeLast = 'і') then
    begin
      WordForms(FWorkingWord, ['ї', 'ї', 'ю', 'єю', 'ї', 'є'], 1);
      Rule(102);
      Result := True;
    end
    else begin
      Buffer[0] := beforeLast + 'і';
      Buffer[1] := inverseGKH(beforeLast) + 'і';
      Buffer[2] := beforeLast + 'ю';
      Buffer[3] := beforeLast + 'ею';
      Buffer[4] := inverseGKH(beforeLast) + 'і';
      Buffer[5] := beforeLast + 'е';
      WordForms(FWorkingWord, Buffer, 2);
      Rule(103);
      Result := True;
    end;
  end
  else
    Result := False;
end;

function TUaCore.ManRule2: Boolean;
var osnova : string;
begin
  if (Last(1) = 'р') then
  begin
    if (InNames(FWorkingWord, ['ігор', 'лазар'])) then
    begin
      WordForms(FWorkingWord, ['я', 'еві', 'я', 'ем', 'еві', 'е']);
      Rule(201);
    end
    else begin
      osnova := FWorkingWord;
      if (Last(osnova, 2, 1) = 'і') then
        osnova := Copy(osnova,1, Length(osnova) - 2) + 'о' + Last(osnova, 1);
      WordForms(osnova, ['а', 'ові', 'а', 'ом', 'ові', 'е']);
      Rule(202);
    end;
    Result := True;
  end
  else
    Result := False;
end;

function TUaCore.ManRule3: Boolean;
var beforeLast, osnova, osLast : string;
    group, delim : integer;
    Buffer : array[0..5] of string;
begin
  //Предпоследний символ
  beforeLast := Last(2, 1);
  if (In_(Last(1), FConsonant + 'оь')) then
  begin
    group := detect2Group(FWorkingWord);
    osnova := getOsnova(FWorkingWord);
    //В іменах типу Антін, Нестір, Нечипір, Прокіп, Сидір, Тиміш, Федір голосний і виступає тільки в
    //називному відмінку, у непрямих - о: Антона, Антонові
    //Чергування і -» о всередині
    osLast := Last(osnova, 1);
    if ((osLast <> 'й') and (Last(osnova, 2, 1) = 'і') and
         not In_(Last(osnova, 4), ['світ', 'цвіт']) and
         not InNames(FworkingWord, 'гліб') and
         not In_(Last(2), ['ік', 'іч']))
    then
      osnova := Copy(osnova,1, Length(osnova) - 2) + 'о' + Last(osnova, 1);
    //Випадання букви е при відмінюванні слів типу Орел
    if ((osnova <> '') and (Copy(osnova,1,1)= 'о') and
        (FirstLastVowel(osnova, FVowels + 'гк') = 'е') and
        (Last(2) <> 'сь'))
    then begin
      delim := PosRev('е', osnova);
      osnova := Copy(osnova,1, delim) + Copy(osnova, delim + 1, Length(osnova) - delim);
    end;

    if (group = 1) then
    begin
      //Тверда група
      //Слова що закінчуються на ок
      if (Last(2) = 'ок') and (Last(3) <> 'оок') then
      begin
        WordForms(FWorkingWord, ['ка', 'кові', 'ка', 'ком', 'кові', 'че'], 2);
        Rule(301);
        Result := True;
      end
      //Російські прізвища на ов, ев, єв
      else if (In_(Last(2), ['ов', 'ев', 'єв'])) and not InNames(FWorkingWord, ['лев', 'остромов']) then
      begin
        Buffer[0] := osLast + 'а';
        Buffer[1] := osLast + 'у';
        Buffer[2] := osLast + 'а';
        Buffer[3] := osLast + 'им';
        Buffer[4] := osLast + 'у';
        Buffer[5] := inverse2(osLast) + 'е';
        WordForms(osnova, Buffer, 1);
        Rule(302);
        Result := True;
      end
      //Російські прізвища на ін
      else if (In_(Last(2), ['ін'])) then
      begin
        WordForms(FWorkingWord, ['а', 'у', 'а', 'ом', 'у', 'е']);
        Rule(303);
        Result := True;
      end
      else begin
        Buffer[0] := osLast + 'а';
        Buffer[1] := osLast + 'ові';
        Buffer[2] := osLast + 'а';
        Buffer[3] := osLast + 'ом';
        Buffer[4] := osLast + 'ові';
        Buffer[5] := inverse2(osLast) + 'е';
        WordForms(osnova, Buffer, 1);
        Rule(304);
        Result := true;
      end
    end
    else if (group = 2) then
    begin
      //Мішана група
      WordForms(osnova, ['а', 'еві', 'а', 'ем', 'еві', 'е']);
      Rule(305);
      Result := true;
    end
    else if (group = 3) then
    begin
      //М’яка група
      //Соловей
      if (Last(2) = 'ей') and In_(Last(3, 1), FGubni) then
      begin
        osnova := Copy(FWorkingWord,1, Length(FWorkingWord) - 2) + '’';
        WordForms(osnova, ['я', 'єві', 'я', 'єм', 'єві', 'ю']);
        Rule(306);
        Result := true;
      end
      else if (Last(1) = 'й') or (beforeLast = 'і') then
      begin
        WordForms(FWorkingWord, ['я', 'єві', 'я', 'єм', 'єві', 'ю'], 1);
        Rule(307);
        Result := true;
      end
      //Швець
      else if (FWorkingWord = 'швець') then
      begin
        WordForms(FWorkingWord, ['евця', 'евцеві', 'евця', 'евцем', 'евцеві', 'евцю'], 4);
        Rule(308);
        Result := true;
      end
      //Слова що закінчуються на ець
      else if (Last(3) = 'ець') then
      begin
        WordForms(FWorkingWord, ['ця', 'цеві', 'ця', 'цем', 'цеві', 'цю'], 3);
        Rule(309);
        Result := True;
      end
      //Слова що закінчуються на єць яць
      else if (In_(Last(3), ['єць', 'яць'])) then
      begin
        WordForms(FWorkingWord, ['йця', 'йцеві', 'йця', 'йцем', 'йцеві', 'йцю'], 3);
        Rule(310);
        Result := true;
      end
      else begin
        WordForms(osnova, ['я', 'еві', 'я', 'ем', 'еві', 'ю']);
        Rule(311);
        Result := true;
      end;
    end
    else
      Result := False;
  end
  else
    Result := false;
end;

function TUaCore.ManRule4: Boolean;
begin
  if (Last(1) = 'і') then
  begin
    WordForms(FWorkingWord, ['их', 'им', 'их', 'ими', 'их', 'і'], 1);
    Rule(4);
    Result := true;
  end
  else
    Result := false;
end;

function TUaCore.ManRule5: Boolean;
begin
  if (In_(Last(2), ['ий', 'ой'])) then
  begin
    WordForms(FWorkingWord, ['ого', 'ому', 'ого', 'им', 'ому', 'ий'], 2);
    Rule(5);
    Result := true;
  end
  else
    Result := false;
end;

function TUaCore.ManSecondName: Boolean;
begin
  Result := RulesChain(gndMan, [5, 1, 2, 3, 4]);
end;

function TUaCore.RulesChain(Gender: TGender;
  RulesArray: array of Integer): Boolean;
var i, n : integer;
    r : Byte;
begin
  Result := False;

  if Assigned(SimpleExceptList) then
  begin
    Result := SimpleExceptList.CheckWord(FWorkingWord, 2, 0);
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
        end;
        if Result then
          Exit;
      end;
  else
    Result := inherited RulesChain(Gender, RulesArray);
  end;
end;

function TUaCore.WomanFatherName: Boolean;
begin
  if (In_(Last(3), ['вна'])) then
  begin
    WordForms(FWorkingWord, ['и', 'і', 'у', 'ою', 'і', 'о'], 1);
    Result := True;
  end
  else
    Result := false;
end;

function TUaCore.WomanFirstName: Boolean;
begin
  Result := RulesChain(gndWoman, [1, 2]);
end;

function TUaCore.WomanRule1: Boolean;
var beforeLast, osnova : string;
    Buffer : array[0..5] of String;
begin
  //Предпоследний символ
  beforeLast := Last(2, 1);
  //Якщо закінчується на ніга -» нога
  if (Last(4) = 'ніга') then
  begin
    osnova := Copy(FWorkingWord,1,Length(FWorkingWord) - 3) + 'о';
    WordForms(osnova, ['ги', 'зі', 'гу', 'гою', 'зі', 'го']);
    Rule(101);
    Result := true;
  end
  //Останні літера або а
  else if (Last(1) = 'а') then
  begin
    Buffer[0] := beforeLast + 'и';
    Buffer[1] := inverseGKH(beforeLast) + 'і';
    Buffer[2] := beforeLast + 'у';
    Buffer[3] := beforeLast + 'ою';
    Buffer[4] := inverseGKH(beforeLast) + 'і';
    Buffer[5] := beforeLast + 'о';
    WordForms(FWorkingWord, Buffer, 2);
    Rule(102);
    Result := true;
  end
  //Остання літера я
  else if (Last(1) = 'я') then
  begin
    if (In_(beforeLast, FVowels) or isApostrof(beforeLast)) then
    begin
      WordForms(FWorkingWord, ['ї', 'ї', 'ю', 'єю', 'ї', 'є'], 1);
      Rule(103);
      Result := true;
    end
    else begin
      Buffer[0] := beforeLast + 'і';
      Buffer[1] := inverseGKH(beforeLast) + 'і';
      Buffer[2] := beforeLast + 'ю';
      Buffer[3] := beforeLast + 'ею';
      Buffer[4] := inverseGKH(beforeLast) + 'і';
      Buffer[5] := beforeLast + 'е';
      WordForms(FWorkingWord, Buffer, 2);
      Rule(104);
      Result := true;
    end
  end
  else
    Result := false;
end;

function TUaCore.WomanRule2: Boolean;
var osnova, apostrof, duplicate,
    osLast, osbeforeLast : string;
begin
  if (In_(Last(1), FConsonant + 'ь')) then
  begin
    osnova := getOsnova(FWorkingWord);
    apostrof := '';
    duplicate := '';
    osLast := Last(osnova, 1);
    osbeforeLast := Last(osnova, 2, 1);
    //Чи треба ставити апостроф
    if (In_(osLast, 'мвпбф') and (In_(osbeforeLast, FVowels))) then
      apostrof := '’';
    //Чи треба подвоювати
    if (In_(osLast, 'дтзсцлн')) then
      duplicate := osLast;
    //Відмінюємо
    if (Last(1) = 'ь') then
    begin
      WordForms(osnova, ['і', 'і', 'ь', duplicate + apostrof + 'ю', 'і', 'е']);
      Rule(201);
      Result := true;
    end
    else begin
      WordForms(osnova, ['і', 'і', '', duplicate + apostrof + 'ю', 'і', 'е']);
      Rule(202);
      Result := true;
    end;
  end
  else
    Result := False;
end;

function TUaCore.WomanRule3: Boolean;
var beforeLast : string;
    Buffer : array[0..5] of string;
begin
  //Предпоследний символ
  beforeLast := Last(2, 1);
  //Донская
  if (Last(2) = 'ая') then
  begin
    WordForms(FworkingWord, ['ої', 'ій', 'ую', 'ою', 'ій', 'ая'], 2);
    Rule(301);
    Result := true;
  end
  //Ті що на ськ
  else if (Last(1) = 'а') and (In_(Last(2, 1), 'чнв') or In_(Last(3, 2), ['ьк'])) then
  begin
    Buffer[0] := beforeLast + 'ої';
    Buffer[1] := beforeLast + 'ій';
    Buffer[2] := beforeLast + 'у';
    Buffer[3] := beforeLast + 'ою';
    Buffer[4] := beforeLast + 'ій';
    Buffer[5] := beforeLast + 'а';
    WordForms(FworkingWord, Buffer, 2);
    Rule(302);
    Result := true;
  end
  else
    Result := false;
end;

function TUaCore.WomanSecondName: Boolean;
begin
  Result := RulesChain(gndWoman, [3, 1]);
end;

end.
