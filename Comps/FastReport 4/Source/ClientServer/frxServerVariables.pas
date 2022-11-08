
{******************************************}
{                                          }
{             FastReport v4.0              }
{             Server variables             }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerVariables;

{$I frx.inc}

interface

uses Windows, Classes, SysUtils;

type
  TfrxServerVariable = class(TCollectionItem)
  private
    FName: String;
    FValue: String;
  published
    property Name: String read FName write FName;
    property Value: String read FValue write FValue;
  end;

  TfrxServerVariables = class(TCollection)
  public
    constructor Create;
    function GetValue(const Name: String): String;
    procedure AddVariable(const Name: String; const Value:String);
  end;

implementation

{ TfrxServerVarables }

procedure TfrxServerVariables.AddVariable(const Name, Value: String);
var
  i, j: Integer;
  s: String;
  v: TfrxServerVariable;
begin
  j := -1;
  s := UpperCase(Name);
  for i := 0 to Count - 1 do
    if TfrxServerVariable(Items[i]).Name = Name then
      j := i;
  if j > 0 then
    v := TfrxServerVariable(Items[j])
  else begin
    v := TfrxServerVariable(Add);
    v.Name := Name;
  end;
  v.Value := Value;
end;

constructor TfrxServerVariables.Create;
begin
  inherited Create(TfrxServerVariable);
end;

function TfrxServerVariables.GetValue(const Name: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    if TfrxServerVariable(Items[i]).Name = Name then
      Result := TfrxServerVariable(Items[i]).Value;
end;

end.