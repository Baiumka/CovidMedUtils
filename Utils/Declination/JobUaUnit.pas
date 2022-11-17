unit JobUaUnit;

interface
uses Classes, SysUtils, ValueListUnit;

  function DeclWord(AWord, Sex: string; var IsJob: byte; Pages: byte = 2;
    Country: string = 'UA'; FIO: string = ''; PartOfSpeech: string = '';
    ExceptName: string = 'СклонениеИсключения'): string;

  function WordToList(Value : String): TValueList;

  function ToJob(Job, Dept, Sex: String; Pages: Byte = 2; Country: String = 'UA'): String;

  procedure LoadExceptList;

implementation

uses Math, IniFiles, Forms, ExceptionUnit;

function declGlasnay(C : string; Country: string = 'UA'): Byte;
begin
  Result := ord(not ((Length(C) = 0) or (Pos(C, 'аеёиоуэыюяіїє''`"') = 0)));
end;

// Возвращает гласные в конце слова,
// Изменяет СловоБезОкончания
function declWordEnds(tWord: string; var eWord: string; Country: string = 'UA'): String;
var
  n: Integer;
  k: Integer;
  c: String;
begin
	Result := '';
	n := Length(tWord);
	For k := -n to -1 do
  begin
		c := Copy(tWord, -k, 1);
		If declGlasnay(c, Country) = 1 then begin
			Result := c + Result;
		end else begin
      Break;
		end;
	end;
	eWord := Copy(tWord, 1, Length(tWord) - Length(Result));
end;

function declReturnReg(rWord, oWord: string): string;
begin
	//Поз = Найти(ИсхСлово, '.');
	//If Поз > 0 then begin
	//	врИсхСлово = ИсхСлово;
	//	врРезСлово = РезСлово;
	//	врСлово = '';
	//	Поз = Найти(врИсхСлово, '.');
	//	While (Поз > 0) and (Поз <= СтрДлина(врРезСлово)) and (Поз <= СтрДлина(врИсхСлово)) do begin
	//		БукваПослеТочкиИсх = Сред(врИсхСлово, Поз+1, 1);
	//		БукваПослеТочкиРез = Сред(врРезСлово, Поз+1, 1);
	//		If (Нрег(БукваПослеТочкиИсх) = Нрег(БукваПослеТочкиРез)) then begin
	//			врСлово = врСлово + Лев(врРезСлово, Поз) + БукваПослеТочкиИсх;
	//		end else begin
	//			врСлово = врСлово + Лев(врРезСлово, Поз) + БукваПослеТочкиРез;
	//		end;
	//		врРезСлово = Сред(врРезСлово, Поз + 2);
	//		врИсхСлово = Сред(врИсхСлово, Поз + 2);
	//		Поз = Найти(врИсхСлово, '.');
	//	end;
	//	РезСлово = врСлово + врРезСлово;
	//end;
	If oWord = AnsiUpperCase(oWord) then begin
		Result := AnsiUpperCase(rWord);
		//If СтрДлина(РезСлово) > СтрДлина(oWord) then begin
		//Возврат(Врег(Лев(РезСлово, СтрДлина(oWord)))+Сред(РезСлово, СтрДлина(oWord) + 1)); // For поддержки аббревиатур
	end else if AnsiUpperCase(Copy(oWord, 1, 1)) = Copy(oWord, 1, 1) then begin
		Result := AnsiUpperCase(Copy(rWord,1, 1)) + Copy(rWord, 2, Length(rWord));
	end else begin
		Result := rWord;
	end;
end;

function declShupashay(Sym, Country: string): Byte;
begin
  Result := ord(not ((Length(Sym) = 0) or (Pos(Sym, 'жшчщ') = 0)));
end;

// В українській мові м'якими не можуть бути губні м, в, б, п, ф,
// шиплячі ж, дж, ш, ч (пом'якшуються лише подовжені шиплячі:
// затишшя, роздоріжжя, річчю), задньоротові ґ, г, к, х
//
function declMagkay(tWord, nSymbol, pSymbol, Country: string): Byte;
begin
	Result := 0;
	If pSymbol = '' then begin
		If nSymbol <> 'ь' then begin
      Exit;
    end;
  end;
	If declGlasnay(tWord, Country) = 1 then begin
		//
	end else if (Length(tWord) > 0) and (Pos(tWord, 'мвбпф') > 0) then begin // губные
		//
	end else if (Length(tWord) > 0) and (Pos(tWord, 'ґгкх') > 0) then begin  // глухие
		//
	end else if declShupashay(tWord, Country) = 1 then begin

		Result := ord(tWord = pSymbol);
	end else if (Length(nSymbol) > 0) and (Pos(nSymbol, 'яюєіїь') > 0) then begin
		Result := 1;
	end else if tWord = 'ь' then begin
		Result := declMagkay(pSymbol, tWord, '', Country);
	//end else if (tWord = 'й') and (СтрДлина(pSymbol) > 0) and (Найти('яюєіїь', pSymbol) > 0) then begin
	end else if (tWord = 'й')
  and (Length(pSymbol) > 0)
  and (declGlasnay(pSymbol, Country) = 1) then begin
		// Нет в правилах... проверить... пример Сергій (2-ая группа, Мягкая)
		// Пример Талалай
		Result := 1;
	end;
end;

var
  ExceptList : TValueList;

function declGetGroupAndTyp(tWord: string; var tGroup: integer; var tTyp: string; tEnds: string; nEnds: integer; lSymEnds, eCoglOsnov, tRod, Counrty: string): Byte;
var
  fSymEnds,
  pSymOsnov,
  pSymEnds: string;
  pMagkay,
  pTverday,
  pShipashay: Byte;
