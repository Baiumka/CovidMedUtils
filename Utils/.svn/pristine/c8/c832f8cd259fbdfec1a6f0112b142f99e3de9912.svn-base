unit DebugUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGridEh, ComCtrls, ExtCtrls, StdCtrls, Mask,
  DBCtrlsEh, Menus, Buttons, dbf;

type
  TfmDebug = class(TForm)
    tc1: TTabControl;
    dbg1: TDBGridEh;
    ds1: TDataSource;
    pnlCaption: TPanel;
    lbl1: TLabel;
    grp1: TGroupBox;
    lblFilter: TLabel;
    edFilter: TDBEditEh;
    pm1: TPopupMenu;
    miN1: TMenuItem;
    miN2: TMenuItem;
    sbtn1: TSpeedButton;
    pmDataModule: TPopupMenu;
    miN3: TMenuItem;
    miSaveToDBF: TMenuItem;
    dlgSave: TSaveDialog;
    procedure tc1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lblFilterClick(Sender: TObject);
    procedure edFilterExit(Sender: TObject);
    procedure edFilterKeyPress(Sender: TObject; var Key: Char);
    procedure miN1Click(Sender: TObject);
    procedure sbtn1Click(Sender: TObject);
    procedure miN3Click(Sender: TObject);
    procedure miSaveToDBFClick(Sender: TObject);
  private
    { Private declarations }
    FSender : TForm;
    procedure OnDataMenuClick(Sender : TObject);
  public
    { Public declarations }
    function LoadDataSet(Sender : TForm) : Boolean;
    function LoadDMDataSet(Sender : TDataModule) : Boolean;
  end;


  function ShowDebugForm(Sender : TForm) : Boolean;
  function HideDebugForm() : Boolean;
  function RefreshDebugForm(Sender : TForm) : Boolean;

implementation

{$R *.dfm}

var
  fmDbfDebug: TfmDebug;

function ShowDebugForm(Sender : TForm) : Boolean;
begin
  if fmDbfDebug = nil then
    fmDbfDebug := TfmDebug.Create(Application);
  fmDbfDebug.LoadDataSet(Sender);
  fmDbfDebug.Show;
  Result := True;
end;

function HideDebugForm() : Boolean;
begin
  if fmDbfDebug <> nil then
  begin
    fmDbfDebug.Close;
    fmDbfDebug.Free;
    fmDbfDebug := nil;
  end;
  Result := True;
end;

function RefreshDebugForm(Sender : TForm) : Boolean;
begin
  if fmDbfDebug <> nil then
    fmDbfDebug.LoadDataSet(Sender);
  Result := True;
end;

{ TfmDebug }

function TfmDebug.LoadDataSet(Sender: TForm): Boolean;
var i : byte;
  procedure AddByControl(ASender : TWinControl);
  var k, j : Integer;
  begin
    for k := 0 to ASender.ControlCount - 1 do
    begin
      if ASender.Controls[k] is TFrame then
      begin
        for j := 0 to TFrame(ASender.Controls[k]).ComponentCount - 1 do
          if TFrame(ASender.Controls[k]).Components[j] is TDataSet then
            tc1.Tabs.AddObject(TFrame(ASender.Controls[k]).Name +'->'+TDataSet(TFrame(ASender.Controls[k]).Components[j]).Name, TFrame(ASender.Controls[k]).Components[j]);
      end
      else if (ASender.Controls[k] is TPanel) or
              (ASender.Controls[k] is TGroupBox)
      then
        AddByControl(TWinControl(ASender.Controls[k]))
      else if ASender.Controls[k] is TPageControl then
      begin
        for j := 0 to TPageControl(ASender.Controls[k]).PageCount - 1 do
          AddByControl(TPageControl(ASender.Controls[k]).Pages[j]);
      end;
    end;  
  end;
begin
  tc1.Tabs.Clear;
  for i := 0 to Sender.ComponentCount - 1 do
    if Sender.Components[i] is TDataSet then
       tc1.Tabs.AddObject(TDataSet(Sender.Components[i]).Name, Sender.Components[i]);
  AddByControl(Sender);
  pnlCaption.Caption := '   '+Sender.Caption;
  if tc1.Tabs.Count > 0 then
  begin
    tc1.TabIndex := 0;
    tc1Change(tc1);
  end;
  FSender := Sender;
  Result := True;
end;

