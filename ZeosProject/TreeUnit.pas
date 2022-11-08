unit TreeUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClientUnit, ImgList, ActnList, Buttons, ComCtrls, ToolWin,
  Menus, StdCtrls, Mask, DBCtrlsEh, ExtCtrls, frmItemsUnit;

type
  TtvEditMode = (tvemNone, tvemAdd, tvemEdit, tvemDel);

  TfmSimpleTree = class(TfmSimpleClient)
    actItemApply: TAction;
    actItemCancel: TAction;
    actItemAdd: TAction;
    actItemEdit: TAction;
    actItemDel: TAction;
    pnlItems: TPanel;
    frmItemsList: TfrmItemsBase;
    pnlClient: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tvItemsChange(Sender: TObject; Node: TTreeNode);
    procedure actRefreshExecute(Sender: TObject);
    procedure actItemAddExecute(Sender: TObject);
    procedure actItemEditExecute(Sender: TObject);
    procedure actItemDelExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure AddTreeMenuItems; dynamic;
  protected
    procedure UpdateItemsAction; dynamic;
    function  CheckItemForDelete(tvItem : TDefaultNodeItem) : Boolean; dynamic;
    function  OnBeforeItemAction(AMode : TtvEditMode; tvNode : TDefaultNodeItem) : boolean; dynamic;
    function  OnParamsQuery(AMode : TtvEditMode; tvNode : TDefaultNodeItem) : boolean; dynamic;
    function  OnAfterItemAction(AMode : TtvEditMode; tvNode : TDefaultNodeItem) : boolean; dynamic;
    function  OnParamsListQuery : boolean; dynamic;
  protected
    FItemList,
    FItemInsert,
    FItemModify,
    FItemDelete : string;
  public
    { Public declarations }
    FullExpandAfterRefresh : Boolean;
  end;

var
  fmSimpleTree: TfmSimpleTree;

implementation

uses SimpleDialog, ConstUnit, DB, ZDataset;

{$R *.dfm}

procedure TfmSimpleTree.FormCreate(Sender: TObject);
begin
  FItemList   := '';
  FItemInsert := '';
  FItemModify := '';
  FItemDelete := '';

  inherited;

  AddTreeMenuItems;
  UpdateItemsAction;
end;

procedure TfmSimpleTree.FormDestroy(Sender: TObject);
begin
  inherited;
  fmSimpleTree := nil;
end;

procedure TfmSimpleTree.UpdateItemsAction;
begin
  with frmItemsList do
  begin
    if (Selected <> nil) then
    begin
      FMaster.EnabledAction(Pointer(actItemAdd) , True);
      FMaster.EnabledAction(Pointer(actItemEdit), True);
      FMaster.EnabledAction(Pointer(actItemDel) , not Selected.HasChildren);
    end
    else begin
      FMaster.EnabledAction(Pointer(actItemAdd) , False);
      FMaster.EnabledAction(Pointer(actItemEdit), False);
      FMaster.EnabledAction(Pointer(actItemDel) , False);
    end;
  end;
end;

procedure TfmSimpleTree.tvItemsChange(Sender: TObject; Node: TTreeNode);
begin
  UpdateItemsAction;
end;

procedure TfmSimpleTree.actRefreshExecute(Sender: TObject);
begin
  if not FInRefreshing then
  try
    FInRefreshing := True;
    inherited;
    frmItemsList.zqrItems.Close;
    frmItemsList.zqrItems.SQL.Text := FItemList;
    if OnParamsListQuery then
      frmItemsList.Active;
  finally
    FInRefreshing := False;
  end;
end;

function TfmSimpleTree.CheckItemForDelete(tvItem: TDefaultNodeItem): Boolean;
begin
  Result :=    (tvItem <> nil)
           and (not tvItem.HasChildren);
  if not Result then
    FMaster.ShowError(MSG_ITEM_CAN_NOT_DEL,[]);
end;

procedure TfmSimpleTree.actItemAddExecute(Sender: TObject);
var sItem : TDefaultNodeItem;
begin
  sItem := frmItemsList.Selected;
  if OnBeforeItemAction(tvemAdd, sItem) then
  begin
    OnAfterItemAction(tvemAdd, sItem);
  end;
end;

procedure TfmSimpleTree.actItemEditExecute(Sender: TObject);
var sItem : TDefaultNodeItem;
begin
  sItem := frmItemsList.Selected;
  if OnBeforeItemAction(tvemEdit, sItem) then
  begin
    OnAfterItemAction(tvemEdit, sItem);
  end;
