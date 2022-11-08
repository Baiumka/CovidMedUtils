{*******************************************************}
{                                                       }
{                       EhLib v4.2                      }
{                  The editor of columns                }
{                                                       }
{      Copyright (c) 2006 by Alexandr A. Sal'nikov      }
{ e-mail: alexandr.salnikov@gmail.com                   }
{                                                       }
{*******************************************************}

unit ColumnEdit;

interface

{$IfDef NoChangesByALX} // before changes by Alx
{$Else}                 // after changes by Alx
{
  Доработки выполненные Александром Сальниковым (обрамлены усл.трансляцией NoChangesByALX):

#1 10.03.06 - В одном из своих проектов реализовывал в свое время редактор
              колонок для DbGridEh, сейчас пишу новый проект, опять захотелось
              иметь редактор колонок. В связи с этим решил сделать универсальное окно.
#2 Vadim Исправление детской ошибки
#3 Vadim Удаление из заголовка столбца знаков переноса
}
{$EndIf}

{$IfDef NoChangesByALX} // before changes by Alx
{$Else}                 // after changes by Alx #1
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PropFilerEh, StdCtrls, Mask, DBCtrlsEh, PropStorageEh, ImgList,
  ComCtrls, CheckLst, ExtCtrls, ToolWin, {GridsEh,} DBGridEh, ActnList, Menus;

type
  TItemEx= class(TObject)
  public
    StringValue: string;
  end;

type
  TfrmColumnEdit = class(TForm)
    ToolBar1: TToolBar;
    Panel1: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    Panel2: TPanel;
    CheckListBox1: TCheckListBox;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    PropStorageEh1: TPropStorageEh;
    Label1: TLabel;
    Label2: TLabel;
    txtFrozenCols: TDBNumberEditEh;
    txtContraColCount: TDBNumberEditEh;
    ToolButton3: TToolButton;
    ActionList1: TActionList;
    actUp: TAction;
    actDown: TAction;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    actSelectAll: TAction;
    actClearSelect: TAction;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure actUpExecute(Sender: TObject);
    procedure actDownExecute(Sender: TObject);
    procedure ActionList1Update(Action: TBasicAction; var Handled: Boolean);
    procedure CheckListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure CheckListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure CheckListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOkClick(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actClearSelectExecute(Sender: TObject);
  private
    { Private declarations }
    DraggedPM: Integer;
    NotMove : Boolean;
    procedure WMActivateApp(var Msg: TWMActivateApp); message WM_ACTIVATEAPP;
    procedure WMSysCommand(var Msg: TWMSysCommand)  ; message WM_SYSCOMMAND ;
  public
    { Public declarations }
  end;

function ShowColumnEdit(aGrid: TCustomDBGridEh; aStorageManager: TPropStorageManagerEh = nil): TModalResult;

resourcestring
  cnstMsg = 'Должно отображаться не менее %s колонок';

{$EndIf}
implementation

{$IfDef NoChangesByALX} // before changes by Alx
{$Else}                 // after changes by Alx #1
uses
  Consts, DBGrids, Math;

{$R *.dfm}

function ShowColumnEdit(aGrid: TCustomDBGridEh; aStorageManager: TPropStorageManagerEh = nil): TModalResult;
  function columnTitleTrim(AValue : String) : String;
  var n : Integer;
  begin
    Result := AValue;
    n      := Length(Result);
    while n > 0 do
    begin
      if Result[n] in ['-', #13, #10] then
        Delete(Result, n, 1);
      Dec(n);  
    end;
  end;

var
  n, m: Integer;
  objItemEx: TItemEx;
begin
  with TfrmColumnEdit.Create(Application) do
  try
    if Assigned(aStorageManager) then
      PropStorageEh1.StorageManager:= aStorageManager
    else
      PropStorageEh1.StorageManager:= DefaultPropStorageManager;

    CheckListBox1.Items.BeginUpdate;
    try
      CheckListBox1.Items.Clear;
      m := -1; {#2}
      for n:= 0 to aGrid.Columns.Count-1 do
        with aGrid.Columns[n] do
        begin
          if not Assigned(Field) then Continue;
          objItemEx:= TItemEx.Create;
          objItemEx.StringValue:= Field.FieldName;
          CheckListBox1.Items.AddObject(columnTitleTrim(Title.Caption), objItemEx);
          {#2}
          Inc(m);
          CheckListBox1.Checked[m]:= Visible;
          { было так, но если нет поля if not Assigned(Field) then Continue;
                      то CheckListBox1.Items.Count < n
                      и ошибка SListIndexError
          CheckListBox1.Checked[n]:= Visible;
          }
        end;
    finally
      CheckListBox1.Items.EndUpdate;
    end;

    try
      if CheckListBox1.Items.Count <> 0 then
      begin
        CheckListBox1.ItemIndex := 0;
        txtFrozenCols.Value     := aGrid.FrozenCols       ;
        txtFrozenCols.MaxValue  := aGrid.Columns.Count - 1;
        //txtContraColCount.Value   := aGrid.ContraColCount   ;
        //txtContraColCount.MaxValue:= aGrid.Columns.Count - 1;
        NotMove :=    (not (dgColumnResize in aGrid.Options))
                   or (dghNoColumnMove in aGrid.OptionsEh);
      end;
      aGrid.DataSource.DataSet.Cancel;
      Result:= ShowModal;

      if Result = mrOk then
      begin
        aGrid.Columns.BeginUpdate;
        try
          aGrid.FrozenCols    := 0;
          //aGrid.ContraColCount:= 0;
          m := -1;
          for n:= 0 to CheckListBox1.Items.Count-1 do
          begin
            objItemEx:= TItemEx(CheckListBox1.Items.Objects[n]);
            aGrid.FieldColumns[objItemEx.StringValue].Visible:= CheckListBox1.Checked[n];
            aGrid.FieldColumns[objItemEx.StringValue].Index:= n;
            if CheckListBox1.Checked[n] then Inc(m);
          end;
          n := txtFrozenCols.Value;
          aGrid.FrozenCols := Min(n, m);
          //aGrid.ContraColCount:= txtContraColCount.Value;
        finally
          aGrid.Columns.EndUpdate;
        end;
      end
    finally
      for n:= 0 to CheckListBox1.Items.Count-1 do
        TItemEx(CheckListBox1.Items.Objects[n]).Free;
    end;
  finally
    Release;
  end;
end;

procedure TfrmColumnEdit.actClearSelectExecute(Sender: TObject);
var
  n: Integer;
begin
  for n:= 0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[n]:= False;
end;

procedure TfrmColumnEdit.actDownExecute(Sender: TObject);
var
  ind: Integer;
begin
  ind:= CheckListBox1.ItemIndex;
  if ind = -1 then Exit;
  CheckListBox1.Items.Move(ind, ind+1);
  CheckListBox1.ItemIndex:= ind+1;
end;

procedure TfrmColumnEdit.ActionList1Update(Action: TBasicAction;
  var Handled: Boolean);
var
  cnt: Integer;
begin
  cnt:= CheckListBox1.Items.Count;
  actUp  .Enabled:= (not NotMove) and (cnt > 1) and (CheckListBox1.ItemIndex <> 0    );
  actDown.Enabled:= (not NotMove) and (cnt > 1) and (CheckListBox1.ItemIndex <> cnt-1);
end;

procedure TfrmColumnEdit.actSelectAllExecute(Sender: TObject);
var
  n: Integer;
begin
  for n:= 0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[n]:= True;
end;

procedure TfrmColumnEdit.actUpExecute(Sender: TObject);
var
  ind: Integer;
begin
  ind:= CheckListBox1.ItemIndex;
  if ind = -1 then Exit;
  CheckListBox1.Items.Move(ind, ind-1);
  CheckListBox1.ItemIndex:= ind-1;
end;

procedure TfrmColumnEdit.btnOkClick(Sender: TObject);
var
  n, k: Integer;
begin
  inherited;
  ModalResult:= mrNone;
  k:= 0;
  for n:= 0 to CheckListBox1.Items.Count-1 do
    if CheckListBox1.Checked[n] then Inc(k);

  if k <= txtFrozenCols.Value + txtContraColCount.Value then begin
    Windows.MessageBox(GetActiveWindow, PChar(Format(cnstMsg, [VarToStr(txtFrozenCols.Value + txtContraColCount.Value + 1)])), PChar(SMsgDlgError), MB_OK or MB_ICONERROR or MB_TASKMODAL);
    Exit;
  end;

  ModalResult:= mrOk;
end;

procedure TfrmColumnEdit.CheckListBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  NewIndex: integer;
begin
  NewIndex:= CheckListBox1.ItemAtPos(Point(X,Y), False);
  if NewIndex > CheckListBox1.Items.Count-1 then
    NewIndex:= CheckListBox1.Items.Count-1;
  CheckListBox1.Items.Move(DraggedPM, NewIndex);
  CheckListBox1.ItemIndex:= NewIndex;
end;

procedure TfrmColumnEdit.CheckListBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source = CheckListBox1 then Accept:= True;
end;

procedure TfrmColumnEdit.CheckListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then with Sender as TCheckListBox do begin
    DraggedPM:= ItemAtPos(Point(X,Y), True);
    if DraggedPM >= 0 then BeginDrag(False);
  end;
end;

procedure TfrmColumnEdit.WMActivateApp(var Msg: TWMActivateApp);
begin
  if IsIconic(Application.Handle) then begin
    ShowWindow(Application.Handle, SW_RESTORE);
    SetActiveWindow(Handle);
  end;
  inherited;
end;

procedure TfrmColumnEdit.WMSysCommand(var Msg: TWMSysCommand);
begin
  if (Msg.CmdType = SC_Minimize) then
    ShowWindow(Application.Handle, SW_MINIMIZE)
  else
    inherited;
end;
{$EndIf}
end.
