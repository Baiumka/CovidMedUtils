{*******************************************************}
{                                                       }
{                       EhLib v3.5                      }
{      Register object that sort data in TIBQuery       }
{                                                       }
{   Copyright (c) 2002, 2003 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TIBQuery automatically after sorting markers          }
{ will be changed.                                      }
{ TSQLDatasetFeaturesEh will try to find line in        }
{ TIBQuery.SQL string that begin from 'ORDER BY' phrase }
{ and replace line by 'ORDER BY FieldNo1 [DESC],....'   }
{ using SortMarkedColumns.                              }
{*******************************************************}

unit EhLibZEOS;

{$I EhLib.Inc}

interface

uses
  DbUtilsEh, Db, ZDataset;

implementation
uses DBGridEh, SysUtils, Variants;

function ZeosDataSetDriverName(DataSet: TDataSet): String;
begin
  Result := 'ZEOS';
end;

type

  TZEOSDatasetFeaturesEh = class(TSQLDatasetFeaturesEh)
  public
    constructor Create; override;
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
  end;

procedure SortDataInZEOSDataSet(Grid : TCustomDBGridEh; DataSet : TDataSet);
var s : String;
    i : Integer;
    BM : TBookmarkStr;
begin
  s := '';
  for i := 0 to Grid.SortMarkedColumns.Count - 1 do
  begin
    s := s + Grid.SortMarkedColumns[i].FieldName;
    if Grid.SortMarkedColumns[i].Title.SortMarker = smUpEh
      then s := s + ' DESC, '
      else s := s + ', ';
  end;
  if s <> EmptyStr then
  begin
    s := Copy(s, 1, Length(s) - 2);
    BM := DataSet.Bookmark;
    if DataSet is TZQuery then
      TZQuery(DataSet).SortedFields := s
    else if DataSet is TZReadOnlyQuery then
      TZReadOnlyQuery(DataSet).SortedFields := s
    else if DataSet is TZTable then
      TZTable(DataSet).SortedFields := s;
    if DataSet.Active and (BM <> EmptyStr) and
      DataSet.BookmarkValid(TBookmark(BM))
    then
      DataSet.Bookmark := BM;
  end;
end;

{ TZQueryDatasetFeaturesEh }

procedure TZEOSDatasetFeaturesEh.ApplyFilter(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
var OldDC : Char;
begin
  if not (Sender is TCustomDBGridEh) then Exit;
  
  BracketField := False;
  if TDBGridEh(Sender).STFilter.Local or (DataSet is TZTable) then
  begin
    OldDC := DecimalSeparator;
    try
      DecimalSeparator := '.';
      TDBGridEh(Sender).DataSource.DataSet.Filter :=
        GetExpressionAsFilterString(TDBGridEh(Sender),
          GetOneExpressionAsLocalFilterString, nil, False, False);
    finally
     DecimalSeparator := OldDC;
    end;
    if not TDBGridEh(Sender).DataSource.DataSet.Filtered then
      TDBGridEh(Sender).DataSource.DataSet.Filtered := True;
  end
  else begin
    SupportsLocalLike := True;
    ApplyFilterSQLBasedDataSet(TDBGridEh(Sender), DateValueToSQLString, IsReopen, SQLPropName);
  end;
end;

procedure TZEOSDatasetFeaturesEh.ApplySorting(Sender: TObject;
  DataSet: TDataSet; IsReopen: Boolean);
var s : string;
    v : Variant;
    i : Integer;
begin
  if Sender is TCustomDBGridEh then
  begin
    if (not TCustomDBGridEh(Sender).SortLocal) and
       (not (DataSet is TZTable))
    then begin
      s := '';
      v := VarArrayCreate([0, DataSet.FieldCount - 1], varVariant);
      for i := 0 to DataSet.FieldCount - 1 do
      begin
        s := s + DataSet.Fields[i].FieldName + ';';
        v[i] := DataSet.Fields[i].Value;
      end;

      inherited;

      DataSet.Locate(s,v,[]);
    end
    else
      SortDataInZEOSDataSet(TCustomDBGridEh(Sender), TZQuery(DataSet));
  end;
end;

constructor TZEOSDatasetFeaturesEh.Create;
begin
  inherited;
  SortUsingFieldName := True;
end;

initialization
  RegisterDatasetFeaturesEh(TZEOSDatasetFeaturesEh, TZQuery);
  RegisterDatasetFeaturesEh(TZEOSDatasetFeaturesEh, TZReadOnlyQuery);
  RegisterDatasetFeaturesEh(TZEOSDatasetFeaturesEh, TZTable);
end.
