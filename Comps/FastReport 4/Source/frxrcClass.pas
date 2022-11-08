{******************************************}
{                                          }
{             FastReport v4.0              }
{          Language resource file          }
{                                          }
{         Copyright (c) 1998-2007          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxrcClass;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.0" encoding="utf-8"?><Resources CodePage="1251"><StrRes Name="1" Text="ОК"/><StrRes Name="2" Text="Отмена"/><StrRes Name="3" ' + 
'Text="Все"/><StrRes Name="4" Text="Текущая"/><StrRes Name="5" Text="Номера:"/><StrRes Name="6" Text="Разрывы страниц"/><' + 
'StrRes Name="7" Text="Страницы"/><StrRes Name="8" Text="Опции"/><StrRes Name="9" Text="Введите номера и/или диапаз' + 
'оны страниц, разделенные запятыми. Например, 1,3,5-12"/><StrRes Name="100" Text="Предварительный �' + 
'�росмотр"/><StrRes Name="101" Text="Печать"/><StrRes Name="102" Text="Печать"/><StrRes Name="103" Text="Открыть"/><StrRes Na' + 
'me="104" Text="Открыть"/><StrRes Name="105" Text="Сохранить"/><StrRes Name="106" Text="Сохранить"/><StrRes Name="107" Text="�' + 
'�кспорт"/><StrRes Name="108" Text="Экспорт"/><StrRes Name="109" Text="Найти"/><StrRes Name="110" Text="Найти"/><StrRes Name="11' + 
'1" Text="Целиком"/><StrRes Name="112" Text="Страница целиком"/><StrRes Name="113" Text="По ширине"/><StrRes Name="114" T' + 
'ext="По ширине"/><StrRes Name="115" Text="100%"/><StrRes Name="116" Text="100%"/><StrRes Name="117" Text="Две страницы"/><StrRes Na' + 
'me="118" Text="Две страницы"/><StrRes Name="119" Text="Масштаб"/><StrRes Name="120" Text="Поля"/><StrRes Name="121" Text="Сво' + 
'йства страницы"/><StrRes Name="122" Text="Дерево"/><StrRes Name="123" Text="Дерево отчета"/><StrRes Name="124" Text="У' + 
'величить"/><StrRes Name="125" Text="Увеличить"/><StrRes Name="126" Text="Уменьшить"/><StrRes Name="127" Text="Уменьши' + 
'ть"/><StrRes Name="128" Text="Дерево"/><StrRes Name="129" Text="Дерево отчета"/><StrRes Name="130" Text="Миниатюры"/><Str' + 
'Res Name="131" Text="Миниатюры"/><StrRes Name="132" Text="Правка"/><StrRes Name="133" Text="Редактировать страницу' + 
'"/><StrRes Name="134" Text="Первая"/><StrRes Name="135" Text="На первую страницу"/><StrRes Name="136" Text="Предыдущая' + 
'"/><StrRes Name="137" Text="На предыдущую страницу"/><StrRes Name="138" Text="Следующая"/><StrRes Name="139" Text="На �' + 
'�ледующую страницу"/><StrRes Name="140" Text="Последняя"/><StrRes Name="141" Text="На последнюю страницу"/' + 
'><StrRes Name="142" Text="Номер страницы"/><StrRes Name="150" Text="Во весь экран"/><StrRes Name="151" Text="Сохранит�' + 
'� в PDF"/><StrRes Name="152" Text="Отослать по E-mail"/><StrRes Name="zmPageWidth" Text="По ширине"/><StrRes Name="zmWholePage" Tex' + 
't="Страница целиком"/><StrRes Name="200" Text="Печать"/><StrRes Name="201" Text="Принтер"/><StrRes Name="202" Text="Стр' + 
'аницы"/><StrRes Name="203" Text="Количество"/><StrRes Name="204" Text="Разобрать по копиям"/><StrRes Name="205" Text="' + 
'Копии"/><StrRes Name="206" Text="Печатать"/><StrRes Name="207" Text="Прочее"/><StrRes Name="208" Text="Где:"/><StrRes Name="209"' + 
' Text="Свойства..."/><StrRes Name="210" Text="Печать в файл"/><StrRes Name="211" Text="Порядок"/><StrRes Name="212" Text="И' + 
'мя:"/><StrRes Name="213" Text="Режим печати"/><StrRes Name="214" Text="Печатать на листе"/><StrRes Name="216" Text="Дуп' + 
'лекс"/><StrRes Name="ppAll" Text="Все страницы"/><StrRes Name="ppOdd" Text="Нечетные страницы"/><StrRes Name="ppEven" T' + 
'ext="Четные страницы"/><StrRes Name="pgDefault" Text="По умолчанию"/><StrRes Name="pmDefault" Text="По умолчанию"/' + 
'><StrRes Name="pmSplit" Text="Разрезать большие страницы"/><StrRes Name="pmJoin" Text="Объединять маленькие' + 
' страницы"/><StrRes Name="pmScale" Text="Масштабировать"/><StrRes Name="poDirect" Text="Прямой (1-9)"/><StrRes Name="poRev' + 
'erse" Text="Обратный (9-1)"/><StrRes Name="300" Text="Искать текст"/><StrRes Name="301" Text="Текст:"/><StrRes Name="302" Text' + 
'="Настройки поиска   "/><StrRes Name="303" Text="Заменить"/><StrRes Name="304" Text="Искать с начала"/><StrRes Nam' + 
'e="305" Text="Различать регистр"/><StrRes Name="400" Text="Настройки страницы"/><StrRes Name="401" Text="Ширина' + 
'"/><StrRes Name="402" Text="Высота"/><StrRes Name="403" Text="Размер   "/><StrRes Name="404" Text="Ориентация   "/><StrRes Name=' + 
'"405" Text="Левое"/><StrRes Name="406" Text="Верхнее"/><StrRes Name="407" Text="Правое"/><StrRes Name="408" Text="Нижнее"/><St' + 
'rRes Name="409" Text="Поля   "/><StrRes Name="410" Text="Портретная"/><StrRes Name="411" Text="Альбомная"/><StrRes Name="412" T' + 
'ext="Прочее   "/><StrRes Name="413" Text="Применить к текущей странице"/><StrRes Name="414" Text="Применить к' + 
'о всем страницам"/><StrRes Name="500" Text="Печать"/><StrRes Name="501" Text="Принтер   "/><StrRes Name="502" Text="Стр�' + 
'�ницы   "/><StrRes Name="503" Text="Копии   "/><StrRes Name="504" Text="Количество"/><StrRes Name="505" Text="Опции   "/><StrR' + 
'es Name="506" Text="ESC-команды   "/><StrRes Name="507" Text="Печать в файл"/><StrRes Name="508" Text="OEM-кодировка"/><Str' + 
'Res Name="509" Text="Псевдографика"/><StrRes Name="510" Text="Файл печати (*.prn)|*.prn"/><StrRes Name="mbConfirm" Text="Под' + 
'тверждение"/><StrRes Name="mbError" Text="Ошибка"/><StrRes Name="mbInfo" Text="Информация"/><StrRes Name="xrCantFindClass" T' + 
'ext="Не удалось найти класс"/><StrRes Name="prVirtual" Text="Виртуальный"/><StrRes Name="prDefault" Text="По умол�' + 
'�анию"/><StrRes Name="prCustom" Text="Пользовательский"/><StrRes Name="enUnconnHeader" Text="Не подключенный header/' + 
'footer"/><StrRes Name="enUnconnGroup" Text="Нет дата-бэнда для группы"/><StrRes Name="enUnconnGFooter" Text="Нет заголо�' + 
'�ка группы"/><StrRes Name="enBandPos" Text="Неправильно расположен бэнд:"/><StrRes Name="dbNotConn" Text="Компо�' + 
'�ент %s не подключен к данным"/><StrRes Name="dbFldNotFound" Text="Поле не найдено:"/><StrRes Name="clDSNotIncl" Tex' + 
't="(компонент не включен в Report.DataSets)"/><StrRes Name="clUnknownVar" Text="Неизвестная переменная или ' + 
'поле БД:"/><StrRes Name="clScrError" Text="Ошибка в скрипте %s: %s"/><StrRes Name="clDSNotExist" Text="Набор данных &#3' + 
'8;#34;%s&#38;#34; не найден"/><StrRes Name="clErrors" Text="Были обнаружены следующие ошибки:"/><StrRes Name="clE' + 
'xprError" Text="Ошибка в выражении"/><StrRes Name="clFP3files" Text="Готовый отчет"/><StrRes Name="clSaving" Text="Сох�' + 
'�аняется файл..."/><StrRes Name="clCancel" Text="Отмена"/><StrRes Name="clClose" Text="Закрыть"/><StrRes Name="clPrinting" Tex' + 
't="Печатается страница"/><StrRes Name="clLoading" Text="Загружается файл..."/><StrRes Name="clPageOf" Text="Стра�' + 
'�ица %d из %d"/><StrRes Name="clFirstPass" Text="Первый проход: страница "/><StrRes Name="clNoPrinters" Text="В вашей �' + 
'�истеме не установлено принтеров"/><StrRes Name="clDecompressError" Text="Ошибка распаковки данных"/' + 
'><StrRes Name="crFillMx" Text="Заполняется cross-tab..."/><StrRes Name="crBuildMx" Text="Строится cross-tab..."/><StrRes Name="prRu' + 
'nningFirst" Text="Первый проход: страница %d"/><StrRes Name="prRunning" Text="Готовится страница %d"/><StrRes Nam' + 
'e="prPrinting" Text="Печатается страница %d"/><StrRes Name="prExporting" Text="Экспорт страницы %d"/><StrRes Name="uC' + 
'm" Text="см"/><StrRes Name="uInch" Text="in"/><StrRes Name="uPix" Text="px"/><StrRes Name="uChar" Text="chr"/><StrRes Name="dupDefault" Text="По �' + 
'�молчанию"/><StrRes Name="dupVert" Text="Вертикальный"/><StrRes Name="dupHorz" Text="Горизонтальный"/><StrRes Name="' + 
'dupSimpl" Text="Не использовать"/><StrRes Name="SLangNotFound" Text="Язык ''%s'' не найден"/><StrRes Name="SInvalidLanguage" T' + 
'ext="Ошибка в описании языка"/><StrRes Name="SIdRedeclared" Text="Идентификатор переопределен: "/><StrRe' + 
's Name="SUnknownType" Text="Неизвестный тип: "/><StrRes Name="SIncompatibleTypes" Text="Несовместимые типы"/><StrRes Na' + 
'me="SIdUndeclared" Text="Неопределенный идентификатор: "/><StrRes Name="SClassRequired" Text="Ожидается класс' + 
'"/><StrRes Name="SIndexRequired" Text="Ожидается индекс"/><StrRes Name="SStringError" Text="Строка не имеет свойств' + 
' или методов"/><StrRes Name="SClassError" Text="Класс %s не содержит свойства по умолчанию"/><StrRes Name=' + 
'"SArrayRequired" Text="Ожидается массив"/><StrRes Name="SVarRequired" Text="Ожидается переменная"/><StrRes Name="SNo' + 
'tEnoughParams" Text="Недостаточно параметров"/><StrRes Name="STooManyParams" Text="Слишком много параметро�' + 
'�"/><StrRes Name="SLeftCantAssigned" Text="Левая часть выражения не может быть присвоена"/><StrRes Name="SForEr' + 
'ror" Text="Переменная цикла FOR должна быть числовой"/><StrRes Name="SEventError" Text="Обработчик собы' + 
'тия должен быть процедурой"/><StrRes Name="600" Text="Раскрыть все"/><StrRes Name="601" Text="Свернуть вс�' + 
'�"/></Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
