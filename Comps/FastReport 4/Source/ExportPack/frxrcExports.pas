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

unit frxrcExports;

interface

implementation

uses frxRes;

const resXML =
'<?xml version="1.0" encoding="utf-8"?><Resources CodePage="1251"><StrRes Name="8000" Text="Экспорт в Excel"/><StrRes Name="8001" Text="Сти�' + 
'�и"/><StrRes Name="8002" Text="Картинки"/><StrRes Name="8003" Text="Объединять ячейки"/><StrRes Name="8004" Text="Быстр�' + 
'�й экспорт"/><StrRes Name="8005" Text="WYSIWYG"/><StrRes Name="8006" Text="Как текст"/><StrRes Name="8007" Text="Фон"/><StrRes Name' + 
'="8008" Text="Открыть Excel после экспорта"/><StrRes Name="8009" Text="Файл Excel (*.xls)|*.xls"/><StrRes Name="8010" Text=".x' + 
'ls"/><StrRes Name="8100" Text="Экспорт в Excel"/><StrRes Name="8101" Text="Стили"/><StrRes Name="8102" Text="WYSIWYG"/><StrRes Name="8103' + 
'" Text="Фон"/><StrRes Name="8104" Text="Открыть Excel после экспорта"/><StrRes Name="8105" Text="Файл Excel (*.xls)|*.xls"/' + 
'><StrRes Name="8106" Text=".xls"/><StrRes Name="8200" Text="Экспорт в HTML (табличный)"/><StrRes Name="8201" Text="Открыть п�' + 
'�сле экспорта"/><StrRes Name="8202" Text="Стили"/><StrRes Name="8203" Text="Картинки"/><StrRes Name="8204" Text="Все в о�' + 
'�ной папке"/><StrRes Name="8205" Text="Фикс.ширина"/><StrRes Name="8206" Text="Навигатор"/><StrRes Name="8207" Text="Мно' + 
'гостраничный"/><StrRes Name="8208" Text="Браузер Mozilla"/><StrRes Name="8209" Text="Фон"/><StrRes Name="8210" Text="Файл HT' + 
'ML (*.html)|*.html"/><StrRes Name="8211" Text=".html"/><StrRes Name="8300" Text="Экспорт в текст"/><StrRes Name="8301" Text="Просмо' + 
'тр результата"/><StrRes Name="8302" Text=" Опции  "/><StrRes Name="8303" Text="Разрывы страниц"/><StrRes Name="8304" Te' + 
'xt="OEM-кодировка"/><StrRes Name="8305" Text="Пустые строки"/><StrRes Name="8306" Text="Пробелы слева"/><StrRes Name=' + 
'"8307" Text="Номера"/><StrRes Name="8308" Text="Введите номера и/или диапазоны страниц, разделенные ' + 
'запятыми. Например, 1,3,5-12"/><StrRes Name="8309" Text=" Масштаб "/><StrRes Name="8310" Text="по оси X"/><StrRes Name="83' + 
'11" Text="по оси Y"/><StrRes Name="8312" Text=" Рамки "/><StrRes Name="8313" Text="Нет"/><StrRes Name="8314" Text="Текстовые"/><' + 
'StrRes Name="8315" Text="Графические"/><StrRes Name="8316" Text="Only with OEM codepage"/><StrRes Name="8317" Text="Печать после' + 
' экспорта"/><StrRes Name="8318" Text="Сохранить настройки"/><StrRes Name="8319" Text=" Просмотр "/><StrRes Name="832' + 
'0" Text="Ширина:"/><StrRes Name="8321" Text="Высота:"/><StrRes Name="8322" Text="Страница"/><StrRes Name="8323" Text="Увелич' + 
'ить"/><StrRes Name="8324" Text="Уменьшить"/><StrRes Name="8325" Text="Текстовый файл (*.txt)|*.txt"/><StrRes Name="8326" Text' + 
'=".txt"/><StrRes Name="8400" Text="Печать"/><StrRes Name="8401" Text="Принтер"/><StrRes Name="8402" Text="Имя"/><StrRes Name="8403" Te' + 
'xt="Настройки..."/><StrRes Name="8404" Text="Копии"/><StrRes Name="8405" Text="Количество"/><StrRes Name="8406" Text=" Опц�' + 
'�и "/><StrRes Name="8407" Text="Тип принтера"/><StrRes Name="8408" Text=".fpi"/><StrRes Name="8409" Text="Настройки принте�' + 
'�а (*.fpi)|*.fpi"/><StrRes Name="8410" Text=".fpi"/><StrRes Name="8411" Text="Настройки принтера (*.fpi)|*.fpi"/><StrRes Name="8500"' + 
' Text="Экспорт в RTF (табличный)"/><StrRes Name="8501" Text="Картинки"/><StrRes Name="8502" Text="WYSIWYG"/><StrRes Name="850' + 
'3" Text="Открыть после экспорта"/><StrRes Name="8504" Text="Файл RTF (*.rtf)|*.rtf"/><StrRes Name="8505" Text=".rtf"/><StrRes ' + 
'Name="8600" Text="Экспорт в рисунок"/><StrRes Name="8601" Text=" Опции "/><StrRes Name="8602" Text="Качество JPEG"/><StrRe' + 
's Name="8603" Text="Разрешение (dpi)"/><StrRes Name="8604" Text="Раздельные файлы"/><StrRes Name="8605" Text="Обрезат�' + 
'� страницу"/><StrRes Name="8606" Text="Монохромный"/><StrRes Name="8700" Text="Экспорт в PDF"/><StrRes Name="8701" Text="К' + 
'омпрессия"/><StrRes Name="8702" Text="Встроить шрифты"/><StrRes Name="8703" Text="Высокое разрешение"/><StrRes' + 
' Name="8704" Text="Оглавление"/><StrRes Name="8705" Text="Фон"/><StrRes Name="8706" Text="Открыть после экспорта"/><S' + 
'trRes Name="8707" Text="Файл Adobe PDF (*.pdf)|*.pdf"/><StrRes Name="8708" Text=".pdf"/><StrRes Name="RTFexport" Text="Документ Word (та' + 
'бличный)"/><StrRes Name="BMPexport" Text="Рисунок BMP"/><StrRes Name="JPEGexport" Text="Рисунок JPEG"/><StrRes Name="TIFFexport" ' + 
'Text="Рисунок TIFF"/><StrRes Name="TextExport" Text="Текстовый файл (prn)"/><StrRes Name="XlsOLEexport" Text="Документ Exc' + 
'el (OLE)"/><StrRes Name="HTMLexport" Text="Документ HTML (табличный)"/><StrRes Name="XlsXMLexport" Text="Документ Excel (XML)' + 
'"/><StrRes Name="PDFexport" Text="Документ PDF"/><StrRes Name="ProgressWait" Text="Подождите, пожалуйста"/><StrRes Name="Pr' + 
'ogressRows" Text="Настройка строк"/><StrRes Name="ProgressColumns" Text="Настройка колонок"/><StrRes Name="ProgressStyle' + 
's" Text="Настройка стилей"/><StrRes Name="ProgressObjects" Text="Экспорт объектов"/><StrRes Name="TIFFexportFilter" Text' + 
'="Рисунок TIFF (*.tif)|*.tif"/><StrRes Name="BMPexportFilter" Text="Рисунок BMP (*.bmp)|*.bmp"/><StrRes Name="JPEGexportFilter" Text="Р' + 
'исунок JPEG (*.jpg)|*.jpg"/><StrRes Name="HTMLNavFirst" Text="Начало"/><StrRes Name="HTMLNavPrev" Text="Пред."/><StrRes Name="HTMLNavN' + 
'ext" Text="След."/><StrRes Name="HTMLNavLast" Text="Конец"/><StrRes Name="HTMLNavRefresh" Text="Обновить"/><StrRes Name="HTMLNavPrint' + 
'" Text="Печать"/><StrRes Name="HTMLNavTotal" Text="Всего страниц"/><StrRes Name="8800" Text="Экспорт в текст"/><StrRes ' + 
'Name="8801" Text="Текстовый файл (*.txt)|*.txt"/><StrRes Name="8802" Text=".txt"/><StrRes Name="SimpleTextExport" Text="Текстовы�' + 
'� файл"/><StrRes Name="8850" Text="Экспорт в CSV"/><StrRes Name="8851" Text="CSV файл (*.csv)|*.csv"/><StrRes Name="8852" Text=".csv"/' + 
'><StrRes Name="8853" Text="Разделитель"/><StrRes Name="CSVExport" Text="CSV файл"/><StrRes Name="8900" Text="Отослать по E-ma' + 
'il"/><StrRes Name="8901" Text="E-mail"/><StrRes Name="8902" Text="Ящик"/><StrRes Name="8903" Text="Подключение"/><StrRes Name="8904" Te' + 
'xt="Адрес"/><StrRes Name="8905" Text="Приложение"/><StrRes Name="8906" Text="Формат"/><StrRes Name="8907" Text="Адрес"/><Str' + 
'Res Name="8908" Text="Автор"/><StrRes Name="8909" Text="Сервер"/><StrRes Name="8910" Text="Имя"/><StrRes Name="8911" Text="Письмо"' + 
'/><StrRes Name="8912" Text="Сообщение"/><StrRes Name="8913" Text="Текст"/><StrRes Name="8914" Text="Организация"/><StrRes Nam' + 
'e="8915" Text="Пароль"/><StrRes Name="8916" Text="Порт"/><StrRes Name="8917" Text="Запомнить настройки"/><StrRes Name="891' + 
'8" Text="Необходимые поля не заполнены"/><StrRes Name="8919" Text="Расширенные настройки экспорт�' + 
'�"/><StrRes Name="8920" Text="Подпись"/><StrRes Name="8921" Text="Собрать"/><StrRes Name="8922" Text="Тема"/><StrRes Name="8923" Tex' + 
't="С уважением"/><StrRes Name="8924" Text="Отправка письма на"/><StrRes Name="EmailExport" Text="E-mail"/><StrRes Name="Fast' + 
'ReportFile" Text="FastReport файл"/><StrRes Name="GifexportFilter" Text="Рисунок Gif (*.gif)|*.gif"/><StrRes Name="GIFexport" Text="Рис�' + 
'�нок Gif"/><StrRes Name="8950" Text="Неразрывный"/><StrRes Name="8951" Text="Колонтитулы"/><StrRes Name="8952" Text="Текс' + 
'т"/><StrRes Name="8953" Text="Колонтитулы"/><StrRes Name="8954" Text="Нет"/><StrRes Name="ODSExportFilter" Text="Open Document Табл' + 
'ица (*.ods)|*.ods"/><StrRes Name="ODSExport" Text="Open Document Таблица"/><StrRes Name="ODTExportFilter" Text="Open Document Текст (*.' + 
'odt)|*.odt"/><StrRes Name="ODTExport" Text="Open Document Текст"/><StrRes Name="8960" Text=".ods"/><StrRes Name="8961" Text=".odt"/><StrRes Name=' + 
'"8962" Text="Защита"/><StrRes Name="8963" Text="Настройки защиты"/><StrRes Name="8964" Text="Пароль владельца"/><S' + 
'trRes Name="8965" Text="Пароль пользователя"/><StrRes Name="8966" Text="Печать документа"/><StrRes Name="8967" Text="' + 
'Изменение документа"/><StrRes Name="8968" Text="Копирование текста и графики"/><StrRes Name="8969" Text="А' + 
'ннотации"/><StrRes Name="8970" Text="Защита PDF"/><StrRes Name="8971" Text="Информация о документе"/><StrRes Name="8' + 
'972" Text="Информация"/><StrRes Name="8973" Text="Заголовок"/><StrRes Name="8974" Text="Автор"/><StrRes Name="8975" Text="Те' + 
'ма"/><StrRes Name="8976" Text="Слова"/><StrRes Name="8977" Text="Создатель"/><StrRes Name="8978" Text="Программа"/><StrRes Na' + 
'me="8979" Text="Аутентификация"/><StrRes Name="8980" Text="Права доступа"/><StrRes Name="8981" Text="Просмотр"/><Str' + 
'Res Name="8982" Text="Настройки просмотра"/><StrRes Name="8983" Text="Спрятать toolbar"/><StrRes Name="8984" Text="Спря�' + 
'�ать menubar"/><StrRes Name="8985" Text="Спрятать интерфейс окна"/><StrRes Name="8986" Text="Растянуть окно"/><St' + 
'rRes Name="8987" Text="Центровать окно"/><StrRes Name="8988" Text="Растягивать при печати"/></Resources>' + 
' ';

initialization
  frxResources.AddXML(resXML);

end.