begin
	//Result := 0;

	tGroup := 0;
	If nEnds > 0 then begin
		If ((tRod = 'м') or (tRod = 'ж'))
		and ((lSymEnds = 'а')
		or (lSymEnds = 'я')) then begin
			// Здесь может быть 4-ая группа For среднего рода, определить можно только склонением.
			// and 2-ая группа среднего рода, определить как неизвестно...
			tGroup := 1;
		end else if (tRod = 'м')
		and (lSymEnds = 'о') then begin
			tGroup := 2;
		end else if (tRod = 'с')
		and (lSymEnds <> '')
		and (Pos(lSymEnds, 'оея') > 0) then begin
			tGroup := 2;
		end else begin
			//If 2 = 1 then begin
			//	Сообщить(
      raise Exception.Create( 'Неопределена группа, род: '+tRod+' окончание: -'+lSymEnds+'! '+tWord+ '!');
			//end;
			//Exit;
		end;
	end else begin
		If (tRod = 'м') or (tRod = 'с') then begin
			tGroup := 2;
		end else if (tRod = 'ж') then begin
			tGroup := 3;
		end else begin
			//If ВыводитьНеопределенности = 1 then begin
		  //		Сообщить(
      raise Exception.Create('Неопределена группа, род: '+tRod+' без окончания! '+tWord+'!');
			//end;
			//Exit;
		end;
	end;

	fSymEnds := Copy(tEnds, 1, 1);
	pSymOsnov := '';
	If Length(tWord) - nEnds > 1 then begin
		pSymOsnov := Copy(tWord, Length(tWord) - nEnds - 1, 1);
	end;

	// Последняя согласная основы
	pSymEnds := '';
	If (nEnds > 1) then begin
		pSymEnds := Copy(tEnds, Length(tEnds) - 1, 1);
	end;

	If (nEnds > 1)
	and (declGlasnay(pSymEnds, Counrty) = 1)
	and (Pos(lSymEnds, 'іяєюї') > 0)
	then begin
		pMagkay := 1;
	end else begin
		pMagkay := declMagkay(eCoglOsnov, fSymEnds, pSymOsnov, Counrty);
	end;
	pTverday := 1 - pMagkay;
	pShipashay := declShupashay(eCoglOsnov, Counrty);

	If tGroup = 1 then begin
		If (pTverday = 1) and (pShipashay = 0) then begin
			tTyp := 'Т';
		end else if (pTverday = 1) and (pShipashay = 1) then begin
			tTyp := 'С';
		end else if (pMagkay = 1) then begin
			tTyp := 'М';
		end;
	end else if tGroup = 2 then begin
		If (eCoglOsnov = 'р')
		and (declGlasnay(pSymOsnov, Counrty) = 1) then begin
			// Тут тип определить сложно, так как нужно сначала просклонять...
			// А так как вызов идет из функции склонения For осуществления склонения
			// то цепочка бесконечна...
		  If (ExceptList.GetValueByKey('МягкаяР') is TValueList)
			and (TValueList(ExceptList.GetValueByKey('МягкаяР')).FindKey(tWord) > 0) then begin
			//Найти('ігор лазар секретар ', tWord+' ') > 0 then begin
				// Ігор - Ігорем, Єгор
				tTyp := 'М';
			end else begin
				tTyp := 'Т';
			end;
		end else if (pTverday = 1) and (pShipashay = 0) then begin
			If eCoglOsnov = 'ь' then begin
				tTyp := 'С';
			end else begin
				tTyp := 'Т';
			end;
		end else if (tRod = 'м') and (pMagkay = 1) then begin
			tTyp := 'М';
		end else if (tRod = 'с') and (tEnds = 'е') and (pShipashay = 0) then begin
			tTyp := 'М';
		end else if (tRod = 'с') and (lSymEnds = 'я') then begin
			tTyp := 'М';
		end else if (Pos(tRod, 'мс') > 0) and (pShipashay = 1) then begin
			tTyp := 'С';
		end;
	end else if tGroup = 3 then begin
		tTyp := '-';
		If (pMagkay = 1) or (pShipashay = 1) then begin
			tTyp := 'М';
		end else if (pTverday = 1) and (pShipashay = 0) then begin
			tTyp := 'Т';
		end;
	end;

	If tTyp = '' then begin
		//If ВыводитьНеопределенности = 1 then begin
			//Сообщить
    raise Exception.Create('Неопределен тип, род: '+tRod+', группа: '+IntToStr(tGroup)+'! '+tWord+ '!');
		//end;
   // Exit;
	end;

  Result := ord((tGroup > 0) and (tTyp <> ''));
end;


function DeclWord(AWord, Sex: string; var IsJob: byte; Pages: byte = 2;
  Country: string = 'UA'; FIO: string = ''; PartOfSpeech: string = '';
  ExceptName: string = 'СклонениеИсключения'): string;
const
	EnSymbol = 'iIoOpPmnBMCcXaAHKeETy*`"';
	UaSymbol  = 'іІоОрРтпВМСсХаАНКеЕТу''''''';
var
  tWord,
  kWord,
  rWord,
  zWord,
  eWord,
  bWord,
  hWord,
  eWord1,
  eWord2,
  fcWord1,
	wfcWord,
  fWord2,
  fWord_2,
  eWord_u: String;
  nWord,
  neWord: Integer;
  k: Integer;
  pSub,
  pSep,
	pDef,
  npDef,
	pSpace,
  pPoint: Integer;
  fNumberBeforeDef,
  fIskBeforeDef,
  fNotDec,
  fPrilag,
  //fCyshestv,
  fAddZvuch,
  fAddZvuch_b: Byte;
  fGroup: Integer;
	fTip: String;

  f3EndSFioPril,
  f2EndSFioPril: string;

