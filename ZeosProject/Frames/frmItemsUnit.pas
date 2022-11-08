unit frmItemsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ComCtrls,
  Menus, ImgList, InterfaceUnit;

type
  TtvEditMode = (tvemNone, tvemAdd, tvemEdit, tvemDel);

  TDefaultNodeItem = class(TTreeNode)
  public
    Id,
    Root,
    TreeLevel,
    State,
    IsRoot,
    Active,
    Pos : Integer;
    Ext : string;
  end;

  TTreeView = class(ComCtrls.TTreeView);

  TBuildNodeEvent =  procedure(Node : TDefaultNodeItem) of object;

  TfrmItemsBase = class(TFrame)
    tvItems: TTreeView;
    zqrItems: TZQuery;
    pmItems: TPopupMenu;
    miN4: TMenuItem;
    miSubShow: TMenuItem;
    ilItems: TImageList;
    procedure tvItemsCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvItemsCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure tvItemsCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure miSubShowClick(Sender: TObject);
    procedure tvItemsKeyPress(Sender: TObject; var Key: Char);
    procedure tvItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure tvItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tvItemsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FOnCreate : TNotifyEvent;
    FOnBuildNode : TBuildNodeEvent;
    FMaster : IMaster;
  protected
    FSearchText : string;
    FTimerActive : Boolean;
    FSearchNode : TDefaultNodeItem;
    procedure BuildItemsTree;
    procedure TimerActive(AReset : Boolean = True);
    procedure TimerStop;
    procedure WMTimer(var Message: TWMTimer); message WM_TIMER;
    procedure SearchText(ASearch : string);
    procedure DrawSearchText();
  public
    { Public declarations }
    AutoItemsDrag : Boolean;

    StrFieldId,
    StrFieldName,
    StrFieldLevel,
    StrFieldRoot,
    StrFieldActive,
    StrFieldExternal,
    StrFieldPos,
    StrFieldIsRoot,
    ExtStr : string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Active;
    function GetFilterStr(LikeSql : Boolean = False) : string; overload;
    function GetFilterStr(StrRoot,StrId : string;  LikeSql : Boolean = False) : string; overload;
    function GetNormalText(AText: String): string; overload;
    function GetNormalText(index : integer) : string; overload;
    function IsHorScrollVisble : Boolean;
    procedure DefaultBuildNode(Node : TDefaultNodeItem); virtual;
    procedure RefreshNodeText(Node : TDefaultNodeItem);
    function  FindId(const AID : integer) : Boolean;
    function  Selected : TDefaultNodeItem;
  published
    property OnCreate : TNotifyEvent read FOnCreate write FOnCreate;
    property OnBuildNode : TBuildNodeEvent read FOnBuildNode write FOnBuildNode;
  end;

implementation

uses ConstUnit, SimpleDialog;

{$R *.dfm}

constructor TfrmItemsBase.Create(AOwner: TComponent);
begin
  AutoItemsDrag := False;

  inherited Create(AOwner);

  FMaster := Application.MainForm as IMaster;

  StrFieldId       := API_ID;
  StrFieldName     := API_NAME;
  StrFieldLevel    := API_LEVEL;
  StrFieldRoot     := API_PARENT;
  StrFieldActive   := API_ACTIVE;
  StrFieldExternal := API_EXTERNAL;
  StrFieldPos      := API_POS;
  StrFieldIsRoot   := API_IS_ROOT;

  ExtStr := '()';

  tvItems.HideSelection := False;
  if Assigned(FOnCreate) then
    FOnCreate(Self);
  FSearchText := EmptyStr;
  FTimerActive := False;
  OnBuildNode := nil;
end;

destructor TfrmItemsBase.Destroy;
begin
  FMaster := nil;
  inherited;
end;

procedure TfrmItemsBase.tvItemsCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TDefaultNodeItem;
end;

procedure TfrmItemsBase.BuildItemsTree;
var BM : TBookmarkStr;
    tvRoot, tvItem : TDefaultNodeItem;
    OldLevel, Level : integer;
    F : TField;
    OldOnChanging : TTVChangingEvent;
    OldOnChange   : TTVChangedEvent;
