unit TreeListUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClientUnit, ExtCtrls, Grids, DBGridEh, ComCtrls, ImgList,
  ActnList, Buttons, ToolWin, StdCtrls, Menus, DB, DBClient, Mask,
  DBCtrlsEh, DBCtrls;

type
  TtvEditMode = (tvemNone, tvemAdd, tvemEdit, tvemDel);

  TDefaultNodeItem = class(TTreeNode)
  public
    Id,
    Root,
    TreeLevel,
    State : Integer;
  end;

  TfmSampleTreeList = class(TfmSimpleClient)
    pnlMaster: TPanel;
    dbgMaster: TDBGridEh;
    splDetail: TSplitter;
    splItems: TSplitter;
    pnlItems: TPanel;
    tvItems: TTreeView;
    pnlItemsCommand: TPanel;
    btnItemApply: TBitBtn;
    btnItemsCancel: TBitBtn;
    actItemsApply: TAction;
    actItemsCancel: TAction;
    lblItemsParent: TLabel;
    lblItemsParentName: TLabel;
    lblItems: TLabel;
    pmItems: TPopupMenu;
    actItemsAdd: TAction;
    actItemsEdit: TAction;
    actItemsDel: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    actItemsShowSubFolder: TAction;
    N5: TMenuItem;
    cdsItems: TClientDataSet;
    cdsMaster: TClientDataSet;
    cdsDetail: TClientDataSet;
    dsDetail: TDataSource;
    edItems: TDBEditEh;
    dsMaster: TDataSource;
    pnlDetail: TPanel;
    dbgDetail: TDBGridEh;
    dbnDetail: TDBNavigator;
    pnlDetailCommand: TPanel;
    pnlItemEdit: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure pnlItemsCommandResize(Sender: TObject);
    procedure pnlItemsCommandExit(Sender: TObject);

    procedure tvItemsCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure tvItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvItemsDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure actRefreshExecute(Sender: TObject);
    procedure actSaveChangeExecute(Sender: TObject);
    procedure actItemsAddExecute(Sender: TObject);
    procedure actItemsEditExecute(Sender: TObject);
    procedure actItemsDelExecute(Sender: TObject);
    procedure actItemsCancelExecute(Sender: TObject);
    procedure actItemsApplyExecute(Sender: TObject);
    procedure actItemsShowSubFolderExecute(Sender: TObject);

    procedure dbgMasterDblClick(Sender: TObject);
    procedure cdsMasterAfterScroll(DataSet: TDataSet);

    procedure cdsAfterPost(DataSet: TDataSet);
    procedure cdsBeforeDelete(DataSet: TDataSet);
    procedure cdsAfterInsert(DataSet: TDataSet);
    procedure cdsBeforeInsert(DataSet: TDataSet);
    procedure dbnMasterClick(Sender: TObject; Button: TNavigateBtn);
    procedure dbnDetailClick(Sender: TObject; Button: TNavigateBtn);
  protected
    { Private declarations }
    FItemsEditMode : TtvEditMode;
    StrFieldId,
    StrFieldLevel,
    StrFieldRoot,
    StrFieldName,
    ItemListSelect,
    ItemListInsert,
    ItemListModify,
    ItemListDelete,
    ItemListMove,
    MasterInsert,
    MasterUpdate,
    MasterDelete,
    DetailInsert,
    DetailUpdate,
    DetailDelete : String;

    procedure ShowItemsEdit(AValue : Boolean = True);
    procedure BuildItemsTree;
    procedure UpdateItemsAction; dynamic;
    function  GetMasterFilter : String;
    procedure ShowDetail(AValue : Boolean = True);
    procedure SetMasterFilter;
    function  CheckItemForDelete(tvItem : TTreeNode) : Boolean;
    procedure SetEnabledNavButton(B : TNavigateBtn; AValue : Boolean);
    procedure OnBuildTreeNode(tvNode : TDefaultNodeItem); dynamic;
    procedure OnGetItemsSelectParams; dynamic;
    function  SaveChanges : Boolean; dynamic;
    function  SaveTable(cds : TClientDataSet; AutoClose : Boolean = True) : Boolean;
    function  GetCommandText(cds :TClientDataSet; AState : byte): string; dynamic;
    function  LoadOtherCDS : Boolean; dynamic;
  public
    { Public declarations }
    RefreshOnlyData,
    FullExpandAfterRefresh,
    AutoLoadMaster,
    AutoLoadDetail,
    AutoMasterFilter,
    AutoItemsDrag : Boolean;
  end;

