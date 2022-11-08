
{*****************************************}
{                                         }
{             FastReport v2.3             }
{     Select Band datasource dialog       }
{                                         }
{  Copyright (c) 1998-99 by Tzyganenko A. }
{                                         }
{*****************************************}

unit FR_BndEd;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FR_Class;

type
  TfrBandEditorForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GB1: TGroupBox;
    Label2: TLabel;
    CB1: TComboBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CB1Click(Sender: TObject);
    procedure EditKeyPress(Sender: TObject; var Key : Char);
  private
    { Private declarations }
    procedure FillCombo;
  public
    { Public declarations }
    procedure ShowEditor(t: TfrView);
  end;

var
  frBandEditorForm: TfrBandEditorForm;

implementation

{$R *.DFM}

uses FR_DSet, FR_Const, FR_Utils;

const
      HintColumn = 'Доступно когда бенд'#13#10'не растягиваемый и'#13#10'не разрываемый';
procedure TfrBandEditorForm.ShowEditor(t: TfrView);
var
  i: Integer;
  s: String;
begin
  FillCombo;
  s := (t as TfrBandView).DataSet;
  if (s <> '') and (s[1] in ['1'..'9']) then
  begin
    i := 1;
    Edit1.Text := s;
  end
  else
  begin
    i := CB1.Items.IndexOf(s);
    if i = -1 then
      i := CB1.Items.IndexOf(LoadStr(SNotAssigned));
  end;
  CB1.ItemIndex := i;
  CB1Click(nil);
  Edit2.Hint := HintColumn;
  Label1.Hint := HintColumn;
  Edit2.Enabled := ((t.Flags and (flStretched or flBandPageBreak)) = 0);
  i := (t.Flags shr 8) and $F;
  if i = 0 then i := 1;
  Edit2.Text := IntToStr(i);
  if ShowModal = mrOk then
  begin
    frDesigner.BeforeChange;
    if CB1.ItemIndex = 1 then
      (t as TfrBandView).DataSet := Edit1.Text else
      (t as TfrBandView).DataSet := CB1.Items[CB1.ItemIndex];
    i := StrToIntDef(Edit2.Text, 1);
    if i = 1 then i := 0;
    i := (i shl 8) + (t.Flags and $FF);
    t.Flags := Word(i);
  end;
end;

procedure TfrBandEditorForm.FillCombo;
begin
  frGetComponents(CurReport.Owner, TfrDataset, CB1.Items, nil);
  CB1.Items.Insert(0, LoadStr(SVirtualDataset));
  CB1.Items.Insert(0, LoadStr(SNotAssigned));
end;

procedure TfrBandEditorForm.FormCreate(Sender: TObject);
begin
  Caption := LoadStr(frRes + 480);
  GB1.Caption := LoadStr(frRes + 481);
  Label2.Caption := LoadStr(frRes + 482);
  Button1.Caption := LoadStr(SOk);
  Button2.Caption := LoadStr(SCancel);
end;

procedure TfrBandEditorForm.CB1Click(Sender: TObject);
begin
  frEnableControls([Label2, Edit1], CB1.ItemIndex = 1);
end;

procedure TfrBandEditorForm.EditKeyPress(Sender: TObject; var Key : Char);
begin
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

end.

