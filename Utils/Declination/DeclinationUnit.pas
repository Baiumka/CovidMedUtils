unit DeclinationUnit;

interface
uses Classes;

type
  TGender = (gndNull, gndMan, gndWoman);

  TProbability = record
    X,Y : Double;
  end;

  TGenderProbability = class
  private
    FProbability : TProbability;
  public
    constructor Create(); overload;
    constructor Create(const X,Y : Double); overload;
    procedure Add(XY : TProbability); overload;
    procedure Add(P : TGenderProbability); overload;
    procedure ManAdd(X : Double);
    procedure WomanAdd(Y : Double);
    property Man : Double  read FProbability.X write FProbability.X;
    property Woman : Double  read FProbability.Y write FProbability.Y;
  end;

  TLettersMask = (lmSmall, lmBig);

  TNamePart = (npNull, npFirstName, npSecondName, npFatherName);

  TPadeg = (IMENITLN, RODITLN, DATELN, VINITELN, TVORITELN, PREDLOGN, Klychnyi
            // UaNazyvnyi, UaRodovyi, UaDavalnyi, UaZnahidnyi, UaOrudnyi, UaMiszevyi , UaKlychnyi
           );

  TWord = class
  private
    FWord : string;
    FNamePart : TNamePart;
    FGenderProbability : TGenderProbability;
    FGenderSolved : TGender;
    FLetterMask : array of TLettersMask;
    FisUpperCase : Boolean;
    FNameCases : TStringList;
    FRule : Integer;
    procedure GenerateMask(Word : string);
    procedure ReturnMask();
    function GetGender: TGender;
  public
    constructor Create(Word : string);
    destructor Destroy; override;
    function GetNameCase(Padeg : TPadeg) : string;
    function IsGenderSolved : Boolean;
    property Gender : TGender read GetGender write FGenderSolved;
    property NamePart : TNamePart read FNamePart write FNamePart;
    property Name : string read FWord;
    property Rule : Integer read FRule write FRule;
    property GenderProbability : TGenderProbability read FGenderProbability write FGenderProbability;
  end;

  TWordsArray = class(TList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    function GetWord(id : integer): TWord;
    function GetByNamePart(NamePart : TNamePart) : TWord;
  end;

  TCore = class
  protected
    FVersion : string;
    FLanguageBuild : string;
    FWorkingWord : string;
  private
    FReady, FFinished : Boolean;
    FWordsArray : TWordsArray;

    //FWorkindLastCache : TStringList;
    FLastRule : Integer;
    //function GetFatherNameCase(CaseNum: TPadeg): TStringList;
    //function GetFirstNameCase(CaseNum: TPadeg): TStringList;
    //function GetSecondNameCase(CaseNum: TPadeg): TStringList;
  protected
    FLastResult : TStringList;
    FCaseCount : Integer;
  public
    constructor Create;
    destructor Destroy; override;
  private
    procedure Reset();
    procedure NotReady();
  public
    procedure FullReset();
  protected
    procedure Rule(RuleId : integer);
    function  GetRule : Integer;
    procedure SetWorkingWord(Word : string);
    procedure MakeResultTheSame();
    function  Last(l : integer) : string; overload;
    function  Last(Word : string; l : integer) : string; overload;
    function  Last(l, StopAfter : integer) : string; overload;
    function  Last(Word : string; l, StopAfter : integer) : string; overload;
    function  In_(Needle, Letters : string) : Boolean; overload;
    function  In_(Needle : string; HayStack : array of string) : Boolean; overload;
    function  InNames(Needle, Name : string) : Boolean; overload;
    function  InNames(Needle : string; Names : array of string) : Boolean; overload;
    procedure WordForms(Word : string; Endings : array of string; Replacelast : integer = 0);
  protected
    function  RulesChain(Gender : TGender; RulesArray : array of Integer) : Boolean; virtual;
  public
    procedure SetFirstName(Name : string);
    procedure SetSecondName(Name : string);
    procedure SetFatherName(Name : string);
    procedure SetGender(Gender : TGender);
    procedure SetFullName(SecondName,FirstName, FatherName : string);
    procedure SetName(Name : string);
    procedure SetLastName(Name : string);
    procedure SetSirName(Name : String);
  private
    procedure PrepareNamePart(Word : TWord);
    procedure PrepareAllNameParts;
    procedure PrepareGender(Word : TWord);
    procedure SolveGender();
    procedure PrepareEverything();
  public
    function  GenderAutoDetect : TGender;
    procedure SplitFullName(FullName : string);
  protected
    procedure WordCase(Word : TWord);
    procedure AllWordCases();
  public
    function GetFirstNameCase() : TStringList; overload;
    function GetFirstNameCase(CaseNum : TPadeg) : string; overload;
    function GetSecondNameCase() : TStringList; overload;
    function GetSecondNameCase(CaseNum : TPadeg) : string; overload;
    function GetFatherNameCase() : TStringList; overload;
    function GetFatherNameCase(CaseNum : TPadeg) : string; overload;
  protected
    procedure DetectNamePart(Word : TWord); dynamic; abstract;
    procedure GenderByFirstName(Word : TWord); dynamic; abstract;
    procedure GenderBySecondName(Word : TWord); dynamic; abstract;
    procedure GenderByFatherName(Word : TWord); dynamic; abstract;
  public
    function QFirstName(Name : string; Gender : TGender = gndNull) : TStringList; overload;
    function QFirstName(Name : string; CaseNum : TPadeg; Gender : TGender = gndNull) : string; overload;
    function QSecondName(Name : string; Gender : TGender = gndNull) : TStringList; overload;
    function QSecondName(Name : string; CaseNum : TPadeg; Gender : TGender = gndNull) : string; overload;
    function QFatherName(Name : string; Gender : TGender = gndNull) : TStringList; overload;
    function QFatherName(Name : string; CaseNum : TPadeg; Gender : TGender = gndNull) : string; overload;
  private
    function ConnectedCase(CaseNum : TPadeg) : string; overload;
    function ConnectedCase : TStringList; overload;
  public
    function Q(FullName : string; Gender : TGender = gndNull) : TStringList; overload;
    function Q(FullName : string; CaseNum : TPadeg; Gender : TGender = gndNull) : string; overload;
    function FIO(FullName : string; Gender : TGender = gndNull) : TStringList; overload;
    function FIO(FullName : string; CaseNum : TPadeg; Gender : TGender = gndNull) : string; overload;
    function GetWordsArray : TWordsArray;
  protected
    function CallNameFunc(Gender : TGender; NamePart : TNamePart) : Boolean;
    function ManFirstName : Boolean; virtual; abstract;
    function ManSecondName : Boolean; virtual; abstract;
    function ManFatherName : Boolean; virtual; abstract;
    function WomanFirstName : Boolean; virtual; abstract;
    function WomanSecondName : Boolean; virtual; abstract;
    function WomanFatherName : Boolean; virtual; abstract;
  public
    property Version : string read FVersion;
    property LanguageVersion : string read FLanguageBuild;
  end;
implementation

uses SysUtils;

function Min_(A,B : integer) : Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;

{ TGenderProbability }

constructor TGenderProbability.Create;
begin
  FProbability.X := 0;
  FProbability.Y := 0;
end;

procedure TGenderProbability.Add(XY: TProbability);
begin
  FProbability.X := FProbability.X + XY.X;
  FProbability.Y := FProbability.Y + XY.Y;
end;

constructor TGenderProbability.Create(const X, Y: Double);
begin
  FProbability.X := X;
  FProbability.Y := Y;
end;

procedure TGenderProbability.Add(P : TGenderProbability);
begin
  if P <> nil then
    Add(P.FProbability);
end;

procedure TGenderProbability.ManAdd(X: Double);
begin
  FProbability.X := FProbability.X + X;
end;

procedure TGenderProbability.WomanAdd(Y: Double);
begin
  FProbability.Y := FProbability.Y + Y;
end;

{ TWord }

constructor TWord.Create(Word: string);
begin
  FNamePart := npNull;
  FGenderSolved := gndNull;
  GenerateMask(Word);
  FWord := AnsiLowerCase(Word);
  FNameCases := TStringList.Create;
end;

destructor TWord.Destroy;
begin
  FreeAndNil(FNameCases);
  FreeAndNil(FGenderProbability);
  SetLength(FLetterMask,0);
  inherited;
end;

procedure TWord.GenerateMask(Word: string);
var n, i : Integer;
    c : Char;
begin
  FisUpperCase := True;
  n := Length(Word);
  SetLength(FLetterMask, n);
  for i := 1 to n do
  begin
     c := Word[i];
     if AnsiLowerCase(c) = c then
     begin
       FisUpperCase   := False;
       FLetterMask[i-1] := lmSmall;
     end
     else
       FLetterMask[i-1] := lmBig;
  end;
end;

function TWord.GetGender: TGender;
begin
  if (FGenderSolved = gndNull) and (FGenderProbability <> nil) then
  begin
    if FGenderProbability.Man >= FGenderProbability.Woman then
      FGenderSolved := gndMan
    else
      FGenderSolved := gndWoman;
  end;
  Result := FGenderSolved;
end;

function TWord.GetNameCase(Padeg: TPadeg): string;
begin
  Result := FNameCases.Strings[Integer(Padeg)];
end;

function TWord.IsGenderSolved: Boolean;
begin
  Result := (Gender <> gndNull);
end;

procedure TWord.ReturnMask;
var n,i, m, l, k : Integer;
    s : string;
begin
  n := FNameCases.Count;
  if FisUpperCase then
  begin
    for i := 0 to n-1 do
      FNameCases.Strings[i] := AnsiUpperCase(FNameCases.Strings[i]);
  end
  else begin
    k := Length(FLetterMask);
    for i := 0 to n-1 do
    begin
      s := FNameCases.Strings[i];
      m := Length(s);
      m := Min_(m,k);
      for l := 1 to m do
        if (FLetterMask[l-1] = lmBig) then
          s[l] := AnsiUpperCase(s[l])[1];
      FNameCases.Strings[i] := s;
    end;
  end;
end;

{ TWordArray }

procedure TWordsArray.Notify(Ptr: Pointer; Action: TListNotification);
var W : TWord;
begin
  if Action = lnDeleted then
  begin
    W := TWord(Ptr);
    FreeAndNil(W);
  end;
end;

function TWordsArray.GetByNamePart(NamePart: TNamePart): TWord;
var i,n : Integer;
begin
  Result := nil;
  n := Count;
  for i := 0 to n - 1 do
  begin
    if GetWord(i).NamePart = NamePart then
      Result := GetWord(i);
  end;
  if Result = nil then
  begin
    Result := TWord.Create('');
    Result.NamePart := NamePart;
    Add(Result);
  end;
end;

function TWordsArray.GetWord(id: integer): TWord;
begin
  Result := TWord(Items[id]);
end;

{ TCore }

procedure TCore.FullReset;
begin
  FWordsArray.Clear;
  Reset;
  NotReady;
end;

function TCore.GetRule: Integer;
begin
  Result := FLastRule;
end;

function TCore.Last(l: integer): string;
var i : Integer;
begin
  Result := '';
  if Result = '' then
  begin
    i := Length(FWorkingWord) - l+1;
    if i > 1 then
      Result := Copy(FWorkingWord, i, l)
    else
      Result := FWorkingWord;
    //workindLastCache.Push(result, length, length);
  end;
end;

function TCore.Last(Word: string; l: integer): string;
var i : Integer;
begin
  i := Length(Word) - l+1;
  if i > 1 then
    Result := Copy(Word, i, l)
  else
    Result := Word;
end;

function TCore.Last(l, StopAfter: integer): string;
var i : Integer;
begin
  Result := '';//workindLastCache.Get(length, stopAfter);
  if (Result = '') then
  begin
    i := Length(FWorkingWord) - l + 1;
    if (i > 1) then
      Result := Copy(FWorkingWord, i, stopAfter)
    else
      Result := FWorkingWord;
    // workindLastCache.Push(result, length, stopAfter);
  end;
end;

function TCore.In_(Needle, Letters: string): Boolean;
begin
  Result := (Needle <> '') and (Pos(Needle, Letters) > 0);
end;

function TCore.Last(Word: string; l, StopAfter: integer): string;
var i : Integer;
begin
  i := Length(Word) - l + 1;
  if (i > 1) then
    Result := Copy(Word, i, stopAfter)
  else
    Result := Word;
end;

procedure TCore.MakeResultTheSame;
var i : Integer;
begin
  FLastResult.Clear;
  for i := 1 to FCaseCount do
    FLastResult.Add(FWorkingWord);
end;

procedure TCore.NotReady;
begin
  FReady    := False;
  FFinished := False;
end;

procedure TCore.Reset;
begin
  FLastRule := 0; 
  FLastResult.Clear; 
end;

procedure TCore.Rule(RuleId: integer);
begin
  FLastRule := RuleId;
end;

function TCore.RulesChain(Gender: TGender;
  RulesArray: array of Integer): Boolean;
begin
  Result := False;
end;

procedure TCore.SetWorkingWord(Word: string);
begin
  Reset();
  FWorkingWord := Word;
  //fworkindLastCache = new LastCache();
end;

function TCore.In_(Needle: string; HayStack: array of string): Boolean;
var i,n : Integer;
begin
  Result := False;
  if Needle <> '' then
  begin
    n := Length(HayStack) - 1;
    for i := 0 to n do
      if Needle = HayStack[i] then
      begin
        Result := True;
        Exit;
      end;
  end;
end;

function TCore.InNames(Needle, Name: string): Boolean;
begin
  Result := (Needle = Name);
end;

function TCore.InNames(Needle: string; Names: array of string): Boolean;
var i,n : Integer;
begin
  Result := False;
  n := Length(Names) - 1;
  for i := 0 to n do
    if Needle = Names[i] then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TCore.WordForms(Word: string; Endings: array of string;
  Replacelast: integer = 0);
var n, i : integer;
begin
  FLastResult.Clear;
  FLastResult.Add(FWorkingWord);
  n := Length(Word);
  if (n > Replacelast) then
    //убираем лишние буквы
    Word := Copy(Word, 1, n - Replacelast)
  else 
    Word := '';
  //ѕриписуем окончани€
  for i := 2 to FCaseCount do
    FLastResult.Add(Word + Endings[i - 2]);
end;

procedure TCore.SetFirstName(Name: string);
var Word : TWord;
begin
  if Trim(Name) <> '' then
  begin
    Word := TWord.Create(Name);
    Word.NamePart := npFirstName;
    FWordsArray.Add(Word);
    NotReady;
  end;
end;

procedure TCore.SetFatherName(Name: string);
var Word : TWord;
begin
  if Trim(Name) <> '' then
  begin
    Word := TWord.Create(Name);
    Word.NamePart := npFatherName;
    FWordsArray.Add(Word);
    NotReady;
  end;
end;

procedure TCore.SetSecondName(Name: string);
var Word : TWord;
begin
  if Trim(Name) <> '' then
  begin
    Word := TWord.Create(Name);
    Word.NamePart := npSecondName;
    FWordsArray.Add(Word);
    NotReady;
  end;
end;

procedure TCore.SetGender(Gender: TGender);
var i,n : Integer;
begin
  n := FWordsArray.Count - 1;
  for i := 0 to n do
  begin
    FWordsArray.GetWord(i).Gender := Gender;
  end;
end;

procedure TCore.SetFullName(SecondName, FirstName, FatherName: string);
begin
  SetFirstName(FirstName);
  SetSecondName(SecondName);
  SetFatherName(FatherName);
end;

procedure TCore.SetLastName(Name: string);
begin
  SetSecondName(Name);
end;

procedure TCore.SetName(Name: string);
begin
  SetFirstName(Name);
end;

procedure TCore.SetSirName(Name: String);
begin
  SetSecondName(Name);
end;

procedure TCore.PrepareNamePart(Word: TWord);
begin
  if Word.Gender = gndNull then
    DetectNamePart(Word);
end;

procedure TCore.PrepareAllNameParts;
var i,n : Integer;
begin
  n := FWordsArray.Count - 1 ;
  for i := 0 to n do
    PrepareNamePart(FWordsArray.GetWord(i));
end;

procedure TCore.PrepareGender(Word: TWord);
begin
  if not Word.IsGenderSolved then
  begin
    case Word.NamePart of
      npFirstName:  GenderByFirstName(Word);
      npSecondName: GenderBySecondName(Word);
      npFatherName: GenderByFatherName(Word);
    end;
  end;
end;

procedure TCore.SolveGender;
var i,n : Integer;
    p : TGenderProbability;
    Word : TWord;
begin
  n := FWordsArray.Count - 1;
  for i := 0 to n do
    if FWordsArray.GetWord(i).IsGenderSolved then
    begin
      SetGender(FWordsArray.GetWord(i).Gender);
      Exit;
    end;
  p := TGenderProbability.Create(0,0);
  for i := 0 to n do
  begin
    Word := FWordsArray.GetWord(i);
    PrepareGender(Word);
    p.Add(Word.FGenderProbability);
  end;
  if p.Man >= p.Woman then
    SetGender(gndMan)
  else
    SetGender(gndWoman);
end;

procedure TCore.PrepareEverything;
begin
  if not FReady then
  begin
    PrepareAllNameParts;
    SolveGender;
    FReady := True;
  end;
end;

function TCore.GenderAutoDetect: TGender;
begin
  PrepareEverything();
  if (FWordsArray.Count > 0) then
    Result := FWordsArray.GetWord(0).Gender
  else
    Result := gndNull;
end;

procedure TCore.SplitFullName(FullName: string);
var SL : TStringList;
    i, n : Integer;
begin
  SL := TStringList.Create;
  try
    SL.Delimiter := ' ';
    SL.DelimitedText := Trim(FullName);

    FWordsArray.Clear;
    n := SL.Count - 1;
    for i := 0  to n do
    begin
      if SL.Strings[i] <> '' then
        FWordsArray.Add(TWord.Create(SL.Strings[i]));
    end;
  finally
    SL.Free;
  end;
end;

procedure TCore.WordCase(Word: TWord);
begin
  SetWorkingWord(Word.Name);
  if CallNameFunc(Word.Gender, Word.NamePart) then
  begin
    Word.FNameCases.AddStrings(FLastResult);
    Word.Rule := FLastRule;
  end
  else begin
    MakeResultTheSame;
    Word.FNameCases.Assign(FLastResult);
    Word.Rule := -1;
  end;
end;

procedure TCore.AllWordCases;
var i, n : Integer;
begin
  if (not FFinished) then
  begin
    PrepareEverything();
    n := FWordsArray.Count - 1;

    for i := 0 to n do
    begin
      WordCase(FWordsArray.GetWord(i));
      FWordsArray.GetWord(i).ReturnMask;
    end;

    FFinished := True;
  end;
end;

function TCore.GetFatherNameCase: TStringList;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npFatherName).FNameCases;
end;