var
  fmSampleTreeList: TfmSampleTreeList;

implementation

uses ConstUnit, SimpleDialog;

{$R *.dfm}

type TTempCustomPanel = class(TCustomPanel);
     TTempDBNavigator = class(TDBNavigator);

procedure TfmSampleTreeList.actItemsAddExecute(Sender: TObject);
begin
  FItemsEditMode := tvemAdd;
  ShowItemsEdit();
end;

procedure TfmSampleTreeList.actItemsApplyExecute(Sender: TObject);
begin
  if edItems.Text = '' then Exit;
  case FItemsEditMode of
    tvemAdd  : cdsItems.CommandText := ItemListInsert;
    tvemEdit : cdsItems.CommandText := ItemListModify;
  end;
  if cdsItems.CommandText = '' then
    case FItemsEditMode of
      tvemAdd  : FMaster.ShowWarning(MSG_FUNC_NOT_DEFINE,['Добавления']);
      tvemEdit : FMaster.ShowWarning(MSG_FUNC_NOT_DEFINE,['Изменения']);
    end
  else begin
    with cdsItems.Params do
    begin
      case FItemsEditMode of
        tvemAdd  :
          ParamByName(StrFieldRoot).AsInteger := TDefaultNodeItem(tvItems.Selected).Id;
        tvemEdit :
          ParamByName(StrFieldId).AsInteger   := TDefaultNodeItem(tvItems.Selected).Id;
      end;
      ParamByName(StrFieldName).AsString  := edItems.Text;
    end;
    if FMaster.GetData(Pointer(cdsItems)) then
    case FItemsEditMode of
      tvemAdd  :
        with TDefaultNodeItem(tvItems.Items.AddChild(tvItems.Selected, '')) do
        begin
          Text      := cdsItems.FieldByName(StrFieldName).AsString;
          Id        := cdsItems.FieldByName(StrFieldId).AsInteger;
          Root      := cdsItems.FieldByName(StrFieldRoot).AsInteger;
          //TreeLevel := cdsItems.FieldByName(StrFieldLevel).AsInteger;
          State     := esInsert;
        end;
      tvemEdit :
        with TDefaultNodeItem(tvItems.Selected) do
        begin
          Text  := edItems.Text;
          if State = esFixed then
            State := esModify;
        end;
    end;
    cdsItems.Close;
  end;

  actItemsCancel.Execute;
end;

procedure TfmSampleTreeList.actItemsCancelExecute(Sender: TObject);
begin
  ShowItemsEdit(False);
end;

procedure TfmSampleTreeList.actItemsDelExecute(Sender: TObject);
begin
  if     CheckItemForDelete(tvItems.Selected)
     and ConfirmDeletion(DLG_DELETE_ITEM)
  then begin
    cdsItems.CommandText := ItemListDelete;
    if cdsItems.CommandText = '' then
      FMaster.ShowWarning(Format(MSG_FUNC_NOT_DEFINE,['Удаления']))
    else begin
      with cdsItems.Params do
        ParamByName(StrFieldId).AsInteger := TDefaultNodeItem(tvItems.Selected).Id;
      if FMaster.GetData(Pointer(cdsItems)) then
        tvItems.Selected.Delete;
      cdsItems.Close;
    end;
  end;
end;

procedure TfmSampleTreeList.actItemsEditExecute(Sender: TObject);
begin
  FItemsEditMode := tvemEdit;
  ShowItemsEdit();
end;

procedure TfmSampleTreeList.actItemsShowSubFolderExecute(Sender: TObject);
begin
  with actItemsShowSubFolder do
    Checked := not Checked;
  SetMasterFilter;
end;

