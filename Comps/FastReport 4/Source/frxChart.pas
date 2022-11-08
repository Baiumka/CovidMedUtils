
{******************************************}
{                                          }
{             FastReport v4.0              }
{         TeeChart Add-In Object           }
{                                          }
{         Copyright (c) 1998-2008          }
{         by Alexander Tzyganenko,         }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxChart;

interface

{$I frx.inc}
{$I tee.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Menus, Controls,
{$IFDEF FR_COM}
  FastReport_TLB, ComObj,
{$ENDIF}
  frxClass,
  TeeProcs, TeEngine, Chart, Series, TeCanvas
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxChartObject = class(TComponent);  // fake component
  TChartClass = class of TCustomChart;

  TfrxSeriesDataType = (dtDBData, dtBandData, dtFixedData);
  TfrxSeriesSortOrder = (soNone, soAscending, soDescending);
  TfrxSeriesXType = (xtText, xtNumber, xtDate);
  TSeriesClass = class of TChartSeries;
  TfrxChartSeries = (csLine, csArea, csPoint, csBar, csHorizBar,
    csPie, csGantt, csFastLine, csArrow, csBubble, csChartShape, csHorizArea,
    csHorizLine, csPolar, csRadar, csPolarBar, csGauge, csSmith, csPyramid,
    csDonut, csBezier, csCandle, csVolume, csPointFigure, csHistogram,
    csHorizHistogram, csErrorBar, csError, csHighLow, csFunnel, csBox,
    csHorizBox, csSurface, csContour, csWaterFall, csColorGrid, csVector3D,
    csTower, csTriSurface, csPoint3D, csBubble3D, csMyPoint, csBarJoin, csBar3D);


{$IFDEF FR_COM}
  TfrxSeriesItem = class(TCollectionItem, IfrxSeriesItem, IUnknown )
  private
    FRefCount: Integer;
    FSeries: TChartSeries;
{$ELSE}
  TfrxSeriesItem = class(TCollectionItem)
  private
{$ENDIF}
    FDataBand: TfrxDataBand;
    FDataSet: TfrxDataSet;
    FDataSetName: String;
    FDataType: TfrxSeriesDataType;
    FSortOrder: TfrxSeriesSortOrder;
    FTopN: Integer;
    FTopNCaption: String;
    FSource1: String;
    FSource2: String;
    FSource3: String;
    FSource4: String;
    FSource5: String;
    FSource6: String;
    FXType: TfrxSeriesXType;
    FValues1: String;
    FValues2: String;
    FValues3: String;
    FValues4: String;
    FValues5: String;
    FValues6: String;
    procedure FillSeries(Series: TChartSeries);
    procedure SetDataSet(const Value: TfrxDataSet);
    procedure SetDataSetName(const Value: String);
    function GetDataSetName: String;
{$IFDEF FR_COM}
    { IUnknown }
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    { IfrxSeriesItem }
    function Get_DataBand(out Value: IfrxDataBand): HResult; stdcall;
    function Set_DataBand(const Value: IfrxDataBand): HResult; stdcall;
    function Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
    function Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
    function Get_DataSetName(out Value: WideString): HResult; stdcall;
    function Set_DataSetName(const Value: WideString): HResult; stdcall;
    function Get_XSource(out Value: WideString): HResult; stdcall;
    function Set_XSource(const Value: WideString): HResult; stdcall;
    function Get_YSource(out Value: WideString): HResult; stdcall;
    function Set_YSource(const Value: WideString): HResult; stdcall;
    function Get_XValues(out Value: WideString): HResult; stdcall;
    function Set_XValues(const Value: WideString): HResult; stdcall;
    function Get_YValues(out Value: WideString): HResult; stdcall;
    function Set_YValues(const Value: WideString): HResult; stdcall;
    function Get_TopNCaption(out Value: WideString): HResult; stdcall;
    function Set_TopNCaption(const Value: WideString): HResult; stdcall;
    function Get_Title(out Value: WideString): HResult; stdcall;
    function Set_Title(const Value: WideString): HResult; stdcall;
    function Get_ZSource(out Value: WideString): HResult; stdcall;
    function Set_ZSource(const Value: WideString): HResult; stdcall;
    function Get_ZValues(out Value: WideString): HResult; stdcall;
    function Set_ZValues(const Value: WideString): HResult; stdcall;
    function Get_FourthSource(out Value: WideString): HResult; stdcall;
    function Set_FourthSource(const Value: WideString): HResult; stdcall;
    function Get_FourthValues(out Value: WideString): HResult; stdcall;
    function Set_FourthValues(const Value: WideString): HResult; stdcall;
    function Get_FifthSource(out Value: WideString): HResult; stdcall;
    function Set_FifthSource(const Value: WideString): HResult; stdcall;
    function Get_FifthValues(out Value: WideString): HResult; stdcall;
    function Set_FifthValues(const Value: WideString): HResult; stdcall;
    function Get_SixthSource(out Value: WideString): HResult; stdcall;
    function Set_SixthSource(const Value: WideString): HResult; stdcall;
    function Get_SixthValues(out Value: WideString): HResult; stdcall;
    function Set_SixthValues(const Value: WideString): HResult; stdcall;
    function Get_XAxisType(out Value: frxSeriesXType): HResult; stdcall;
    function Set_XAxisType(Value: frxSeriesXType): HResult; stdcall;
{$ENDIF}
  published
    property DataType: TfrxSeriesDataType read FDataType write FDataType;
    property DataBand: TfrxDataBand read FDataBand write FDataBand;
    property DataSet: TfrxDataSet read FDataSet write SetDataSet;
    property DataSetName: String read GetDataSetName write SetDataSetName;
    property SortOrder: TfrxSeriesSortOrder read FSortOrder write FSortOrder;
    property TopN: Integer read FTopN write FTopN;
    property TopNCaption: String read FTopNCaption write FTopNCaption;
    property XType: TfrxSeriesXType read FXType write FXType;

    { source expressions }
    property Source1: String read FSource1 write FSource1;
    property Source2: String read FSource2 write FSource2;
    property Source3: String read FSource3 write FSource3;
    property Source4: String read FSource4 write FSource4;
    property Source5: String read FSource5 write FSource5;
    property Source6: String read FSource6 write FSource6;

    { ready values. For internal use only. }
    property Values1: String read FValues1 write FValues1;
    property Values2: String read FValues2 write FValues2;
    property Values3: String read FValues3 write FValues3;
    property Values4: String read FValues4 write FValues4;
    property Values5: String read FValues5 write FValues5;
    property Values6: String read FValues6 write FValues6;

    { backward compatibility }
    property XSource: String read FSource1 write FSource1;
    property YSource: String read FSource2 write FSource2;
    property XValues: String read FValues1 write FValues1;
    property YValues: String read FValues2 write FValues2;
    {}
{$IFDEF FR_COM}
    property Series: TChartSeries read FSeries write FSeries;
{$ENDIF}
  end;

  TfrxSeriesData = class(TCollection)
  private
    FReport: TfrxReport;
    function GetSeries(Index: Integer): TfrxSeriesItem;
  public
    constructor Create(Report: TfrxReport);
    function Add: TfrxSeriesItem;
    property Items[Index: Integer]: TfrxSeriesItem read GetSeries; default;
  end;

{$IFDEF FR_COM}
  TfrxChartAxis = class(TAutoObject, IfrxChartAxis)
    FAxis:  TChartAxis;
  private
    function Get_Automatic(out Value: WordBool): HResult; stdcall;
    function Set_Automatic(Value: WordBool): HResult; stdcall;
    function Get_Minimum(out Value: Double): HResult; stdcall;
    function Set_Minimum(Value: Double): HResult; stdcall;
    function Get_Maximum(out Value: Double): HResult; stdcall;
    function Set_Maximum(Value: Double): HResult; stdcall;
    function Get_AutomaticMaximum(out Value: WordBool): HResult; stdcall;
    function Set_AutomaticMaximum(Value: WordBool): HResult; stdcall;
    function Get_AutomaticMinimum(out Value: WordBool): HResult; stdcall;
    function Set_AutomaticMinimum(Value: WordBool): HResult; stdcall;
    function Get_AxisValuesFormat(out Value: WideString): HResult; stdcall;
    function Set_AxisValuesFormat(const Value: WideString): HResult; stdcall;
    function Get_EndPosition(out Value: Double): HResult; stdcall;
    function Set_EndPosition(Value: Double): HResult; stdcall;
    function Get_Width(out Value: Integer): HResult; stdcall;
    function Set_Width(Value: Integer): HResult; stdcall;
    function Get_Color(out Value: Integer): HResult; stdcall;
    function Set_Color(Value: Integer): HResult; stdcall;
    function Get_Labels(out Value: WordBool): HResult; stdcall;
    function Set_Labels(Value: WordBool): HResult; stdcall;
    function Get_LabelsExponent(out Value: WordBool): HResult; stdcall;
    function Set_LabelsExponent(Value: WordBool): HResult; stdcall;
    function Get_LabelsSeparation(out Value: Integer): HResult; stdcall;
    function Set_LabelsSeparation(Value: Integer): HResult; stdcall;
    function Get_LabelStyle(out Value: Integer): HResult; stdcall;
    function Set_LabelStyle(Value: Integer): HResult; stdcall;
    function Get_Logarithmic(out Value: WordBool): HResult; stdcall;
    function Set_Logarithmic(Value: WordBool): HResult; stdcall;
  public
    constructor Create(Axis: TChartAxis);
  end;

  TfrxChartView = class(TfrxView, IfrxChartView)
  private
    FLeftAxis:  TfrxChartAxis;
    FBottomAxis:  TfrxChartAxis;
{$ELSE}
  TfrxChartView = class(TfrxView)
{$ENDIF}
  private
    FChart: TCustomChart;
    FSeriesData: TfrxSeriesData;
    procedure FillChart;
    procedure ReadData(Stream: TStream);
    procedure ReadData1(Reader: TReader);
    procedure ReadData2(Reader: TReader);
    procedure WriteData(Stream: TStream);
    procedure WriteData1(Writer: TWriter);
    procedure WriteData2(Writer: TWriter);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CreateChart; virtual;
    class function GetChartClass: TChartClass; virtual;
    {$IFDEF FR_COM}
    function GetSeriesItem(Index: Integer; out Value: IfrxSeriesItem): HResult; stdcall;
    function AddSeriesItem(Type_: frxSeriesType; out NewItem: IfrxSeriesItem): HResult; stdcall;
    function SeriesCount(out Value: Integer): HResult; stdcall;
    function Get_View3D(out Value: WordBool): HResult; stdcall;
    function Set_View3D(Value: WordBool): HResult; stdcall;
    function Get_View3dWalls(out Value: WordBool): HResult; stdcall;
    function Set_View3dWalls(Value: WordBool): HResult; stdcall;
    function Get_LeftAxis(out Value: IfrxChartAxis): HResult; stdcall;
    function Get_BottomAxis(out Value: IfrxChartAxis): HResult; stdcall;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function GetDescription: String; override;
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX, OffsetY: Extended); override;
    procedure AfterPrint; override;
    procedure GetData; override;
    procedure BeforeStartReport; override;
    procedure OnNotify(Sender: TObject); override;
    procedure ClearSeries;
    procedure AddSeries(Series: TfrxChartSeries);

    property Chart: TCustomChart read FChart;
    property SeriesData: TfrxSeriesData read FSeriesData;
  published
    property BrushStyle;
    property Color;
    property Cursor;
    property Frame;
    property TagStr;
    property URL;
  end;


