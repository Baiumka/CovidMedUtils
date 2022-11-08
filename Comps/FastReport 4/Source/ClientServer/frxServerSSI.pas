
{******************************************}
{                                          }
{             FastReport v4.0              }
{            Server SSI support            }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerSSI;

{$I frx.inc}

interface

uses Classes, SysUtils, frxServerVariables;

type
  TfrxSSIStream = class;

  TfrxSSIStream = class(TMemoryStream)
  private
    FBasePath: String;
    FTempStream: TMemoryStream;
    FVariables: TfrxServerVariables;
    function ParseVarName(VarPos: Integer; VarLen: Integer; Src: PChar): String;
    function SearchSign(const Sign: String; Src: PChar; StartPos: Integer;
      Len: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Prepare;

    property BasePath: String read FBasePath write FBasePath;
    property Variables: TfrxServerVariables read FVariables write FVariables;
  end;

implementation


{ TfrxSSIStream }

constructor TfrxSSIStream.Create;
begin
  FTempStream := TMemoryStream.Create;
  FBasePath := '.\';
end;

destructor TfrxSSIStream.Destroy;
begin
  FTempStream.Free;
  inherited;
end;

function TfrxSSIStream.ParseVarName(VarPos: Integer;
  VarLen: Integer; Src: PChar): String;
var
  i: Integer;
begin
  Result := '';
  i := 0;
  while (Src[VarPos + i] <> '"') and (i <= VarLen) do
    i := i + 1;
  i := i + 1;
  while (Src[VarPos + i] <> '"') and (i <= VarLen) do
  begin
    Result := Result + Src[VarPos + i];
    i := i + 1;
  end;
end;

procedure TfrxSSIStream.Prepare;
var
  BegPos, EndPos, SignPos, delta, StreamPos: Integer;
  BufPos: PChar;
  Sign, VarName, Value: String;
  FileStream: TFileStream;
  InsideSSI: TfrxSSIStream;
begin
  FTempStream.Clear;
  FTempStream.CopyFrom(Self, 0);
  Clear;
  BegPos := 0;
  StreamPos := 0;
  FTempStream.Position := 0;
  delta := 1;
  while BegPos >= 0 do
  begin
    BegPos := SearchSign('<!--#', FTempStream.Memory, BegPos,
      FTempStream.Size - BegPos);
    if BegPos >=0 then
    begin
      BufPos := PChar(FTempStream.Memory) + StreamPos;
      Write(BufPos^, BegPos - StreamPos);
      EndPos := SearchSign('-->', FTempStream.Memory, BegPos + 5,
        FTempStream.Size - BegPos);
      if EndPos >=0 then
      begin
        Sign := 'echo var';
        SignPos := SearchSign(Sign, FTempStream.Memory, BegPos + 5,
          EndPos - BegPos);
        if SignPos >= 0 then
        begin
          VarName := ParseVarName(SignPos, EndPos - SignPos,
            FTempStream.Memory);
          Value := FVariables.GetValue(VarName);
          if Length(Value) > 0 then
            Write(Value[1], Length(Value));
          StreamPos := EndPos + 3;
        end else
        begin
          Sign := 'include virtual';
          SignPos := SearchSign(Sign, FTempStream.Memory, BegPos + 5,
            EndPos - BegPos);
          if SignPos >= 0 then
          begin
            VarName := ParseVarName(SignPos, EndPos - SignPos,
              FTempStream.Memory);
            if FileExists(FBasePath + VarName) then
            begin
              try
                FileStream := TFileStream.Create(FBasePath + VarName,
                  fmOpenRead);
                try
                  InsideSSI := TfrxSSIStream.Create;
                  try
                    InsideSSI.Variables := FVariables;
                    InsideSSI.BasePath := FBasePath;
                    InsideSSI.CopyFrom(FileStream, 0);
                    InsideSSI.Prepare;
                    CopyFrom(InsideSSI, 0);
                  finally
                    InsideSSI.Free;
                  end;
                finally
                  FileStream.Free;
                end;
              except
              end;
            end;
          end;
          StreamPos := EndPos + 3;
        end;
        delta := EndPos - BegPos + 3;
      end else
        break;
    end else
      break;
    BegPos := BegPos + delta;
  end;
  if StreamPos < FTempStream.Size then
  begin
    BufPos := PChar(FTempStream.Memory) + StreamPos;
    Write(BufPos^, FTempStream.Size - StreamPos);
  end;
  Position := 0;
end;

function TfrxSSIStream.SearchSign(const Sign: String; Src: PChar;
  StartPos: Integer; Len: Integer): Integer;
var
  i, j, r: Integer;
begin
  i := 0;
  r := -1;
  while i < len do
    if Src[StartPos + i] = Sign[1] then
    begin
      r := i;
      j := 1;
      while (Src[StartPos + i] = Sign[j]) and (i <= len) and
            (j < (Length(Sign))) do
      begin
        i := i + 1;
        j := j + 1;
      end;
      if (j = Length(Sign))  and ((Src[StartPos + i] = Sign[j])) then
        break
      else
        r := -1
    end else
      i := i + 1;
  if r >= 0 then
    Result := StartPos + r
  else
    Result := -1;
end;

end.