procedure TfmSampleTreeList.actRefreshExecute(Sender: TObject);
var Result : Boolean;
begin
  if not FInRefreshing then
  try
    FInRefreshing := True;
    inherited;

    Result := True;
    if not RefreshOnlyData then
    begin
      cdsItems.CommandText := ItemListSelect;
      if Result and (cdsItems.CommandText <> '') then
      begin
        OnGetItemsSelectParams;
        Result := FMaster.GetData(Pointer(cdsItems));
        if Result then
           BuildItemsTree;
      end;
    end;
    RefreshOnlyData := False;
    if     Result
       and AutoLoadMaster
       and (cdsMaster.CommandText <> '')
    then begin
      Result := FMaster.GetData(Pointer(cdsMaster), nil,True, cdsMaster.ReadOnly);
      if Result and cdsMaster.Active then
      begin
        cdsMaster.MergeChangeLog;
        tvItemsChange(nil,nil);
      end;
    end;
    if     Result
       and AutoLoadDetail
       and (cdsDetail.CommandText <> '')
    then begin
      Result := FMaster.GetData(Pointer(cdsDetail));
      if Result and cdsDetail.Active then
        cdsDetail.MergeChangeLog;
    end;

    if Result then
      Result := LoadOtherCDS; 

    if Result then
      HaveChange := False;
  finally
    FInRefreshing := False;
  end;
end;

procedure TfmSampleTreeList.actSaveChangeExecute(Sender: TObject);
begin
  if SaveChanges then
  begin
    inherited;
    RefreshOnlyData := True;
    actRefresh.Execute;
  end;
end;

procedure TfmSampleTreeList.BuildItemsTree;
var BM : TBookmarkStr;
    tvRoot, tvItem : TDefaultNodeItem;
    OldLevel, Level : integer;
begin
  with cdsItems do
  try
    DisableControls;
    BM := Bookmark;
    First;
    //построение дерева
    tvItems.Items.BeginUpdate;
    tvItems.Items.Clear;

    tvRoot := nil;
    tvItem := nil;
    OldLevel := 0;
    while not Eof do
    begin
      Level := FieldByName(StrFieldLevel).AsInteger;
      if OldLevel < level then
        tvRoot := tvItem
      else if OldLevel > Level then
      begin
        tvRoot := tvItem;
        while (tvRoot <> nil)
           and (tvRoot.TreeLevel >= Level) do
          tvRoot := TDefaultNodeItem(tvRoot.Parent);
      end;
      tvItem           := TDefaultNodeItem(
                            tvItems.Items.AddChild(tvRoot,
                                                   FieldByName(StrFieldName).AsString));
      tvItem.Id        := FieldByName(StrFieldId).AsInteger;
      tvItem.Root      := FieldByName(StrFieldRoot).AsInteger;
      tvItem.TreeLevel := Level;
      tvItem.State     := esFixed;
      OldLevel         := Level;
      OnBuildTreeNode(tvItem);
      Next;
    end;
    if tvItems.Items.Count > 0 then
    begin
      tvItems.Items[0].Expand(FullExpandAfterRefresh);
      tvItems.Items[0].Selected := True;
    end;
  finally
    if (BM <> '') and BookmarkValid(TBookmark(BM)) then
      Bookmark := BM;
    EnableControls;
    tvItems.Items.EndUpdate;
    UpdateItemsAction;
    Close;
  end;
end;

procedure TfmSampleTreeList.cdsAfterInsert(DataSet: TDataSet);
var F : TField;
begin
  F := DataSet.FindField(API_STATE);
  if (F<>nil) and IsNumeric(F.DataType) then
  begin
    F.AsInteger := esInsert;
  end;
  F := DataSet.FindField(StrFieldRoot);
  if (F<>nil) and IsNumeric(F.DataType) then
    F.AsInteger := TDefaultNodeItem(tvItems.Selected).Id;

  F := DataSet.FindField(StrFieldId);
  if (F<>nil) and IsNumeric(F.DataType) and (F.Required) then
    F.AsInteger := GetNextInsertId;
end;

procedure TfmSampleTreeList.cdsAfterPost(DataSet: TDataSet);
var F : TField;
begin
  with TClientDataSet(DataSet) do
    if     (not HaveChange)
       and Active
       and (ChangeCount > 0)
    then
      HaveChange := True;

  with DataSet do
    if (UpdateStatus = usModified) and (not FInPosting) then
    begin
      F := FindField(API_STATE);
      if (F <> nil) and IsNumeric(F.DataType) then
      begin
        if F.AsInteger = esFixed then
        try
          FInPosting := True;
          Edit;
          F.AsInteger := esModify;
          Post;
        finally
          FInPosting := False;
        end;
      end;
    end;    
end;

