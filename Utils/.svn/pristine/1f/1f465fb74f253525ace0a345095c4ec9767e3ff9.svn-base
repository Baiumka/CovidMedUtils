unit SelectDeptUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, StdCtrls,
  Buttons, ComCtrls, ClientUnit, frmDeptItemsUnit, ImgList,
  Menus, frmItemsUnit, ActnList, Mask, DBCtrlsEh, ExtCtrls;

type
  TSelectMode = (smChoice, smSelect, smChoiceSQL, smSelectSQL);
  TShowMode = (smNormal, smWithOld, smOtiz, smOtizTemp);

  TSelectRec = record
    Mode : TSelectMode;
    ShowMode : TShowMode;

    OtizTemp : Integer;

    FirstSelect : Integer;
    SelectCount,
    RealCount : Integer;
    SelectName,
    RealName : string;
    RealIdStr : string;

    Filter,
    FieldName : string;
  end;

  TfmSelectDept = class(TfmSimpleClient)
    grpBottom: TGroupBox;
    btnItemApply: TBitBtn;
    btnItemsCancel: TBitBtn;
    chkMulty: TCheckBox;
    chkSubItem: TCheckBox;
    frmItems: TfrmDeptItems;
    miN1: TMenuItem;
    miDefault: TMenuItem;
    miName: TMenuItem;
    miCode: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure chkMultyClick(Sender: TObject);
    procedure tvItemsClick(Sender: TObject);
    procedure frmItemstvItemsDblClick(Sender: TObject);
    procedure frmItemstvItemsCompare(Sender: TObject; Node1,
      Node2: TTreeNode; Data: Integer; var Compare: Integer);
    procedure miClick(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
  private
    { Private declarations }
    FMode: TSelectMode;
    FSortMode : Integer;
    procedure CheckMultySelectItem;
    procedure SetMode(const Value: TSelectMode);
  public
    { Public declarations }
    property Mode : TSelectMode read FMode write SetMode;
  public
    function LoadRec(aRec : TSelectRec) : Boolean;
    function SaveRec(var aRec : TSelectRec) : Boolean;
  end;

//var
//  fmSelectDepartment: TfmSelectDepartment;
  procedure ClearRec(var aRec : TSelectRec);
  function  ShowSelect(var aRec : TSelectRec) : Boolean;
  function  GetPdInfo(var aRec : TSelectRec) : Boolean;

implementation

uses ConstUnit;

{$R *.dfm}

procedure ClearRec(var aRec : TSelectRec);
begin
  aRec.Mode     := smChoice;
  aRec.ShowMode := smNormal;

  aRec.OtizTemp := 0;

  aRec.FirstSelect := 0;
  aRec.SelectCount := 0;
  aRec.RealCount   := 0;

  aRec.SelectName := '';
  aRec.RealName   := '';
  aRec.RealIdStr  := '';

  aRec.Filter := '';
  aRec.FieldName := API_PD;
end;

function ShowSelect(var aRec : TSelectRec) : Boolean;
begin
  with TfmSelectDept.Create(Application) do
  try
    Visible := False;
    Result := LoadRec(aRec);

    if Result then
    begin
      Result := (ShowModal = mrOk);
      if Result then
        Result := SaveRec(aRec);
    end;
  finally
    Free;
  end;
end;

function  GetPdInfo(var aRec : TSelectRec) : Boolean;
begin
  Result := False;
end;


{ TfmSelectDepartment }

procedure TfmSelectDept.FormCreate(Sender: TObject);
begin
  FormStyle := fsNormal;
  Visible := False;
  inherited;
  AutoRefresh := False;

  Mode := smChoice;
  Visible := False;
end;


function TfmSelectDept.LoadRec(aRec: TSelectRec): Boolean;
var i : Integer;
begin
  Mode := aRec.Mode;

  case Mode of
    smChoice : frmItems.StrFieldName := API_SNAME;
    smSelect : frmItems.StrFieldName := API_NAME;
  end;

  case aRec.ShowMode of
    smNormal   : frmItems.zqrItems.SQL.Text := FNC_DEPT_ACTIVE_SELECT;
    smWithOld  : frmItems.zqrItems.SQL.Text := FNC_DEPT_SELECT;
    smOtiz     : frmItems.zqrItems.SQL.Text := FNC_OTIZ_ACTIVE_SELECT;
    smOtizTemp : begin
      frmItems.zqrItems.SQL.Text := FNC_OTIZ_TEMP_SELECT;
      frmItems.zqrItems.Params[0].AsInteger := aRec.OtizTemp;
    end;
  end;

  Result := actRefresh.Execute;

  if Result then
  begin
    if (aRec.FirstSelect > 0) then
    begin
      with frmItems.tvItems.Items do
        for i := 0 to Count - 1 do
          if TDefaultNodeItem(Item[i]).Id = aRec.FirstSelect then
          begin
            Item[i].Selected := True;
          end;
    end;

    chkSubItem.Checked := True;
  end;
end;

function TfmSelectDept.SaveRec(var aRec: TSelectRec): Boolean;
var i  : Integer;
    tvItem, MinNode : TDefaultNodeItem;
    s : string;

  procedure CheckMinNode;
  begin
    if not Assigned(MinNode) or
      (MinNode.Level > tvItem.Level) or
      ((MinNode.Level = tvItem.Level) and (MinNode.Index > tvItem.Index))
    then
      MinNode := tvItem;
  end;

  procedure AddIdLikeSql(AID : Integer);
  begin
    s := Format(',%d,',[AId]);
    if Pos(s, aRec.Filter) < 1 then
    begin
      aRec.Filter := aRec.Filter + Copy(s,2,255);
      Inc(aRec.RealCount);
      aRec.RealName  := aRec.RealName + frmItems.GetNormalText(tvItem.Text)+', ';
      aRec.RealIdStr := aRec.RealIdStr + IntToStr(tvItem.Id)+',';
      CheckMinNode;
    end;
  end;

  procedure BuildLikeSql;
  var j,k,l : Integer;
  begin
    aRec.Filter := ',';
    for j := 0 to frmItems.tvItems.SelectionCount - 1 do
    begin
      tvItem := TDefaultNodeItem(frmItems.tvItems.Selections[j]);
      Inc(aRec.SelectCount);
      aRec.SelectName := aRec.SelectName + frmItems.GetNormalText(tvItem.Text)+' ';
      if tvItem.IsRoot = 0 then
        AddIdLikeSql(tvItem.Id);
      if chkSubItem.Checked or (tvItem.IsRoot = 1) then
      begin
        k := tvItem.AbsoluteIndex+1;
        l := tvItem.Level;
        while (k < frmItems.tvItems.Items.Count) and (frmItems.tvItems.Items[k].Level > l) do
        begin
          tvItem := TDefaultNodeItem(frmItems.tvItems.Items[k]);
          if tvItem.IsRoot = 0 then
            AddIdLikeSql(tvItem.id);
          Inc(k);
        end;
      end;
    end;
    j := Length(aRec.Filter);
    aRec.Filter := Format('%s in (%s)',[aRec.FieldName, Copy(aRec.Filter,2, j - 2)]);
  end;

  procedure AddIdFilter(AID : Integer);
  begin
    s := Format('%s=%d or ',[aRec.FieldName, AId]);
    if Pos(s, aRec.Filter) < 1 then
    begin
      aRec.Filter := aRec.Filter + s;
      Inc(aRec.RealCount);
      aRec.RealName  := aRec.RealName + frmItems.GetNormalText(tvItem.Text)+', ';
      aRec.RealIdStr := aRec.RealIdStr + IntToStr(tvItem.Id)+',';
      CheckMinNode;
    end;
  end;

  procedure BuildFilter;
  var j,k,l : Integer;
  begin
    aRec.SelectCount := 0;
    aRec.SelectName  := EmptyStr;
    aRec.RealCount   := 0;
    aRec.RealName    := EmptyStr;
    for j := 0 to frmItems.tvItems.SelectionCount - 1 do
    begin
      tvItem := TDefaultNodeItem(frmItems.tvItems.Selections[j]);

      Inc(aRec.SelectCount);
      aRec.SelectName := aRec.SelectName + frmItems.GetNormalText(tvItem.Text)+' ';
      if tvItem.IsRoot = 0 then
        AddIdFilter(tvItem.Id);
      if chkSubItem.Checked or (tvItem.IsRoot = 1) then
      begin
        k := tvItem.AbsoluteIndex+1;
        l := tvItem.Level;
        while (k < frmItems.tvItems.Items.Count) and (frmItems.tvItems.Items[k].Level > l) do
        begin
          tvItem := TDefaultNodeItem(frmItems.tvItems.Items[k]);
          if tvItem.IsRoot = 0 then
            AddIdFilter(tvItem.id);
          Inc(k);
        end;
      end;
    end;
    j := Length(aRec.Filter);
    Delete(aRec.Filter, j-3, 4);
  end;

begin
  aRec.Filter := '';

  for i := 0 to frmItems.tvItems.SelectionCount - 1 do
  begin
    if frmItems.tvItems.Selections[i] = frmItems.tvItems.Items[0]  then
    begin
      aRec.Filter := '1=1';
      aRec.FirstSelect := 0;
      aRec.SelectCount := 1;
      aRec.RealCount   := 1;

      aRec.SelectName := frmItems.tvItems.Items[0].Text;
      aRec.RealName   := aRec.SelectName;

      aRec.RealIdStr := '0';

      Result := True;
      Exit;
    end;
  end;

  MinNode := nil;
  if aRec.Mode in [smChoiceSQL, smSelectSQL] then
    BuildLikeSql
  else
    BuildFilter;
    
  if Assigned(MinNode) then
    aRec.FirstSelect := MinNode.Id;
  if aRec.RealCount > 0 then
  begin
    i := Length(aRec.RealIdStr);
    Delete(aRec.RealIdStr, i,1);
    i := Length(aRec.RealName);
    Delete(aRec.RealName, i,1);
    i := Length(aRec.SelectName);
    Delete(aRec.SelectName, i,1);
  end;

  Result := True;
end;

procedure TfmSelectDept.chkMultyClick(Sender: TObject);
begin
  frmItems.tvItems.MultiSelect := chkMulty.Checked;
end;

procedure TfmSelectDept.tvItemsClick(Sender: TObject);
begin
  if (Mode = smChoice) and chkMulty.Checked then
  begin
    CheckMultySelectItem;
  end;
end;

procedure TfmSelectDept.CheckMultySelectItem;
var tvItem : TDefaultNodeItem;
    i : Integer;
begin
  tvItem := TDefaultNodeItem(frmItems.tvItems.Selected);
  if tvItem = nil then Exit;
  for i := 1 to frmItems.tvItems.SelectionCount-1 do
    if tvItem.HasAsParent(frmItems.tvItems.Selections[i]) then
    begin
      frmItems.tvItems.Deselect(tvItem);
      Exit;
    end;
  i := frmItems.tvItems.SelectionCount-1;
  while i > 0 do
  begin
    if frmItems.tvItems.Selections[i].HasAsParent(tvItem) then
      frmItems.tvItems.Deselect(frmItems.tvItems.Selections[i]);
    dec(i);
  end;
end;

procedure TfmSelectDept.SetMode(const Value: TSelectMode);
begin
  if FMode <> Value then
  begin
    FMode   := Value;
    case FMode of
      smSelect, smSelectSQL : grpBottom.Visible := False;
      smChoice, smChoiceSQL : grpBottom.Visible := True;
    end;
  end;                                 
end;

procedure TfmSelectDept.frmItemstvItemsDblClick(Sender: TObject);
begin
  if Mode in [smSelect, smSelectSQL] then
  begin
    btnItemApply.Click;
  end;
end;

procedure TfmSelectDept.frmItemstvItemsCompare(Sender: TObject;
  Node1, Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  case FSortMode of
    0: frmItems.tvItemsCompare(Sender, Node1, Node2, Data, Compare);
    1: Compare := AnsiCompareStr(Node1.Text, Node2.Text);
    2: Compare := TDefaultNodeItem(Node1).Id - TDefaultNodeItem(Node2).Id;
  end;
end;

procedure TfmSelectDept.miClick(Sender: TObject);
begin
  FSortMode := TMenuItem(Sender).Tag;
  frmItems.tvItems.AlphaSort(True);
end;

procedure TfmSelectDept.actRefreshExecute(Sender: TObject);
begin
  inherited;
  frmItems.Active;
end;

end.
