unit LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, InterfaceUnit, Mask, DBCtrlsEh;

type
  TfmLogin = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    bvl1: TBevel;
    bvl2: TBevel;
    edPass: TDBEditEh;
    cbLogin: TDBComboBoxEh;
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbLoginUpdateData(Sender: TObject; var Handled: Boolean);
    procedure cbLoginCloseUp(Sender: TObject; Accept: Boolean);
  private
    { Private declarations }
    FMaster : IMaster;
    procedure LoadUsersInfo;
  public
    { Public declarations }
  end;

  var fmLogin : TfmLogin;

  function ShowLoginForm : Boolean;

implementation

uses SimpleDialog, ConstUnit, UtilsUnit, StrUtils;

{$R *.dfm}

//var
  //fmLogin: TfmLogin;

function ShowLoginForm: Boolean;
begin
  //Result := False;
  fmLogin := TfmLogin.Create(Application);
  with fmLogin do
  try
    ShowModal;
    Result := (ModalResult = mrOk);
  finally
   Free;
  end;
end;

{ TfmLogin }

procedure TfmLogin.FormActivate(Sender: TObject);
begin
  FMaster := Application.MainForm as IMaster;

  if not Assigned(FMaster) then
  begin
    ShowErrorDlg('Не указан мастер интерфейс!');
    cbLogin.Enabled := False;
    cbLogin.Enabled := False;
    edPass.Enabled  := False;
    btnOk.Enabled   := False;
    Exit;
  end;

  LoadUsersInfo;

  cbLogin.Value := DecodeString(FMaster.GetIniData('user','login','s'), AppSecretWord);
  edPass.Text   := DecodeString(FMaster.GetIniData('user','pass','s'), AppSecretWord);

  if cbLogin.Text = '' then
    cbLogin.SetFocus
  else if edPass.Text = '' then
    edPass.SetFocus
  else
    btnOk.SetFocus;
end;

procedure TfmLogin.FormDestroy(Sender: TObject);
begin
  FMaster := nil;
end;

procedure TfmLogin.btnOkClick(Sender: TObject);
begin
  ModalResult := mrNone;
  if (cbLogin.Value <> '') and (edPass.Text <> '') then
  begin
    // проверка соединения
    if FMaster.CheckConnection(cbLogin.Value, edPass.Text) then
      ModalResult := mrOk;
  end;

  if ModalResult = mrNone then
  begin
   if not ConfirmDlg(DLG_LOGIN_FAULT) then
     ModalResult := mrCancel
   else
     edPass.SetFocus;
  end;
end;

procedure TfmLogin.LoadUsersInfo;
var s, s1 : String;
    i, n, j : Integer;
begin
  s := FMaster.GetUsersInfo;
  if s <> '' then
  begin
    n := Length(s);
    i := 1;
    repeat
      j := PosEx('~',s,i);
      if j = 0 then
        j := n;
      s1 := Copy(s,i,j-i);
      i := j+1;
      j := PosEx('=',s1, 1);
      if j > 0 then
      begin
        cbLogin.KeyItems.Add(Copy(s1,1,j-1));
        cbLogin.Items.Add(Copy(s1,j+1,255));
      end;
    until i > n;
  end
  else
    cbLogin.EditButton.Enabled := False;
end;

procedure TfmLogin.cbLoginUpdateData(Sender: TObject;
  var Handled: Boolean);
begin
  edPass.Clear;
  edPass.SetFocus;
end;

procedure TfmLogin.cbLoginCloseUp(Sender: TObject; Accept: Boolean);
begin
  edPass.Clear;
  edPass.SetFocus;
end;

end.