procedure TfmSampleTreeList.cdsBeforeDelete(DataSet: TDataSet);
var F : TField;
begin
  if not ConfirmDlg(DLG_DELETE_ROW) then Abort;

  F := DataSet.FindField(API_STATE);
  if (F<>nil) and IsNumeric(F.DataType) then
  begin
    if F.AsInteger <> esInsert then
    try
      FInEditing := True;
      FInPosting := True;
      DataSet.Edit;
      F.AsInteger := esDelete;
      DataSet.Post;
      Abort;
    finally
      FInPosting := False;
      FInEditing := False;
    end;
  end;
end;

procedure TfmSampleTreeList.cdsBeforeInsert(DataSet: TDataSet);
begin
  // переопределяеться у детей
end;

procedure TfmSampleTreeList.cdsMasterAfterScroll(DataSet: TDataSet);
begin
  ShowDetail(False);
end;

function TfmSampleTreeList.CheckItemForDelete(tvItem : TTreeNode): Boolean;
begin
  Result :=    (tvItem <> nil)
           and (not tvItem.HasChildren);
  if Result then
    Result := cdsMaster.Active and cdsMaster.IsEmpty;
  if not Result then
    FMaster.ShowError(MSG_ITEM_CAN_NOT_DEL);            
end;

procedure TfmSampleTreeList.dbgMasterDblClick(Sender: TObject);
begin
  ShowDetail();
end;

type TCntrl = class(TControl);

procedure TfmSampleTreeList.FormCreate(Sender: TObject);
begin
  inherited;

  tvItems.HideSelection := False;
  StrFieldId     := API_ID;
  StrFieldRoot   := API_PARENT;
  StrFieldLevel  := API_LEVEL;
  StrFieldName   := API_NAME;

  ItemListSelect := '';
  ItemListInsert := '';
  ItemListModify := '';
  ItemListDelete := '';
  ItemListMove   := '';

  MasterInsert   := '';
  MasterUpdate   := '';
  MasterDelete   := '';

  DetailInsert   := '';
  DetailUpdate   := '';
  DetailDelete   := '';

  TTempCustomPanel(dbnMaster).ParentColor := True;
  TTempCustomPanel(dbnDetail).ParentColor := True;

  RefreshOnlyData        := False;
  FullExpandAfterRefresh := True;
  AutoLoadMaster         := True;
  AutoLoadDetail         := True;
  AutoMasterFilter       := True;
  AutoItemsDrag          := True;

  ShowItemsEdit(False);
  ShowDetail(False);
  UpdateItemsAction;
end;

procedure TfmSampleTreeList.FormDestroy(Sender: TObject);
begin
  inherited;
  fmSampleTreeList := nil;
end;

function TfmSampleTreeList.GetMasterFilter: String;
var tvItem : TDefaultNodeItem;
    i : integer;
begin
  with tvItems do
  begin
    tvItem := TDefaultNodeItem(Selected);
    if (tvItem = nil) or (tvItem.Parent = nil) then
    begin
      if actItemsShowSubFolder.Checked then
        Result := '1=1'
      else 
        Result := Format('[%s] in (%d)',[StrFieldRoot, tvItem.Id]);
    end
    else begin
      Result := IntToStr(tvItem.Id);
      if actItemsShowSubFolder.Checked then
      begin
        i := tvItem.AbsoluteIndex + 1;
        while (i < tvItems.Items.Count) and (tvItems.Items[i].Level > tvItem.Level) do
        begin
          Result := Format('%s, %d',[Result, TDefaultNodeItem(tvItems.Items[i]).id]);
          Inc(i);
        end;
      end;
      Result := Format('[%s] in (%s)',[StrFieldRoot, Result]);
    end;
  end;
end;

procedure TfmSampleTreeList.OnBuildTreeNode(tvNode: TDefaultNodeItem);
begin
  // Добавлять в дочерних
end;

procedure TfmSampleTreeList.OnGetItemsSelectParams;
begin
  // Добавлять в дочерних
end;

procedure TfmSampleTreeList.pnlItemsCommandExit(Sender: TObject);
begin
  ShowItemsEdit(False);
end;

procedure TfmSampleTreeList.pnlItemsCommandResize(Sender: TObject);
var W : Integer;
begin
  W := pnlItemsCommand.Width div 2;
  with btnItemApply do
    Left := W - 5 - Width;
  with btnItemsCancel do
    Left := W + 5;
end;

procedure TfmSampleTreeList.SetEnabledNavButton(B: TNavigateBtn;
  AValue: Boolean);
