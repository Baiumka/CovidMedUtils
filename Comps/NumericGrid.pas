unit NumericGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, Messages;

type
  TNumericGrid = class(TStringGrid)
  private
    { Private declarations }
    FOnlyNumeric   : Boolean;
    FOnEditorExit  : TNotifyEvent;
    FOnEditorEnter : TNotifyEvent;
    FSendByMinus   : Boolean;
    FDecimalPlaces : Byte;
    procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
  protected
    { Protected declarations }
    procedure DoEditorExit(Value : Boolean);
    procedure DoEditorEnter(Value : Boolean);
    procedure KeyPress(var Key: Char); override;
    procedure SetDecimalPlaces(const Value : Byte);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
  published
    { Published declarations }
    property OnlyNumeric   : Boolean read FOnlyNumeric write FOnlyNumeric default True;
    property DecimalPlaces : Byte read FDecimalPlaces write FDecimalPlaces default 2;
    property OnEditorExit  : TNotifyEvent read FOnEditorExit write FOnEditorExit;
    property OnEditorEnter : TNotifyEvent read FOnEditorEnter write FOnEditorEnter;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TNumericGrid]);
end;

{ TNumericGrid }

type TCG = class(TCustomGrid);
     TSG = class(TStringGrid);

procedure TNumericGrid.ColumnMoved(FromIndex, ToIndex: Integer);
begin
  inherited;
end;

constructor TNumericGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnlyNumeric   := True;
  FSendByMinus   := False;
  FDecimalPlaces := 2;
end;

procedure TNumericGrid.DoEditorEnter(Value: Boolean);
begin
  if Assigned(FOnEditorEnter) then
    FOnEditorEnter(Self);
end;

procedure TNumericGrid.DoEditorExit(Value : Boolean);
var S     : String;
    Reset : boolean;
    n     : Byte;
begin
  if FOnlyNumeric then
  begin
    S := Cells[Col, Row];
    n := Length(S);
    if n > 0 then
    begin
      Reset := False;
      if S[1] = DecimalSeparator then
      begin
        S     := '0'+ S;
        Reset := True;
      end
      else if S[n] = DecimalSeparator then
      begin
        SetLength(S, n-1);
        Reset := True;
      end;
      if Reset then
        Cells[Col, Row] := FloatToStr(StrToFloat(S));
    end;
  end;
  if Assigned(FOnEditorExit) then
    FOnEditorExit(Self);
end;

procedure TNumericGrid.KeyPress(var Key: Char);
var i, j,
    k, n : byte;
    S    : String;
begin
  FSendByMinus := False;
  if FOnlyNumeric then
  begin
    if not (Key  in ['0'..'9', '.',',',#8,#13,'-']) then
      Key := #0
    else begin
      S := Cells[Col, Row];
      n := Length(S);
      j := TCG(Self).InplaceEditor.SelStart;
      if Key in ['.',','] then
      begin
        Key := DecimalSeparator;
        if Pos(Key, S) > 0 then
          Key := #0;
        if DecimalPlaces = 0 then
          Key := #0;  
      end
      else if Key = '-' then
      begin
        Key := #0;
        if (n > 0) and (Pos('-',S) = 0) then
        begin
          FSendByMinus := True;
          if S[1] <> DecimalSeparator then
          begin
            Cells[Col, Row] := '-' + S;
            k := 1;
          end
          else begin
            Cells[Col, Row] := '-0' + S;
            k := 2;
          end;
          FSendByMinus := False;
          TCG(Self).InplaceEditor.Deselect;
          TCG(Self).InplaceEditor.SelStart := j+k;
        end;
      end
      else if Key in ['0'..'9'] then
      begin
        if (n > 0) and (j = 0) and (S[1] = '-') then
          Key := #0
        else begin
          i := Pos(DecimalSeparator, S);
          if    (i > 0)
            and (j >= i)
            and ((n-i)>= DecimalPlaces)
          then
            Key := #0;
        end;
      end;
    end;
  end;
  if Key <> #0 then
    inherited KeyPress(Key);
end;

procedure TNumericGrid.SetDecimalPlaces(const Value: Byte);
begin
  FDecimalPlaces := Value;
  if FDecimalPlaces > 10 then
    FDecimalPlaces := 10;
end;

procedure TNumericGrid.WMCommand(var Message: TWMCommand);
begin
  inherited;
  with Message do
  begin
    if (TCG(Self).InplaceEditor <> nil) and
       (Ctl = TCG(Self).InplaceEditor.Handle)
       and not FSendByMinus
       then
      case NotifyCode of
        EN_KILLFOCUS: DoEditorExit(TCG(Self).InplaceEditor.Visible);
        EN_SETFOCUS : DoEditorEnter(TCG(Self).InplaceEditor.Visible);
      end;
  end;
end;

end.
