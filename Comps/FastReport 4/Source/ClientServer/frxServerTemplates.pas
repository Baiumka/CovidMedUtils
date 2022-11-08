
{******************************************}
{                                          }
{             FastReport v4.0              }
{         Server templates support         }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerTemplates;

{$I frx.inc}

interface

uses Classes, SysUtils, frxServerVariables, frxServerSSI,
    frxServerUtils, frxServerConfig;


type
  TfrxServerTemplate = class(TObject)
  private
    FVariables: TfrxServerVariables;
    FSSI: TfrxSSIStream;
    FTemplate: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Prepare;
    procedure SetTemplate(const Name: String);

    property TemplateStrings: TStringList read FTemplate;
    property Variables: TfrxServerVariables read FVariables;
  end;

implementation

const
  error403 = '<html><head><title>Forbidden</title></head><body><h1><b>ERROR 403</b><br>Forbidden</h1><h3><!--#echo var="ERROR"--></h3><body></html>';
  error404 = '<html><head><title>Not found</title></head><body><h1><b>ERROR 404</b><br>Not found</h1><h3><!--#echo var="ERROR"--></h3><body></html>';
  error500 = '<html><head><title>Internal error</title></head><body><h1><b>ERROR 500</b><br>Internal error</h1><h3><!--#echo var="ERROR"--></h3><body></html>';
  list_begin = '<table width="700" border="1" cellspacing="1" cellpadding="1">';
  list_header = '<tr><td bgcolor="#DDDDDD" colspan="2"><b><!--#echo var="HEADER"--></b></td></tr>';
  list_line = '<tr><td valign="top"><a href="result?report=<!--#echo var="FILE"-->" target=_blank><!--#echo var="NAME"--></a></td><td><!--#echo var="DESCRIPTION"--></td></tr>';
  list_end = '</table>';
  form_begin = '<html><head>' +
    '<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' +
    '<meta name=Generator content="FastReport 4.0 http://www.fast-report.com">' +
    '<title><!--#echo var="TITLE"--></title></head>' +
    '<body  bgcolor="#FFFFFF" text="#000000" <!--#echo var="HTML_INIT"-->>' +
    '<script>history.forward()</script>' +
    '<!--#echo var="HTML_CODE"-->' +
    '<table border="0" cellspacing="0" cellpadding="0" align="center">' +
    '<tr height="100%"><td width="100%" align="center" valign="middle">' +
    '<form method="get" action="result">' +
    '<input type="hidden" name="report" value="<!--#echo var="REPORT"-->">' +
    '<input type="hidden" name="pagenav" value="0">' +
    '<input type="hidden" name="multipage" value="0">' +
    '<input type="hidden" name="sessionid" value="<!--#echo var="SESSION"-->">' +
    '<table border="0" cellspacing="0" cellpadding="0" bgcolor="<!--#echo var="BCOLOR"-->" align="center" style="border: solid 1px #000000">' +
    '<tr height="20"><td style="font-family: Arial; font-weight: bold; font-size: 14px; color: #FFFFFF; background-color: #000080;" align="center" valign="middle" colspan="<!--#echo var="COLSPAN"-->"><!--#echo var="CAPTION"--></td></tr>';
  form_end = '<tr height="10"><td style="font-size:1px" colspan="<!--#echo var="COLSPAN"-->">&nbsp;</td></tr></table></form></td></tr></table></body></html>';
  form_checkbox = '<input type="checkbox" name="<!--#echo var="NAME"-->" value="<!--#echo var="NAME"-->" <!--#echo var="CHECKED"-->>' +
    '<font style="font-family: <!--#echo var="FONT_NAME"-->; font-size: <!--#echo var="FONT_SIZE"-->px;' +
    'color: <!--#echo var="FONT_COLOR"-->; background-color: <!--#echo var="BCOLOR"-->;"><!--#echo var="CAPTION"--></font>';
  form_label = '<font style="font-family: <!--#echo var="FONT_NAME"-->; font-size: <!--#echo var="FONT_SIZE"-->px; color: <!--#echo var="FONT_COLOR"-->; background-color: <!--#echo var="BCOLOR"-->;"><!--#echo var="CAPTION"--></font>';
  form_memo = '<textarea name="<!--#echo var="NAME"-->" rows="<!--#echo var="ROWS"-->" cols="<!--#echo var="COLS"-->" wrap="virtual"><!--#echo var="TEXT"--></textarea>';
  form_text = '<input type="<!--#echo var="VISIBLE"-->" name="<!--#echo var="NAME"-->" value="<!--#echo var="VALUE"-->" id="<!--#echo var="NAME"-->" size="<!--#echo var="SIZE"-->" maxlength="<!--#echo var="LENGTH"-->" <!--#echo var="READONLY"-->>';
  form_radio = '<input type="radio" name="<!--#echo var="NAME"-->" value="<!--#echo var="VALUE"-->" <!--#echo var="CHECKED"-->>' +
    '<font style="font-family: <!--#echo var="FONT_NAME"-->; font-size: <!--#echo var="FONT_SIZE"-->px; color: <!--#echo var="FONT_COLOR"-->; background-color: <!--#echo var="BCOLOR"-->;"><!--#echo var="CAPTION"--></font>';
  form_button = '<input type="submit" size="<!--#echo var="SIZE"-->" value="<!--#echo var="VALUE"-->">';
  form_select = '<select size="1" name="<!--#echo var="NAME"-->">';
  form_date = '<input type="<!--#echo var="VISIBLE"-->" name="<!--#echo var="NAME"-->" value="<!--#echo var="VALUE"-->" id="<!--#echo var="NAME"-->" size="<!--#echo var="SIZE"-->" maxlength="<!--#echo var="LENGTH"-->" <!--#echo var="READONLY"-->>';
  main = '';
  navigator = '';
  outline = '';
  report = '';