begin
  TTempDBNavigator(dbnMaster).Buttons[B].Enabled := AValue;
end;

procedure TfmSampleTreeList.SetMasterFilter;
var BM : TBookmarkStr;
    S  : String;
begin
  with cdsMaster do
    if Active and AutoMasterFilter then
    try
      DisableControls;
      BM     := Bookmark;
      if FindField(API_STATE) <> nil then
        s := '(' + Format(FLT_CDS_NOT_STATE,[esDelete]) + ') and '
      else
        s := '';

      Filter := S + '(' + GetMasterFilter + ')';
      lbl1.Caption := Filter;
      if not Filtered then
        Filtered := True;
    finally
      if (BM <> '') and BookmarkValid(TBookmark(BM)) then
        Bookmark := BM;
      EnableControls;  
    end;
end;

procedure TfmSampleTreeList.ShowItemsEdit(AValue: Boolean);
var dT : Integer;
begin
  if AValue then
  begin
    if tvItems.Selected <> nil then
    begin
      if FItemsEditMode = tvemEdit then
      begin
        if tvItems.Selected.Parent <> nil then
          lblItemsParentName.Caption := tvItems.Selected.Parent.Text
        else
          lblItemsParentName.Caption := LBL_NO_PARENT;
      end
      else if FItemsEditMode = tvemAdd then
        lblItemsParentName.Caption := tvItems.Selected.Text;

      case FItemsEditMode of
        tvemEdit : edItems.Value := tvItems.Selected.Text;
        tvemAdd  : edItems.Value := '';
      end;
    end
    else
      AValue := False;
  end;
  pnlItemsCommand.Visible := AValue;
  dT := edItems.Top - lblItems.Top;
  if dT <> 30 then
    pnlItemsCommand.Height := lblItems.Top + 113;
  if edItems.CanFocus then
    edItems.SetFocus;
end;

procedure TfmSampleTreeList.ShowDetail(AValue: Boolean);
begin
  AValue := AValue and (not cdsDetail.IsEmpty);
  if pnlDetail.Visible = AValue then Exit;
  if AValue then
  begin
    pnlDetail.Visible := True;
    splDetail.Visible := True;
  end
  else
  begin
    splDetail.Visible := False;
    pnlDetail.Visible := False;
    //dbgMaster.UpdateRowCount;
  end;
end;

procedure TfmSampleTreeList.tvItemsChange(Sender: TObject;
  Node: TTreeNode);
begin
  UpdateItemsAction;
  SetMasterFilter;
end;

procedure TfmSampleTreeList.tvItemsCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TDefaultNodeItem;
end;

procedure TfmSampleTreeList.tvItemsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var tvItem, tvSelected : TDefaultNodeItem;
begin
  if not ConfirmDlg(DLG_MOVE_ITEM) then Exit;
  cdsItems.CommandText := ItemListMove;
  if (cdsItems.CommandText <> '') then
  begin
    tvItem     := TDefaultNodeItem(tvItems.GetNodeAt(X,Y));
    tvSelected := TDefaultNodeItem(tvItems.Selected);
    if tvItem <> nil then
    begin
      with cdsItems.Params do
      begin
        ParamByName(API_ID).AsInteger     := tvSelected.Id;
        ParamByName(API_PARENT).AsInteger := tvItem.Id;
      end;
      if FMaster.GetData(Pointer(cdsItems)) then
      begin
        if tvSelected.State = esFixed then
          tvSelected.State := esModify;
        tvSelected.MoveTo(tvItem, naAddChild);
        tvSelected.Root := tvItem.Id;
        tvItem.AlphaSort;
        tvSelected.Expand(True);
      end;
      cdsItems.Close;
    end;
  end
  else
    FMaster.ShowWarning(Format(MSG_FUNC_NOT_DEFINE,['Перемещения']))
end;

procedure TfmSampleTreeList.tvItemsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var tvItem : TDefaultNodeItem;
begin
  if Sender = Source then
  begin
    tvItem := TDefaultNodeItem(tvItems.GetNodeAt(X,Y));
    Accept :=    (tvItem <> nil)
             and (not tvItem.Selected)
             and (tvItems.Selected.Parent <> tvItem);
  end;
end;

