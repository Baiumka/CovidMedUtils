{*******************************************************}
{                                                       }
{                       EhLib v3.5                      }
{          Register object that sort data in            }
{                         TDBF                          }
{                                                       }
{   Copyright (c) 2002, 2003 by Dmitry V. Bolshakov     }
{                                                       }
{*******************************************************}

{*******************************************************}
{ Add this unit to 'uses' clause of any unit of your    }
{ project to allow TDBGridEh to sort data in            }
{ TClientDataSet automatically  after sorting markers   }
{ will be changed.                                      }
{ TCDSDatasetFeaturesEh determine if                    }
{ TDBGridEh.SortLocal = True then it will create index  }
{ with name 'SortIndexEh' using SortMarkedColumns       }
{ else if SortLocal = False and CDS connected to other  }
{ DataSet via DataSetProvider it will try to sord data  }
{ in this DataSet using GetDatasetFeaturesForDataSet    }
{ function                                              }
{*******************************************************}

unit EhLibDBF;

{$I EhLib.Inc}

interface

uses
{$IFDEF EH_LIB_6} Variants, {$ENDIF}
  DbUtilsEh, DBGridEh, DB, dbf, Provider, SysUtils;

type

  TDBFDatasetFeaturesEh = class(TDatasetFeaturesEh)
  public
    procedure ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
    procedure ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean); override;
  end;

implementation

uses Classes;

{ TDBFDatasetFeaturesEh }

procedure TDBFDatasetFeaturesEh.ApplySorting(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
begin
//
end;

procedure TDBFDatasetFeaturesEh.ApplyFilter(Sender: TObject; DataSet: TDataSet; IsReopen: Boolean);
var AFilter : string;
    n : Integer;
begin
  if TDBGridEh(Sender).STFilter.Local then
  begin
    AFilter :=
      GetExpressionAsFilterString(TDBGridEh(Sender),
        GetOneExpressionAsLocalFilterString, nil, False, True);
    if AFilter = '' then
      AFilter := '1=1';
    // delete symbol "[" and "]"
    n := Length(AFilter);
    while n > 0 do
    begin
      if AFilter[n] in ['[',']'] then
        Delete(AFilter,n,1);
      Dec(n);   
    end;
    // replace Like for '='
    n := Pos('Like', AFilter);
    if n > 0 then
    begin
      AFilter[n] := '=';
      Inc(n);
      Delete(AFilter, n,3);
    end;

    // replace IS NULL for ' = '''
    n := Pos('IS NULL', AFilter);
    if n > 0 then
    begin
      AFilter[n] := '=';
      Inc(n);
      AFilter[n] := ' ';
      Inc(n);
      AFilter[n] := '''';
      Inc(n);
      AFilter[n] := '''';
      Inc(n);
      Delete(AFilter, n,3);
    end;

    // replace IS NOT NULL for ' <> '''
    n := Pos('IS NOT NULL', AFilter);
    if n > 0 then
    begin
      AFilter[n] := '<';
      Inc(n);
      AFilter[n] := '>';
      Inc(n);
      AFilter[n] := ' ';
      Inc(n);
      AFilter[n] := '''';
      Inc(n);
      AFilter[n] := '''';
      Inc(n);
      Delete(AFilter, n,6);
    end;

    TDBGridEh(Sender).DataSource.DataSet.Filter := AFilter;
    if AFilter = '1=1' then
      TDBGridEh(Sender).DataSource.DataSet.Filtered := False
    else if not TDBGridEh(Sender).DataSource.DataSet.Filtered then
      TDBGridEh(Sender).DataSource.DataSet.Filtered := True;
  end;
end;

initialization
  RegisterDatasetFeaturesEh(TDBFDatasetFeaturesEh, TDBF);
end.
