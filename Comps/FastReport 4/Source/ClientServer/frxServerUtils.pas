
{******************************************}
{                                          }
{             FastReport v4.0              }
{          Report Server misc utils        }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerUtils;

{$I frx.inc}

interface

uses Windows, SysUtils, Messages, ActiveX, frxUtils;

function StrToHex(const s: String): String;
function HexToStr(const s : String) : String;
function Byte2Hex(const b: byte): String;
function GetHTTPErrorText(const ErrorCode: integer):string;
function GetUniqueFileName(const Path: String; const Prefix: String): String;
function Str2HTML(const Str: String): String;
function HTML2Str(const Line: String): String;
function UnQuoteStr(const s: String): String;
function GetEnvVar(const VarName: string): string;
function MakeSessionId: String;

function frxGetAbsPath(const Path: String): String;
function frxGetRelPath(const Path: String): String;
function frxGetAbsPathDir(const Path: String; const Dir: String): String;
function frxGetRelPathDir(const Path: String; const Dir: String): String;

procedure frxTouchDir(const Path: String);

type
  TfrxServerFormat = (sfHTM, sfXML, sfXLS, sfRTF, sfCSV, sfTXT, sfPDF, sfJPG, sfBMP, sfTIFF, sfGIF, sfFRP, sfODS, sfODT);
  TfrxServerOutputFormats = set of TfrxServerFormat;
  TfrxHTTPQueryType = (qtGet, qtPost, qtHead);

implementation


function StrToHex(const s: String): String;
var
  Len, i: Integer;
  C, H, L: Byte;

  function HexChar(N : Byte) : Char;
  begin
    if (N < 10) then Result := Chr(Ord('0') + N)
    else Result := Chr(Ord('A') + (N - 10));
  end;

begin
  Len := Length(s);
  SetLength(Result, Len shl 1);
  for i := 1 to Len do begin
    C := Ord(s[i]);
    H := (C shr 4) and $f;
    L := C and $f;
    Result[i shl 1 - 1] := HexChar(H);
    Result[i shl 1]:= HexChar(L);
  end;
end;

function HexToStr(const s : String) : String;
var
  Len, i: Integer;
  C, H, L: Byte;

  function CharHex(C: Char): Byte;
  begin
    C := UpCase(C);
    if (C <= '9') then Result := Ord(C) - Ord('0')
    else Result := Ord(C) - Ord('A') + 10;
  end;

begin
  Len := Length(s);
  SetLength(Result, Len shr 1);
  for i := 1 to Len shr 1 do begin
    H := CharHex(s[i shl 1 - 1]);
    L := CharHex(s[i shl 1]);
    C := H shl 4 or L;
    Result[i] := Chr(C);
  end;
end;

function Byte2Hex(const b: byte): String;
var
  H, L: Byte;
  function HexChar(N : Byte) : Char;
  begin
    if (N < 10) then Result := Chr(Ord('0') + N)
    else Result := Chr(Ord('A') + (N - 10));
  end;
begin
  SetLength(Result, 2);
  H := (b shr 4) and $f;
  L := b and $f;
  Result[1] := HexChar(H);
  Result[2]:= HexChar(L);
end;

function GetHTTPErrorText(const ErrorCode: integer):string;
begin
  case errorcode of
    400: result:=  'Bad Request';
    401: result:=  'Unauthorized';
    402: result:=  'Payment Required';
    403: result:=  'Forbidden';
    404: result:=  'Not Found';
    405: result:=  'Method Not Allowed';
    406: result:=  'Not Acceptable';
    407: result:=  'Proxy Authentication Required';
    408: result:=  'Request Timeout';
    409: result:=  'Conflict';
    410: result:=  'Gone';
    411: result:=  'Length Required';
    412: result:=  'Precondition Failed';
    413: result:=  'Request Entity Too Large';
    414: result:=  'Request-URI Too Long';
    415: result:=  'Unsupported Media Type';
    500: result:=  'Internal Server Error';
    501: result:=  'Not Implemented'
    else
      Result := ''
  end;
  if Length(Result) > 0 then
    Result := Result + ' (' + IntToStr(errorcode) + ')';
end;

function GetUniqueFileName(const Path: String; const Prefix: String): String;
begin
  Result := Path + '\' + Prefix + MakeSessionId + '.tmp';
end;

function Str2HTML(const Str: String): String;
var
  i: Integer;
  c: Char;
  s: String;