begin
  Result := '';
	tWord := Trim(AWord);

  if tWord = '' then
  begin
		Result := tWord;
    Exit;
  end;

	// Корректируем i, I, o, O, p, P, m, n, B, M, C, c, X, a, H, K, e, E, T, y, and апостроф
	kWord := '';
	nWord := Length(tWord);
	For k := 1 to nWord do begin
		bWord := Copy(tWord, k, 1);
		pSub := Pos(bWord, EnSymbol);
		If pSub > 0 then begin
			kWord := kWord + Copy(UaSymbol, pSub, 1);
		end else begin
			kWord := kWord + bWord;
		end;
	end;
	tWord := kWord;

	If Length(tWord) = 1 then begin
		// tWord из одной буквы
		IsJob := 1;
    Result := tWord;
    Exit;
	end;

	If AWord = AnsiUpperCase(AWord) then begin
		// Капитализированное, считаем, что аббревиатура
		IsJob := 1;
    Result := tWord;
    Exit;
	end;

  // Возвращаем tWord с откорректированными символами и то хлеб
  // особенно для именительного падежа
	If (Pages = 1) then begin
		Result := tWord;
    Exit;
	end;

  if Assigned(ExceptionUnit.SimpleExceptList) then
  begin
    if ExceptionUnit.SimpleExceptList.CheckWord(tWord, 2, Pages) then
    begin
      Result := ExceptionUnit.SimpleExceptList.Strings[Pages-1];
      Exit;
    end;
  end;

	//pSep := 0;
	pDef := Pos('-',tWord);
	pSpace := Pos(' ', tWord);

	// Числа, т.е. возможно числительные вида 1-а, 2-а, 3-я
	fNumberBeforeDef := 0;
	If pDef > 0 then begin
		hWord := Trim(Copy(tWord, 1, pDef - 1));
		If (Length(hWord) > 0 )
		and (hWord = IntToStr(StrToIntDef(hWord,0))) then begin
			fNumberBeforeDef := 1;
			npDef := Pos('-', Copy(tWord, pDef + 1, Length(tWord)));
			If npDef > 0 then begin
				pDef := pDef + npDef;
			end else begin
				pDef := 0;
			end;
		end;
	end;

	If FIO = 'Д' then begin
		// Составные:
		//   заступник начальника управління - начальник відділу
		//   заступнику начальника управління - начальнику відділу
		// склоняется только первое tWord, а If есть дефисы, то and первое после каждого дефиса
		// но головному бухгалтеру, провідному спеціалісту
		//   прилагательные перед первым существительным также склоняются
		// дефис разделяет составные слова

		pSep := pDef;
		If IsJob = 0 then begin
			If pSpace <> 0 then begin
				If pSep = 0 then begin
					pSep := pSpace;
				end else begin
					pSep := Min(pSep, pSpace);
				end;
			end;
		end;
		If (pSep > 0) then begin
			// Рекурсивный вызов склонения If есть '-' or ' '
			fIskBeforeDef := 0;
			If pSep = pDef then begin
				//Сообщить('Перед дефисом: '+Нрег(Лев(tWord, pSep - 1)));
			  If (ExceptList.GetValueByKey('НеСклоняетсяПередДефисом') is TValueList)
				and (TValueList( ExceptList.GetValueByKey('НеСклоняетсяПередДефисом')).FindKey(AnsiLowerCase(Copy(tWord,1,pSep - 1))) > 0) then
        begin
					//Сообщить('Не склоняется');
					fIskBeforeDef := 1;
				end;
			end;
			If fIskBeforeDef = 1 then begin
				rWord := Copy(tWord,1, pSep - 1);
			end else begin
				rWord := DeclWord(Copy(tWord, 1, pSep - 1), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
			end;
			If pSep = pDef then begin
				rWord := rWord + '-';
				IsJob := 0;
			end else begin
				rWord := rWord + ' ';
			end;
			rWord := rWord + DeclWord(Copy(tWord, pSep + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
      Result := rWord;
      Exit;
		end else if IsJob = 1 then begin
			// Не склоняем оставшуюся часть составной должности, когда
			// обработали первое существительное
      Result := tWord;
      Exit;
		end;
	end else begin
		pSep := pDef;
		If pSpace <> 0 then begin
			If pSep = 0 then begin
				pSep := pSpace;
			end else begin
				pSep := Min(pSep, pSpace);
			end;
		end;
		If (pSep > 0) then begin
			// Рекурсивный вызов склонения If есть '-' or ' '
			fIskBeforeDef := 0;
			If pSep = pDef then begin
			  If (ExceptList.GetValueByKey('НеСклоняетсяПередДефисом') is TValueList)
				and (TValueList( ExceptList.GetValueByKey('НеСклоняетсяПередДефисом')).FindKey(AnsiLowerCase(Copy(tWord,1, pSep - 1))) > 0) then begin
					fIskBeforeDef := 1;
				end;
			end;
			If fIskBeforeDef = 1 then begin
				rWord := Copy(tWord, 1, pSep - 1);
			end else begin
				rWord := DeclWord(Copy(tWord, 1, pSep - 1), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
			end;
      if pSep = pDef then begin
      	rWord := rWord + '-';
      end else begin
      	rWord := rWord + ' ';
      end;
			rWord := rWord + DeclWord(Copy(tWord, pSep + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
      Result := rWord;
      Exit;
		end;
	end;

	// сокращения не склоняем
	If Copy(tWord, Length(tWord)-1+1, 1) = '.' then begin
  	Result := tWord;
    Exit;
	end;

	// сокращения не склоняем
	If Copy(tWord, Length(tWord)-1+1, 1) = '/' then begin
  	Result := tWord;
    Exit;
	end;

	// Разбиваем tWord содержащее точки на составляющие слова
	pPoint := Pos('.', tWord );
	If pPoint > 0 then begin
		// Рекурсивный вызов склонения If есть '.'
		// точку не отсекаем - считаем, что tWord с точкой - сокращение
		rWord := DeclWord(Copy(tWord, 1, pPoint), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName)
			+ DeclWord(Copy(tWord, pPoint + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
  	Result := rWord;
    Exit;
	end;

	// Разбиваем tWord содержащее / на составляющие слова
	pPoint := Pos('/', tWord);
	If pPoint > 0 then begin
		// Рекурсивный вызов склонения If есть '/'
		// точку не отсекаем - считаем, что tWord с точкой - сокращение
		rWord := DeclWord(Copy(tWord, 1, pPoint), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName)
			+ DeclWord(Copy(tWord, pPoint + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
  	Result := rWord;
    Exit;
	end;

	// Разбиваем tWord содержащее ) на составляющие слова
	pPoint := Pos(')', tWord);
	If (pPoint > 0) then begin
		// Рекурсивный вызов склонения If есть ')'
		// точку не отсекаем - считаем, что tWord с точкой - сокращение
		rWord := DeclWord(Copy(tWord, 1, pPoint - 1), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName)
			+ ')'
			+ DeclWord(Copy(tWord, pPoint + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
  	Result := rWord;
    Exit;
	end;

	// Разбиваем tWord содержащее ( на составляющие слова
	pPoint := Pos('(', tWord);
	If (pPoint > 0) then begin
		// Рекурсивный вызов склонения If есть '('
		// точку не отсекаем - считаем, что tWord с точкой - сокращение
		rWord := DeclWord(Copy(tWord, 1, pPoint - 1), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName)
			+ '('
			+ DeclWord(Copy(tWord, pPoint + 1, Length(tWord)), Sex, IsJob, Pages, Country, FIO, PartOfSpeech, ExceptName);
  	Result := rWord;
    Exit;
	end;

	tWord := AnsiLowerCase(tWord);
	Sex := AnsiLowerCase(Sex);
	rWord := '';

	//Сообщить('П.'+Pages+'. '+tWord+'. IsJob = '+IsJob);

	zWord := '';
	eWord := declWordEnds(tWord, zWord, Country);
	neWord := Length(eWord);

	eWord1 := '';
	eWord2 := '';
	If neWord > 0  then
  begin
		eWord1 := Copy(eWord, Length(eWord)-1+1, 1);
		If neWord > 1 then
    begin
			eWord2 := Copy(eWord, Length(eWord) - 1, 1);
		end;
	end;

	rWord := '';
	//If склНайтиВИсключениях(tWord, Country, ExceptName, PartOfSpeech, Pages, rWord) = 1 then begin
	//	// If находим tWord с заданным падежом в исключениеях - возвращаем
	//	//Возврат (rWord);
	//end;

	If fNumberBeforeDef = 1 then begin
		// Числительное вида 1-а, 2-а, 3-я
		PartOfSpeech := 'П';
	end;

	// Числительные
	If Pos(' ' + zWord + ' ', ' перш друг трет четверт п''ят шост сьом восьм дев''ят '+
	' десят одинадцят дванадцят тринадцят чотирнадцят п''ятнадцят шістнадцят сімнадцят вісімнадцят дев''ятнадцят '+
	' двадцят тридцят сороков п''ятидисят шостидесят сьомидесят восьмидесят '+
	' сот двухсот трьохсот чотирьохсот п''ятисот шостисот сьомисот восьмисот дев''ятисот '+
	' тисячн ') > 0 then begin
		PartOfSpeech := 'П';
	end;

	fNotDec := 0;
	If rWord = '' then begin
		If FIO = 'Ф' then begin
			If (Sex = 'ж') then begin
				If (eWord = '') or (eWord = 'о') then begin
					fNotDec := 1;
				end;
			end else if (Sex = 'м') then begin
				// For российских, но непонятно как определить? (Келих, Пелих) но (Гладких рус.)
				//If (eWord = <> '') and (Найти('ово ако их ', eWord+' ') then begin
				//	fNotDec = 1;
				//end;
			end;
		end;
		// Иностранного происхождения не склоняются
		//+іменники, що закінчуються на -а, перед яким виступає голосний звук: амплуа, боа, Нікарагуа;
		//+на -і: колібрі, парі, поні, попурі, Марі, Голсуорсі, Капрі, Россіні, Паганіні, Шеллі;
		//+на -ї: Віньї, Шантільї;
		//+на -у: какаду, кенгуру, рагу, Баку, Шоу;
		//+на -ю (-йу або -у): меню, інтерв'ю, Сю;
		//-власні назви з приголосним перед -а: Дюма, Вольта;
		//+іменники, що закінчуються на -е (-є): кафе, кашне, турне, каре, піке, протеже, Беранже, Гейне, Гете, Данте; ательє, Готьє, Лавуазьє;
		//-на -o: авто, бюро, депо, кіно, манто, метро, радіо, Арно, Буало, Гюго, Дідро, Лонгфелло, Тюссо, Глазго (але виняток становить tWord пальто, яке відмінюється як іменники ІІ відміни середнього роду на -о);
		//-прізвища на -я (-йа або -а): Гойя, Золя;
		//-жіночі імена на приголосний, а також жіночі прізвища на -ін, -ов: Аліс, Долорес, Зейнаб; (Ельза) Вірхов, (Джеральдіна) Чаплін;
		//-російські прізвища на -ово, -ако, -их: Острово, Плевако, Гладких.
		If (eWord1 = 'а') and (neWord > 1) then begin
			fNotDec := 1;
		end;
		If (Pos(eWord1, 'іїую') > 0) and (neWord > 0) then begin
			fNotDec := 1;
		end;
		If (Length(FIO) > 0) and (Pos(FIO, 'FIO') > 0) then begin
			If Pos(tWord, 'огли кизи ') > 0 then begin
				fNotDec := 1;
			end;
		end;
		If fNotDec = 0 then begin
		  If (ExceptList.GetValueByKey('НеСклоняется') is TValueList)
			and (TValueList( ExceptList.GetValueByKey('НеСклоняется')).FindKey(tWord) > 0) then begin
				fNotDec := 1;
			end;
		end;
		If fNotDec = 1 then begin
			rWord := tWord;
			//Возврат rWord;
		end;
	end;
	fcWord1 := '';
	wfcWord := '';
	If Length(zWord) > 0 then begin
		fcWord1 := Copy(tWord, Length(zWord), 1);
		If Length(zWord) > 1 then begin
			wfcWord := Copy(zWord, 1, Length(zWord) - 1);
		end;
	end;
	fWord2 := '';
	If Length(wfcWord) > 1 then begin
		fWord2 := Copy(wfcWord, Length(wfcWord), 1);
	end;
	fGroup := 0;
	fTip := '';

	fWord_2 := fWord2 + fcWord1;

	fPrilag := 0;
	If PartOfSpeech = 'П' then begin
		fPrilag := 1;
	end;
	If PartOfSpeech = '' then begin
	  If (ExceptList.GetValueByKey('КакСуществительные') is TValueList)
		and (TValueList( ExceptList.GetValueByKey('КакСуществительные')).FindKey(tWord) > 0) then begin
			PartOfSpeech := 'С';
			//fCyshestv := 1;
			fPrilag := 0;
		end else
	  If (ExceptList.GetValueByKey('КакПрилагательные') is TValueList)
		and (TValueList( ExceptList.GetValueByKey('КакПрилагательные')).FindKey(tWord) > 0) then begin
			PartOfSpeech := 'П';
			//fCyshestv := 0;
			fPrilag := 1;
		end;
	end;
  If (ExceptList.GetValueByKey('СреднийРод') is TValueList)
	and (TValueList( ExceptList.GetValueByKey('СреднийРод')).FindKey(tWord) > 0) then begin
		Sex := 'с';
	end;

	If ((FIO = 'Ф') or (FIO = 'Д') or (PartOfSpeech = 'П')) and (PartOfSpeech <> 'С') then begin
		If (Sex = 'м') then begin
			If fcWord1 = 'й' then begin
				If fWord2 = 'и' then begin
					fPrilag := 1;
					fTip := 'Т';
					If Length(zWord) >= 5 then begin
						If Copy(zWord, Length(zWord)-5+1, 5) = 'лиций' then begin
							fTip := 'Л';
						end;
					end;
				end else if fWord2 = 'і' then begin
					fPrilag := 1;
					fTip := 'М';
				end else if fWord2 = 'ї' then begin
					fPrilag := 1;
					fTip := 'Й';
				end;
				If fPrilag = 1 then begin
					zWord := Copy(zWord,1,  Length(zWord) - 2);
				end;
			end else if (nWord > 2)
			and (Pos(Copy(tWord, Length(tWord)-2+1, 2)+' ','ов ев єв ів їв ий ін їн ') > 0 ) then begin
				fPrilag := 1;
				fTip := '3';

				// Неясна зависимость подстановки 'о' or 'е' вместо 'і'
				//If (fWord2 = 'і')
				//и (Pages <> 1) then begin
				//	zWord = Лев(zWord, СтрДлина(zWord) - 2) + 'о' + fcWord1;
				//end;
			end;
		end;
		If (Sex = 'ж') or (FIO = 'Д') then begin
			If (eWord1 = 'а')
			or (eWord1 = 'я') then begin
				// Попробуем определить, относится ли tWord к прилагательным to окончанию из 3 символов
				//
				// Поиск нужно осуществлять to трем последним буквам женских фамилий с окончанием на -а, -я
				// If не нашли - значит скорее всего существительное
				// If нашли то не факт что прилагательное, есть исключения
				// гарантий нет, так как to окончанию определить часть речи невозможно
				f3EndSFioPril :=
				'лая, ная, рая, тая,'+
				'ава, ева, єва, іва, ова,'+
				'вга, лга,'+
				'бка, гка, дка, ика, цка, ька,'+
				'ала, ила, іла, сла, ула,'+
				'ана, бна, дна, жна, зна, їна, йна, нна, пна, рна, сна, тна, чна, шна, ьна, яна, іна, ина,'+
				'дня, жня, тня,'+
				'ата, ста,'+
				'дча,'+
				'';
				f2EndSFioPril :=
				'ая, ша, '+
				'';
				//If PartOfSpeech = '' then begin
				//	PartOfSpeech = '';
				//	If склНайтиВИсключениях(tWord, Country, ExceptName, PartOfSpeech) = 1 then begin
				//		If PartOfSpeech = 'П' then begin
				//			fPrilag = 1;
				//		end else if PartOfSpeech = 'С' then begin
				//			fPrilag = 0;
				//			fCyshestv = 1;
				//		end;
				//	end;
				//end;
				If PartOfSpeech = '' then begin
					If Pos(Copy(tWord, Length(tWord)-3+1, 3) + ',', f3EndSFioPril ) > 0 then begin
						fPrilag := 1;
					end else if Pos(Copy(tWord, Length(tWord)-2+1, 2), f2EndSFioPril) > 0 then begin
						fPrilag := 1;
					end;
				end;
			end;

			If fPrilag = 1 then begin
				If eWord1 = 'а' then begin
					Sex := 'ж';
					fTip := 'Т';
				end else if eWord1 = 'я' then begin
					If declGlasnay(eWord2, Country) = 1 then begin
						Sex := 'ж';
						fTip := 'Й';
					end else begin
						Sex := 'ж';
						fTip := 'М';
						If Length(zWord) >= 3 then begin
							If Copy(zWord, Length(tWord)-3+1, 3) = 'лиц' then begin
								fTip := 'Л';
							end;
						end;
					end;
				end;
			end;
		end;
		If (Sex = 'с') or (FIO = 'Д') then begin
			If eWord1 = 'е' then begin
				Sex := 'с';
				fPrilag := 1;
				fTip := 'Т';
				If Length(zWord) >= 3 then begin
					If Copy(zWord, Length(tWord)-3+1, 3) = 'лиц' then begin
						fTip := 'Л';
					end;
				end;
			end else if eWord1 = 'є' then begin
				Sex := 'с';
				fPrilag := 1;
				If declGlasnay(eWord2, Country) = 1 then begin
					fTip := 'Й';
				end else begin
					fTip := 'М';
				end;
			end;
		end;
	end;

	If (fPrilag = 0) or (PartOfSpeech = 'С') then begin
		// Отмечаем что существительное обработали, чтобы не сколнять дальнейшую составную часть должности
		IsJob := 1;

		//+іменники, що закінчуються на -е (-є): кафе, кашне, турне, каре, піке, протеже, Беранже, Гейне, Гете, Данте; ательє, Готьє, Лавуазьє;
		If (eWord1 = 'е')
		or (eWord1 = 'є') then begin
			//fNotDec := 1;
			rWord := tWord;
		end;
	end;
	If rWord <> '' then begin
    Result := declReturnReg(rWord, AWord);
    Exit;
	end;

	If fPrilag = 1 then begin
		// Прилагательное
		If Sex = 'м' then begin
			// мужского рода
			If fTip = 'М' then begin
				// ій
				If Pages = 1 then begin
					rWord := zWord + 'ій';
				end else if Pages = 2 then begin
					rWord := zWord + 'ього';
				end else if Pages = 3 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 4 then begin
					rWord := zWord + 'ого'; // (-ій) любое
				end else if Pages = 5 then begin
					rWord := zWord + 'ім';
				end else if Pages = 6 then begin
					rWord := zWord + 'ьому'; // (-ім) любое
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Т' then begin
				// -ий
				If Pages = 1 then begin
					rWord := zWord + 'ий';
				end else if Pages = 2 then begin
					rWord := zWord + 'ого';
				end else if Pages = 3 then begin
					rWord := zWord + 'ому';
				end else if Pages = 4 then begin
					rWord := zWord + 'ого';
				end else if Pages = 5 then begin
					rWord := zWord + 'им';
				end else if Pages = 6 then begin
					rWord := zWord + 'ому';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Й' then begin
				// -їй
				If Pages = 1 then begin
					rWord := zWord + 'їй';
				end else if Pages = 2 then begin
					rWord := zWord + 'його';
				end else if Pages = 3 then begin
					rWord := zWord + 'йому';
				end else if Pages = 4 then begin
					rWord := zWord + 'його'; // (-їй)
				end else if Pages = 5 then begin
					rWord := zWord + 'їм';
				end else if Pages = 6 then begin
					rWord := zWord + 'йому'; // (-їм)
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Л' then begin
				// -лиций
				If Pages = 1 then begin
					rWord := zWord + 'ий';
				end else if Pages = 2 then begin
					rWord := zWord + 'ього';
				end else if Pages = 3 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 4 then begin
					rWord := zWord + 'ього'; // (-им)
				end else if Pages = 5 then begin
					rWord := zWord + 'им';
				end else if Pages = 6 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = '3' then begin
				// -ов ев єв ів їв ий ін їн
				If Pages = 1 then begin
					rWord := zWord;
				end else if Pages = 2 then begin
					rWord := zWord + 'а';
				end else if Pages = 3 then begin
					rWord := zWord + 'у';
				end else if Pages = 4 then begin
					rWord := zWord + 'а';
				end else if Pages = 5 then begin
					rWord := zWord + 'им';
				end else if Pages = 6 then begin
					rWord := zWord + 'і';
				end else if Pages = 7 then begin
					rWord := zWord + 'е'; // or не склоняем
				end;
			end;
		end else if Sex = 'ж' then begin
			// женского
			If (fTip = 'М') or (fTip = 'Л') then begin
				// -я
				If Pages = 1 then begin
					rWord := zWord + 'я';
				end else if Pages = 2 then begin
					rWord := zWord + 'ьої';
				end else if Pages = 3 then begin
					rWord := zWord + 'ій';
				end else if Pages = 4 then begin
					rWord := zWord + 'ю';
				end else if Pages = 5 then begin
					rWord := zWord + 'ьою';
				end else if Pages = 6 then begin
					rWord := zWord + 'ій';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Т' then begin
				// -а
				If Pages = 1 then begin
					rWord := zWord + 'а';
				end else if Pages = 2 then begin
					rWord := zWord + 'ої';
				end else if Pages = 3 then begin
					rWord := zWord + 'ій';
				end else if Pages = 4 then begin
					rWord := zWord + 'у';
				end else if Pages = 5 then begin
					rWord := zWord + 'ою';
				end else if Pages = 6 then begin
					rWord := zWord + 'ій';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Й' then begin
				// -ая
				If Pages = 1 then begin
					rWord := zWord + 'я';
				end else if Pages = 2 then begin
					rWord := zWord + 'йої';
				end else if Pages = 3 then begin
					rWord := zWord + 'їй';
				end else if Pages = 4 then begin
					rWord := zWord + 'ю';
				end else if Pages = 5 then begin
					rWord := zWord + 'йою';
				end else if Pages = 6 then begin
					rWord := zWord + 'їй';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end;
		end else if Sex = 'с' then begin
			// среднего рода
			If fTip = 'М' then begin
				// -є
				If Pages = 1 then begin
					rWord := zWord + 'є';
				end else if Pages = 2 then begin
					rWord := zWord + 'ього';
				end else if Pages = 3 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 4 then begin
					rWord := zWord + 'є';
				end else if Pages = 5 then begin
					rWord := zWord + 'ім';
				end else if Pages = 6 then begin
					rWord := zWord + 'ьому'; // (-ім) любое
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Т' then begin
				// -е
				If Pages = 1 then begin
					rWord := zWord + 'е';
				end else if Pages = 2 then begin
					rWord := zWord + 'ого';
				end else if Pages = 3 then begin
					rWord := zWord + 'ому';
				end else if Pages = 4 then begin
					rWord := zWord + 'е';
				end else if Pages = 5 then begin
					rWord := zWord + 'им';
				end else if Pages = 6 then begin
					rWord := zWord + 'ому';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Й' then begin
				// -ає
				If Pages = 1 then begin
					rWord := zWord + 'є';
				end else if Pages = 2 then begin
					rWord := zWord + 'його';
				end else if Pages = 3 then begin
					rWord := zWord + 'йому';
				end else if Pages = 4 then begin
					rWord := zWord + 'є';
				end else if Pages = 5 then begin
					rWord := zWord + 'їм';
				end else if Pages = 6 then begin
					rWord := zWord + 'йому'; // (-їм) любое
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end else if fTip = 'Л' then begin
				// -лице
				If Pages = 1 then begin
					rWord := zWord + 'е';
				end else if Pages = 2 then begin
					rWord := zWord + 'ього';
				end else if Pages = 3 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 4 then begin
					rWord := zWord + 'е';
				end else if Pages = 5 then begin
					rWord := zWord + 'им';
				end else if Pages = 6 then begin
					rWord := zWord + 'ьому';
				end else if Pages = 7 then begin
					rWord := tWord; // не склоняем
				end;
			end;
		end;

		//Сообщить(''+tWord+'. Группа: Прилагательное. fTip: '+fTip);

	end else if declGetGroupAndTyp(tWord, fGroup, fTip, eWord, neWord, eWord1, fcWord1, Sex, Country) = 0 then begin
		//Возврат '';
		// Не склоняем, If не можем определить to правилам
		rWord := tWord;

	//end else if склНайтиВИсключениях(tWord, Country, ExceptName) = 1 then begin

		// Не склоняем, If в исключениях
	//	rWord = tWord;

	end else begin
		// Существительное

		//Сообщить(''+tWord+'. Группа: '+fGroup+'. fTip: '+fTip);

		If neWord > 1 then begin
			// Поправочка, не все eWord убираем, а только последнюю букву
			eWord_u := Copy(eWord, 1, Length(eWord) - 1);
			zWord := zWord + eWord_u;
		end;

		If fGroup = 1 then begin
			// 1-ая группа
			//
			//1.Українські чоловічі та жіночі імена, що в називному відмінку
			//	однини закінчуються на -а (-я), відмінються як відповідні
			//	іменники І відміни.
			//Примітка 1. Кінцеві приголосні основи г, к, х у жіночих іменах
			//						у давальному та місцевому відмінках однини перед
			//						закінченням -і змінюються на з, ц, с:
			//						Ольга - Ользі, Палажка - Палажці, Солоха - Солосі.
			//Примітка 2. У жіночих іменах типу Одарка, Параска в родовому
			//						відмінку множини в кінці основи між приголосними
			//						з'являється звук о: Одарок, Парасок.
			//

			If fTip = 'Т' then begin
				// твердая
				If (Sex = 'ж') or (FIO = 'Д') then begin
			    If (Pages = 3)
					or (Pages = 6) then begin
						If fcWord1 = 'г' then begin
							zWord := wfcWord + 'з';
						end else if fcWord1 = 'к' then begin
							zWord := wfcWord + 'ц';
						end else if fcWord1 = 'х' then begin
							zWord := wfcWord + 'с';
						end;
					end;
				end;
				If Pages = 1 then begin
					rWord := zWord + 'а';
				end else if Pages = 2 then begin
					rWord := zWord + 'и';
				end else if Pages = 3 then begin
					rWord := zWord + 'і';
				end else if Pages = 4 then begin
					rWord := zWord + 'у';
				end else if Pages = 5 then begin
					rWord := zWord + 'ою';
				end else if Pages = 6 then begin
					rWord := zWord + 'і';
				end else if Pages = 7 then begin
					rWord := zWord + 'о';
				end;
			end else if fTip = 'М' then begin
				fAddZvuch := 0;
				If (fcWord1 = 'й') then begin
					fAddZvuch := 1;
				end;
				// мягкая
				If Pages = 1 then begin
					rWord := zWord + 'я';
				end else if Pages = 2 then begin
					If (declGlasnay(eWord2, Country) = 1)
					or (fAddZvuch = 1) then begin
						rWord := zWord + 'ї';
					end else begin
						rWord := zWord + 'і';
					end;
				end else if Pages = 3 then begin
					If (declGlasnay(eWord2, Country) = 1)
					or (fAddZvuch = 1) then begin
						rWord := zWord + 'ї';
					end else begin
						rWord := zWord + 'і';
					end;
				end else if Pages = 4 then begin
					rWord := zWord + 'ю';
				end else if Pages = 5 then begin
					If (declGlasnay(eWord2, Country) = 1)
					or (fAddZvuch = 1) then begin
						rWord := zWord + 'єю';
					end else begin
						rWord := zWord + 'ею';
					end;
				end else if Pages = 6 then begin
					If (declGlasnay(eWord2, Country) = 1)
					or (fAddZvuch = 1) then begin
						rWord := zWord + 'ї';
					end else begin
						rWord := zWord + 'і';
					end;
				end else if Pages = 7 then begin
					If Sex = 'м' then begin
						rWord := zWord + 'є'; // Ілле (в книжке), Іллє (в ворде)
					end else begin
						If (declGlasnay(eWord2, Country) = 1)
						//or (fAddZvuch = 1)
						then begin
							rWord := zWord + 'є';
						end else begin
							rWord := zWord + 'ю';
						end;
					end;
				end;
			end else if fTip = 'С' then begin
				// смешанная
				If Pages = 1 then begin
					rWord := zWord + 'а';
				end else if Pages = 2 then begin
					rWord := zWord + 'і';
				end else if Pages = 3 then begin
					rWord := zWord + 'і';
				end else if Pages = 4 then begin
					rWord := zWord + 'у';
				end else if Pages = 5 then begin
					rWord := zWord + 'ею';
				end else if Pages = 6 then begin
					rWord := zWord + 'і';
				end else if Pages = 7 then begin
					rWord := zWord + 'е';
				end;
			end;
		end else if fGroup = 2 then begin
			// 2-ая группа

			//2. Українські чоловічі імена, що в називному відмінку однини закінчуються
			//	 на приголосний та -о , відмінюються як відповідні іменники ІІ відміни.
			//Примітка 1. В іменах типу Антін, Нестір, Нечипір, Прокіп, Сидір, Тиміш,
			//						Федір голосний і виступає тільки в називному відмінку,
			//						у непрямих - о: Антона, Антонові, Нестора, Несторові й т.д.,
			//						але: Лаврін - Лавріна, Олефір - Олефіра.
			//Примітка 2. Імена, що в називному відмінку закінчуються на -р, у родовому
			//						мають закінчення -а: Віктор - Віктора, Макар - Макара,
			//						але: Ігор - Ігоря, Лазар - Лазаря.
			//Примітка 3. Ім'я Лев при відмінюванні має паралельні форми: Лева й Льва, Левові й Львові та ін.

			// Чередование... Возможно For имен не чередуется?... Олег - М. Олегові
			//If (FIO <> '') and (Найти('FIO', FIO) = 0) then begin
			//	// в FIO не чередуются
		  //  If (Pages = 3)
		  //  or (Pages = 6) then begin
			//		If Найти('олег ', tWord+' ') = 0 then begin
			//			If fcWord1 = 'г' then begin
			//				zWord = wfcWord + 'з';
			//			end else if fcWord1 = 'к' then begin
			//				zWord = wfcWord + 'ц';
			//			end else if fcWord1 = 'х' then begin
			//				zWord = wfcWord + 'с';
			//			end;
			//		end;
			//	end;
			//end;

			fAddZvuch_b := 0;
			If (fcWord1 = 'ь') then begin
				// (Василь - в типе 'С')
				zWord := Copy(zWord, 1, Length(zWord) - 1);
				eWord := 'ь';
				fAddZvuch_b := 1;
			end;

			fAddZvuch := 0;
			If (fcWord1 = 'й')
			and (fTip = 'М') then begin
				// -ій (Сергій)
				zWord := Copy(zWord, 1, Length(zWord) - 1);
				eWord := 'й';
				fAddZvuch := 1;
			end else if (fWord2 = 'і') and (FIO = 'И') then begin
				// Проверка на исключения
				If Pages <> 1 then begin
				  If (ExceptList.GetValueByKey('НетЧередованияИО') is TValueList)
					and (TValueList( ExceptList.GetValueByKey('НетЧередованияИО')).FindKey(tWord) = 0)
					//Найти('лаврін олефір леонід ', tWord+' ') = 0
					then begin
						If ((Pages = 3) or (Pages = 6)) and (Pos(tWord+' ', 'яків ' ) > 0) then begin
							// якобові
							fcWord1 := 'б';
						end;
						zWord := Copy(wfcWord, 1, Length(wfcWord) - 1) + 'о' + fcWord1;
					end;
				end;
			end else if Copy(tWord, length(tWord)-3+1, 3) = 'ець' then begin
				If Copy(tWord, length(tWord)-5+1, 5) = 'швець' then begin
					// Швець - Шевця
          if Pages = 7 then begin
  					zWord := Copy(tWord, 1, nWord - 5) + 'шевч';
          end else begin
  					zWord := Copy(tWord, 1, nWord - 5) + 'шевц';
          end;
  			end else begin
					// Марганець - Марганця
					//zWord := Лев(wfcWord, СтрДлина(wfcWord) - 2) + fWord2;
          if Pages = 7 then begin
            zWord := Copy(wfcWord, 1, Length(wfcWord) - 2) + 'ч';
//            zWord := Лев(tWord, nWord - 3) + 'ч';
          end else begin
            zWord := Copy(wfcWord, 1, Length(wfcWord) - 2) + 'ц';
            //zWord := Лев(tWord, nWord - 3) + 'ц';
          end;
				end;
			end;

			If fTip = 'Т' then begin
				If Pages = 1 then begin
					rWord := zWord + eWord;
				end else if Pages = 2 then begin
				  If (ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ') is TValueList)
					and (TValueList( ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ')).FindKey(tWord) > 0) then begin
						rWord := zWord + 'у';
					end else begin
						rWord := zWord + 'а';
					end;
				end else if Pages = 3 then begin
					//If FIO = 'Д' then begin
						rWord := zWord + 'у'; //(-у) можно любое
					//end else begin
					//	rWord = zWord + 'ові'; //(-у) можно любое
					//end;
				end else if Pages = 4 then begin
					rWord := zWord + 'а';
				end else if Pages = 5 then begin
					rWord := zWord + 'ом';
				end else if Pages = 6 then begin
					rWord := zWord + 'ові';
				end else if Pages = 7 then begin
          // ів (-їв), -ов -ев (-єв), -ин, -ін (-їн) == -e / -
          If Pos(Copy(tWord, Length(tWord)-2+1, 2) + ' ','ів їв ов ев єв ин ін їн ' ) > 0 then begin
            rWord := zWord + 'е';
          end else begin
            rWord := zWord + 'у';
          end;
//					If Найти('олег ', tWord+' ') > 0 then begin
//						rWord := zWord + 'у';
//					end else begin
//						rWord := zWord + 'е'; //(-у) можно только одно, зависимость неясна
//					end;
				end;
			end else if (fTip = 'М') or (fTip = 'С') then begin
				If Pages = 1 then begin
					rWord := zWord + eWord;
				end else if Pages = 2 then begin
					If ((fcWord1 = 'р') and (
		  		(ExceptList.GetValueByKey('МягкаяР') is TValueList)
					and (TValueList( ExceptList.GetValueByKey('МягкаяР')).FindKey(tWord) = 0)
					//Найти('ігор лазар секретар ', tWord+' ') = 0
					))
					or (declShupashay(fcWord1, Country) = 1) then begin
		  			If (ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ') is TValueList)
						and (TValueList( ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ')).FindKey(tWord) > 0) then begin
							rWord := zWord + 'у';
						end else begin
							rWord := zWord + 'а';
						end;
					end else begin
		  			If (ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ') is TValueList)
						and (TValueList( ExceptList.GetValueByKey('РодительныйПадеж2огоСклоненияОкончаниеУЮ')).FindKey(tWord) > 0) then begin
							rWord := zWord + 'ю';
						end else begin
							rWord := zWord + 'я';
						end;
					end;
				end else if Pages = 3 then begin
					If (fAddZvuch = 1) or (fAddZvuch_b = 1) then begin
						//If FIO = 'Д' then begin
							rWord := zWord + 'ю';
						//end else begin
						//	rWord = zWord + 'єві'; //(-ю) можно любое
						//end;
					end else begin
						//If FIO = 'Д' then begin
						If fTip = 'М' then begin
							rWord := zWord + 'ю';
						end else if fTip = 'С' then begin
							rWord := zWord + 'у';
						end;
						//end else begin
						//	rWord = zWord + 'еві'; //(-ю) можно любое
						//end;
					end;
				end else if Pages = 4 then begin
					If ((fcWord1 = 'р') and (
				  (ExceptList.GetValueByKey('МягкаяР') is TValueList)
					and (TValueList(  ExceptList.GetValueByKey('МягкаяР')).FindKey(tWord) = 0)
					//Найти('ігор лазар секретар ', tWord+' ') = 0
					))
					or (declShupashay(fcWord1, Country) = 1) then begin
						rWord := zWord + 'а';
					end else begin
						rWord := zWord + 'я';
					end;
				end else if Pages = 5 then begin
					If fAddZvuch = 1 then begin
						rWord := zWord + 'єм';
					end else begin
						rWord := zWord + 'ем';
					end;
				end else if Pages = 6 then begin
					If fAddZvuch = 1 then begin
						rWord := zWord + 'єві';
					end else begin
						rWord := zWord + 'еві';
					end;
				end else if Pages = 7 then begin
//          If ((fcWord1 = 'р') and (
//				  (спИсключения.Получить('МягкаяР') is СписокЗначений)
//					and (СписокЗначений( спИсключения.Получить('МягкаяР')).НайтиЗначение(tWord) = 0)
//					//Найти('ігор лазар секретар ', tWord+' ') = 0
//					))
//					or (склШипящая(fcWord1, Country) = 1) then begin
          If (declShupashay(fcWord1, Country) = 1) then begin
            rWord := zWord + 'е';
          end else if (fTip = 'М') and (Copy(tWord, Length(tWord)-3+1, 3) = 'ець') then begin
            rWord := zWord + 'е';
					end else if (fAddZvuch = 1) or (fAddZvuch_b = 1) then begin
						rWord := zWord + 'ю';
					end else begin
						rWord := zWord + 'у';
          end;

//					If (склШипящая(fcWord1, Country) = 1) then begin
//						rWord := zWord + 'у';
//					end else if (fAddZvuch = 1) or (fAddZvuch_b = 1) then begin
//						rWord := zWord + 'ю';
//					end else begin
//						rWord := zWord + 'е'; //(-ю) можно только одно, зависимость частично ясна
//					end;
				end;
			end;
		end else if fGroup = 3 then begin
			// 3-тья группа
			If (fcWord1 = 'ь') then begin
				// (Нінель)
				zWord := Copy(zWord,1, Length(zWord) - 1);
				eWord := 'ь';

				fcWord1 := '';
				wfcWord := '';
				If Length(zWord) > 0 then begin
					fcWord1 := Copy(tWord, Length(zWord), 1);
					If Length(zWord) > 1 then begin
						wfcWord := Copy(zWord, 1, Length(zWord) - 1);
					end;
				end;

				fWord2 := '';
				If Length(wfcWord) > 1 then begin
					fWord2 := Copy(wfcWord, Length(wfcWord), 1);
				end;
			end;
			// Чередование -і- -о-
			// неясна зависимоть.

			If tWord = 'мати' then begin
				If Pages = 1 then begin
					rWord := 'мати';
				end else if Pages = 2 then begin
					rWord := 'матері';
				end else if Pages = 3 then begin
					rWord := 'матері';
				end else if Pages = 4 then begin
					rWord := 'матір';
				end else if Pages = 5 then begin
					rWord := 'матірю';
				end else if Pages = 6 then begin
					rWord := 'матері';
				end else if Pages = 7 then begin
					rWord := 'мати';
				end;
			end else begin
				If Pages = 1 then begin
					rWord := zWord + eWord;
				end else if Pages = 2 then begin
					rWord := zWord + 'і';
				end else if Pages = 3 then begin
					rWord := zWord + 'і';
				end else if Pages = 4 then begin
					rWord := zWord + eWord;
				end else if Pages = 5 then begin
					// якщо основа іменника закінчується одним приголосним (крім губного та р),
					// то після голосного перед закінченням цей приголосний подовжується
					// (на письмі подвоюється): височінн-ю, віссю , в'яззю, міддю;
					// якщо основа іменника закінчується сполученням приголосних або на губний
					// (б, п, в, м, ф), а також на р, щ, то подовження не відбувається:
					// верф'ю, вісс-ю, матір-ю, радіст-ю.

					If (Pos(fcWord1, 'мвбпфр') = 0)
					and (declGlasnay(fWord2, Country) = 1) then begin
						zWord := zWord + fcWord1;
					end else if fTip = 'Т' then begin
						// For изначально твердых окончаний основ - добавляется апостроф (Любов'ю)
						zWord := zWord + '''';
					end;

					rWord := zWord + 'ю';
				end else if Pages = 6 then begin
					rWord := zWord + 'і';
				end else if Pages = 7 then begin
					rWord := zWord + 'е';
				end;
			end;

		end;

	end;

	//Сообщить('П.'+Pages+'. '+tWord+'. IsJob = '+IsJob+'. rWord: '+rWord);

  Result := declReturnReg(rWord, AWord);
end;

function WordToList(Value : String): TValueList;
var i, k, n : Integer;
    s: String;
begin
	Result := TValueList.Create;
	i := 1;
	n := Length(Value);
	for k := 1 to n do
  begin
		if Pos(Value[i], ' -.,/()?[]') > 0 then
    begin
			if k - 1 > i + 1 then
      begin
				s := Copy(Value, i, k - i);
				Result.Add(s);
				i := k + 1;
			end;
		end;
	end;
	If n - 1 > i + 1 then
  begin
		s := Copy(Value, i, n - i + 1);
		Result.Add(Value);
	end;
end;

function ToJob(Job, Dept, Sex: String; Pages: Byte = 2; Country: String = 'UA'): String;
var
	tSex,
  tJob,
  tDept,
  tDept1,
  l_t_Dept,
  tJob2,
  tJob5,
  tWord,
  FWDept: String;
  PagesDept,
  w_s_Job: Byte;
  wJobList,
  wJobList2,
  wJobList5: TValueList;
  k,
  pSpace: Integer;
begin
	//If (Sex <> 'м') and (Sex <> 'ж') then begin
		tSex := 'м';
	//end;

  w_s_Job := 0;

	tJob := DeclWord(Job, tSex, w_s_Job, Pages, Country, 'Д');
	If Trim(tJob) <> '' then begin
		PagesDept := 2;
	end else begin
		PagesDept := Pages;
	end;
  w_s_Job := 0;
	tDept := DeclWord(Dept, tSex, w_s_Job, PagesDept, Country, 'Д');
  w_s_Job := 0;
	tDept1 := DeclWord(Dept, tSex, w_s_Job, 5, Country, 'Д');

	// Попробуем убрать лишние слова при родительном падеже отдела
	l_t_Dept := AnsiLowerCase(tDept);
	tJob2 := tJob;
	wJobList := WordToList(tJob2);
	For k := 0 to wJobList.Count - 1 do
  begin
		tWord := wJobList.Strings[k];
		if Pos(tWord + ' ', l_t_Dept) > 0 then
    begin
			tJob2 := StringReplace(tJob2, tWord + ' ', '',[rfReplaceAll]);
		end
    else if Pos(' ' + tWord, l_t_Dept) > 0 then
    begin
			tJob2 := StringReplace(tJob2, ' ' + tWord, '',[rfReplaceAll]);
		end;
	end;

	// При творительном падеже отдела
	l_t_Dept := AnsiLowerCase(tDept1);
	tJob5 := tJob;
	wJobList := WordToList(tJob5);
	for k := 0 to wJobList.Count-1 do
  begin
		tWord := wJobList.Strings[k];
		if Pos(tWord + ' ', tDept1) > 0 then
    begin
			tJob5 := StringReplace(tJob5, tWord+' ', '', [rfReplaceAll]);
		end
    else if Pos(' ' + tWord, tDept1) > 0 then
    begin
			tJob5 := StringReplace(tJob5, ' ' + tWord, '', [rfReplaceAll]);
		end;
	end;

	// Оставим вариант с меньшим числом слов должности
	wJobList2 := WordToList(tJob2);
	wJobList5 := WordToList(tJob5);
	If wJobList2.Count <= wJobList5.Count then
  begin
		tJob := tJob2;
	end
  else begin
		tJob := tJob5;
		tDept := tDept1;
	end;

	pSpace := Pos(' ', Dept);
	If pSpace = 0 then begin
		FWDept := Dept;
	end else begin
		FWDept := Copy(Dept, 1, pSpace - 1);
	end;

  if ExceptList.GetValueByKey('НижнийРегистрПервоеСловоОтдела') is TValueList then begin
    if TValueList(ExceptList.GetValueByKey('НижнийРегистрПервоеСловоОтдела')).FindKey(AnsiLowerCase(FWDept)) > 0 then
    begin
      if AnsiUpperCase(Dept) <> Dept then
      begin
        // Если не все капитализированные, тогда ставим нижний регистр для первого символа
        tDept := AnsiUpperCase(Copy(tDept, 1,1)) + Copy(tDept, 2, 255);
      end;
    end;
  end;

	Result := '';
	If tJob <> '' then
  begin
		Result := Result + tJob;
	end;
	If tDept <> '' then
  begin
		If Result <> '' then
    begin
			Result := Result + ' ';
		end;
		Result := Result + tDept;
	end;
end;

procedure LoadExceptList;
var s : string;
begin
  ValueListUnit.FreeExceptList(ExceptList);
  ExceptList := nil;
  s := ExtractFilePath(Application.ExeName) +'MainUA.dic';
  ExceptList := ValueListUnit.LoadExceptList(s);
end;

end.