implementation

uses
  frxChartHelpers, frxChartRTTI,
{$IFNDEF NO_EDITORS}
  frxChartEditor,
{$ENDIF}
  frxDsgnIntf, frxUtils, frxRes;


{ TfrxSeriesItem }

procedure TfrxSeriesItem.SetDataSet(const Value: TfrxDataSet);
begin
  FDataSet := Value;
  if FDataSet = nil then
    FDataSetName := '' else
    FDataSetName := FDataSet.UserName;
end;

procedure TfrxSeriesItem.SetDataSetName(const Value: String);
begin
  FDataSetName := Value;
  FDataSet := frxFindDataSet(FDataSet, FDataSetName,
    TfrxSeriesData(Collection).FReport);
end;

function TfrxSeriesItem.GetDataSetName: String;
begin
  if FDataSet = nil then
    Result := FDataSetName else
    Result := FDataSet.UserName;
end;

procedure TfrxSeriesItem.FillSeries(Series: TChartSeries);
var
  i: Integer;
  sl1, sl2, sl3, sl4, sl5, sl6: TStringList;
  v1, v2, v3, v4, v5, v6: String;
  Helper: TfrxSeriesHelper;

  procedure Sort;
  var
    i: Integer;
    sl: TStringList;
    s: String;
  begin
    if sl1.Count <> sl2.Count then exit;

    sl := TStringList.Create;
    sl.Sorted := True;
    sl.Duplicates := dupAccept;

    for i := 0 to sl2.Count - 1 do
    begin
      s := sl2[i];
      if not frxIsValidFloat(s) then
        s := '0';
      sl.Add(Format('%18.2f', [frxStrToFloat(s)]) + '=' + sl1[i]);
    end;

    sl1.Clear;
    sl2.Clear;
    if FSortOrder = soAscending then
      for i := 0 to sl.Count - 1 do
      begin
        sl1.Add(Trim(Copy(sl[i], Pos('=', sl[i]) + 1, 255)));
        sl2.Add(Trim(Copy(sl[i], 1, Pos('=', sl[i]) - 1)));
      end
    else
      for i := sl.Count - 1 downto 0 do
      begin
        sl1.Add(Trim(Copy(sl[i], Pos('=', sl[i]) + 1, 255)));
        sl2.Add(Trim(Copy(sl[i], 1, Pos('=', sl[i]) - 1)));
      end;

    sl.Free;
  end;

  procedure MakeTopN;
  var
    i: Integer;
    d: Double;
    sl: TStringList;
    s: String;
  begin
    if sl1.Count <> sl2.Count then exit;

    sl := TStringList.Create;
    sl.Sorted := True;
    sl.Duplicates := dupAccept;

    for i := 0 to sl2.Count - 1 do
    begin
      s := sl2[i];
      if not frxIsValidFloat(s) then
        s := '0';
      sl.Add(Format('%18.2f', [frxStrToFloat(s)]) + '=' + sl1[i]);
    end;

    sl1.Clear;
    sl2.Clear;
    for i := sl.Count - 1 downto sl.Count - FTopN do
    begin
      sl1.Add(Trim(Copy(sl[i], Pos('=', sl[i]) + 1, 255)));
      sl2.Add(Trim(Copy(sl[i], 1, Pos('=', sl[i]) - 1)));
    end;

    d := 0;
    for i := sl.Count - FTopN - 1 downto 0 do
      d := d + frxStrToFloat(Trim(Copy(sl[i], 1, Pos('=', sl[i]) - 1)));

    sl1.Add(FTopNCaption);
    sl2.Add(FloatToStr(d));

    sl.Free;
  end;

