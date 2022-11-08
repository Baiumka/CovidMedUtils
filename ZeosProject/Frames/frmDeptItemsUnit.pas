unit frmDeptItemsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frmItemsUnit, ImgList, Menus, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ComCtrls;

type
  TDeptNodeItem = class(TDefaultNodeItem)
  public
    Sl,
    Ship,
    IsSdelJob : Integer;
  end;

  TfrmDeptItems = class(TfrmItemsBase)
    procedure tvItemsCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
  private
    { Private declarations }
  public
    { Public declarations }
    StrFieldSL,
    StrFieldShip,
    StrFieldIsSdelJob  : string;
    constructor Create(AOwner: TComponent); override;
    procedure DefaultBuildNode(Node : TDefaultNodeItem); override;
    function Selected : TDeptNodeItem;
  end;

implementation

uses ConstUnit;

{$R *.dfm}

{ TfrmDeptItems }

constructor TfrmDeptItems.Create(AOwner: TComponent);
begin
  inherited;
  StrFieldSL        := API_SL;
  StrFieldShip      := API_SHIP;
  StrFieldIsSdelJob := API_IS_SDELJOB;
end;

procedure TfrmDeptItems.DefaultBuildNode(Node: TDefaultNodeItem);
var F : TField;
begin

  F := zqrItems.FindField(StrFieldSL);
  if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
    TDeptNodeItem(Node).Sl := F.AsInteger
  else
    TDeptNodeItem(Node).Sl := 0;

  F := zqrItems.FindField(StrFieldShip);
  if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
    TDeptNodeItem(Node).Ship := F.AsInteger
  else
    TDeptNodeItem(Node).Ship := 0;

  F := zqrItems.FindField(StrFieldIsSdelJob);
  if Assigned(F) and (F.DataType in [ftSmallint, ftInteger, ftWord]) then
    TDeptNodeItem(Node).IsSdelJob := F.AsInteger
  else
    TDeptNodeItem(Node).IsSdelJob := 0;

  if Node.AbsoluteIndex = 0 then
    inherited
  else if TDeptNodeItem(Node).Ship > 0 then
  begin
    Node.ImageIndex := 2;
    Node.SelectedIndex := 2;
  end
  else begin
    Node.ImageIndex := 1;
    Node.SelectedIndex := 1;
  end;
end;

function TfrmDeptItems.Selected: TDeptNodeItem;
begin
  Result := TDeptNodeItem(tvItems.Selected);
end;

procedure TfrmDeptItems.tvItemsCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TDeptNodeItem;
end;

end.
