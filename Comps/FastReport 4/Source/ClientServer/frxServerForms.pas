
{******************************************}
{                                          }
{             FastReport v4.0              }
{            Server HTTP Forms             }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerForms;

{$I frx.inc}

interface

uses
  Windows, Classes, SysUtils, Graphics, frxClass, frxDCtrl, frxUtils,
  frxExportMatrix, frxServerFormControls, frxUnicodeUtils, frxServerTemplates;

type
  TfrxWebForm = class(Tobject)
  private
    Exp: TFileStream;
    FMatrix: TfrxIEMatrix;
    FDialog: TfrxDialogPage;
    FRepName: String;
    FSession: String;
    procedure WriteExpLn(const str: string);
    function GetHTML(Obj: TfrxDialogControl): String;
  public
    constructor Create(Dialog: TfrxDialogPage; Session: String);
    destructor Destroy; override;
    procedure Prepare;
    procedure Clear;
    procedure SaveFormToFile(FName: String);
    property ReportName: String read FRepName write FRepName;
  end;

implementation

{ TfrxWebForm }

constructor TfrxWebForm.Create(Dialog: TfrxDialogPage; Session: String);
begin
  FDialog := Dialog;
  FSession := Session;
  FMatrix := TfrxIEMatrix.Create(False, '');
  FMatrix.ShowProgress := False;
  FMatrix.Inaccuracy := 10;
  FMatrix.AreaFill := True;
  FMatrix.FramesOptimization := False;
end;

destructor TfrxWebForm.Destroy;
begin
  Clear;
  FMatrix.Free;
  inherited;
end;

procedure TfrxWebForm.Clear;
begin
  FMatrix.Clear;
end;

