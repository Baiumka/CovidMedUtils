unit DateBetweenUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Buttons;

type
  TfmDateBetween = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    edt1: TDBDateTimeEditEh;
    edt2: TDBDateTimeEditEh;
    lbl1: TLabel;
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function DateBetweenPromt(var AFrom, ATo : TDateTime) : boolean;

implementation

{$R *.dfm}

function DateBetweenPromt(var AFrom, ATo : TDateTime) : boolean;
begin
  with TfmDateBetween.Create(Application) do
  try
    edt1.Value := AFrom;
    edt2.Value := ATo;
    Result := (ShowModal = mrOk);
    if Result then
    begin
      AFrom := edt1.Value;
      ATo   := edt2.Value;
    end;
  finally
    Free
  end;
end;

procedure TfmDateBetween.btnOkClick(Sender: TObject);
begin
  ModalResult := mrNone;

  if VarIsNull(edt1.Value) then
  begin
    edt1.SetFocus;
    Exit;
  end
  else if VarIsNull(edt2.Value) then
  begin
    edt2.SetFocus;
    Exit;
  end
  else if edt1.Value > edt2.Value then
  begin
    edt2.SetFocus;
    Exit;
  end
  else
    ModalResult := mrOk;
end;

end.