begin
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  sl3 := TStringList.Create;
  sl4 := TStringList.Create;
  sl5 := TStringList.Create;
  sl6 := TStringList.Create;
  Series.Clear;

  v1 := FValues1;
  if (v1 <> '') and (v1[1] = ';') then
    Delete(v1, 1, 1);
  v2 := FValues2;
  if (v2 <> '') and (v2[1] = ';') then
    Delete(v2, 1, 1);
  v3 := FValues3;
  if (v3 <> '') and (v3[1] = ';') then
    Delete(v3, 1, 1);
  v4 := FValues4;
  if (v4 <> '') and (v4[1] = ';') then
    Delete(v4, 1, 1);
  v5 := FValues5;
  if (v5 <> '') and (v5[1] = ';') then
    Delete(v5, 1, 1);
  v6 := FValues6;
  if (v6 <> '') and (v6[1] = ';') then
    Delete(v6, 1, 1);

  frxSetCommaText(v1, sl1);
  frxSetCommaText(v2, sl2);
  frxSetCommaText(v3, sl3);
  frxSetCommaText(v4, sl4);
  frxSetCommaText(v5, sl5);
  frxSetCommaText(v6, sl6);

  Helper := frxFindSeriesHelper(Series);

  try
    if sl2.Count > 0 then
    begin
      if (FTopN > 0) and (FTopN < sl2.Count) then
        MakeTopN
      else if FSortOrder <> soNone then
        Sort;

      for i := 0 to sl2.Count - 1 do
      begin
        if i < sl1.Count then v1 := sl1[i] else v1 := '';
        if i < sl2.Count then v2 := sl2[i] else v2 := '';
        if i < sl3.Count then v3 := sl3[i] else v3 := '';
        if i < sl4.Count then v4 := sl4[i] else v4 := '';
        if i < sl5.Count then v5 := sl5[i] else v5 := '';
        if i < sl6.Count then v6 := sl6[i] else v6 := '';
        Helper.AddValues(Series, v1, v2, v3, v4, v5, v6, FXType);
      end;
    end;

  finally
    Helper.Free;
    sl1.Free;
    sl2.Free;
    sl3.Free;
    sl4.Free;
    sl5.Free;
    sl6.Free;
  end;