function TCore.GetFirstNameCase: TStringList;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npFirstName).FNameCases;
end;

function TCore.GetSecondNameCase: TStringList;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npSecondName).FNameCases;
end;

function TCore.GetFatherNameCase(CaseNum: TPadeg): string;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npFatherName).GetNameCase(CaseNum);
end;

function TCore.GetFirstNameCase(CaseNum: TPadeg): string;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npFirstName).GetNameCase(CaseNum);
end;

function TCore.GetSecondNameCase(CaseNum: TPadeg): string;
begin
  AllWordCases();
  Result := FWordsArray.GetByNamePart(npSecondName).GetNameCase(CaseNum);
end;

function TCore.QFirstName(Name: string; Gender: TGender): TStringList;
begin
  FullReset();
  SetFirstName(Name);
  if (Gender <> gndNull) then
    SetGender(Gender);
  Result  := GetFirstNameCase();
end;

function TCore.QFirstName(Name: string; CaseNum: TPadeg;
  Gender: TGender): string;
begin
  FullReset();
  SetFirstName(Name);
  if (Gender <> gndNull) then
    SetGender(gender);
  Result := GetFirstNameCase(CaseNum);
end;

function TCore.QSecondName(Name: string; Gender: TGender): TStringList;
begin
  FullReset();
  SetSecondName(Name);
  if (Gender <> gndNull) then
    SetGender(Gender);
  Result  := GetSecondNameCase();