procedure TfrxWebForm.WriteExpLn(const str: string);
begin
  if Length(str) > 0 then
  begin
    Exp.Write(str[1], Length(str));
    Exp.Write(#13#10, 2);
  end;
end;

procedure TfrxWebForm.Prepare;
var
  i: Integer;
begin
  for i := 0 to FDialog.AllObjects.Count - 1 do
    FMatrix.AddDialogObject(FDialog.AllObjects[i]);
  FMatrix.Prepare;
end;

procedure TfrxWebForm.SaveFormToFile(FName: String);
var
  i, x, y, fx, fy, dx, dy: Integer;
  drow, dcol: Integer;
  s, sb, st: String; //ss
  obj: TfrxIEMObject;
  FTemplate: TfrxServerTemplate;

begin
  FTemplate := TfrxServerTemplate.Create;
  try
    try
      Exp := TFileStream.Create(FName, fmCreate);
      try
        FTemplate.SetTemplate('form_begin');
        FTemplate.Variables.AddVariable('TITLE', UTF8Encode(FDialog.Caption));
        FTemplate.Variables.AddVariable('HTML_INIT', '');
        FTemplate.Variables.AddVariable('HTML_CODE', '');
        FTemplate.Variables.AddVariable('REPORT', FRepName);
        FTemplate.Variables.AddVariable('SESSION', FSession);
        FTemplate.Variables.AddVariable('BCOLOR', HTMLRGBColor(FDialog.Color));
        FTemplate.Variables.AddVariable('COLSPAN', IntToStr(FMatrix.Width - 1));
        FTemplate.Variables.AddVariable('CAPTION', UTF8Encode(FDialog.Caption));
        FTemplate.Prepare;
        st := FTemplate.TemplateStrings.Text;
        WriteExpLn(st);
        for y := 0 to FMatrix.Height - 2 do
        begin
          drow := Round(FMatrix.GetYPosById(y + 1) - FMatrix.GetYPosById(y));
          WriteExpLn('<tr height="' + IntToStr(drow) + '"' + s + '>');
          for x := 0 to FMatrix.Width - 2 do
          begin
            i := FMatrix.GetCell(x, y);
            if (i <> -1) then
            begin
              Obj := FMatrix.GetObjectById(i);
              dcol := Round(Obj.Width);
              if Obj.Counter = 0 then
              begin
                FMatrix.GetObjectPos(i, fx, fy, dx, dy);
                Obj.Counter := 1;
                if dx > 1 then
                  s := ' colspan="' + IntToStr(dx) + '"'
                else s := '';
                if dy > 1 then
                  sb := ' rowspan="' + IntToStr(dy) + '"'
                else sb := '';
                if Obj.Link = nil then
                  st := ' style="font-size:1px"'
                else
                  st := '';
                WriteExpLn('<td align="left" valign="top" width="' + IntToStr(dcol) + '"' + s + sb + st + '>');
                if Obj.Link <> nil then
                  WriteExpLn(GetHTML(TfrxDialogControl(Obj.Link)))
                else
                  WriteExpLn('&nbsp;');
                WriteExpLn('</td>');
              end
            end else
            begin
              dcol := Round(FMatrix.GetXPosById(x + 1) - FMatrix.GetXPosById(x));
              WriteExpLn('<td style="font-size:1px" width="' + IntToStr(dcol) + '">&nbsp;</td>');
            end
          end;
          WriteExpLn('</tr>');
        end;
        FTemplate.SetTemplate('form_end');
        FTemplate.Variables.AddVariable('COLSPAN', IntToStr(FMatrix.Width - 1));
        FTemplate.Prepare;
        WriteExpLn(FTemplate.TemplateStrings.Text);
      finally
        FlushFileBuffers(Exp.Handle);
        Exp.Free;
      end;
    except
    end;
  finally
    FTemplate.Free;
  end
end;

function TfrxWebForm.GetHTML(Obj: TfrxDialogControl): String;
var
  wLabel: TfrxWebLabelControl;
  wEdit: TfrxWebTextControl;
  wButton: TfrxWebSubmitControl;
  wRadio: TfrxWebRadioControl;
  wCheckBox: TfrxWebCheckBoxControl;
  wText: TfrxWebTextAreaControl;
  wCombo: TfrxWebSelectControl;
  wDate: TfrxWebDateControl;
begin
  Result := '';
  if Obj is TfrxLabelControl then
  begin
    wLabel := TfrxWebLabelControl.Create;
    wLabel.Assign(Obj);
    Result := wLabel.HTML;
    wLabel.Free;
  end else
  if Obj is TfrxEditControl then
  begin
    wEdit := TfrxWebTextControl.Create;
    wEdit.Assign(Obj);
    Result := wEdit.HTML;
    wEdit.Free;
  end else
  if Obj is TfrxDateEditControl then
  begin
    wDate := TfrxWebDateControl.Create;
    wDate.Assign(Obj);
    Result := wDate.HTML;
    wDate.Free;
  end else
  if Obj is TfrxButtonControl then
  begin
    wButton := TfrxWebSubmitControl.Create;
    wButton.Assign(Obj);
    Result := wButton.HTML;
    wButton.Free;
  end else
  if Obj is TfrxRadioButtonControl then
  begin
    wRadio := TfrxWebRadioControl.Create;
    wRadio.Assign(Obj);
    Result := wRadio.HTML;
    wRadio.Free;
  end else
  if Obj is TfrxCheckBoxControl then
  begin
    wCheckBox := TfrxWebCheckBoxControl.Create;
    wCheckBox.Assign(Obj);
    Result := wCheckBox.HTML;
    wCheckBox.Free;
  end else
  if Obj is TfrxMemoControl then
  begin
    wText := TfrxWebTextAreaControl.Create;
    wText.Assign(Obj);
    Result := wText.HTML;
    wText.Free;
  end else
  if Obj is TfrxComboBoxControl then
  begin
    wCombo:=TfrxWebSelectControl.Create;
    wCombo.Assign(Obj);
    Result := wCombo.HTML;
    wCombo.Free;
  end;
  Result := UTF8Encode(Result);
end;

end.