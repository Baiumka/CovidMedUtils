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

unit frxrcDesgn;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.0" encoding="utf-8"?><Resources CodePage="1251"><StrRes Name="2000" Text="Инспектор"/><StrRes Name="oiProp" Text="Свойс' + 
'тва"/><StrRes Name="oiEvent" Text="События"/><StrRes Name="2100" Text="Дерево данных"/><StrRes Name="2101" Text="Поля БД"/' + 
'><StrRes Name="2102" Text="Переменные"/><StrRes Name="2103" Text="Функции"/><StrRes Name="2104" Text="Вставлять поле"/><' + 
'StrRes Name="2105" Text="Вставлять заголовок"/><StrRes Name="2106" Text="Классы"/><StrRes Name="dtNoData" Text="Нет дан�' + 
'�ых"/><StrRes Name="dtNoData1" Text="Зайдите в меню &#38;#34;Отчет|Данные...&#38;#34;, чтобы добавить сущес' + 
'твующие наборы данных в отчет, или переключитесь на закладку &#38;#34;Данные&#38;#34; и со' + 
'здайте новые наборы данных."/><StrRes Name="dtData" Text="Данные"/><StrRes Name="dtSysVar" Text="Системные"/><St' + 
'rRes Name="dtVar" Text="Переменные"/><StrRes Name="dtFunc" Text="Функции"/><StrRes Name="2200" Text="Дерево отчета"/><Str' + 
'Res Name="2300" Text="Открыть скрипт"/><StrRes Name="2301" Text="Сохранить скрипт"/><StrRes Name="2302" Text="Запуст' + 
'ить отчет"/><StrRes Name="2303" Text="Отладка"/><StrRes Name="2304" Text="Остановить"/><StrRes Name="2305" Text="Вычисл' + 
'ить"/><StrRes Name="2306" Text="Язык:"/><StrRes Name="2307" Text="Выравнивание"/><StrRes Name="2308" Text="Выровнять ле�' + 
'�ые края"/><StrRes Name="2309" Text="Центрировать по горизонтали"/><StrRes Name="2310" Text="Выровнять пра�' + 
'�ые края"/><StrRes Name="2311" Text="Выровнять верхние края"/><StrRes Name="2312" Text="Центрировать по гор' + 
'изонтали"/><StrRes Name="2313" Text="Выровнять нижние края"/><StrRes Name="2314" Text="Расположить равном�' + 
'�рно по ширине"/><StrRes Name="2315" Text="Расположить равномерно по высоте"/><StrRes Name="2316" Text="Цен' + 
'трировать по горизонтали на бэнде"/><StrRes Name="2317" Text="Центрировать по вертикали на бэ�' + 
'�де"/><StrRes Name="2318" Text="Та же ширина"/><StrRes Name="2319" Text="Та же высота"/><StrRes Name="2320" Text="Текст"/><' + 
'StrRes Name="2321" Text="Стиль"/><StrRes Name="2322" Text="Имя шрифта"/><StrRes Name="2323" Text="Размер шрифта"/><StrRes Na' + 
'me="2324" Text="Полужирный"/><StrRes Name="2325" Text="Курсив"/><StrRes Name="2326" Text="Подчеркивание"/><StrRes Name="2' + 
'327" Text="Цвет шрифта"/><StrRes Name="2328" Text="Условное выделение"/><StrRes Name="2329" Text="Поворот текст' + 
'а"/><StrRes Name="2330" Text="Выровнять текст влево"/><StrRes Name="2331" Text="Центрировать текст по гори�' + 
'�онтали"/><StrRes Name="2332" Text="Выровнять текст вправо"/><StrRes Name="2333" Text="Выровнять текст по ш' + 
'ирине"/><StrRes Name="2334" Text="Выровнять по верхнему краю"/><StrRes Name="2335" Text="Центрировать текс' + 
'т по вертикали"/><StrRes Name="2336" Text="Выровнять по нижнему краю"/><StrRes Name="2337" Text="Рамка"/><StrRe' + 
's Name="2338" Text="Верхняя линия"/><StrRes Name="2339" Text="Нижняя линия"/><StrRes Name="2340" Text="Левая линия"/>' + 
'<StrRes Name="2341" Text="Правая линия"/><StrRes Name="2342" Text="Все линии рамки"/><StrRes Name="2343" Text="Убрать р' + 
'амку"/><StrRes Name="2344" Text="Тень"/><StrRes Name="2345" Text="Цвет заливки"/><StrRes Name="2346" Text="Цвет рамки"/><S' + 
'trRes Name="2347" Text="Стиль рамки"/><StrRes Name="2348" Text="Толщина рамки"/><StrRes Name="2349" Text="Стандартная' + 
'"/><StrRes Name="2350" Text="Новый отчет"/><StrRes Name="2351" Text="Открыть"/><StrRes Name="2352" Text="Сохранить"/><StrRes' + 
' Name="2353" Text="Предварительный просмотр"/><StrRes Name="2354" Text="Добавить страницу в отчет"/><StrR' + 
'es Name="2355" Text="Добавить форму в отчет"/><StrRes Name="2356" Text="Удалить страницу"/><StrRes Name="2357" Text=' + 
'"Настройки страницы"/><StrRes Name="2358" Text="Переменные"/><StrRes Name="2359" Text="Вырезать"/><StrRes Name="236' + 
'0" Text="Копировать"/><StrRes Name="2361" Text="Вставить"/><StrRes Name="2362" Text="Копировать формат"/><StrRes Nam' + 
'e="2363" Text="Отменить"/><StrRes Name="2364" Text="Повторить"/><StrRes Name="2365" Text="Сгруппировать"/><StrRes Name="' + 
'2366" Text="Разгруппировать"/><StrRes Name="2367" Text="Показывать сетку"/><StrRes Name="2368" Text="Выравнива�' + 
'�ие по сетке"/><StrRes Name="2369" Text="Расположить объекты в узлах сетки"/><StrRes Name="2370" Text="Масш�' + 
'�аб"/><StrRes Name="2371" Text="Мастера"/><StrRes Name="2372" Text="Выбор объектов"/><StrRes Name="2373" Text="Рука"/><StrRe' + 
's Name="2374" Text="Лупа"/><StrRes Name="2375" Text="Редактор текста"/><StrRes Name="2376" Text="Копирование внешне' + 
'го вида"/><StrRes Name="2377" Text="Вставить бэнд"/><StrRes Name="2378" Text="&Файл"/><StrRes Name="2379" Text="&Правка"/>' + 
'<StrRes Name="2380" Text="Найти..."/><StrRes Name="2381" Text="Найти далее"/><StrRes Name="2382" Text="Заменить..."/><StrRes Na' + 
'me="2383" Text="&Отчет"/><StrRes Name="2384" Text="Данные..."/><StrRes Name="2385" Text="Настройки..."/><StrRes Name="2386" Text="' + 
'Стили..."/><StrRes Name="2387" Text="&Вид"/><StrRes Name="2388" Text="Панели инструментов"/><StrRes Name="2389" Text="Ста' + 
'ндартная"/><StrRes Name="2390" Text="Текст"/><StrRes Name="2391" Text="Рамка"/><StrRes Name="2392" Text="Выравнивание"/>' + 
'<StrRes Name="2393" Text="Мастера"/><StrRes Name="2394" Text="Инспектор"/><StrRes Name="2395" Text="Дерево данных"/><StrRe' + 
's Name="2396" Text="Дерево отчета"/><StrRes Name="2397" Text="Линейки"/><StrRes Name="2398" Text="Выносные линии"/><St' + 
'rRes Name="2399" Text="Удалить выносные линии"/><StrRes Name="2400" Text="Настройки..."/><StrRes Name="2401" Text="&?"/><' + 
'StrRes Name="2402" Text="Справка..."/><StrRes Name="2403" Text="О FastReport..."/><StrRes Name="2404" Text="Редактор TabOrder..."/><St' + 
'rRes Name="2405" Text="Отменить"/><StrRes Name="2406" Text="Повторить"/><StrRes Name="2407" Text="Вырезать"/><StrRes Name="24' + 
'08" Text="Копировать"/><StrRes Name="2409" Text="Вставить"/><StrRes Name="2410" Text="Сгруппировать"/><StrRes Name="241' + 
'1" Text="Разгруппировать"/><StrRes Name="2412" Text="Удалить"/><StrRes Name="2413" Text="Удалить страницу"/><StrR' + 
'es Name="2414" Text="Выбрать все"/><StrRes Name="2415" Text="Редактировать..."/><StrRes Name="2416" Text="На передний' + 
' план"/><StrRes Name="2417" Text="На задний план"/><StrRes Name="2418" Text="Новый..."/><StrRes Name="2419" Text="Новый от' + 
'чет"/><StrRes Name="2420" Text="Новая страница"/><StrRes Name="2421" Text="Новая форма"/><StrRes Name="2422" Text="Откр�' + 
'�ть..."/><StrRes Name="2423" Text="Сохранить"/><StrRes Name="2424" Text="Сохранить как..."/><StrRes Name="2425" Text="Пере�' + 
'�енные..."/><StrRes Name="2426" Text="Настройки страницы..."/><StrRes Name="2427" Text="Просмотр"/><StrRes Name="2428" T' + 
'ext="Выход"/><StrRes Name="2429" Text="Заголовок отчета"/><StrRes Name="2430" Text="Подвал отчета"/><StrRes Name="2431' + 
'" Text="Заголовок страницы"/><StrRes Name="2432" Text="Подвал страницы"/><StrRes Name="2433" Text="Заголовок �' + 
'�анных"/><StrRes Name="2434" Text="Подвал данных"/><StrRes Name="2435" Text="Данные 1 уровня"/><StrRes Name="2436" Text="' + 
'Данные 2 уровня"/><StrRes Name="2437" Text="Данные 3 уровня"/><StrRes Name="2438" Text="Данные 4 уровня"/><StrRes ' + 
'Name="2439" Text="Данные 5 уровня"/><StrRes Name="2440" Text="Данные 6 уровня"/><StrRes Name="2441" Text="Заголовок �' + 
'�руппы"/><StrRes Name="2442" Text="Подвал группы"/><StrRes Name="2443" Text="Дочерний бэнд"/><StrRes Name="2444" Text="З' + 
'аголовок колонки"/><StrRes Name="2445" Text="Подвал колонки"/><StrRes Name="2446" Text="Фоновый бэнд"/><StrRes ' + 
'Name="2447" Text="Вертикальные бэнды"/><StrRes Name="2448" Text="Заголовок данных"/><StrRes Name="2449" Text="Подв' + 
'ал данных"/><StrRes Name="2450" Text="Данные 1 уровня"/><StrRes Name="2451" Text="Данные 2 уровня"/><StrRes Name="2452' + 
'" Text="Данные 3 уровня"/><StrRes Name="2453" Text="Заголовок группы"/><StrRes Name="2454" Text="Подвал группы"' + 
'/><StrRes Name="2455" Text="Дочерний бэнд"/><StrRes Name="2456" Text="0°"/><StrRes Name="2457" Text="45°"/><StrRes Name="2458" Text="90�' + 
'�"/><StrRes Name="2459" Text="180°"/><StrRes Name="2460" Text="270°"/><StrRes Name="2461" Text="Параметры шрифта"/><StrRes Name="2462' + 
'" Text="Полужирный"/><StrRes Name="2463" Text="Наклонный"/><StrRes Name="2464" Text="Подчеркнутый"/><StrRes Name="2465"' + 
' Text="Верхний индекс"/><StrRes Name="2466" Text="Нижний индекс"/><StrRes Name="2467" Text="Сжатый"/><StrRes Name="2468' + 
'" Text="Широкий"/><StrRes Name="2469" Text="12 символов/дюйм"/><StrRes Name="2470" Text="15 символов/дюйм"/><StrRes Nam' + 
'e="2471" Text="Отчет (*.fr3)|*.fr3"/><StrRes Name="2472" Text="Файлы Pascal (*.pas)|*.pas|Файлы C++ (*.cpp)|*.cpp|Файлы JavaScript' + 
' (*.js)|*.js|Файлы Basic (*.vb)|*.vb|All files|*.*"/><StrRes Name="2473" Text="Файлы Pascal (*.pas)|*.pas|Файлы C++ (*.cpp)|*.cpp|Фа�' + 
'�лы JavaScript (*.js)|*.js|Файлы Basic (*.vb)|*.vb|All files|*.*"/><StrRes Name="2474" Text="Подключения..."/><StrRes Name="2475" Te' + 
'xt="Язык"/><StrRes Name="2476" Text="Точка останова"/><StrRes Name="2477" Text="Выполнить до текущей позиции' + 
'"/><StrRes Name="2478" Text="Добавить дочерний бэнд"/><StrRes Name="dsCm" Text="Сантиметры"/><StrRes Name="dsInch" Text=' + 
'"Дюймы"/><StrRes Name="dsPix" Text="Точки"/><StrRes Name="dsChars" Text="Символы"/><StrRes Name="dsCode" Text="Код"/><StrRes Name=' + 
'"dsData" Text="Данные"/><StrRes Name="dsPage" Text="Стр."/><StrRes Name="dsRepFilter" Text="Отчет (*.fr3)|*.fr3"/><StrRes Name="dsComprR' + 
'epFilter" Text="Сжатый отчет (*.fr3)|*.fr3"/><StrRes Name="dsSavePreviewChanges" Text="Сохранить изменения?"/><StrRes Nam' + 
'e="dsSaveChangesTo" Text="Сохранить изменения в "/><StrRes Name="dsCantLoad" Text="Не удалось открыть файл"/><S' + 
'trRes Name="dsStyleFile" Text="Стиль"/><StrRes Name="dsCantFindProc" Text="Не удалось найти главную процедуру"/><St' + 
'rRes Name="dsClearScript" Text="Это очистит весь код. Продолжить?"/><StrRes Name="dsNoStyle" Text="Нет стиля"/><Str' + 
'Res Name="dsStyleSample" Text="Пример стиля"/><StrRes Name="dsTextNotFound" Text="Текст ''%s'' не найден"/><StrRes Name="dsRepla' + 
'ce" Text="Заменить ''%s''?"/><StrRes Name="2600" Text="О FastReport"/><StrRes Name="2601" Text="Посетите нашу страницу:"/><' + 
'StrRes Name="2602" Text="Продажи:"/><StrRes Name="2603" Text="Поддержка:"/><StrRes Name="2700" Text="Настройки страниц' + 
'ы"/><StrRes Name="2701" Text="Страница"/><StrRes Name="2702" Text="Ширина"/><StrRes Name="2703" Text="Высота"/><StrRes Name="2704' + 
'" Text="Формат   "/><StrRes Name="2705" Text="Ориентация   "/><StrRes Name="2706" Text="Левое"/><StrRes Name="2707" Text="Вер�' + 
'�нее"/><StrRes Name="2708" Text="Правое"/><StrRes Name="2709" Text="Нижнее"/><StrRes Name="2710" Text="Поля   "/><StrRes Name="2711' + 
'" Text="Источник бумаги   "/><StrRes Name="2712" Text="Для первой страницы"/><StrRes Name="2713" Text="Для оста�' + 
'�ьных"/><StrRes Name="2714" Text="Портретная"/><StrRes Name="2715" Text="Альбомная"/><StrRes Name="2716" Text="Прочее"/><' + 
'StrRes Name="2717" Text="Колонки   "/><StrRes Name="2718" Text="Количество"/><StrRes Name="2719" Text="Ширина"/><StrRes Name="2' + 
'720" Text="Позиции"/><StrRes Name="2721" Text="Прочее   "/><StrRes Name="2722" Text="Дуплекс"/><StrRes Name="2723" Text="Печа�' + 
'�ать на пред.странице"/><StrRes Name="2724" Text="Зеркальные поля"/><StrRes Name="2725" Text="Большая высот' + 
'а в дизайнере"/><StrRes Name="2726" Text="Бесконечная ширина"/><StrRes Name="2727" Text="Бесконечная высот' + 
'а"/><StrRes Name="2800" Text="Данные отчета"/><StrRes Name="2900" Text="Список переменных"/><StrRes Name="2901" Text="К�' + 
'�тегория"/><StrRes Name="2902" Text="Переменная"/><StrRes Name="2903" Text="Изменить"/><StrRes Name="2904" Text="Удалит' + 
'ь"/><StrRes Name="2905" Text="Список"/><StrRes Name="2906" Text="Открыть"/><StrRes Name="2907" Text="Сохранить"/><StrRes Name="' + 
'2908" Text=" Выражение:"/><StrRes Name="2909" Text="Список переменных (*.fd3)|*.fd3"/><StrRes Name="2910" Text="Список ' + 
'переменных (*.fd3)|*.fd3"/><StrRes Name="vaNoVar" Text="(нет переменных)"/><StrRes Name="vaVar" Text="Переменные"/><S' + 
'trRes Name="vaDupName" Text="Переменная с таким именем уже существует"/><StrRes Name="3000" Text="Настройк�' + 
'� дизайнера"/><StrRes Name="3001" Text="Сетка   "/><StrRes Name="3002" Text="Тип"/><StrRes Name="3003" Text="Размер"/><StrRes N' + 
'ame="3004" Text="Диалоговая форма:"/><StrRes Name="3005" Text="Прочее   "/><StrRes Name="3006" Text="Шрифты   "/><StrRes Na' + 
'me="3007" Text="Редактор кода"/><StrRes Name="3008" Text="Редактор текста"/><StrRes Name="3009" Text="Размер"/><StrRes' + 
' Name="3010" Text="Размер"/><StrRes Name="3011" Text="Цвета   "/><StrRes Name="3012" Text="Промежуток между бэндами:"' + 
'/><StrRes Name="3013" Text="см"/><StrRes Name="3014" Text="in"/><StrRes Name="3015" Text="pt"/><StrRes Name="3016" Text="pt"/><StrRes Name="3017" Te' + 
'xt="pt"/><StrRes Name="3018" Text="Сантиметры:"/><StrRes Name="3019" Text="Дюймы:"/><StrRes Name="3020" Text="Точки:"/><StrRes Nam' + 
'e="3021" Text="Показывать сетку"/><StrRes Name="3022" Text="Выравнивать по сетке"/><StrRes Name="3023" Text="Вызы' + 
'вать редактор после вставки"/><StrRes Name="3024" Text="Использовать шрифт объекта"/><StrRes Name="302' + 
'5" Text="Рабочее поле"/><StrRes Name="3026" Text="Окна"/><StrRes Name="3027" Text="Цвет сетки для LCD-монитора"/><S' + 
'trRes Name="3028" Text="Свободное размещение бэндов"/><StrRes Name="3029" Text="Показывать выпадающий с�' + 
'�исок полей"/><StrRes Name="3030" Text="Показывать окно приветствия"/><StrRes Name="3031" Text="Восстанови' + 
'ть настройки"/><StrRes Name="3032" Text="Показывать заголовки бэндов"/><StrRes Name="3100" Text="Источник ' + 
'данных"/><StrRes Name="3101" Text="Количество записей:"/><StrRes Name="dbNotAssigned" Text="[не назначен]"/><StrRes N' + 
'ame="3200" Text="Группа"/><StrRes Name="3201" Text="Условие   "/><StrRes Name="3202" Text="Свойства   "/><StrRes Name="3203" Text' + 
'="Поле БД"/><StrRes Name="3204" Text="Выражение"/><StrRes Name="3205" Text="Выводить группу на одной страни�' + 
'�е"/><StrRes Name="3206" Text="Формировать новую страницу"/><StrRes Name="3207" Text="Показывать в дереве о' + 
'тчета"/><StrRes Name="3300" Text="Служебный текст"/><StrRes Name="3301" Text="Дата-бэнд"/><StrRes Name="3302" Text="Наб�' + 
'�р данных"/><StrRes Name="3303" Text="Поле БД"/><StrRes Name="3304" Text="Функция"/><StrRes Name="3305" Text="Выражение"/' + 
'><StrRes Name="3306" Text="Агрегатная функция"/><StrRes Name="3307" Text="Системная переменная"/><StrRes Name="330' + 
'8" Text="Учитывать невидимые бэнды"/><StrRes Name="3309" Text="Текст"/><StrRes Name="3310" Text="Нарастающим и' + 
'тогом"/><StrRes Name="agAggregate" Text="Вставить агрегатную функцию"/><StrRes Name="vt1" Text="[DATE]"/><StrRes Name="v' + 
't2" Text="[TIME]"/><StrRes Name="vt3" Text="[PAGE#]"/><StrRes Name="vt4" Text="[TOTALPAGES#]"/><StrRes Name="vt5" Text="[PAGE#] из [TOTALPAGES#]"/><' + 
'StrRes Name="vt6" Text="[LINE#]"/><StrRes Name="3400" Text="OLE объект"/><StrRes Name="3401" Text="Вставить..."/><StrRes Name="3402" Tex' + 
't="Редактор..."/><StrRes Name="3403" Text="Закрыть"/><StrRes Name="olStretched" Text="Растягиваемый"/><StrRes Name="3500" ' + 
'Text="Штрихкод"/><StrRes Name="3501" Text="Код"/><StrRes Name="3502" Text="Тип штрихкода"/><StrRes Name="3503" Text="Масшт' + 
'аб:"/><StrRes Name="3504" Text="Свойства   "/><StrRes Name="3505" Text="Ориентация   "/><StrRes Name="3506" Text="Контроль' + 
'ная сумма"/><StrRes Name="3507" Text="Показывать текст"/><StrRes Name="3508" Text="0°"/><StrRes Name="3509" Text="90°"/><StrR' + 
'es Name="3510" Text="180°"/><StrRes Name="3511" Text="270°"/><StrRes Name="bcCalcChecksum" Text="Контрольная сумма"/><StrRes Name="b' + 
'cShowText" Text="Показывать текст"/><StrRes Name="3600" Text="Псевдонимы"/><StrRes Name="3601" Text="Нажмите Enter д�' + 
'�я редактирования"/><StrRes Name="3602" Text="Псевдоним набора данных"/><StrRes Name="3603" Text="Псевдони' + 
'мы полей"/><StrRes Name="3604" Text="Сброс"/><StrRes Name="3605" Text="Обновить"/><StrRes Name="alUserName" Text="Псевдони' + 
'м"/><StrRes Name="alOriginal" Text="Оригинальное имя"/><StrRes Name="3700" Text="Параметры"/><StrRes Name="qpName" Text="Им' + 
'я"/><StrRes Name="qpDataType" Text="Тип"/><StrRes Name="qpValue" Text="Значение"/><StrRes Name="3800" Text="Редактор Master-Detail' + 
'"/><StrRes Name="3801" Text="Поля Detail"/><StrRes Name="3802" Text="Поля Master"/><StrRes Name="3803" Text="Связанные поля"/><St' + 
'rRes Name="3804" Text="Добавить"/><StrRes Name="3805" Text="Очистить"/><StrRes Name="3900" Text="Редактор текста"/><StrR' + 
'es Name="3901" Text="Вставить выражение"/><StrRes Name="3902" Text="Вставить агрегатную функцию"/><StrRes Na' + 
'me="3903" Text="Вставить формат"/><StrRes Name="3904" Text="Переносить слова"/><StrRes Name="3905" Text="Текст"/><St' + 
'rRes Name="3906" Text="Формат"/><StrRes Name="3907" Text="Выделение"/><StrRes Name="4000" Text="Картинка"/><StrRes Name="4001" ' + 
'Text="Загрузить"/><StrRes Name="4002" Text="Копировать"/><StrRes Name="4003" Text="Вставить"/><StrRes Name="4004" Text="О�' + 
'�истить"/><StrRes Name="piEmpty" Text="Пусто"/><StrRes Name="4100" Text="Диаграмма"/><StrRes Name="4101" Text="Добавить с' + 
'ерию"/><StrRes Name="4102" Text="Удалить серию"/><StrRes Name="4103" Text="Редактировать серию"/><StrRes Name="4104"' + 
' Text="Данные из бэнда"/><StrRes Name="4105" Text="Фиксированные данные"/><StrRes Name="4106" Text="Набор дан�' + 
'�ых"/><StrRes Name="4107" Text="Данные"/><StrRes Name="4108" Text="Значения"/><StrRes Name="4109" Text="Выберите серию и' + 
'ли добавьте новую."/><StrRes Name="4114" Text="Свойства   "/><StrRes Name="4115" Text="Показывать TopN значени' + 
'й"/><StrRes Name="4116" Text="Заголовок TopN"/><StrRes Name="4117" Text="Сортировка"/><StrRes Name="4126" Text="Ось X как"/>' + 
'<StrRes Name="ch3D" Text="Трехмерная"/><StrRes Name="chAxis" Text="Показывать оси"/><StrRes Name="chsoNone" Text="Нет"/><Str' + 
'Res Name="chsoAscending" Text="По возрастанию"/><StrRes Name="chsoDescending" Text="По убыванию"/><StrRes Name="chxtText" Text=' + 
'"Текст"/><StrRes Name="chxtNumber" Text="Число"/><StrRes Name="chxtDate" Text="Дата"/><StrRes Name="4200" Text="RichEdit"/><StrRes Name=' + 
'"4201" Text="Открыть"/><StrRes Name="4202" Text="Сохранить"/><StrRes Name="4203" Text="Отменить"/><StrRes Name="4204" Text="Ш' + 
'рифт"/><StrRes Name="4205" Text="Вставить выражение"/><StrRes Name="4206" Text="Полужирный"/><StrRes Name="4207" Text="' + 
'Курсив"/><StrRes Name="4208" Text="Подчеркивание"/><StrRes Name="4209" Text="Выровнять текст влево"/><StrRes Nam' + 
'e="4210" Text="Выровнять текст по центру"/><StrRes Name="4211" Text="Выровнять текст вправо"/><StrRes Name="' + 
'4212" Text="Выровнять текст по ширине"/><StrRes Name="4213" Text="Список"/><StrRes Name="4300" Text="Редактор Cros' + 
's-tab"/><StrRes Name="4301" Text="Данные   "/><StrRes Name="4302" Text="Размерность   "/><StrRes Name="4303" Text="Строки"/><St' + 
'rRes Name="4304" Text="Колонки"/><StrRes Name="4305" Text="Ячейки"/><StrRes Name="4306" Text="Структура таблицы   "/><Str' + 
'Res Name="4307" Text="Заголовок строки"/><StrRes Name="4308" Text="Заголовок колонки"/><StrRes Name="4309" Text="Ито' + 
'г строки"/><StrRes Name="4310" Text="Итог колонки"/><StrRes Name="4311" Text="Поменять строки/колонки"/><StrRes' + 
' Name="4312" Text="Выберите стиль"/><StrRes Name="4313" Text="Сохранить текущий стиль..."/><StrRes Name="4314" Text=' + 
'"Заголовок таблицы"/><StrRes Name="4315" Text="Угол таблицы"/><StrRes Name="4316" Text="Повторять заголовк' + 
'и на новой странице"/><StrRes Name="4317" Text="Авто-размер"/><StrRes Name="4318" Text="Рамка вокруг ячеек"/' + 
'><StrRes Name="4319" Text="Печатать вниз, потом вбок"/><StrRes Name="4320" Text="Ячейки одной строкой"/><StrRes' + 
' Name="4321" Text="Объединять одинаковые ячейки"/><StrRes Name="4322" Text="Нет"/><StrRes Name="4323" Text="Sum"/><StrRes' + 
' Name="4324" Text="Min"/><StrRes Name="4325" Text="Max"/><StrRes Name="4326" Text="Average"/><StrRes Name="4327" Text="Count"/><StrRes Name="4328" Tex' + 
't="По возрастанию (А-Я)"/><StrRes Name="4329" Text="По убыванию (Я-А)"/><StrRes Name="4330" Text="Не сортироват' + 
'ь"/><StrRes Name="crStName" Text="Введите имя стиля:"/><StrRes Name="crResize" Text="Чтобы изменить размеры яче' + 
'ек, установите свойство AutoSize = False."/><StrRes Name="crSubtotal" Text="Подитоги"/><StrRes Name="crNone" Text="нет"' + 
'/><StrRes Name="crSum" Text="Sum"/><StrRes Name="crMin" Text="Min"/><StrRes Name="crMax" Text="Max"/><StrRes Name="crAvg" Text="Avg"/><StrRes Name="cr' + 
'Count" Text="Count"/><StrRes Name="crAsc" Text="А-Я"/><StrRes Name="crDesc" Text="Я-А"/><StrRes Name="4400" Text="Редактор выражен�' + 
'�й"/><StrRes Name="4401" Text="Выражение:"/><StrRes Name="4500" Text="Форматирование"/><StrRes Name="4501" Text="Катего�' + 
'�ия"/><StrRes Name="4502" Text="Формат"/><StrRes Name="4503" Text="Строка форматирования:"/><StrRes Name="4504" Text="Ра' + 
'зделитель дроби:"/><StrRes Name="fkText" Text="Текст"/><StrRes Name="fkNumber" Text="Число"/><StrRes Name="fkDateTime" Text="�' + 
'�ата/время"/><StrRes Name="fkBoolean" Text="Логическое"/><StrRes Name="fkNumber1" Text="1234.5;%g"/><StrRes Name="fkNumber2" Text="1' + 
'234.50;%2.2f"/><StrRes Name="fkNumber3" Text="1,234.50;%2.2n"/><StrRes Name="fkNumber4" Text="1,234.50р;%2.2m"/><StrRes Name="fkDateTime1" Text="28.1' + 
'1.2002;dd.mm.yyyy"/><StrRes Name="fkDateTime2" Text="28 Ноя 2002;dd mmm yyyy"/><StrRes Name="fkDateTime3" Text="28 Ноябрь 2002;dd mmmm yyyy"/' + 
'><StrRes Name="fkDateTime4" Text="02:14;hh:mm"/><StrRes Name="fkDateTime5" Text="02:14am;hh:mm am/pm"/><StrRes Name="fkDateTime6" Text="02:14:00;hh:mm' + 
':ss"/><StrRes Name="fkDateTime7" Text="02:14, 28 Ноября 2002;hh:mm dd mmmm yyyy"/><StrRes Name="fkBoolean1" Text="0,1;0,1"/><StrRes Name="fkBool' + 
'ean2" Text="Нет,Да;Нет,Да"/><StrRes Name="fkBoolean3" Text="_,x;_,x"/><StrRes Name="fkBoolean4" Text="False,True;False,True"/><StrRes Name="' + 
'4600" Text="Условное выделение"/><StrRes Name="4601" Text="Цвет..."/><StrRes Name="4602" Text="Цвет..."/><StrRes Name="4603" ' + 
'Text="Условие   "/><StrRes Name="4604" Text="Шрифт   "/><StrRes Name="4605" Text="Фон   "/><StrRes Name="4606" Text="Полужирны' + 
'й"/><StrRes Name="4607" Text="Курсив"/><StrRes Name="4608" Text="Подчеркнутый"/><StrRes Name="4609" Text="Прозрачный"/><S' + 
'trRes Name="4610" Text="Другой:"/><StrRes Name="4700" Text="Настройки отчета"/><StrRes Name="4701" Text="Основные"/><StrR' + 
'es Name="4702" Text="Настройки печати   "/><StrRes Name="4703" Text="Копии"/><StrRes Name="4704" Text="Свойства   "/><StrR' + 
'es Name="4705" Text="Пароль"/><StrRes Name="4706" Text="Разобрать по копиям"/><StrRes Name="4707" Text="Два прохода"/' + 
'><StrRes Name="4708" Text="Печатать, если пустой"/><StrRes Name="4709" Text="Описание"/><StrRes Name="4710" Text="Имя"/><' + 
'StrRes Name="4711" Text="Описание"/><StrRes Name="4712" Text="Картинка"/><StrRes Name="4713" Text="Автор"/><StrRes Name="4714" Te' + 
'xt="Major"/><StrRes Name="4715" Text="Minor"/><StrRes Name="4716" Text="Release"/><StrRes Name="4717" Text="Build"/><StrRes Name="4718" Text="Созд' + 
'ан"/><StrRes Name="4719" Text="Изменен"/><StrRes Name="4720" Text="Описание   "/><StrRes Name="4721" Text="Версия   "/><StrRes ' + 
'Name="4722" Text="Выбрать..."/><StrRes Name="4723" Text="Наследование"/><StrRes Name="4724" Text="Выберите действие' + 
':"/><StrRes Name="4725" Text="Не менять"/><StrRes Name="4726" Text="Отсоединить базовый отчет"/><StrRes Name="4727" Tex' + 
't="Наследовать от базового отчета:"/><StrRes Name="4728" Text="Наследование"/><StrRes Name="rePrnOnPort" Text="' + 
'на"/><StrRes Name="riNotInherited" Text="Этот отчет не наследован."/><StrRes Name="riInherited" Text="Этот отчет на�' + 
'�ледован от базового: %s"/><StrRes Name="4800" Text="Редактор строк"/><StrRes Name="4900" Text="Редактор SQL"/><' + 
'StrRes Name="4901" Text="Построитель запроса"/><StrRes Name="5000" Text="Пароль"/><StrRes Name="5001" Text="Введите п�' + 
'�роль:"/><StrRes Name="5100" Text="Стили"/><StrRes Name="5101" Text="Цвет..."/><StrRes Name="5102" Text="Шрифт..."/><StrRes Name="51' + 
'03" Text="Рамка..."/><StrRes Name="5104" Text="Добавить"/><StrRes Name="5105" Text="Удалить"/><StrRes Name="5106" Text="Правк' + 
'а"/><StrRes Name="5107" Text="Загрузить"/><StrRes Name="5108" Text="Сохранить"/><StrRes Name="5200" Text="Редактор рамк' + 
'и"/><StrRes Name="5201" Text="Рамка"/><StrRes Name="5202" Text="Линия"/><StrRes Name="5203" Text="Тень"/><StrRes Name="5204" Text="Ве' + 
'рхняя линия"/><StrRes Name="5205" Text="Нижняя линия"/><StrRes Name="5206" Text="Левая линия"/><StrRes Name="5207" Text' + 
'="Правая линия"/><StrRes Name="5208" Text="Все линии"/><StrRes Name="5209" Text="Выключить линии"/><StrRes Name="5210' + 
'" Text="Цвет рамки"/><StrRes Name="5211" Text="Стиль рамки"/><StrRes Name="5212" Text="Толщина линии"/><StrRes Name="52' + 
'13" Text="Тень"/><StrRes Name="5214" Text="Цвет тени"/><StrRes Name="5215" Text="Размер тени"/><StrRes Name="5300" Text="Соз�' + 
'�ать новый..."/><StrRes Name="5301" Text="Список"/><StrRes Name="5302" Text="Шаблоны"/><StrRes Name="5303" Text="Наследов' + 
'ать отчет"/><StrRes Name="5400" Text="Редактор TabOrder"/><StrRes Name="5401" Text="Элементы управления:"/><StrRes N' + 
'ame="5402" Text="Вверх"/><StrRes Name="5403" Text="Вниз"/><StrRes Name="5500" Text="Вычислить"/><StrRes Name="5501" Text="Выраж' + 
'ение"/><StrRes Name="5502" Text="Результат"/><StrRes Name="5600" Text="Мастер отчетов"/><StrRes Name="5601" Text="Данны' + 
'е"/><StrRes Name="5602" Text="Поля"/><StrRes Name="5603" Text="Группы"/><StrRes Name="5604" Text="Размещение"/><StrRes Name="5605' + 
'" Text="Стиль"/><StrRes Name="5606" Text="Шаг 1. Выберите набор данных."/><StrRes Name="5607" Text="Шаг 2. Выбери�' + 
'�е поля для отображения в отчете."/><StrRes Name="5608" Text="Шаг 3. Создайте группы (не обязател' + 
'ьно)."/><StrRes Name="5609" Text="Шаг 4. Выберите ориентацию листа и размещение данных."/><StrRes Name="' + 
'5610" Text="Шаг 5. Выберите стиль отчета."/><StrRes Name="5611" Text="Добавить &#62;"/><StrRes Name="5612" Text="Доб�' + 
'�вить все &#38;#62;&#38;#62;"/><StrRes Name="5613" Text="&#60; Удалить"/><StrRes Name="5614" Text="&#38;#60;&#38;#60; Удалить в�' + 
'�е"/><StrRes Name="5615" Text="Добавить &#62;"/><StrRes Name="5616" Text="&#60; Удалить"/><StrRes Name="5617" Text="Выбранные' + 
' поля:"/><StrRes Name="5618" Text="Доступные поля:"/><StrRes Name="5619" Text="Группы:"/><StrRes Name="5620" Text="Ориент' + 
'ация   "/><StrRes Name="5621" Text="Размещение   "/><StrRes Name="5622" Text="Портретная"/><StrRes Name="5623" Text="Альб�' + 
'�мная"/><StrRes Name="5624" Text="В виде таблицы"/><StrRes Name="5625" Text="В виде колонок"/><StrRes Name="5626" Text="У' + 
'местить все поля по ширине"/><StrRes Name="5627" Text="&#60;&#60; Назад"/><StrRes Name="5628" Text="Далее &#62;&#62;"/' + 
'><StrRes Name="5629" Text="Готово"/><StrRes Name="5630" Text="Новая таблица..."/><StrRes Name="5631" Text="Новый запрос..' + 
'."/><StrRes Name="5632" Text="Выберите подключение:"/><StrRes Name="5633" Text="Выберите таблицу:"/><StrRes Name="56' + 
'34" Text="или"/><StrRes Name="5635" Text="Создайте запрос..."/><StrRes Name="5636" Text="Настройка подключений"/>' + 
'<StrRes Name="wzStd" Text="Мастер стандартного отчета"/><StrRes Name="wzDMP" Text="Мастер матричного отче�' + 
'�а"/><StrRes Name="wzStdEmpty" Text="Пустой стандартный отчет"/><StrRes Name="wzDMPEmpty" Text="Пустой матричный' + 
' отчет"/><StrRes Name="5700" Text="Мастер подключения к БД"/><StrRes Name="5701" Text="Подключение"/><StrRes Name=' + 
'"5702" Text="Выберите тип подключения:"/><StrRes Name="5703" Text="Выберите базу данных:"/><StrRes Name="5704"' + 
' Text="Имя пользователя"/><StrRes Name="5705" Text="Пароль"/><StrRes Name="5706" Text="Спрашивать пароль"/><StrRe' + 
's Name="5707" Text="Использовать пароль:"/><StrRes Name="5708" Text="Таблица"/><StrRes Name="5709" Text="Выберите и�' + 
'�я таблицы:"/><StrRes Name="5710" Text="Фильтровать записи:"/><StrRes Name="5711" Text="Запрос"/><StrRes Name="5712" Te' + 
'xt="Текст запроса:"/><StrRes Name="5713" Text="Построитель запроса"/><StrRes Name="5714" Text="Редактироват�' + 
'� параметры"/><StrRes Name="ftAllFiles" Text="Все файлы"/><StrRes Name="ftPictures" Text="Картинки"/><StrRes Name="ftDB" Text' + 
'="Базы данных"/><StrRes Name="ftRichFile" Text="Файл RichText"/><StrRes Name="ftTextFile" Text="Текстовый файл"/><StrRes Na' + 
'me="prNotAssigned" Text="(Не определен)"/><StrRes Name="prInvProp" Text="Неверное значение свойства"/><StrRes Name=' + 
'"prDupl" Text="Повторяющееся имя"/><StrRes Name="prPict" Text="(Картинка)"/><StrRes Name="mvExpr" Text="Выражения в ' + 
'тексте"/><StrRes Name="mvStretch" Text="Растягиваемый"/><StrRes Name="mvStretchToMax" Text="Растягивание до макс.' + 
'высоты"/><StrRes Name="mvShift" Text="Смещаемый"/><StrRes Name="mvShiftOver" Text="Смещаемый при перекрытии"/><St' + 
'rRes Name="mvVisible" Text="Видимый"/><StrRes Name="mvPrintable" Text="Печатаемый"/><StrRes Name="mvFont" Text="Шрифт..."/><StrR' + 
'es Name="mvFormat" Text="Форматирование..."/><StrRes Name="mvClear" Text="Очистить текст"/><StrRes Name="mvAutoWidth" Text=' + 
'"Автоширина"/><StrRes Name="mvWWrap" Text="Переносить слова"/><StrRes Name="mvSuppress" Text="Скрывать повторя' + 
'ющиеся"/><StrRes Name="mvHideZ" Text="Скрывать нули"/><StrRes Name="mvHTML" Text="HTML-тэги в тексте"/><StrRes Name="lvDi' + 
'agonal" Text="Диагональная"/><StrRes Name="pvAutoSize" Text="Авторазмер"/><StrRes Name="pvCenter" Text="Центрировать' + 
'"/><StrRes Name="pvAspect" Text="Сохранять пропорции"/><StrRes Name="bvSplit" Text="Разрешить разрыв"/><StrRes Name="' + 
'bvKeepChild" Text="Держать Child вместе"/><StrRes Name="bvPrintChild" Text="Печатать Child если невидимый"/><StrRes ' + 
'Name="bvStartPage" Text="Формировать новую страницу"/><StrRes Name="bvPrintIfEmpty" Text="Печатать, если Detail п' + 
'уст"/><StrRes Name="bvKeepDetail" Text="Держать Detail вместе"/><StrRes Name="bvKeepFooter" Text="Держать подвал вмес' + 
'те"/><StrRes Name="bvReprint" Text="Выводить на новой странице"/><StrRes Name="bvOnFirst" Text="Печатать на пер�' + 
'�ой странице"/><StrRes Name="bvOnLast" Text="Печатать на последней странице"/><StrRes Name="bvKeepGroup" Text="Д' + 
'ержать вместе"/><StrRes Name="bvFooterAfterEach" Text="Footer после каждой записи"/><StrRes Name="bvDrillDown" Text="Ра' + 
'зворачиваемый"/><StrRes Name="bvResetPageNo" Text="Сбрасывать номер страницы"/><StrRes Name="srParent" Text="Пе�' + 
'�атать на бэнде"/><StrRes Name="bvKeepHeader" Text="Держать заголовок вместе"/><StrRes Name="obCatDraw" Text="Рис' + 
'ование"/><StrRes Name="obCatOther" Text="Другие объекты"/><StrRes Name="obCatOtherControls" Text="Другие элементы"/><' + 
'StrRes Name="obDiagLine" Text="Диагональная линия"/><StrRes Name="obRect" Text="Прямоугольник"/><StrRes Name="obRoundRec' + 
't" Text="Скругленный прямоугольник"/><StrRes Name="obEllipse" Text="Эллипс"/><StrRes Name="obTrian" Text="Треугол' + 
'ьник"/><StrRes Name="obDiamond" Text="Ромб"/><StrRes Name="obLabel" Text="Элемент управления Label"/><StrRes Name="obEdit" Te' + 
'xt="Элемент управления Edit"/><StrRes Name="obMemoC" Text="Элемент управления Memo"/><StrRes Name="obButton" Text="�' + 
'�лемент управления Button"/><StrRes Name="obChBoxC" Text="Элемент управления CheckBox"/><StrRes Name="obRButton" Text' + 
'="Элемент управления RadioButton"/><StrRes Name="obLBox" Text="Элемент управления ListBox"/><StrRes Name="obCBox" Te' + 
'xt="Элемент управления ComboBox"/><StrRes Name="obDateEdit" Text="Элемент управления DateEdit"/><StrRes Name="obImag' + 
'eC" Text="Элемент управления Image"/><StrRes Name="obPanel" Text="Элемент управления Panel"/><StrRes Name="obGrBox" ' + 
'Text="Элемент управления GroupBox"/><StrRes Name="obBBtn" Text="Элемент управления BitBtn"/><StrRes Name="obSBtn" Te' + 
'xt="Элемент управления SpeedButton"/><StrRes Name="obMEdit" Text="Элемент управления MaskEdit"/><StrRes Name="obChLB' + 
'" Text="Элемент управления CheckListBox"/><StrRes Name="obDBLookup" Text="Элемент управления DBLookupComboBox"/><Str' + 
'Res Name="obBevel" Text="Элемент управления Bevel"/><StrRes Name="obShape" Text="Элемент управления Shape"/><StrRes ' + 
'Name="obText" Text="Объект &#38;#34;Текст&#38;#34;"/><StrRes Name="obSysText" Text="Объект &#38;#34;Служебный текст&#38' + 
';#34;"/><StrRes Name="obLine" Text="Объект &#38;#34;Линия&#38;#34;"/><StrRes Name="obPicture" Text="Объект &#38;#34;Рисунок&#3' + 
'8;#34;"/><StrRes Name="obBand" Text="Объект &#34;Бэнд&#34;"/><StrRes Name="obDataBand" Text="Объект &#38;#34;Дата-бэнд&#38;#34' + 
';"/><StrRes Name="obSubRep" Text="Объект &#38;#34;Вложенный отчет&#38;#34;"/><StrRes Name="obDlgPage" Text="Диалоговая �' + 
'�орма"/><StrRes Name="obRepPage" Text="Страница отчета"/><StrRes Name="obReport" Text="Объект &#38;#34;Отчет&#38;#34;"/><' + 
'StrRes Name="obRich" Text="Объект &#34;RichText&#34;"/><StrRes Name="obOLE" Text="Объект &#34;OLE&#34;"/><StrRes Name="obChBox" Text="Об' + 
'ъект &#34;CheckBox&#34;"/><StrRes Name="obChart" Text="Объект &#38;#34;Диаграмма&#38;#34;"/><StrRes Name="obBarC" Text="Объек�' + 
'� &#38;#34;Штрихкод&#38;#34;"/><StrRes Name="obCross" Text="Объект &#38;#34;Cross-tab&#38;#34;"/><StrRes Name="obDBCross" Text="Объе' + 
'кт &#38;#34;DB Cross-tab&#38;#34;"/><StrRes Name="obGrad" Text="Объект &#38;#34;Градиент&#38;#34;"/><StrRes Name="obDMPText" Text="О�' + 
'�ъект &#38;#34;Матричный текст&#38;#34;"/><StrRes Name="obDMPLine" Text="Объект &#38;#34;Матричная линия&#38;#34' + 
';"/><StrRes Name="obDMPCmd" Text="Объект &#38;#34;ESC-команда&#38;#34;"/><StrRes Name="obBDEDB" Text="База данных BDE"/><StrRes' + 
' Name="obBDETb" Text="Таблица BDE"/><StrRes Name="obBDEQ" Text="Запрос BDE"/><StrRes Name="obBDEComps" Text="Компоненты BDE"/><' + 
'StrRes Name="obIBXDB" Text="База данных IBX"/><StrRes Name="obIBXTb" Text="Таблица IBX"/><StrRes Name="obIBXQ" Text="Запрос IBX' + 
'"/><StrRes Name="obIBXComps" Text="Компоненты IBX"/><StrRes Name="obADODB" Text="База данных ADO"/><StrRes Name="obADOTb" Text="Т' + 
'аблица ADO"/><StrRes Name="obADOQ" Text="Запрос ADO"/><StrRes Name="obADOComps" Text="Компоненты ADO"/><StrRes Name="obDBXDB" Te' + 
'xt="База данных DBX"/><StrRes Name="obDBXTb" Text="Таблица DBX"/><StrRes Name="obDBXQ" Text="Запрос DBX"/><StrRes Name="obDBXCo' + 
'mps" Text="Компоненты DBX"/><StrRes Name="obFIBDB" Text="База данных FIB"/><StrRes Name="obFIBTb" Text="Таблица FIB"/><StrR' + 
'es Name="obFIBQ" Text="Запрос FIB"/><StrRes Name="obFIBComps" Text="Компоненты FIB"/><StrRes Name="ctString" Text="Строки"/><Str' + 
'Res Name="ctDate" Text="Дата и время"/><StrRes Name="ctConv" Text="Конвертирование"/><StrRes Name="ctFormat" Text="Форма' + 
'тирование"/><StrRes Name="ctMath" Text="Математические"/><StrRes Name="ctOther" Text="Прочие"/><StrRes Name="IntToStr" Te' + 
'xt="Конвертирует целое число в строку"/><StrRes Name="FloatToStr" Text="Конвертирует вещественное' + 
' число в строку"/><StrRes Name="DateToStr" Text="Конвертирует дату в строку"/><StrRes Name="TimeToStr" Text="Кон' + 
'вертирует время в строку"/><StrRes Name="DateTimeToStr" Text="Конвертирует дату и время в строку"/><' + 
'StrRes Name="VarToStr" Text="Конвертирует вариант в строку"/><StrRes Name="StrToInt" Text="Конвертирует стро' + 
'ку в целое число"/><StrRes Name="StrToInt64" Text="Converts a string to an Int64 value"/><StrRes Name="StrToFloat" Text="Конверти' + 
'рует строку в вещественное число"/><StrRes Name="StrToDate" Text="Конвертирует строку в дату"/><Str' + 
'Res Name="StrToTime" Text="Конвертирует строку во время"/><StrRes Name="StrToDateTime" Text="Конвертирует стр�' + 
'�ку в дату и время"/><StrRes Name="Format" Text="Возвращает форматированную строку"/><StrRes Name="FormatF' + 
'loat" Text="Форматирует вещественное число"/><StrRes Name="FormatDateTime" Text="Форматирует дату и вре' + 
'мя"/><StrRes Name="FormatMaskText" Text="Форматирует текст, используя заданную маску"/><StrRes Name="EncodeDat' + 
'e" Text="Возвращает значение TDateTime, соответствующее заданным значениям Year, Month, Day"/><StrRe' + 
's Name="DecodeDate" Text="Разбивает значение TDateTime на значения Year, Month, Day"/><StrRes Name="EncodeTime" Text="Во�' + 
'�вращает значение TDateTime, соответствующее заданным значениям Hour, Min, Sec, MSec"/><StrRes Name="De' + 
'codeTime" Text="Разбивает значение TDateTime на значения Hour, Min, Sec, MSec"/><StrRes Name="Date" Text="Возвраща�' + 
'�т текущую дату"/><StrRes Name="Time" Text="Возвращает текущее время"/><StrRes Name="Now" Text="Возвращает' + 
' текущую дату и время"/><StrRes Name="DayOfWeek" Text="Возвращает номер дня недели, соответствую�' + 
'�ий заданной дате"/><StrRes Name="IsLeapYear" Text="Возвращает True, если заданный год - високосный"/' + 
'><StrRes Name="DaysInMonth" Text="Возвращает число дней в заданном месяце"/><StrRes Name="Length" Text="Возвра' + 
'щает длину строки или массива"/><StrRes Name="Copy" Text="Возвращает подстроку"/><StrRes Name="Pos" Text="' + 
'Возвращает позицию подстроки в строке"/><StrRes Name="Delete" Text="Удаляет часть символов стр' + 
'оки"/><StrRes Name="Insert" Text="Вставляет подстроку в строку"/><StrRes Name="Uppercase" Text="Конвертирует �' + 
'�се символы строки в верхний регистр"/><StrRes Name="Lowercase" Text="Конвертирует все символы с�' + 
'�роки в нижний регистр"/><StrRes Name="Trim" Text="Удаляет пробелы в начале и конце строки"/><StrRe' + 
's Name="NameCase" Text="Конвертирует первый символ слова в верхний регистр"/><StrRes Name="CompareText" Te' + 
'xt="Сравнивает две строки без учета регистра"/><StrRes Name="Chr" Text="Конвертирует целое чис�' + 
'�о в символ"/><StrRes Name="Ord" Text="Конвертирует символ в целое число"/><StrRes Name="SetLength" Text="Уст�' + 
'�навливает длину строки"/><StrRes Name="Round" Text="Округляет число до ближайшего целого знач' + 
'ения"/><StrRes Name="Trunc" Text="Отбрасывает дробную часть числа"/><StrRes Name="Int" Text="Возвращает це' + 
'лую часть вещественного значения"/><StrRes Name="Frac" Text="Возвращает дробную часть вещест�' + 
'�енного значения"/><StrRes Name="Sqrt" Text="Возвращает корень квадратный из числа"/><StrRes Name="Abs"' + 
' Text="Возвращает модуль числа"/><StrRes Name="Sin" Text="Возвращает синус угла (в радианах)"/><StrRe' + 
's Name="Cos" Text="Возвращает косинус угла (в радианах)"/><StrRes Name="ArcTan" Text="Возвращает арктан�' + 
'�енс"/><StrRes Name="Tan" Text="Возвращает тангенс"/><StrRes Name="Exp" Text="Возвращает экспоненту"/><StrRes ' + 
'Name="Ln" Text="Возращает натуральный логарифм заданного числа"/><StrRes Name="Pi" Text="Возвращае�' + 
'� число &#38;#34;пи&#38;#34;"/><StrRes Name="Inc" Text="Увеличивает целое число на 1"/><StrRes Name="Dec" Text="Умен' + 
'ьшает целое число на 1"/><StrRes Name="RaiseException" Text="Вызывает исключение"/><StrRes Name="ShowMessage" Text=' + 
'"Показывает окно сообщения"/><StrRes Name="Randomize" Text="Запускает генератор случайных чисел' + 
'"/><StrRes Name="Random" Text="Возвращает случайное число"/><StrRes Name="ValidInt" Text="Возвращает True если �' + 
'�аданная строка может быть преобразована в целое число"/><StrRes Name="ValidFloat" Text="Возвращ�' + 
'�ет True если заданная строка может быть преобразована в вещественное число"/><StrRes Name' + 
'="ValidDate" Text="Возвращает True если заданная строка может быть преобразована в дату"/><StrR' + 
'es Name="IIF" Text="Возвращает TrueValue если заданное выражение равно True, иначе возвращает False' + 
'Value"/><StrRes Name="Get" Text="Возвращает значение переменной из списка переменных"/><StrRes Name="Set' + 
'" Text="Устанавливает значение переменной из списка переменных"/><StrRes Name="InputBox" Text="Пок' + 
'азывает диалог ввода строки"/><StrRes Name="InputQuery" Text="Показывает диалог ввода строки"/><Str' + 
'Res Name="MessageDlg" Text="Показывает окно сообщения"/><StrRes Name="CreateOleObject" Text="Создает OLE объект"/>' + 
'<StrRes Name="VarArrayCreate" Text="Создает массив вариантов"/><StrRes Name="VarType" Text="Возвращает тип вари' + 
'анта"/><StrRes Name="DayOf" Text="Возвращает день (1..31) даты Date"/><StrRes Name="MonthOf" Text="Возвращает меся' + 
'ц (1..12) даты Date"/><StrRes Name="YearOf" Text="Возвращает год даты Date"/><StrRes Name="ctAggregate" Text="Агрегатны' + 
'е"/><StrRes Name="Sum" Text="Возвращает сумму выражения Expr для бэнда Band"/><StrRes Name="Avg" Text="Возвращ' + 
'ает среднее значение выражения Expr для бэнда Band"/><StrRes Name="Min" Text="Возвращает минималь' + 
'ное значение выражения Expr для бэнда Band"/><StrRes Name="Max" Text="Возвращает максимальное зна' + 
'чение выражения Expr для бэнда Band"/><StrRes Name="Count" Text="Возвращает количество строк в бэн�' + 
'�е Band"/><StrRes Name="wzDBConn" Text="Новое подключение к БД"/><StrRes Name="wzDBTable" Text="Новая таблица"/><StrRe' + 
's Name="wzDBQuery" Text="Новый запрос"/><StrRes Name="5800" Text="Соединения"/><StrRes Name="5801" Text="Новое"/><StrRes Nam' + 
'e="5802" Text="Удалить"/><StrRes Name="cpName" Text="Имя"/><StrRes Name="cpConnStr" Text="Строка подключения"/><StrRes Name' + 
'="startCreateNew" Text="Создать новый отчет"/><StrRes Name="startCreateBlank" Text="Содать пустой отчет"/><StrRes Na' + 
'me="startOpenReport" Text="Открыть отчет"/><StrRes Name="startOpenLast" Text="Открыть последний отчет"/><StrRes Name=' + 
'"startEditAliases" Text="Соединения"/><StrRes Name="startHelp" Text="Помощь"/><StrRes Name="5900" Text="Инспектор перем�' + 
'�нных"/><StrRes Name="5901" Text="Добавить переменную"/><StrRes Name="5902" Text="Удалить переменную"/><StrRes ' + 
'Name="5903" Text="Редактировать переменную"/><StrRes Name="6000" Text="Ошибка наследования"/><StrRes Name="60' + 
'01" Text="Базовый и наследованный отчет имеют одинаковые объекты. Выберите действие:"/' + 
'><StrRes Name="6002" Text="Удалить одинаковые объекты"/><StrRes Name="6003" Text="Переименовать объекты"/>' + 
'</Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