end;

{$IFDEF FR_COM}
function TfrxSeriesItem.QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE;
end;

function TfrxSeriesItem._AddRef: Integer; stdcall;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TfrxSeriesItem._Release: Integer; stdcall;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then Destroy;
end;

function TfrxSeriesItem.Get_DataBand(out Value: IfrxDataBand): HResult; stdcall;
begin
  Value := DataBand;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_DataBand(const Value: IfrxDataBand): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf}IInterfaceComponentReference;
begin
  Result := Value.QueryInterface({IfrxComponentSelf}IInterfaceComponentReference, idsp);
  if Result = S_OK then
  begin
    DataBand := TfrxDataBand(idsp.{Get_Object} GetComponent);
    idsp._Release;
  end;
end;

function TfrxSeriesItem.Get_DataSet(out Value: IfrxDataSet): HResult; stdcall;
begin
  Value := DataSet;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_DataSet(const Value: IfrxDataSet): HResult; stdcall;
var
  idsp:   {IfrxComponentSelf} IInterfaceComponentReference;
begin
  Result := Value.QueryInterface({IfrxComponentSelf}IInterfaceComponentReference, idsp);
  if Result = S_OK  then
  begin
    DataSet := TfrxDataSet(idsp.GetComponent{Get_Object});
  end;
