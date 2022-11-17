unit UsersUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClientUnit, ImgList, ActnList, StdCtrls, Mask, DBCtrlsEh,
  Buttons, ExtCtrls, DBNewNav, Grids, DBGridEh, ComCtrls, DB, Menus,
  ZSequence, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZSqlUpdate;

type
  TfmUserRole = class(TfmSimpleClient)
    pgcMain: TPageControl;
    tsUsers: TTabSheet;
    dbgUsers: TDBGridEh;
    tsRoles: TTabSheet;
    lbl6: TLabel;
    lbl3: TLabel;
    dbnvRoles: TDBNewNav;
    dbnvRoleUser: TDBNewNav;
    dbgRoleUser: TDBGridEh;
    dbgRoles: TDBGridEh;
    tsAccess: TTabSheet;
    lbl4: TLabel;
    sbtnRefreshForms: TSpeedButton;
    dbgAll: TDBGridEh;
    dbgAccess: TDBGridEh;
    dbnvAll: TDBNewNav;
    cbfmName: TDBComboBoxEh;
    zuqRoles: TZUpdateSQL;
    dsRoles: TDataSource;
    zqrRoles: TZQuery;
    dsUsers: TDataSource;
    zqrUsers: TZQuery;
    zqrAll: TZQuery;
    dsAll: TDataSource;
    pmPassword: TPopupMenu;
    miGetPass: TMenuItem;
    dsAccess: TDataSource;
    zqrAccess: TZQuery;
    zuqAccess: TZUpdateSQL;
    dsUserRole: TDataSource;
    zuqUserRole: TZUpdateSQL;
    zqrRoleUser: TZQuery;
    dsRoleUser: TDataSource;
    zqrUserRole: TZQuery;
    zqrUserRoleid: TIntegerField;
    zqrUserRolename: TStringField;
    zqrUserRoleu_name: TStringField;
    zuqUsers: TZUpdateSQL;
    grpExtra: TGroupBox;
    edFioR: TDBEditEh;
    edJobR: TDBEditEh;
    edFioA: TDBEditEh;
    edJobA: TDBEditEh;
    lbl5: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    miGenerate: TMenuItem;
    pgcUserExtra: TPageControl;
    tsUserRole: TTabSheet;
    dbgUserRole: TDBGridEh;
    dbnvUserRole: TDBNewNav;
    pnlUserTop: TPanel;
    dbnvUsers: TDBNewNav;
    btnExtra: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure sbtnRefreshFormsClick(Sender: TObject);
    procedure zqrUsersAfterScroll(DataSet: TDataSet);
    procedure dbgAllGetCellParamsEh(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure zqrAllAfterScroll(DataSet: TDataSet);
    procedure cbfmNameChange(Sender: TObject);
    procedure miGetPassClick(Sender: TObject);
    procedure dbgUsersColumns1EditButtons0Click(Sender: TObject;
      var Handled: Boolean);
    procedure zuqUserRoleBeforeModifySQL(Sender: TObject);
    procedure cbfmNameKeyPress(Sender: TObject; var Key: Char);
    procedure zqrRolesAfterScroll(DataSet: TDataSet);
    procedure zqrUsersBeforePost(DataSet: TDataSet);
    procedure zqrRolesBeforePost(DataSet: TDataSet);
    procedure btnExtraClick(Sender: TObject);
    procedure grpExtraExit(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miGenerateClick(Sender: TObject);
    procedure dbgUsersGetCellParamsEh(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
  private
    { Private declarations }
  protected
    procedure SetDoubleBuffered; override;
    function  GetSQByDataSet(DataSet : TDataSet) : String; override;
    procedure LoadAccess; override;
    procedure RefreshAfterLoadAccess; override;
    procedure ShowGrpExtra(Value : Boolean = True);
  public
    { Public declarations }
  end;

var
  fmUserRole: TfmUserRole;

implementation

uses ConstUnit, GlobalDataUnit, SimpleDialog, Md5Unit, DBCtrls, KadrUnit,
  UtilsUnit;

{$R *.dfm}

procedure TfmUserRole.FormCreate(Sender: TObject);
begin
  inherited;
  zqrUsers.SQL.Text       := FNC_USERS_LIST;
  zuqUsers.InsertSQL.Text := QR_USER_INSERT;
  zuqUsers.ModifySQL.Text := QR_USER_UPDATE;
  zuqUsers.DeleteSQL.Clear;

  zqrUserRole.SQL.Text       := FNC_USER_ROLE_LIST;
  zuqUserRole.InsertSQL.Text := QR_USER_ROLE_INSERT;
  zuqUserRole.ModifySQL.Text := QR_EMPTY;
  zuqUserRole.DeleteSQL.Text := QR_USER_ROLE_DELETE;

  zqrRoles.SQL.Text       := FNC_ROLES_LIST;
  zuqRoles.InsertSQL.Text := QR_ROLE_INSERT;
  zuqRoles.ModifySQL.Text := QR_ROLE_UPDATE;
  zuqRoles.DeleteSQL.Clear;

  zqrRoleUser.SQL.Text := FNC_ROLE_USER_LIST;

  zqrAll.SQL.Text :=  QR_USERS_ROLES;

  zqrAccess.SQL.Text := FNC_ACCESS_LIST;
  zuqAccess.InsertSQL.Clear;
  zuqAccess.ModifySQL.Text  := FNC_ACCESS_UPDATE;
  zuqAccess.DeleteSQL.Clear;
  zuqAccess.RefreshSQL.Text := FNC_ACCESS_ID;

  ShowGrpExtra(False);

  pgcMain.ActivePage := tsAccess;

  AutoRefresh := True;

  if zqrRoles.SQL.Text = '' then
  begin
    tsRoles.TabVisible := False;
    tsUserRole.TabVisible := False;
    pgcUserExtra.Visible := (pgcUserExtra.PageCount > 1);
  end;
end;

procedure TfmUserRole.FormDestroy(Sender: TObject);
begin
  inherited;
  fmUserRole := nil;
end;

procedure TfmUserRole.SetDoubleBuffered;
var i : Integer;
begin
  inherited;
  pgcMain.DoubleBuffered := True;
  for i := 0 to pgcMain.PageCount - 1 do
     pgcMain.Pages[i].DoubleBuffered := True;
  dbnvUsers.DoubleBuffered    := True;
  dbnvUserRole.DoubleBuffered := True;
  dbnvRoles.DoubleBuffered    := True;
  dbnvRoleUser.DoubleBuffered := True;
  dbnvAll.DoubleBuffered      := True;
end;

procedure TfmUserRole.actRefreshExecute(Sender: TObject);
var OldNotify : TDataSetNotifyEvent;
begin
  inherited;

  FMaster.GetData(zqrRoles);

  FMaster.GetData(zqrUsers);

  OldNotify := zqrAll.AfterScroll;
  try
    zqrAll.AfterScroll := nil;
    FMaster.GetData(zqrAll);
    sbtnRefreshForms.Click;
  finally
    zqrAll.AfterScroll := OldNotify;
    zqrAllAfterScroll(nil);
  end;
end;

procedure TfmUserRole.sbtnRefreshFormsClick(Sender: TObject);
var TempValue : Variant;
begin
  TempValue := cbfmName.Value;
  cbfmName.Tag := 1;
  try
    cbfmName.Value := null;
    with dmGlobalData.zqrAny do
    try
      Close;
      SQL.Text := QR_FORMCONTROLS;
      if FMaster.GetData(dmGlobalData.zqrAny) then
        dmGlobalData.FillKeyItemList(dmGlobalData.zqrAny, cbfmName.Items, cbfmName.KeyItems);
    finally
      Close;
    end;
  finally
    cbfmName.Tag := 0;
  end;

  if cbfmName.Value <> TempValue then
    cbfmName.Value := TempValue
  else
    cbfmNameChange(cbfmName);
end;

procedure TfmUserRole.zqrUsersAfterScroll(DataSet: TDataSet);
begin
  if zqrUserRole.SQL.Text <> '' then
  begin
    zuqUserRole.Params.ParamByName(API_USER_ID).AsInteger := zqrUsers.FieldByName(API_ID).AsInteger;
    zqrUserRole.ParamByName(API_ID).AsInteger := zqrUsers.FieldByName(API_ID).AsInteger;
    FMaster.GetData(zqrUserRole);
  end;
end;

procedure TfmUserRole.dbgAllGetCellParamsEh(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if (zqrAll.FieldByName(API_IS_ROLE).AsInteger = 1) and not Highlight then
    Background := clInfoBk
  else if (zqrAll.FieldByName(API_ACTIVE).AsInteger = 0) and not Highlight then
    AFont.Style := AFont.Style + [fsStrikeOut];
end;

procedure TfmUserRole.zqrAllAfterScroll(DataSet: TDataSet);
begin
  if not zqrAll.Active then Exit;
  zqrAccess.ParamByName(API_ID).AsInteger := zqrAll.FieldByName(API_ID).AsInteger;
  zuqAccess.Params.ParamByName(API_USER_ID).Value := zqrAll.FieldByName(API_ID).Value;
  zqrAccess.ParamByName(API_FMNAME).Value := cbfmName.Value;
  FMaster.GetData(zqrAccess);
end;

procedure TfmUserRole.cbfmNameChange(Sender: TObject);
begin
  if cbfmName.Tag = 1 then Exit;
  dbgAccess.FieldColumns[API_FORMNAME].Visible := VarIsNull(cbfmName.Value);
  if Assigned(zqrAll.AfterScroll) then
    zqrAll.AfterScroll(zqrAll);
end;

procedure TfmUserRole.miGetPassClick(Sender: TObject);
var s : string;
begin
  s := '';
  if SimpleDialog.PasswordPromptDlg(AppTitle, DLG_INPUT_PASS, s) then
  begin
    dmGlobalData.DataSetEdit(zqrUsers);
    zqrUsers.FieldByName(API_PASS).AsString := MD5(AnsiLowerCase(s));
  end;
end;

procedure TfmUserRole.dbgUsersColumns1EditButtons0Click(Sender: TObject;
  var Handled: Boolean);
var ARec : KadrUnit.TSelectRec;
begin
  Handled := True;
  KadrUnit.ClearRecord(ARec);
  ARec.tn := zqrUsers.FieldByName(API_TN).AsInteger;
  if KadrUnit.ShowForSelect(ARec) then
  begin
    dmGlobalData.DataSetEdit(zqrUsers);
    zqrUsers.FieldByName(API_TN).AsInteger := ARec.tn;
    zqrUsers.FieldByName(API_FIO).AsString := ARec.fio;
    zqrUsers.FieldByName(API_JOB).AsString := ARec.job;
  end;
end;

procedure TfmUserRole.zuqUserRoleBeforeModifySQL(Sender: TObject);
begin
  raise Exception.Create(DLG_NO_EDIT_ROLE);
end;

procedure TfmUserRole.cbfmNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    if dbgAccess.CanFocus then
      dbgAccess.SetFocus;
end;

procedure TfmUserRole.zqrRolesAfterScroll(DataSet: TDataSet);
begin
  zqrRoleUser.ParamByName(API_ID).AsInteger := zqrRoles.FieldByName(API_ID).AsInteger;
  FMaster.GetData(zqrRoleUser);
end;

procedure TfmUserRole.zqrUsersBeforePost(DataSet: TDataSet);
begin
  if zqrUsers.FieldByName(API_IS_PROG).IsNull then
    zqrUsers.FieldByName(API_IS_PROG).AsInteger := 0;

  DefaultDatasetPost(zqrUsers);
end;

function TfmUserRole.GetSQByDataSet(DataSet: TDataSet): String;
begin
  if (DataSet = zqrUsers) then
    Result := SQ_USERS
  else if DataSet = zqrRoles then
    Result := SQ_ROLES;
end;

procedure TfmUserRole.zqrRolesBeforePost(DataSet: TDataSet);
begin
  if not CheckEmptyRow(zqrRoles) then
  begin
    if zqrRoles.FieldByName(API_ID).IsNull then
    begin
      zqrRoles.FieldByName(API_ID).Value := GetNextInsertId(zqrRoles);
    end;
  end;
end;

procedure TfmUserRole.LoadAccess;
begin
  inherited;
  //FMaster.SetActionHelpContext(actForm, 'actUsers', 'fmMain');
end;

procedure TfmUserRole.RefreshAfterLoadAccess;
begin
  if FMaster.ReadOnlyAction(actForm) then
  begin
    zqrUsers.ReadOnly := True;
    dbnvUsers.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];
    dbgUsers.AllowedOperations := [];
    dbgUsers.FieldColumns[API_PASS].PopupMenu := nil;

    zqrRoles.ReadOnly := True;
    dbnvRoles.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast, nbRefresh];
    dbgRoles.AllowedOperations := [];

    zqrUserRole.ReadOnly := True;
    dbnvUserRole.VisibleButtons := [nbFirst, nbPrior, nbNext, nbLast];
    dbgUserRole.AllowedOperations := [];

    zqrAccess.ReadOnly := True;
    dbgAccess.AllowedOperations := [];
  end;
end;

procedure TfmUserRole.ShowGrpExtra(Value: Boolean);
begin
  if Value then
  begin
    if dbgUsers.Height > grpExtra.Width then
      grpExtra.Top := dbgUsers.Top + (dbgUsers.Height - grpExtra.Height) div 2
    else
      grpExtra.Top := (Self.ClientHeight - grpExtra.Height) div 2;

    if dbgUsers.Width > grpExtra.Width then
      grpExtra.Left := dbgUsers.Left + (dbgUsers.ClientWidth -  grpExtra.Width) div 2
    else
      grpExtra.Left := (Self.ClientWidth -  grpExtra.Width) div 2;
  end;

  grpExtra.Visible := Value;

  if Value and grpExtra.CanFocus then
    grpExtra.SetFocus;
end;

procedure TfmUserRole.btnExtraClick(Sender: TObject);
begin
  ShowGrpExtra();
end;

procedure TfmUserRole.grpExtraExit(Sender: TObject);
begin
  ShowGrpExtra(False);
end;

procedure TfmUserRole.FormResize(Sender: TObject);
begin
  if grpExtra.Visible then
    ShowGrpExtra();
end;

procedure TfmUserRole.miGenerateClick(Sender: TObject);
var s : string;
begin
  if not zqrUsers.FieldByName(API_LOGIN).IsNull then
  begin
    s := '';
    if SimpleDialog.PasswordPromptDlg(AppTitle, DLG_INPUT_PASS, s) then
    begin
      FMaster.ShowInfo('Login : %s Password : %s',[
        UtilsUnit.EncodeString(zqrUsers.FieldByName(API_LOGIN).AsString, AppSecretWord),
        UtilsUnit.EncodeString(s, AppSecretWord)
      ]);
    end;
  end;
end;

procedure TfmUserRole.dbgUsersGetCellParamsEh(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if (zqrUsers.FieldByName(API_ACTIVE).AsInteger = 0) and not Highlight then
    AFont.Color := clGreen;
end;

end.