begin
  OldOnChanging := tvItems.OnChanging;
  OldOnChange   := tvItems.OnChange;
  with zqrItems do
  try
    DisableControls;
    BM := Bookmark;
    //OldAfterScroll := af
    First;
    //построение дерева
    tvItems.OnChanging := nil;
    tvItems.OnChange := nil;
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

      // Обязательные поля
      tvItem.Id        := FieldByName(StrFieldId).AsInteger;
      tvItem.Root      := FieldByName(StrFieldRoot).AsInteger;
      tvItem.TreeLevel := Level;
      tvItem.State     := esFixed;
      OldLevel         := Level;
      // Необязательные поля
      F := FindField(StrFieldIsRoot);
      if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
        tvItem.IsRoot := F.AsInteger
      else
        tvItem.IsRoot := 0;

      F := FindField(StrFieldActive);
      if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
        tvItem.Active := F.AsInteger
      else
        tvItem.Active := 1;

      F := FindField(StrFieldExternal);
      if Assigned(F) {and (F.DataType in [ftString])} then
        tvItem.Ext := F.AsString
      else
        tvItem.Ext := EmptyStr;

      F := FindField(StrFieldPos);
      if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
        tvItem.Pos := F.AsInteger
      else
        tvItem.Pos := RecNo;

      RefreshNodeText(tvItem);

      if Assigned(OnBuildNode) then
        OnBuildNode(tvItem)
      else DefaultBuildNode(tvItem);
      Next;
    end;
  finally
    if (BM <> '') and BookmarkValid(TBookmark(BM)) then
      Bookmark := BM;
    EnableControls;
    tvItems.OnChanging := OldOnChanging;
    tvItems.OnChange   := OldOnChange;
    tvItems.Items.EndUpdate;
    Close;
  end;
  if tvItems.Items.Count > 0 then
  begin
    tvItems.Items[0].Expand(False);
    tvItems.Items[0].Selected := True;
    tvItems.TopItem := tvItems.Selected;
  end;
end;

procedure TfrmItemsBase.Active;
begin
  if zqrItems.SQL.Text <> EmptyStr then
  begin
    if FMaster.GetData(zqrItems) then
      BuildItemsTree;
  end;
end;

procedure TfrmItemsBase.tvItemsCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  Compare := TDefaultNodeItem(Node1).Pos - TDefaultNodeItem(Node2).Pos;
  if Compare = 0 then
    Compare := AnsiCompareStr(Node1.Text, Node2.Text);
end;

procedure TfrmItemsBase.tvItemsCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if TDefaultNodeItem(Node).IsRoot = 1 then
    Sender.Canvas.Font.Color := clRed
  else if TDefaultNodeItem(Node).Active = 0 then
  begin
    if cdsSelected in State then
      Sender.Canvas.Font.Color := clRealActive
    else
      Sender.Canvas.Font.Color := clRealInactive;
  end;
end;

function TfrmItemsBase.GetFilterStr(LikeSql: Boolean): string;
var tvItem : TDefaultNodeItem;
    i : integer;
    s : string;
begin
  Result := EmptyStr;
  with tvItems do
  begin
    tvItem := TDefaultNodeItem(Selected);
    if (tvItem = nil) or (tvItem.Parent = nil) then
    begin
      if miSubShow.Checked then
        Result := '1=1'
      else
        Result := Format('%s=%d',[StrFieldRoot, tvItem.Id]);
    end
    else begin
      if not LikeSql then
      begin
        Result := Format('%s=%d',[StrFieldId, tvItem.Id]);
        if StrFieldId <> StrFieldRoot then
          Result := Result + Format(' or %s=%d',[StrFieldRoot, tvItem.Id]);
      end
      else
        s := Format('%d',[tvItem.Id]);
      if miSubShow.Checked then
      begin
        i := tvItem.AbsoluteIndex + 1;
        while (i < tvItems.Items.Count) and (tvItems.Items[i].Level > tvItem.Level) do
        begin
          if not LikeSql then
            Result := Format('%s or %s=%d',[Result,StrFieldRoot,
                                            TDefaultNodeItem(tvItems.Items[i]).id])
          else
            s := Format('%s,%d',[s,TDefaultNodeItem(tvItems.Items[i]).id]);
          Inc(i);
        end;
      end;
      if LikeSql then
        Result := Format('%s in (%s)',[StrFieldRoot, s]);
    end;
  end;
end;

function TfrmItemsBase.GetNormalText(AText: String): string;
var i : Integer;
begin
  i := Pos(ExtStr[1],AText);
  if i > 0 then
    Result := Copy(AText,1,i-1)
  else
    Result := AText;
end;

function TfrmItemsBase.GetNormalText(index: integer): string;
begin
  Result := GetNormalText(tvItems.Items[index].Text);
end;

function TfrmItemsBase.IsHorScrollVisble: Boolean;
var style : Integer;
begin
  style  := GetWindowLong(tvItems.Handle, GWL_STYLE);
  style  := (style and WS_HSCROLL);
  Result := (style <> 0);
end;

function TfrmItemsBase.GetFilterStr(StrRoot, StrId: string;
  LikeSql: Boolean): string;
var OldStrFieldId, OldStrFieldRoot : string;
begin
  try
    OldStrFieldId   := StrFieldId;
    OldStrFieldRoot := StrFieldRoot;
    StrFieldId      := StrId;
    StrFieldRoot    := StrRoot;
    Result          := GetFilterStr(LikeSql);
  finally
    StrFieldId   := OldStrFieldId;
    StrFieldRoot := OldStrFieldRoot;
  end;
end;

procedure TfrmItemsBase.miSubShowClick(Sender: TObject);
begin
  tvItems.Change(tvItems.Selected);
end;

procedure TfrmItemsBase.TimerActive(AReset : Boolean = True);
begin
  if FTimerActive then
    TimerStop
  else if AReset then
  begin
    FSearchNode := nil;
    FSearchText := '';
  end;
  SetTimer(Handle, 1, 1000, nil);
  FTimerActive := True;
end;