end;

function TfrxSeriesItem.Get_DataSetName(out Value: WideString): HResult; stdcall;
begin
  Value := DataSetName;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_DataSetName(const Value: WideString): HResult; stdcall;
begin
  DataSetName := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_XSource(out Value: WideString): HResult; stdcall;
begin
  Value := XSource;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_XSource(const Value: WideString): HResult; stdcall;
begin
  XSource := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_YSource(out Value: WideString): HResult; stdcall;
begin
  Value := YSource;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_YSource(const Value: WideString): HResult; stdcall;
begin
  YSource := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_XValues(out Value: WideString): HResult; stdcall;
begin
  Value := XValues;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_XValues(const Value: WideString): HResult; stdcall;
begin
  XValues := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_YValues(out Value: WideString): HResult; stdcall;
begin
  Value := YValues;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_YValues(const Value: WideString): HResult; stdcall;
begin
  YValues := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_TopNCaption(out Value: WideString): HResult; stdcall;
begin
  Value := TopNCaption;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_TopNCaption(const Value: WideString): HResult; stdcall;
begin
  TopNCaption := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_Title(out Value: WideString): HResult; stdcall;
begin
  Value := Series.Title;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_Title(const Value: WideString): HResult; stdcall;
begin
  Series.Title := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_ZSource(out Value: WideString): HResult; stdcall;
begin
  Value := Source3;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_ZSource(const Value: WideString): HResult; stdcall;
begin
  Source3 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_ZValues(out Value: WideString): HResult; stdcall;
begin
  Value := Values3;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_ZValues(const Value: WideString): HResult; stdcall;
begin
  Values3 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_FourthSource(out Value: WideString): HResult; stdcall;
begin
  Value := Source4;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_FourthSource(const Value: WideString): HResult; stdcall;
begin
  Source4 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_FourthValues(out Value: WideString): HResult; stdcall;
begin
  Value := Values4;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_FourthValues(const Value: WideString): HResult; stdcall;
begin
  Values4 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_FifthSource(out Value: WideString): HResult; stdcall;
begin
  Value := Source5;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_FifthSource(const Value: WideString): HResult; stdcall;
begin
  Source5 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_FifthValues(out Value: WideString): HResult; stdcall;
begin
  Value := Values5;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_FifthValues(const Value: WideString): HResult; stdcall;
begin
  Values5 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_SixthSource(out Value: WideString): HResult; stdcall;
begin
  Value := Source6;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_SixthSource(const Value: WideString): HResult; stdcall;
begin
  Source6 := Value;
  Result := S_OK;
end;

function TfrxSeriesItem.Get_SixthValues(out Value: WideString): HResult; stdcall;
begin
  Value := Values6;
  Result := S_OK;
end;

function TfrxSeriesItem.Set_SixthValues(const Value: WideString): HResult; stdcall;
begin
  Values6 := Value;
  Result := S_OK;
end;
function TfrxSeriesItem.Get_XAxisType(out Value: frxSeriesXType): HResult; stdcall;
begin
  Value := frxSeriesXType(XType);
  Result := S_OK;
end;

function TfrxSeriesItem.Set_XAxisType(Value: frxSeriesXType): HResult; stdcall;
begin
  XType := TfrxSeriesXType(Value);
  Result := S_OK;
end;
{$ENDIF}

{ TfrxSeriesData }

constructor TfrxSeriesData.Create(Report: TfrxReport);
begin
  inherited Create(TfrxSeriesItem);
  FReport := Report;
end;

function TfrxSeriesData.Add: TfrxSeriesItem;
begin
  Result := TfrxSeriesItem(inherited Add);
end;

function TfrxSeriesData.GetSeries(Index: Integer): TfrxSeriesItem;
begin
  Result := TfrxSeriesItem(inherited Items[Index]);
end;


{ TfrxChartView }

constructor TfrxChartView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateChart;
  FSeriesData := TfrxSeriesData.Create(Report);
{$IFDEF FR_COM}
  FLeftAxis := TfrxChartAxis.Create(Chart.LeftAxis);
  FBottomAxis := TfrxChartAxis.Create(Chart.BottomAxis);
{$ENDIF}
end;