{ TfrxServerTemplate }

procedure TfrxServerTemplate.Clear;
begin
  FVariables.Clear;
  FSSI.Clear;
  FTemplate.Clear;
end;

constructor TfrxServerTemplate.Create;
begin
  FVariables := TfrxServerVariables.Create;
  FSSI := TfrxSSIStream.Create;
  FSSI.Variables := FVariables;
  FTemplate := TStringList.Create;
end;

destructor TfrxServerTemplate.Destroy;
begin
  FSSI.Free;
  FVariables.Free;
  FTemplate.Free;
  inherited;
end;

procedure TfrxServerTemplate.Prepare;
begin
  FSSI.Clear;
  FTemplate.SaveToStream(FSSI);
  FSSI.Prepare;
  FTemplate.Clear;
  FSSI.Position := 0;
  FTemplate.LoadFromStream(FSSI);
end;

procedure TfrxServerTemplate.SetTemplate(const Name: String);
var
  path: String;
begin
  path := frxGetAbsPathDir(ServerConfig.GetValue('server.http.templatespath'), ServerConfig.ConfigFolder) + name + '.html';
  if FileExists(path) then
    FTemplate.LoadFromFile(path )
  else if name = 'error403' then
    FTemplate.Text := error403
  else if name = 'error404' then
    FTemplate.Text := error403
  else if name = 'error500' then
    FTemplate.Text := error403
  else if name = 'list_begin' then
    FTemplate.Text := list_begin
  else if name = 'list_header' then
    FTemplate.Text := list_header
  else if name = 'list_line' then
    FTemplate.Text := list_line
  else if name = 'list_end' then
    FTemplate.Text := list_end
  else if name = 'form_begin' then
    FTemplate.Text := form_begin
  else if name = 'form_button' then
    FTemplate.Text := form_button
  else if name = 'form_checkbox' then
    FTemplate.Text := form_checkbox
  else if name = 'form_end' then
    FTemplate.Text := form_end
  else if name = 'form_label' then
    FTemplate.Text := form_label
  else if name = 'form_memo' then
    FTemplate.Text := form_memo
  else if name = 'form_radio' then
    FTemplate.Text := form_radio
  else if name = 'form_select' then
    FTemplate.Text := form_select
  else if name = 'form_text' then
    FTemplate.Text := form_text
  else if name = 'form_date' then
    FTemplate.Text := form_date
  else if name = 'main' then
    FTemplate.Text := main
  else if name = 'navigator' then
    FTemplate.Text := navigator
  else if name = 'outline' then
    FTemplate.Text := outline
  else if name = 'report' then
    FTemplate.Text := report
end;

end.