procedure TfrmItemsBase.TimerStop;
begin
  if not FTimerActive then Exit;
  KillTimer(Handle, 1);
  FTimerActive := False;
end;

procedure TfrmItemsBase.WMTimer(var Message: TWMTimer);
begin
  TimerStop;
  FSearchText := '';
  FSearchNode := nil;
  tvItems.Refresh;
end;

procedure TfrmItemsBase.tvItemsKeyPress(Sender: TObject; var Key: Char);
begin
  if Key >#31 then
  begin
    TimerActive;
    SearchText(FSearchText + Key);
    Key := #0;
  end;
end;

procedure TfrmItemsBase.SearchText(ASearch: string);
var find, findid : Boolean;
    i, n : Integer;
    s : string;
begin
  TimerStop;

  if not Assigned(FSearchNode) then
    FSearchNode := TDefaultNodeItem(tvItems.Items[0]);
  find := False;
  n := StrToIntDef(ASearch, -1);
  findid := (n > -1);
  i := FSearchNode.AbsoluteIndex-1;
  n := Length(ASearch);
  ASearch := AnsiUpperCase(ASearch);
  while not find and (i < tvItems.Items.Count-1) do
  begin
    Inc(i);
    if findid then
      s := TDefaultNodeItem(tvItems.Items[i]).Ext
    else
      s := GetNormalText(i);
    if s <> EmptyStr then
    begin
      s := AnsiUpperCase(Copy(s,1,n));
      find := (ASearch = s);
    end;
  end;
  if find then
  begin
    FSearchText := ASearch;
    FSearchNode := TDefaultNodeItem(tvItems.Items[i]);
    tvItems.Select(FSearchNode);
    DrawSearchText;
  end;
  TimerActive(False);
end;

procedure TfrmItemsBase.DrawSearchText;
var R : TRect;
begin
  if (FSearchText <> '') and Assigned(FSearchNode)
  then begin
    R := FSearchNode.DisplayRect(True);
    R := Rect(R.Left,R.Top,R.Left+tvItems.Canvas.TextWidth(FSearchText),R.Bottom);
    tvItems.Canvas.Font.Color := clYellow;
    tvItems.Canvas.Brush.Color := clBlue;
    tvItems.Canvas.TextRect(R, R.Left, R.Top, FSearchText);
  end;
end;

procedure TfrmItemsBase.DefaultBuildNode(Node: TDefaultNodeItem);
begin
  {if Node.AbsoluteIndex = 0 then
  begin
    Node.ImageIndex    := 0;
    Node.SelectedIndex := 0;
  end;}
end;

procedure TfrmItemsBase.RefreshNodeText(Node: TDefaultNodeItem);
begin
  Node.Text := GetNormalText(Node.Text);
  if (Node.IsRoot = 0) and (Node.Ext <> EmptyStr) then
    Node.Text := Format('%s %s%s%s',[Node.Text, ExtStr[1], Node.Ext, ExtStr[2]]);
end;

function TfrmItemsBase.FindId(const AID: integer): Boolean;
var i : Integer;
begin
  Result := False;
  i := 0;
  while not Result and (i < tvItems.Items.Count-1) do
  begin
    Result := (TDefaultNodeItem(tvItems.Items[i]).Id = AID);
    Inc(i);
  end;
  if Result then
    tvItems.Select(tvItems.Items[i-1]);
end;

function TfrmItemsBase.Selected: TDefaultNodeItem;
begin
  Result := TDefaultNodeItem(tvItems.Selected);
end;

procedure TfrmItemsBase.tvItemsDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var tvItem : TDefaultNodeItem;
begin
  if not ConfirmDlg(DLG_MOVE_ITEM) then Exit;

  {if (QueryMoveItem <> '') then
    with dmGlobalData.zqrAny do
    try
      Close;
      SQL.Text := QueryMoveItem;}
      tvItem     := TDefaultNodeItem(tvItems.GetNodeAt(X,Y));
      {tvSelected := TDefaultItem(tvItems.Selected);}
      if tvItem <> nil then
      begin
        {ParamByName(StrFieldId).AsInteger   := tvSelected.Id;
        ParamByName(StrFieldRoot).AsInteger := tvItem.Id;
        if FMaster.GetData(dmGlobalData.zqrAny) then
        begin}
          if Selected.State = esFixed then
            Selected.State := esModify;
          Selected.MoveTo(tvItem, naAddChild);
          Selected.Root := tvItem.Id;
          tvItem.AlphaSort;
          Selected.Expand(True);
        {end;}
      end;
    {finally
      Close;
    end
  else
    FMaster.ShowWarning(MSG_FUNC_NOT_DEFINE,[MSG_API_MOVE]);}
end;

procedure TfrmItemsBase.tvItemsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var tvItem : TDefaultNodeItem;
begin
  if Sender = Source then
  begin
    tvItem := TDefaultNodeItem(tvItems.GetNodeAt(X,Y));
    Accept :=    (tvItem <> nil)
             and (not tvItem.Selected)
             and (Selected.Parent <> tvItem);
  end;
end;

procedure TfrmItemsBase.tvItemsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
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

end.
