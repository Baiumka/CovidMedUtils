
{******************************************}
{                                          }
{             FastReport v4.0              }
{       FastReport CGI wrapper demo        }
{                                          }
{         Copyright (c) 1998-2007          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

program fastreport;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils, Classes, frxCGIClient, IniFiles, frxServerUtils;

const
  CONFIG_FILENAME = 'fastreport.ini';
  DEFAULT_CONFIG_PATH = '';
  DEFAULT_PORT = 8097;
  DEFAULT_HOST = '127.0.0.1';

var
  FHost: String;
  FPort: Integer;
  FIni: TIniFile;
  c: TfrxCGIClient;
  s: String;

begin
  if DEFAULT_CONFIG_PATH = '' then
    s := ExtractFilePath(ParamStr(0)) + CONFIG_FILENAME
  else
    s := DEFAULT_CONFIG_PATH + CONFIG_FILENAME;
  if FileExists(s) then
  begin
    FIni := TIniFile.Create(s);
    FHost := FIni.ReadString('REPORTSERVER', 'Host', DEFAULT_HOST);
    FPort := FIni.ReadInteger('REPORTSERVER', 'Port', DEFAULT_PORT);
    FIni.Free;
  end
  else begin
    FHost := DEFAULT_HOST;
    FPort := DEFAULT_PORT;
  end;
  c := TfrxCGIClient.Create;
  c.Host := FHost;
  c.Port := FPort;
  try
    c.Open;
  finally
    c.Free;
  end;
end.
