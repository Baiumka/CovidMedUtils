unit TableUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClientUnit, ImgList, ActnList, Buttons, ComCtrls, ToolWin,
  ExtCtrls, DBCtrls, DB, DBClient, Grids, DBGridEh, StdCtrls,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, DBNewNav, Mask, DBCtrlsEh;

type
  TfmSimpleTable = class(TfmSimpleClient)
    lblTableTitle: TLabel;
    dbgTable: TDBGridEh;
    nwTable: TDBNewNav;
    zqrTable: TZQuery;
    dsTable: TDataSource;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure nwTableClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure zqrTableBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  protected
    NeedRequired : Boolean;
    procedure RefreshAfterLoadAccess; override;
    function  SetTableParams : Boolean; dynamic;
    procedure DoAfterLoadTable; dynamic;
  public
    { Public declarations }
  end;

var
  fmSimpleTable: TfmSimpleTable;

implementation

uses ConstUnit, SimpleDialog, Math, InterfaceUnit,
  DataUnit;

{$R *.dfm}

procedure TfmSimpleTable.FormCreate(Sender: TObject);
begin
  inherited;
  NeedRequired := False;
end;

procedure TfmSimpleTable.FormDestroy(Sender: TObject);
begin
  inherited;
  fmSimpleTable := nil;
end;

procedure TfmSimpleTable.actRefreshExecute(Sender: TObject);
var BM : TBookmarkStr;
begin
  inherited;
  if Self.Visible and dbgTable.CanFocus then
    dbgTable.SetFocus;

  BM := zqrTable.Bookmark;
  zqrTable.Close;
  if (zqrTable.SQL.Text <> '') and SetTableParams then
    if FMaster.GetData(zqrTable, True, zqrTable.ReadOnly, NeedRequired) then
    begin
      DoAfterLoadTable;
      if zqrTable.BookmarkValid(TBookmark(BM)) then
        zqrTable.Bookmark := BM;
    end;
end;

procedure TfmSimpleTable.nwTableClick(Sender: TObject;
  Button: TNavigateBtn);
begin
  if dbgTable.CanFocus and Self.Visible then
    dbgTable.SetFocus;
end;

procedure TfmSimpleTable.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if zqrTable.Active then
    CanClose := dmSimpleClient.DatasetPost(zqrTable, False);
  if CanClose then
    inherited;
end;

procedure TfmSimpleTable.zqrTableBeforePost(DataSet: TDataSet);
begin
  DefaultDatasetPost(DataSet);
  FModify := True;
end;

procedure TfmSimpleTable.RefreshAfterLoadAccess;
begin
  inherited;
  zqrTable.ReadOnly := zqrTable.ReadOnly or FMaster.ReadOnlyAction(actForm);
end;

function TfmSimpleTable.SetTableParams: Boolean;
begin
  Result := True;
end;

procedure TfmSimpleTable.DoAfterLoadTable;
begin
  if zqrTable.ReadOnly and not dbgTable.ReadOnly then
    dbgTable.ReadOnly := True;
  if dbgTable.FooterRowCount > 0 then
    dbgTable.SumList.Activate(True);
  //
end;

end.