end;

function TCore.QSecondName(Name: string; CaseNum: TPadeg;
  Gender: TGender): string;
begin
  FullReset();
  SetSecondName(Name);
  if (Gender <> gndNull) then
    SetGender(gender);
  Result := GetSecondNameCase(CaseNum);
end;

function TCore.QFatherName(Name: string; Gender: TGender): TStringList;
begin
  FullReset();
  SetFatherName(Name);
  if (Gender <> gndNull) then
    SetGender(Gender);
  Result  := GetFirstNameCase();
end;

function TCore.QFatherName(Name: string; CaseNum: TPadeg;
  Gender: TGender): string;
begin
  FullReset();
  SetFatherName(Name);
  if (Gender <> gndNull) then
    SetGender(gender);
  Result := GetFatherNameCase(CaseNum);
end;

function TCore.ConnectedCase(CaseNum: TPadeg): string;
var i, n : Integer;
begin
  Result := '';
  n := FWordsArray.Count - 1;
  for i := 0 to n do
    result := Result + FWordsArray.GetWord(i).GetNameCase(CaseNum) + ' ';
  Result := Trim(Result);
end;

function TCore.ConnectedCase: TStringList;
var i, n : Integer;
begin
  Result := TStringList.Create;
  n := FCaseCount - 1;
  for i := 0 to n do
    Result.Add(ConnectedCase(TPadeg(i)));
