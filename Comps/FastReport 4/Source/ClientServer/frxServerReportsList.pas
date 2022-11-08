
{******************************************}
{                                          }
{             FastReport v4.0              }
{                                          }
{         List of available reports        }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerReportsList;

{$I frx.inc}

interface

uses
  SysUtils, Classes, frxClass, frxServerTemplates;

type
  TfrxServerReportsListItem = class (TCollectionItem)
  private
    FFileName: String;
    FDescription: String;
    FName: String;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
  published
    property FileName: String read FFileName write FFileName;
    property ReportName: String read FName write FName;
    property Description: String read FDescription write FDescription;
  end;

  TfrxServerReportsList = class (TCollection)
  private
    FReportsPath: String;
    Report: TfrxReport;
    FHtml: String;
    FLines: TStrings;
    function GetItems(Index: Integer): TfrxServerReportsListItem;
    procedure BuildListInFolder(const Folder: String);
  public
    constructor Create;
    destructor Destroy; override;
    property Items[Index: Integer]: TfrxServerReportsListItem read GetItems;
    procedure BuildListOfReports;
  published
    function Add: TfrxServerReportsListItem;
    property ReportsPath: String read FReportsPath write FReportsPath;
    property Html: String read FHtml;
    property Lines: TStrings read FLines;
  end;

implementation

uses frxServerUtils, frxNetUtils, frxUtils;

{ TfrxServerReportsList }

function TfrxServerReportsList.Add: TfrxServerReportsListItem;
begin
  Result := TfrxServerReportsListItem.Create(Self);
end;

procedure TfrxServerReportsList.BuildListInFolder(const Folder: String);
var
  SRec: TSearchRec;
  i: Integer;
  s: String;
  List: TStringList;
  ListFolders: TStringList;
begin
  List := TStringList.Create;
  ListFolders := TStringList.Create;
  try
    i := FindFirst(FReportsPath + Folder + '*.*', faDirectory + faArchive, SRec);
    try
      while i = 0 do
      begin
        if (SRec.Name <> '.') and (SRec.Name <> '..') then
        begin
          if (LowerCase(ExtractFileExt(SRec.Name)) = '.fr3') then
            List.Add(Folder + SRec.Name)
          else
            if (SRec.Attr and faDirectory) = faDirectory then
              ListFolders.Add(SRec.Name);
        end;
        i := FindNext(SRec);
        PMessages;
      end;
    finally
      FindClose(SRec);
    end;
    ListFolders.Sort;
    for i := 0 to ListFolders.Count - 1 do
      BuildListInFolder(Folder + ListFolders[i] + '\');
    List.Sort;

    for i := 0 to List.Count - 1 do
    begin
      Report := TfrxReport.Create(nil);
      try
        Report.ReportOptions.Info := True;
        Report.ShowProgress :=False;
        Report.EngineOptions.SilentMode := True;
        try
          Report.LoadFromFile(FReportsPath + List[i]);
        except
        end;
        with Add do
        begin
          if Report.ReportOptions.Name = '' then
          begin
            s := ExtractFileName(List[i]);
            SetLength(s, Length(s) - 4);
            ReportName := s;
          end
          else
            ReportName := Report.ReportOptions.Name;
          Description := Report.ReportOptions.Description.Text;
          FileName := List[i];
        end;
      finally
        Report.Free;
      end;
      PMessages;
    end;
  finally
    List.Free;
    ListFolders.Free;
  end;
end;

procedure TfrxServerReportsList.BuildListOfReports;
var
  i: Integer;
  s, t: String;
  FTemplate: TfrxServerTemplate;
begin
  FTemplate := TfrxServerTemplate.Create;
  try
    Clear;
    FLines.Clear;
    if DirectoryExists(FReportsPath) then
      BuildListInFolder('');
    FTemplate.SetTemplate('list_begin');
    FTemplate.Prepare;
    FHtml := FTemplate.TemplateStrings.Text;
    FTemplate.Clear;
    s := '';
    t := '';
    for i := 0 to Count - 1 do
    begin
      if Pos('\', Items[i].FileName) > 0 then
      begin
        s := StringReplace(StringReplace(Items[i].FileName,
             ExtractFileName(Items[i].FileName), '',
             [rfReplaceAll]), '\', ' ', [rfReplaceAll]);
        if s <> t then
        begin
          FTemplate.SetTemplate('list_header');
          FTemplate.Variables.AddVariable('HEADER', s);
          FTemplate.Prepare;
          FHtml := FHtml + FTemplate.TemplateStrings.Text;
          FTemplate.Clear;
          t := s;
        end;
      end;
      FTemplate.SetTemplate('list_line');
      FTemplate.Variables.AddVariable('FILE', items[i].FileName);
      FTemplate.Variables.AddVariable('NAME', items[i].ReportName);
      FTemplate.Variables.AddVariable('DESCRIPTION', Items[i].Description);
      FTemplate.Prepare;
      FHtml := FHtml + FTemplate.TemplateStrings.Text;
      FTemplate.Clear;
      FLines.Add(items[i].ReportName);
      FLines.Add(items[i].FileName);
      FLines.Add(StringReplace(items[i].Description, #13#10, ' ', [rfReplaceAll]));
    end;
    FTemplate.SetTemplate('list_end');
    FTemplate.Prepare;
    FHtml := FHtml +  FTemplate.TemplateStrings.Text;
  finally
    FTemplate.Free;
  end;
end;

constructor TfrxServerReportsList.Create;
begin
  inherited Create(TfrxServerReportsListItem);
  ReportsPath := '';
  FLines := TStringList.Create;
end;

destructor TfrxServerReportsList.Destroy;
begin
  FLines.Free;
  Clear;
  inherited;
end;

function TfrxServerReportsList.GetItems(Index: Integer): TfrxServerReportsListItem;
begin
  Result := TfrxServerReportsListItem(inherited Items[Index]);
end;

{ TfrxServerReportsListItem }

constructor TfrxServerReportsListItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor TfrxServerReportsListItem.Destroy;
begin
  inherited;
end;

end.