end;

procedure TfmSimpleTree.actItemDelExecute(Sender: TObject);
var sItem : TDefaultNodeItem;
begin
  sItem := frmItemsList.Selected;
  if     CheckItemForDelete(sItem)
     and ConfirmDeletion(DLG_DELETE_ITEM)
  then begin
    if OnBeforeItemAction(tvemDel, sItem) then
    begin
      sItem.Delete;
      OnAfterItemAction(tvemDel, nil);
    end;
  end;
end;

procedure TfmSimpleTree.AddTreeMenuItems;
var miItem : TMenuItem;
begin
  miItem := TMenuItem.Create(frmItemsList.pmItems);
  miItem.Name   := 'miItemDel';
  miItem.Action := actItemDel;
  frmItemsList.pmItems.Items.Insert(0, miItem);
  miItem := TMenuItem.Create(frmItemsList.pmItems);
  miItem.Name   := 'miItemEdit';
  miItem.Action := actItemEdit;
  frmItemsList.pmItems.Items.Insert(0, miItem);
  miItem := TMenuItem.Create(frmItemsList.pmItems);
  miItem.Name   := 'miItemAdd';
  miItem.Action := actItemAdd;
  frmItemsList.pmItems.Items.Insert(0, miItem);
end;

function TfmSimpleTree.OnBeforeItemAction(AMode: TtvEditMode;
  tvNode: TDefaultNodeItem): boolean;
begin
  Result := False;
  case AMode of
    tvemAdd : begin
      if FItemInsert = '' then
        Result := True
      else begin
        frmItemsList.zqrItems.Close;
        frmItemsList.zqrItems.SQL.Text := FItemInsert;
        if OnParamsQuery(AMode, tvNode) then
          Result := FMaster.GetData(frmItemsList.zqrItems)
        else
          Result := False;
      end;
    end;
    tvemEdit : begin
      if FItemModify = '' then
        Result := True
      else begin
        frmItemsList.zqrItems.Close;
        frmItemsList.zqrItems.SQL.Text := FItemModify;
        if OnParamsQuery(AMode, tvNode) then
          Result := FMaster.GetData(frmItemsList.zqrItems)
        else
          Result := False;
      end;
    end;
    tvemDel : begin
      if FItemDelete = '' then
        Result := True
      else begin
        frmItemsList.zqrItems.Close;
        frmItemsList.zqrItems.SQL.Text := FItemDelete;
        if OnParamsQuery(AMode, tvNode) then
          Result := FMaster.GetData(frmItemsList.zqrItems)
        else
          Result := False;
      end;
    end;
  end;
end;

function TfmSimpleTree.OnAfterItemAction(AMode: TtvEditMode;
  tvNode: TDefaultNodeItem): boolean;
begin
  Result := False;
  case AMode of
    tvemAdd : begin
      if (FItemInsert <> '') and (frmItemsList.zqrItems.Active) then
      begin
        if frmItemsList.zqrItems.FindField(frmItemsList.StrFieldId) <> nil then
          tvNode.Id := frmItemsList.zqrItems.FieldByName(frmItemsList.StrFieldId).Value;
        frmItemsList.zqrItems.Close;
      end;
      Result := True;
    end;
    tvemDel : begin
      if (FItemDelete <> '') and (frmItemsList.zqrItems.Active) then
        frmItemsList.zqrItems.Close;
      Result := True;
    end;
  end;
end;

function TfmSimpleTree.OnParamsQuery(AMode: TtvEditMode;
  tvNode: TDefaultNodeItem): boolean;
begin
  //Result := False;
  case AMode of
    tvemAdd : begin
      if frmItemsList.zqrItems.Params.FindParam(frmItemsList.StrFieldId) <> nil then
        frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldId).Value   := null;
      frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldName).Value := LBL_NEW_ITEM;
      frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldRoot).Value := tvNode.Id;
      if frmItemsList.zqrItems.Params.FindParam(frmItemsList.StrFieldPos) <> nil then
        frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldPos).Value := tvNode.Count+1;
    end;
    tvemEdit : begin
      //frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldId).Value   := tvNode.Id;
      //frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldName).Value := edItems.Text;
    end;
    tvemDel : begin
      frmItemsList.zqrItems.ParamByName(frmItemsList.StrFieldId).Value := tvNode.Id;
    end;
  end;
  Result := True;
end;

function  TfmSimpleTree.OnParamsListQuery : boolean;
begin
  Result := True;
end;

end.