end;

function TCore.Q(FullName: string; Gender: TGender): TStringList;
begin
  FullReset();
  SplitFullName(fullName);
  if (Gender <> gndNull) then
    SetGender(Gender);
  AllWordCases();
  Result := ConnectedCase();
end;

function TCore.Q(FullName: string; CaseNum: TPadeg;
  Gender: TGender): string;
begin
  FullReset();
  SplitFullName(FullName);
  if (Gender <> gndNull) then
    SetGender(Gender);
  AllWordCases();
  Result := ConnectedCase(CaseNum);
end;

function TCore.GetWordsArray: TWordsArray;
begin
  Result := FWordsArray;
end;

constructor TCore.Create;
begin
  FReady := False;
  FFinished := False;
  FWordsArray := TWordsArray.Create;
  FLastResult := TStringList.Create;
end;

destructor TCore.Destroy;
begin
  FLastResult.Clear;
  FreeAndNil(FLastResult);
  FreeAndNil(FWordsArray);
  inherited;
end;

function TCore.CallNameFunc(Gender: TGender; NamePart: TNamePart): Boolean;
begin
  Result := False;
  if (Gender = gndNull) or (NamePart = npNull) then Exit;
  case Gender of
    gndMan:
      case NamePart of
        npFirstName  : Result := ManFirstName;
        npSecondName : Result := ManSecondName;
        npFatherName : Result := ManFatherName;
      end;
    gndWoman:
      case NamePart of
        npFirstName  : Result := WomanFirstName;
        npSecondName : Result := WomanSecondName;
        npFatherName : Result := WomanFatherName;
      end;
  end;
end;

function TCore.FIO(FullName: string; Gender: TGender): TStringList;
begin
  FullReset();
  SplitFullName(fullName);
  FWordsArray.GetWord(0).NamePart := npSecondName;
  if FWordsArray.Count > 1 then
    FWordsArray.GetWord(1).NamePart := npFirstName;
  if FWordsArray.Count > 2 then
    FWordsArray.GetWord(2).NamePart := npFatherName;
  if (Gender <> gndNull) then
    SetGender(Gender);
  AllWordCases();
  Result := ConnectedCase();
end;

function TCore.FIO(FullName: string; CaseNum: TPadeg;
  Gender: TGender): string;
begin
  FullReset();
  SplitFullName(fullName);
  if FWordsArray.Count > 0 then
    FWordsArray.GetWord(0).NamePart := npSecondName;
  if FWordsArray.Count > 1 then
    FWordsArray.GetWord(1).NamePart := npFirstName;
  if FWordsArray.Count > 2 then
    FWordsArray.GetWord(2).NamePart := npFatherName;
  if (Gender <> gndNull) then
    SetGender(Gender);
  AllWordCases();
  Result := ConnectedCase(CaseNum);
end;

end.