destructor TfrxChartView.Destroy;
begin
{$IFDEF FR_COM}
  FLeftAxis.Destroy;
  FBottomAxis.Destroy;
{$ENDIF}
  FChart.Free;
  inherited Destroy;
  FSeriesData.Free;
end;

class function TfrxChartView.GetDescription: String;
begin
  Result := frxResources.Get('obChart');
end;

procedure TfrxChartView.Notification(AComponent: TComponent; Operation: TOperation);
var
  i: Integer;
begin
  inherited;
  if Operation = opRemove then
  begin
    for i := 0 to FSeriesData.Count - 1 do
      if AComponent is TfrxDataSet then
      begin
        if FSeriesData[i].DataSet = AComponent then
          FSeriesData[i].DataSet := nil;
      end
      else if AComponent is TfrxBand then
      begin
        if FSeriesData[i].DataBand = AComponent then
          FSeriesData[i].DataBand := nil;
      end;
  end;
end;

class function TfrxChartView.GetChartClass: TChartClass;
begin
  Result := TChart;
end;

procedure TfrxChartView.CreateChart;
begin
  FChart := GetChartClass.Create(Self);
  with FChart do
  begin
    Color := clWhite;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Name := 'Chart';
    Frame.Visible := False;
    View3DOptions.Rotation := 0;
    Title.Text.Text := '';
  end;
end;

procedure TfrxChartView.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Chart', ReadData, WriteData, True);
  Filer.DefineProperty('ChartElevation', ReadData1, WriteData1, True);
  Filer.DefineProperty('SeriesData', ReadData2, WriteData2, True);
end;

procedure TfrxChartView.ReadData(Stream: TStream);
begin
  FChart.Free;
  CreateChart;
  Stream.ReadComponent(FChart);
end;

procedure TfrxChartView.WriteData(Stream: TStream);
begin
  Stream.WriteComponent(FChart);
end;

procedure TfrxChartView.ReadData1(Reader: TReader);
begin
  FChart.View3DOptions.Elevation := Reader.ReadInteger;
end;

procedure TfrxChartView.WriteData1(Writer: TWriter);
begin
  Writer.WriteInteger(FChart.View3DOptions.Elevation);
end;

procedure TfrxChartView.ReadData2(Reader: TReader);
begin
  frxReadCollection(FSeriesData, Reader, Self);
end;

procedure TfrxChartView.WriteData2(Writer: TWriter);
begin
  frxWriteCollection(FSeriesData, Writer, Self);
end;

procedure TfrxChartView.FillChart;
var
  i: Integer;
begin
  for i := 0 to FSeriesData.Count - 1 do
    FSeriesData[i].FillSeries(FChart.Series[i]);
end;

procedure TfrxChartView.Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
  OffsetY: Extended);
var
  EMF: TMetafile;
begin
  BeginDraw(Canvas, ScaleX, ScaleY, OffsetX, OffsetY);
  DrawBackground;

  FillChart;

  if Color = clTransparent then
    FChart.Color := clWhite else
    FChart.Color := Color;
  FChart.BufferedDisplay := True;
  EMF := FChart.TeeCreateMetafile(False, Rect(0, 0, Round(Width), Round(Height)));
  Canvas.StretchDraw(Rect(FX, FY, FX1, FY1), EMF);
  EMF.Free;

  DrawFrame;
end;

procedure TfrxChartView.AfterPrint;
var
  i: Integer;
begin
  for i := 0 to FSeriesData.Count - 1 do
    with FSeriesData[i] do
    begin
      Values1 := '';
      Values2 := '';
      Values3 := '';
      Values4 := '';
      Values5 := '';
      Values6 := '';
    end;
end;

procedure TfrxChartView.GetData;
var
  i: Integer;
begin
  inherited;
  for i := 0 to FSeriesData.Count - 1 do
    with FSeriesData[i] do
      if (DataType = dtDBData) and (DataSet <> nil) then
      begin
        Values1 := '';
        Values2 := '';
        Values3 := '';
        Values4 := '';
        Values5 := '';
        Values6 := '';

        DataSet.First;
        while not DataSet.Eof do
        begin
          if Source1 <> '' then
            Values1 := Values1 + ';' + VarToStr(Report.Calc(Source1));
          if Source2 <> '' then
            Values2 := Values2 + ';' + VarToStr(Report.Calc(Source2));
          if Source3 <> '' then
            Values3 := Values3 + ';' + VarToStr(Report.Calc(Source3));
          if Source4 <> '' then
            Values4 := Values4 + ';' + VarToStr(Report.Calc(Source4));
          if Source5 <> '' then
            Values5 := Values5 + ';' + VarToStr(Report.Calc(Source5));
          if Source6 <> '' then
            Values6 := Values6 + ';' + VarToStr(Report.Calc(Source6));
          DataSet.Next;
        end;
      end
      else if DataType = dtFixedData then
      begin
        Values1 := Source1;
        Values2 := Source2;
        Values3 := Source3;
        Values4 := Source4;
        Values5 := Source5;
        Values6 := Source5;
      end