procedure TfmDebug.tc1Change(Sender: TObject);
var i : Integer;
begin
  dbg1.DataSource.DataSet := TDataSet(tc1.Tabs.Objects[tc1.TabIndex]);

  with dbg1.DataSource.DataSet do
  begin
    if Filter <> EmptyStr then
      lblFilter.Caption := Filter
    else
      lblFilter.Caption := '<<Не установлен>>';
    if Filtered then
      lblFilter.Font.Color := clRed
    else
      lblFilter.Font.Color := clBlack;
  end;
  for i := 0 to dbg1.Columns.Count - 1 do
  begin
    if dbg1.Columns[i].Width > 200 then
      dbg1.Columns[i].Width := 200;
  end;
end;

procedure TfmDebug.FormDestroy(Sender: TObject);
begin
  fmDbfDebug := nil;
end;

procedure TfmDebug.lblFilterClick(Sender: TObject);
begin
  edFilter.Text := lblFilter.Caption;
  edFilter.Visible := True;
end;

procedure TfmDebug.edFilterExit(Sender: TObject);
begin
  edFilter.Visible := False;
  ds1.DataSet.Filter := edFilter.Text;
  ds1.DataSet.Filtered := True;
  tc1Change(nil);
end;

procedure TfmDebug.edFilterKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    dbg1.SetFocus;
  end;
end;

procedure TfmDebug.miN1Click(Sender: TObject);
begin
  dbg1.Columns[dbg1.Col - 1].Footer.ValueType := fvtSum;
end;

procedure TfmDebug.sbtn1Click(Sender: TObject);
var p : TPoint;
    i : Integer;
    Item : TMenuItem;
begin
  if pmDataModule.Items.Count = 2 then
  begin
    for i := 0 to Screen.DataModuleCount-1 do
    begin
      Item := TMenuItem.Create(pmDataModule);
      Item.Caption := Screen.DataModules[i].Name;
      Item.OnClick := OnDataMenuClick;
      Item.Tag := Integer(Screen.DataModules[i]);
      pmDataModule.Items.Add(Item);
    end;
  end;
  if pmDataModule.Items.Count > 2 then
  begin
    p := Point(0,sbtn1.Height+1);
    p := sbtn1.ClientToScreen(p);
    pmDataModule.Popup(p.X,p.Y);
  end;
end;

procedure TfmDebug.OnDataMenuClick(Sender: TObject);
var Item : TMenuItem;
begin
  Item := TMenuItem(Sender);
  LoadDMDataSet(TDataModule(Item.Tag))
end;

function TfmDebug.LoadDMDataSet(Sender: TDataModule): Boolean;
  var i : byte;
begin
  tc1.Tabs.Clear;
  for i := 0 to Sender.ComponentCount - 1 do
    if Sender.Components[i] is TDataSet then
       tc1.Tabs.AddObject(TDataSet(Sender.Components[i]).Name, Sender.Components[i]);
  pnlCaption.Caption := '   '+Sender.Name;
  if tc1.Tabs.Count > 0 then
  begin
    tc1.TabIndex := 0;
    tc1Change(tc1);
  end;
  Result := True;
end;

procedure TfmDebug.miN3Click(Sender: TObject);
begin
  LoadDataSet(FSender);
end;

procedure TfmDebug.miSaveToDBFClick(Sender: TObject);
var TempDBF : TDbf;
    aSource : TDataSet;
    s : string;
    //i : Integer;
begin
  if not dlgSave.Execute then Exit;

  s := dlgSave.FileName;
  if AnsiLowerCase(ExtractFileExt(s)) <> '.dbf' then
    ChangeFileExt(s,'.dbf');

  aSource := ds1.DataSet;

  TempDBF := TDbf.Create(Self);
  try
    TempDBF.OpenMode   := omAutoCreate;
    TempDBF.TableLevel := 3;
    TempDBF.LanguageID := 0;
    TempDBF.TableName  := s;
    TempDBF.FieldDefs.Assign(aSource.FieldDefs);
    TempDBF.Open;
    TempDBF.Zap;
    TempDBF.CopyFrom(aSource, False, False);
    {SDBF.First;
    while not SDBF.Eof do
    begin
      TempDBF.Append;
      for i := 0 to SDBF.FieldCount - 1 do
        TempDBF.Fields[i].Value := SDBF.Fields[i].Value;
      TempDBF.Post;
      SDBF.Next;
    end;}
  finally
    TempDBF.Free;
  end;

end;

end.