procedure TfmSampleTreeList.tvItemsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tvItem : TDefaultNodeItem;
begin
  if AutoItemsDrag and (Button = mbLeft) and (ssAlt in Shift) then
  begin
    tvItem := TDefaultNodeItem(tvItems.GetNodeAt(X,Y));
    if (tvItem <> nil) and (tvItem.Selected) then
    begin
      if tvItem.Level > 0  then
        tvItems.BeginDrag(False);
    end;
  end;
end;

procedure TfmSampleTreeList.UpdateItemsAction;
var E : Boolean;
begin
  with tvItems do
  begin
    if (Selected <> nil) then
    begin
      E := (Selected.Parent <> nil);
      FMaster.EnabledAction(Pointer(actItemsAdd) , True);
      FMaster.EnabledAction(Pointer(actItemsEdit), True);
      FMaster.EnabledAction(Pointer(actItemsDel) , e);
    end
    else begin
      FMaster.EnabledAction(Pointer(actItemsAdd) , False);
      FMaster.EnabledAction(Pointer(actItemsEdit), False);
      FMaster.EnabledAction(Pointer(actItemsDel) , False);
    end;
  end;
  FMaster.EnabledAction(Pointer(actItemsShowSubFolder), True);
end;

function TfmSampleTreeList.SaveChanges: Boolean;
begin
  Result := SaveTable(cdsMaster);
  if Result and cdsDetail.Active then
    Result := SaveTable(cdsDetail);
end;

function TfmSampleTreeList.SaveTable(cds: TClientDataSet;
  AutoClose: Boolean): Boolean;
var BM          : TBookmarkStr;
    OldFilter   : String;
    OldFiltered : Boolean;
  // Функция сохранения единичного состояния  
  function SaveState(AState : Byte) : Boolean;
  var msg : string;
  begin
    case AState of
      esInsert:
      begin
        if cds = cdsMaster then
          cdsItems.CommandText := MasterInsert
        else if cds = cdsDetail then
          cdsItems.CommandText := DetailInsert
        else
          cdsItems.CommandText := GetCommandText(cds, esInsert);
        msg := MSG_API_INSERT;
      end;
      esModify:
      begin
        if cds = cdsMaster then
          cdsItems.CommandText := MasterUpdate
        else if cds = cdsDetail then
          cdsItems.CommandText := DetailUpdate
        else
          cdsItems.CommandText := GetCommandText(cds, esInsert);
        msg := MSG_API_DELETE;
      end;
      esDelete:
      begin
        if cds = cdsMaster then
          cdsItems.CommandText := MasterDelete
        else if cds = cdsDetail then
          cdsItems.CommandText := DetailDelete
        else
          cdsItems.CommandText := GetCommandText(cds, esInsert);
        msg := MSG_API_DELETE;
      end;
    end;

    Result := True;
    if (cdsItems.CommandText <> '') then
    begin
      if (cdsItems.CommandText = FCN_EMPTY) then Exit;

      cds.Filter := Format(FLT_CDS_IS_STATE,[AState]);
      if not cds.Filtered then
        cds.Filtered := True;
      if  not cds.IsEmpty then
        Result := FMaster.GetData(Pointer(cdsItems), Pointer(cds));
      if AutoClose then
        cdsItems.Close;
    end
    else
      FMaster.ShowWarning(Format(MSG_FUNC_NOT_DEFINE, [msg]));
  end;
begin
  Result      := False;
  OldFiltered := False;
  with cds do
  try
    DisableControls;
    if State in [dsEdit, dsInsert] then
      Post;
    BM          :=  Bookmark;
    OldFilter   := Filter;
    OldFiltered := Filtered;
    if FindField(API_STATE) <> nil then
    begin
      Result := SaveState(esDelete);
      if Result then
      begin
        Result := SaveState(esModify);
        if Result then
          Result := SaveState(esInsert);
      end;
    end;
  finally
    Filter   := OldFilter;
    Filtered := OldFiltered;
    if (BM <> '') and BookmarkValid(TBookmark(BM)) then
      Bookmark := BM;
    EnableControls;
  end;
end;

function TfmSampleTreeList.GetCommandText(cds: TClientDataSet;
  AState: byte): string;
begin
  // перепределяеться у потомков
  Result := '';
end;

function TfmSampleTreeList.LoadOtherCDS: Boolean;
begin
  Result := True;
end;

procedure TfmSampleTreeList.dbnMasterClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  dbgMaster.SetFocus;
end;

procedure TfmSampleTreeList.dbnDetailClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  dbgDetail.SetFocus;
end;

end.