begin
  Result := '';
  for i := 1 to Length(Str) do
  begin
    c := Str[i];
    case c of
     '0'..'9', 'A'..'Z', 'a'..'z', '.', '-': Result := Result + c;
      else begin
        s := c;
        Result := Result + '%' + StrToHex(s);
      end
   end;
  end;
end;

function HTML2Str(const Line: String): String;
var
  i: Integer;
  s, buf: String;
begin
  Result := Line;
  if Length(Result) > 0 then
  begin
    i := 1;
    while i <= Length(Result) do
    begin
      if Result[i] = '%' then
      begin
        if i <= Length(Result) - 2 then
        begin
          s := Result[i + 1] + Result[i + 2];
          buf := HexToStr(s);
          Delete(Result, i, 2);
          Result[i] := buf[1];
        end
      end
      else
      if Result[i] = '+' then
        Result[i] := ' ';
      i := i + 1;
    end;
  end;
end;

function UnQuoteStr(const s: String): String;
begin
  Result := s;
  if Length(Result) > 0 then
  begin
    if (Result[1] = #39) and (Result[Length(Result)] = #39) then
    begin
      Delete(Result, 1, 1);
      Delete(Result, Length(Result), 1);
    end;
  end;
end;

function GetEnvVar(const VarName: string): string;
var
  buffer: PChar;
  size: Integer;
const
  BUF_SIZE = 4096;
begin
  Result := '';
  size := 0;
  GetMem(buffer, BUF_SIZE);
  if buffer <> nil then
  size := GetEnvironmentVariable(PChar(VarName), buffer, BUF_SIZE);
  if size > 0 then
    Result := String(buffer);
  FreeMem(buffer);
end;

function MakeSessionId: String;
var
  AGUID: TGUID;
  AGUIDString: widestring;
begin
  CoCreateGUID(AGUID);
  SetLength(AGUIDString, 39);
  StringFromGUID2(AGUID, PWideChar(AGUIDString), 39);
  Result := string(PWideChar(AGUIDString));
  Result := Copy(Result, 2, 36);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

function frxGetAbsPath(const Path: String): String;
begin
  Result := frxGetAbsPathDir(Path, GetAppPath);
end;

function frxGetAbsPathDir(const Path: String; const Dir: String): String;
var
  s: String;
  i: Integer;

  function PosEx(const SubStr, S: string; Offset: Cardinal = 1): Integer;
  var
    I,X: Integer;
    Len, LenSubStr: Integer;
  begin
    if Offset = 1 then
      Result := Pos(SubStr, S)
    else
    begin
      I := Offset;
      LenSubStr := Length(SubStr);
      Len := Length(S) - LenSubStr + 1;
      while I <= Len do
      begin
        if S[I] = SubStr[1] then
        begin
          X := 1;
          while (X < LenSubStr) and (S[I + X] = SubStr[X + 1]) do
            Inc(X);
          if (X = LenSubStr) then
          begin
            Result := I;
            exit;
          end;
        end;
        Inc(I);
      end;
      Result := 0;
    end;
  end;

begin
  s := Dir;
  if Pos('.\', Path) = 1 then
    Result := StringReplace(Path, '.\', s, [])
  else
  if Pos('..\', Path) = 1 then
  begin
    s := frxReverseString(s);
    i := PosEx('\', s, 2);
    if i > 0 then
      s := Copy(s, i, Length(s) - i + 1);
    Result := frxReverseString(s) + Copy(Path, 4, Length(Path) - 3);
  end
  else
  if (Pos('\', Path) = 1) or (Pos(':', Path) = 2) then
    Result := Path
  else
    Result := s + Path;
end;

function frxGetRelPath(const Path: String): String;
begin
  Result := frxGetRelPathDir(Path, GetAppPath);
end;

function frxGetRelPathDir(const Path: String; const Dir: String): String;
var
  s1, s2: String;
begin
  s1 := Dir;
  s2 := frxGetAbsPathDir('..\', Dir);
  if Pos(s1, Path) = 1 then
    Result := StringReplace(Path, s1, '.\', [rfIgnoreCase])
  else
  if Pos(s2, Path) = 1 then
    Result := StringReplace(Path, s2, '..\', [rfIgnoreCase])
  else
    Result := Path;
end;

procedure frxTouchDir(const Path: String);
var
  SecAtrtrs: TSecurityAttributes;
begin
  if not DirectoryExists(Path) then
  begin
    SecAtrtrs.nLength := SizeOf(TSecurityAttributes);
    SecAtrtrs.lpSecurityDescriptor := nil;
    SecAtrtrs.bInheritHandle := true;
    CreateDirectory(PChar(Path), @SecAtrtrs);
  end;
end;


end.