end;

procedure TfrxChartView.BeforeStartReport;
var
  i: Integer;
begin
  for i := 0 to FSeriesData.Count - 1 do
    with FSeriesData[i] do
    begin
      Values1 := '';
      Values2 := '';
      Values3 := '';
      Values4 := '';
      Values5 := '';
      Values6 := '';
    end;
  Report.Engine.NotifyList.Add(Self);
end;

procedure TfrxChartView.OnNotify(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  for i := 0 to FSeriesData.Count - 1 do
    with FSeriesData[i] do
      if (DataType = dtBandData) and (DataBand = Sender) then
      begin
        Report.CurObject := Self.Name;
        if Source1 <> '' then
          Values1 := Values1 + ';' + VarToStr(Report.Calc(Source1));
        if Source2 <> '' then
          Values2 := Values2 + ';' + VarToStr(Report.Calc(Source2));
        if Source3 <> '' then
          Values3 := Values3 + ';' + VarToStr(Report.Calc(Source3));
        if Source4 <> '' then
          Values4 := Values4 + ';' + VarToStr(Report.Calc(Source4));
        if Source5 <> '' then
          Values5 := Values5 + ';' + VarToStr(Report.Calc(Source5));
        if Source6 <> '' then
          Values6 := Values6 + ';' + VarToStr(Report.Calc(Source6));
      end;
end;

procedure TfrxChartView.AddSeries(Series: TfrxChartSeries);
var
  sc: TSeriesClass;
  s: TChartSeries;
  b: Boolean;
{$IFDEF FR_COM}
  item: TfrxSeriesItem;
{$ENDIF}
begin
  sc := frxChartSeries[Integer(Series)];
  s := TChartSeries(sc.NewInstance);
  s.Create(Chart);
  Chart.AddSeries(s);
{$IFNDEF FR_COM}
  SeriesData.Add;
{$ELSE}
  item := SeriesData.Add;
  item.Series := s;
{$ENDIF}

  with Chart do
  begin
    b := not (s is TPieSeries);
    View3DOptions.Orthogonal := b;
    AxisVisible := b;
    View3DWalls := b;
  end;
end;

procedure TfrxChartView.ClearSeries;
begin
  FChart.Free;
  CreateChart;
  SeriesData.Clear;
end;

{$IFDEF FR_COM}
function TfrxChartView.GetSeriesItem(Index: Integer; out Value: IfrxSeriesItem): HResult; stdcall;
begin
  Value := SeriesData.Items[Index] as IfrxSeriesItem;
  Value._AddRef();
  Result := S_OK;
end;

function TfrxChartView.AddSeriesItem(Type_: frxSeriesType; out NewItem: IfrxSeriesItem): HResult; stdcall;
begin
  AddSeries( TfrxChartSeries(Type_) );
  Result := GetSeriesItem(SeriesData.Count-1, NewItem);
end;

function TfrxChartView.SeriesCount(out Value: Integer): HResult; stdcall;
begin
  Value := SeriesData.Count;
  Result := S_OK;
end;

function TfrxChartView.Get_View3D(out Value: WordBool): HResult; stdcall;
begin
  Value := Chart.View3D;
  Result := S_OK;
end;

function TfrxChartView.Set_View3D(Value: WordBool): HResult; stdcall;
begin
  Chart.View3D := Value;
  Result := S_OK;
end;

function TfrxChartView.Get_View3dWalls(out Value: WordBool): HResult; stdcall;
begin
  Value := Chart.View3DWalls;
  Result := S_OK;
end;

function TfrxChartView.Set_View3dWalls(Value: WordBool): HResult; stdcall;
begin
  Chart.View3dWalls := Value;
  Result := S_OK;
end;

function TfrxChartView.Get_LeftAxis(out Value: IfrxChartAxis): HResult; stdcall;
begin
  Value := FLeftAxis;
  FLeftAxis._AddRef;
  Result := S_OK;
end;

function TfrxChartView.Get_BottomAxis(out Value: IfrxChartAxis): HResult; stdcall;
begin
  Value := FBottomAxis;
  FBottomAxis._AddRef;
  Result := S_OK;
end;

{$ENDIF}

{$IFDEF FR_COM}
{ TfrxChartAxis }

constructor TfrxChartAxis.Create(Axis: TChartAxis);
begin
  FAxis := Axis;
end;

function TfrxChartAxis.Get_Automatic(out Value: WordBool): HResult; stdcall;
begin
  Value := FAxis.Automatic;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Automatic(Value: WordBool): HResult; stdcall;
begin
  FAxis.Automatic := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_Minimum(out Value: Double): HResult; stdcall;
begin
  Value := FAxis.Minimum;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Minimum(Value: Double): HResult; stdcall;
begin
  FAxis.Minimum := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_Maximum(out Value: Double): HResult; stdcall;
begin
  Value := FAxis.Maximum;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Maximum(Value: Double): HResult; stdcall;
begin
  FAxis.Maximum := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_AutomaticMaximum(out Value: WordBool): HResult; stdcall;
begin
  Value := FAxis.AutomaticMaximum;
  Result := S_OK;
end;

function TfrxChartAxis.Set_AutomaticMaximum(Value: WordBool): HResult; stdcall;
begin
  FAxis.AutomaticMaximum := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_AutomaticMinimum(out Value: WordBool): HResult; stdcall;
begin
  Value := FAxis.AutomaticMinimum;
  Result := S_OK;
end;

function TfrxChartAxis.Set_AutomaticMinimum(Value: WordBool): HResult; stdcall;
begin
  FAxis.AutomaticMinimum := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_AxisValuesFormat(out Value: WideString): HResult; stdcall;
begin
  Value := FAxis.AxisValuesFormat;
  Result := S_OK;
end;

function TfrxChartAxis.Set_AxisValuesFormat(const Value: WideString): HResult; stdcall;
begin
  FAxis.AxisValuesFormat := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_EndPosition(out Value: Double): HResult; stdcall;
begin
  Value := FAxis.EndPosition;
  Result := S_OK;
end;

function TfrxChartAxis.Set_EndPosition(Value: Double): HResult; stdcall;
begin
  FAxis.EndPosition := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_Width(out Value: Integer): HResult; stdcall;
begin
  Value := FAxis.Axis.Width;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Width(Value: Integer): HResult; stdcall;
begin
  FAxis.Axis.Width := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_Color(out Value: Integer): HResult; stdcall;
begin
  Value := FAxis.Axis.Color;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Color(Value: Integer): HResult; stdcall;
begin
  FAxis.Axis.Color := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_Labels(out Value: WordBool): HResult; stdcall;
begin
  Value := FAxis.Labels;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Labels(Value: WordBool): HResult; stdcall;
begin
  FAxis.Labels := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_LabelsExponent(out Value: WordBool): HResult; stdcall;
begin
{$IFDEF TEECHART7}
  Value := FAxis.LabelsExponent;
  Result := S_OK;
{$ELSE}
  Result := E_NOTIMPL;
{$ENDIF}
end;

function TfrxChartAxis.Set_LabelsExponent(Value: WordBool): HResult; stdcall;
begin
{$IFDEF TEECHART7}
  FAxis.LabelsExponent := Value;
  Result := S_OK;
{$ELSE}
  Result := E_NOTIMPL;
{$ENDIF}
end;

function TfrxChartAxis.Get_LabelsSeparation(out Value: Integer): HResult; stdcall;
begin
  Value := FAxis.LabelsSeparation;
  Result := S_OK;
end;

function TfrxChartAxis.Set_LabelsSeparation(Value: Integer): HResult; stdcall;
begin
  FAxis.LabelsSeparation := Value;
  Result := S_OK;
end;

function TfrxChartAxis.Get_LabelStyle(out Value: Integer): HResult; stdcall;
begin
  Value := Integer(FAxis.LabelStyle);
  Result := S_OK;
end;

function TfrxChartAxis.Set_LabelStyle(Value: Integer): HResult; stdcall;
begin
  FAxis.LabelStyle := TAxisLabelStyle(Value);
  Result := S_OK;
end;

function TfrxChartAxis.Get_Logarithmic(out Value: WordBool): HResult; stdcall;
begin
  Value := FAxis.Logarithmic;
  Result := S_OK;
end;

function TfrxChartAxis.Set_Logarithmic(Value: WordBool): HResult; stdcall;
begin
  FAxis.Logarithmic := Value;
  Result := S_OK;
end;
{$ENDIF}


initialization
{$IFNDEF TeeChartStd}
{$IFNDEF TeeChartStd7}
{$IFNDEF TeeChart4}
  RegisterTeeStandardSeries;
{$ENDIF}
{$ENDIF}
{$ENDIF}
  frxObjects.RegisterObject1(TfrxChartView, nil, '', '', 0, 25);

finalization
  frxObjects.UnRegister(TfrxChartView);

end.


//
