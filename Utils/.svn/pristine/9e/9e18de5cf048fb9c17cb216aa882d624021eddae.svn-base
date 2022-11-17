unit KadrUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TableUnit, StdCtrls, Buttons, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ImgList, ActnList, DBNewNav, Grids, DBGridEh,
  Mask, DBCtrlsEh, ExtCtrls;

type
  TSelectRec = record
    tn : Integer;
    fio,
    job : string;
  end;

  TfmKadr = class(TfmSimpleTable)
    pnlBottom: TPanel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    chkAll: TDBCheckBoxEh;
    procedure dbgTableGetCellParamsEh(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function LoadInfo(ARec : TSelectRec) : boolean;
    function SaveInfo(var ARec : TSelectRec) : Boolean;
  end;

  procedure ClearRecord(var ARec : TSelectRec);
  function ShowForSelect(var ARec : TSelectRec) : Boolean;

implementation

uses ConstUnit, ClientUnit;

{$R *.dfm}

var
  fmKadr: TfmKadr;

procedure ClearRecord(var ARec : TSelectRec);
begin
  ARec.tn  := 0;
  ARec.fio := '';
  ARec.job := '';
end;

function ShowForSelect(var ARec : TSelectRec) : Boolean;
begin
  if not Assigned(fmKadr) then
    fmKadr := TfmKadr.Create(Application);
  try
    fmKadr.Visible := False;

    if fmKadr.LoadInfo(ARec) then
    begin
    end;

    Result := (fmKadr.ShowModal = mrOk);

    if Result then
      fmKadr.SaveInfo(ARec);
  except
    Result := False;
  end;
end;

{ TfmKadr }

procedure TfmKadr.FormCreate(Sender: TObject);
begin
  inherited;
  AutoRefresh := False;
  zqrTable.SQL.Text := 'select p.*' + #13#10 +
                       'from nsi.p_get_kadr_list(:pr) p';
  chkAllClick(nil);
end;

procedure TfmKadr.FormDestroy(Sender: TObject);
begin
  inherited;
  fmKadr := nil;
end;

procedure TfmKadr.dbgTableGetCellParamsEh(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if zqrTable.FieldByName(API_PR).AsInteger = 1 then
    AFont.Color := clRed;
end;

function TfmKadr.LoadInfo(ARec: TSelectRec): boolean;
begin
  if not zqrTable.Active then
    actRefresh.Execute;
  if (ARec.tn = 0) or not zqrTable.Locate(API_TN, ARec.tn, []) then
    zqrTable.First;
  Result := True;
end;

function TfmKadr.SaveInfo(var ARec: TSelectRec): Boolean;
begin
  ARec.tn  := zqrTable.FieldByName(API_TN).AsInteger;
  ARec.fio := zqrTable.FieldByName(API_FIO).AsString;
  ARec.job := zqrTable.FieldByName(API_JOB).AsString;
  Result := True;
end;

procedure TfmKadr.chkAllClick(Sender: TObject);
begin
  zqrTable.ParamByName(API_PR).AsInteger := Integer(chkAll.Checked);
end;

end.
