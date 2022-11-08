
{******************************************}
{                                          }
{             FastReport v4.0              }
{          Report Server engine            }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServerReports;

{$I frx.inc}

interface

uses
  Windows, SysUtils, Classes, frxClass, frxExportHTML, frxExportRTF, StdCtrls,
  frxExportText, frxExportCSV, frxExportPDF, frxExportXML, frxExportImage, frxVariables,
  frxXML, frxServerForms, frxServerCache, frxDCtrl, frxServerUtils, frxNetUtils,
  frxUnicodeUtils, frxServerLog, frxExportODF;

type
  TfrxReportSession = class(TThread)
  private
    FPath: String;
    FBasePath: String;
    FSessionId: String;
    FReportPath: String;
    FPageRange: String;
    FFormat: TfrxServerFormat;
    FMainDocument: String;
    FName: String;
    FVariables: TfrxVariables;
    FReportErrors: Boolean;
    FError: String;
    FResultPage: String;
    FReport: TfrxReport;
    FHTMLExport: TfrxHTMLExport;
    FXMLExport: TfrxXMLExport;
    FRTFExport: TfrxRTFExport;
    FTXTExport: TfrxSimpleTextExport;
    FJPGExport: TfrxJPEGExport;
    FBMPExport: TfrxBMPExport;
    FGIFExport: TfrxGIFExport;
    FTIFFExport: TfrxTIFFExport;
    FPDFExport: TfrxPDFExport;
    FCSVExport: TfrxCSVExport;
    FODSExport: TfrxODSExport;
    FODTExport: TfrxODTExport;
    FParentThread: TThread;
    CurPage: TfrxDialogPage;
    FParentReportServer: TComponent;
    FCached: Boolean;
    FNativeClient: Boolean;
    FStream: TMemoryStream;
    FCacheId: String;
    FPassword: String;
    FAuth: Boolean;
    FMessage: String;
    FPageNav: Boolean;
    FMultipage: Boolean;
    FUserLogin: String;
    procedure DoError;
    procedure DoFillForm;
    procedure DoSaveForm;
    procedure DoOnGetReport;
    procedure ShowReportDialog(Page: TfrxDialogPage);
    procedure DoAfterBuildReport;
    function ExtractReportName(const FileName: String): String;
  protected
    procedure Execute; override;
  public
    Active: Boolean;
    Continue: Boolean;
    DialogActive: Boolean;
    Readed: Boolean;
    constructor Create;
    destructor Destroy; override;

    property FileName: String read FName write FName;
    property Format: TfrxServerFormat read FFormat write FFormat;
    property IndexFileName: String read FMainDocument write FMainDocument;
    property PageRange: String read FPageRange write FPageRange;
    property ParentThread: TThread read FParentThread write FParentThread;
    property ReportPath: String read FReportPath write FReportPath;
    property ResultPage: String read FResultPage;
    property RootPath: String read FBasePath write FBasePath;
    property SessionId: String read FSessionId write FSessionId;
    property CacheId: String read FCacheId write FCacheId;
    property Variables: TfrxVariables read FVariables write FVariables;
    property ParentReportServer: TComponent read FParentReportServer write FParentReportServer;
    property NativeClient: Boolean read FNativeClient write FNativeClient;
    property Stream: TMemoryStream read FStream write FStream;
    property Password: String read FPassword write FPassword;
    property Auth: Boolean read FAuth;
    property ReportMessage: String read FMessage;

    property PageNav: Boolean read FPageNav write FPageNav;
    property Multipage: Boolean read FMultipage write FMultipage;
    property UserLogin: String read FUserLogin write FUserLogin;
  end;

implementation

uses frxServer, frxXMLSerializer, frxServerConfig;

{ TfrxReportSession }

constructor TfrxReportSession.Create;
begin
  inherited Create(True);
  Active := True;
  try
    FReport := TfrxReport.Create(nil);
    FReport.Engine.OnRunDialog := ShowReportDialog;
    FReport.EngineOptions.SilentMode := True;
    FReport.EngineOptions.EnableThreadSafe := True;
    FReport.EngineOptions.UseFileCache := ServerConfig.GetBool('server.reports.usefilecache');
    FReport.EngineOptions.MaxMemSize := StrToInt(ServerConfig.CheckValue('server.reports.maxmemsize', '10'));
    FReport.EngineOptions.TempDir := ServerConfig.CheckValue('server.reports.temp', '');
    FReport.ShowProgress := False;
  except
    FReport := nil;
    FError := 'TfrxReport create error';
    DoError;
  end;
end;

destructor TfrxReportSession.Destroy;
begin
  Terminate;
  while DialogActive do
  begin
    Sleep(10);
    PMessages;
  end;
  if Assigned(FReport) then
  try
    FReport.Free;
  except
    on e: Exception do
    begin
      FError := 'TfrxReport destroy error ' + e.Message;
      DoError;
    end;
  end;
  inherited;
end;

procedure TfrxReportSession.Execute;
var
  i: Integer;
  VName: String;
  VValue: Variant;
  s: String;
  FResPrep: Boolean;
begin
  LogWriter.StatAddCurrentReport;

  FResultPage := '';
  DialogActive := False;
  Readed := False;
  FCached := True;
  FAuth := False;

//  CoInitialize(nil);

  if Assigned(FReport) then
  begin
    FPath := FBasePath + FSessionId;
    try
      if Assigned(TfrxReportServer(FParentReportServer).OnGetReport) then
        Synchronize(DoOnGetReport)
      else
        if FileExists(FName) then
          try
            FReport.LoadFromFile(FName)
          except
          end
        else
        begin
          FError := 'Report not found: ' + FName;
          DoError;
        end;
    except
      FError := 'Report load error: ' + FName;
      DoError;
    end;
    if FReport.ReportOptions.Password <> '' then
      s := FPassword
    else
      s := '';
    if FReport.ReportOptions.Password = s then
    begin
      if Assigned(FVariables) then
      begin
        for i := 0 to FVariables.Count - 1 do
        begin
          VName := FVariables.Items[i].Name;
          VValue := TfrxVariable(FVariables.Items[i]).Value;
          VValue := '''' + StringReplace(UnQuoteStr(VValue), '''', '''''', [rfReplaceAll]) + '''';
          FReport.Variables[VName] := VValue;
        end;
      end;

      FReport.Variables['PathToDatabase'] :=
            '''' + frxGetAbsPathDir(ServerConfig.GetValue('server.database.pathtodatabase'), ServerConfig.ConfigFolder) + '''';
      FReport.ReportOptions.ConnectionName := ServerConfig.GetValue('server.database.connection');

      if not ReportCache.GetCachedStream(FReport, ExtractReportName(FName), FReport.Variables, FCacheId) then
      try
        FResPrep := False;
        try
          FResPrep := FReport.PrepareReport;
        except
        end;
        if FResPrep then
        begin
          if FCached then
            ReportCache.AddReport(FReport, ExtractReportName(FName), FReport.Variables, '')
          else
            ReportCache.AddReport(FReport, ExtractReportName(FName), FReport.Variables, FSessionId);
        end
        else begin
          FError := 'Report prepare error: ' + FReport.Errors.Text;
          DoError;
        end;
      except
        on e: Exception do
        begin
          FError := 'Report prepare exception: ' + FReport.Errors.Text + e.Message;
          DoError;
        end;
      end;

      if Assigned(TfrxReportServer(FParentReportServer).OnAfterBuildReport) then
        Synchronize(DoAfterBuildReport);

      if (not FReportErrors) and (not DialogActive) and (not Terminated) then
        if (FFormat = sfXML) and (ServerConfig.GetBool('server.exports.xml.active')) then
        begin
          FXMLExport := TfrxXMLExport.Create(nil);
          try
            FXMLExport.ShowDialog := False;
            FXMLExport.ShowProgress := False;
            FXMLExport.PageNumbers := FPageRange;
            FXMLExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FXMLExport.SuppressPageHeadersFooters := ServerConfig.GetBool('server.exports.xml.continuous');
            FXMLExport.EmptyLines := ServerConfig.GetBool('server.exports.xml.emptylines');
            FXMLExport.ExportPageBreaks := ServerConfig.GetBool('server.exports.xml.pagebreaks');
            FXMLExport.ExportStyles := ServerConfig.GetBool('server.exports.xml.styles');
            FXMLExport.Wysiwyg := ServerConfig.GetBool('server.exports.xml.wysiwyg');
            FXMLExport.Background := ServerConfig.GetBool('server.exports.xml.background');
            FResultPage := '\' + 'result.xml';
            FXMLExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FXMLExport);
            except
              FError := 'XML export error';
              DoError;
            end;
          finally
            FXMLExport.Free;
          end
        end else if (FFormat = sfXLS) and (ServerConfig.GetBool('server.exports.xml.active')) then
        begin
          FXMLExport := TfrxXMLExport.Create(nil);
          try
            FXMLExport.ShowDialog := False;
            FXMLExport.ShowProgress := False;
            FXMLExport.PageNumbers := FPageRange;
            FXMLExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FXMLExport.SuppressPageHeadersFooters := ServerConfig.GetBool('server.exports.xml.continuous');
            FXMLExport.EmptyLines := ServerConfig.GetBool('server.exports.xml.emptylines');
            FXMLExport.ExportPageBreaks := ServerConfig.GetBool('server.exports.xml.pagebreaks');
            FXMLExport.ExportStyles := ServerConfig.GetBool('server.exports.xml.styles');
            FXMLExport.Wysiwyg := ServerConfig.GetBool('server.exports.xml.wysiwyg');
            FXMLExport.Background := ServerConfig.GetBool('server.exports.xml.background');
            FResultPage := '\' + 'result.xls';
            FXMLExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FXMLExport);
            except
              FError := 'XLS export error';
              DoError;
            end;
          finally
            FXMLExport.Free;
          end
//
        end else if (FFormat = sfODS) and (ServerConfig.GetBool('server.exports.ods.active')) then
        begin
          FODSExport := TfrxODSExport.Create(nil);
          try
            FODSExport.ShowDialog := False;
            FODSExport.ShowProgress := False;
            FODSExport.PageNumbers := FPageRange;
            FODSExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FODSExport.SuppressPageHeadersFooters := ServerConfig.GetBool('server.exports.ods.continuous');
            FODSExport.EmptyLines := ServerConfig.GetBool('server.exports.ods.emptylines');
            FODSExport.ExportPageBreaks := ServerConfig.GetBool('server.exports.ods.pagebreaks');
            FODSExport.Wysiwyg := ServerConfig.GetBool('server.exports.ods.wysiwyg');
            FODSExport.Background := ServerConfig.GetBool('server.exports.ods.background');
            FResultPage := '\' + 'result.ods';
            FODSExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FODSExport);
            except
              FError := 'ODS export error';
              DoError;
            end;
          finally
            FODSExport.Free;
          end
        end else if (FFormat = sfODT) and (ServerConfig.GetBool('server.exports.odt.active')) then
        begin
          FODTExport := TfrxODTExport.Create(nil);
          try
            FODTExport.ShowDialog := False;
            FODTExport.ShowProgress := False;
            FODTExport.PageNumbers := FPageRange;
            FODTExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FODTExport.SuppressPageHeadersFooters := ServerConfig.GetBool('server.exports.odt.continuous');
            FODTExport.EmptyLines := ServerConfig.GetBool('server.exports.odt.emptylines');
            FODTExport.ExportPageBreaks := ServerConfig.GetBool('server.exports.odt.pagebreaks');
            FODTExport.Wysiwyg := ServerConfig.GetBool('server.exports.odt.wysiwyg');
            FODTExport.Background := ServerConfig.GetBool('server.exports.odt.background');
            FResultPage := '\' + 'result.odt';
            FODTExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FODTExport);
            except
              FError := 'ODT export error';
              DoError;
            end;
          finally
            FODTExport.Free;
          end
//
        end else if (FFormat = sfRTF) and (ServerConfig.GetBool('server.exports.rtf.active')) then
        begin
          FRTFExport := TfrxRTFExport.Create(nil);
          try
            FRTFExport.ShowDialog := False;
            FRTFExport.ShowProgress := False;
            FRTFExport.PageNumbers := FPageRange;
            FRTFExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FRTFExport.ExportPageBreaks := ServerConfig.GetBool('server.exports.rtf.pagebreaks');
            FRTFExport.ExportPictures := ServerConfig.GetBool('server.exports.rtf.pictures');
            FRTFExport.Wysiwyg := ServerConfig.GetBool('server.exports.rtf.wysiwyg');
            FResultPage := '\' + 'result.rtf';
            FRTFExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FRTFExport);
            except
              FError := 'RTF export error';
              DoError;
            end;
          finally
            FRTFExport.Free;
          end
        end else if (FFormat = sfCSV) and (ServerConfig.GetBool('server.exports.csv.active')) then
        begin
          FCSVExport := TfrxCSVExport.Create(nil);
          try
            FCSVExport.ShowDialog := False;
            FCSVExport.ShowProgress := False;
            FCSVExport.PageNumbers := FPageRange;
            FCSVExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FCSVExport.OEMCodepage := ServerConfig.GetBool('server.exports.csv.oemcodepage');
            FCSVExport.Separator := ServerConfig.CheckValue('server.exports.csv.separator', ';');
            FResultPage := '\' + 'result.csv';
            FCSVExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FCSVExport);
            except
              FError := 'CSV export error';
              DoError;
            end;
          finally
            FCSVExport.Free;
          end
        end else if (FFormat = sfTXT) and (ServerConfig.GetBool('server.exports.txt.active'))  then
        begin
          FTXTExport := TfrxSimpleTextExport.Create(nil);
          try
            FTXTExport.ShowDialog := False;
            FTXTExport.ShowProgress := False;
            FTXTExport.PageNumbers := FPageRange;
            FTXTExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FTXTExport.PageBreaks := ServerConfig.GetBool('server.exports.txt.pagebreaks');
            FTXTExport.OEMCodepage := ServerConfig.GetBool('server.exports.txt.oemcodepage');
            FResultPage := '\' + 'result.txt';
            FTXTExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FTXTExport);
            except
              FError := 'TXT export error';
              DoError;
            end;
          finally
            FTXTExport.Free;
          end
        end else if (FFormat = sfJPG) and (ServerConfig.GetBool('server.exports.jpg.active')) then
        begin
          FJPGExport := TfrxJPEGExport.Create(nil);
          try
            FJPGExport.ShowDialog := False;
            FJPGExport.PageNumbers := FPageRange;
            FJPGExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FJPGExport.CropImages := ServerConfig.GetBool('server.exports.jpg.crop');
            FJPGExport.Monochrome := ServerConfig.GetBool('server.exports.jpg.monochrome');
            FJPGExport.JPEGQuality := StrToInt(ServerConfig.CheckValue('server.exports.jpg.quality', '80'));
            FJPGExport.Resolution := StrToInt(ServerConfig.CheckValue('server.exports.jpg.resolution', '72'));
            FJPGExport.SeparateFiles := not ServerConfig.GetBool('server.exports.jpg.singlefile');
            FResultPage := '\' + 'result.jpg';
            FJPGExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FJPGExport);
            except
              FError := 'JPG export error';
              DoError;
            end;
            FResultPage := '\' + 'result.1.jpg';
          finally
            FJPGExport.Free;
          end
        end else if (FFormat = sfBMP) and (ServerConfig.GetBool('server.exports.bmp.active')) then
        begin
          FBMPExport := TfrxBMPExport.Create(nil);
          try
            FBMPExport.ShowDialog := False;
            FBMPExport.PageNumbers := FPageRange;
            FBMPExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FBMPExport.CropImages := ServerConfig.GetBool('server.exports.bmp.crop');
            FBMPExport.Monochrome := ServerConfig.GetBool('server.exports.bmp.monochrome');
            FBMPExport.Resolution := StrToInt(ServerConfig.CheckValue('server.exports.bmp.resolution', '72'));
            FBMPExport.SeparateFiles := not ServerConfig.GetBool('server.exports.bmp.singlefile');
            FResultPage := '\' + 'result.bmp';
            FBMPExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FBMPExport);
            except
              FError := 'BMP export error';
              DoError;
            end;
            FResultPage := '\' + 'result.1.bmp';
          finally
            FBMPExport.Free;
          end
        end else if (FFormat = sfGIF) and (ServerConfig.GetBool('server.exports.gif.active')) then
        begin
          FGIFExport := TfrxGIFExport.Create(nil);
          try
            FGIFExport.ShowDialog := False;
            FGIFExport.PageNumbers := FPageRange;
            FGIFExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FGIFExport.CropImages := ServerConfig.GetBool('server.exports.gif.crop');
            FGIFExport.Resolution := StrToInt(ServerConfig.CheckValue('server.exports.gif.resolution', '72'));
            FGIFExport.SeparateFiles := not ServerConfig.GetBool('server.exports.gif.singlefile');
            FResultPage := '\' + 'result.gif';
            FGIFExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FGIFExport);
            except
              FError := 'GIF export error';
              DoError;
            end;
            FResultPage := '\' + 'result.1.gif';
          finally
            FGIFExport.Free;
          end
        end else if (FFormat = sfTIFF) and (ServerConfig.GetBool('server.exports.tiff.active')) then
        begin
          FTIFFExport := TfrxTIFFExport.Create(nil);
          try
            FTIFFExport.ShowDialog := False;
            FTIFFExport.PageNumbers := FPageRange;
            FTIFFExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FTIFFExport.CropImages := ServerConfig.GetBool('server.exports.tiff.crop');
            FTIFFExport.Monochrome := ServerConfig.GetBool('server.exports.tiff.monochrome');
            FTIFFExport.Resolution := StrToInt(ServerConfig.CheckValue('server.exports.tiff.resolution', '72'));
            FTIFFExport.SeparateFiles := not ServerConfig.GetBool('server.exports.tiff.singlefile');
            FResultPage := '\' + 'result.tif';
            FTIFFExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FTIFFExport);
            except
              FError := 'TIFF export error';
              DoError;
            end;
            FResultPage := '\' + 'result.1.tif';
          finally
            FTIFFExport.Free;
          end
        end else if (FFormat = sfPDF) and (ServerConfig.GetBool('server.exports.pdf.active')) then
        begin
          FPDFExport := TfrxPDFExport.Create(nil);
          try
            FPDFExport.ShowDialog := False;
            FPDFExport.PageNumbers := FPageRange;
            FPDFExport.EmbeddedFonts := ServerConfig.GetBool('server.exports.pdf.embeddedfonts');
            FResultPage := '\' + 'result.pdf';
            FPDFExport.FileName := FPath + FResultPage;
            FPDFExport.Background := ServerConfig.GetBool('server.exports.pdf.background');
            FPDFExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FPDFExport.Outline := ServerConfig.GetBool('server.exports.pdf.outline') and FReport.PreviewOptions.OutlineVisible;
            FPDFExport.HTMLTags := ServerConfig.GetBool('server.exports.pdf.htmltags');
            FPDFExport.PrintOptimized := ServerConfig.GetBool('server.exports.pdf.printoptimized');
            try
              FReport.Export(FPDFExport);
            except
              FError := 'PDF export error';
              DoError;
            end;
          finally
            FPDFExport.Free;
          end
        end else if (FFormat = sfFRP) and (ServerConfig.GetBool('server.exports.fp3.active')) then
        begin
          FResultPage := '\' + 'result.fp3';
          try
            FReport.PreviewPages.SaveToFile(FPath + FResultPage);
          except
            FError := 'FP3 save error ' + FReport.Errors.Text;
            DoError;
          end
        end else
        if (ServerConfig.GetBool('server.exports.html.active')) then
        begin
          FHTMLExport := TfrxHTMLExport.Create(nil);
          try
            FHTMLExport.ShowDialog := False;
            FHTMLExport.ShowProgress := False;
            FHTMLExport.AbsLinks := True;
            FHTMLExport.Server := True;
            FHTMLExport.PageNumbers := FPageRange;
            FHTMLExport.FixedWidth := ServerConfig.GetBool('server.exports.html.fixedwidth');
            FHTMLExport.PicsInSameFolder := ServerConfig.GetBool('server.exports.html.allinonefolder');
            FHTMLExport.Multipage := FMultipage;
            FHTMLExport.Navigator := FPageNav;
            s := ServerConfig.GetValue('server.exports.html.picsformat');
            FHTMLExport.UseJpeg := s = 'jpeg';
            FHTMLExport.UseGif := s = 'gif';
            FHTMLExport.ExportPictures := ServerConfig.GetBool('server.exports.html.pictures');
            FHTMLExport.ExportStyles := ServerConfig.GetBool('server.exports.html.styles');
            FHTMLExport.Background := ServerConfig.GetBool('server.exports.html.background');
            FHTMLExport.UseFileCache := FReport.EngineOptions.UseFileCache;
            FHTMLExport.ReportPath := frxGetAbsPathDir(ServerConfig.GetValue('server.reports.path'), ServerConfig.ConfigFolder);
            if Assigned(FParentReportServer) then
              if TfrxReportServer(FParentReportServer).PrintPDF then
                FHTMLExport.PrintLink := 'result?report=' + Str2HTML(ExtractReportName(FName)) +
                  '&format=PDF&pagerange=' + FPageRange +
                  '&cacheid=' + FSessionId;

            FHTMLExport.RefreshLink := 'result?report=' + Str2HTML(ExtractReportName(FName)) + '&multipage=' + IntToStr(ord(FHTMLExport.Multipage));

            if Assigned(FVariables) then
            begin
              for i := 0 to FVariables.Count - 1 do
                FHTMLExport.PrintLink := FHTMLExport.PrintLink + '&' +
                  UnQuoteStr(Str2HTML(FVariables.Items[i].Name)) + '=' +
                  UnQuoteStr(Str2HTML(FVariables.Items[i].Value));
              for i := 0 to FVariables.Count - 1 do
                FHTMLExport.RefreshLink := FHTMLExport.RefreshLink + '&' +
                  UnQuoteStr(Str2HTML(FVariables.Items[i].Name)) + '=' +
                  UnQuoteStr(Str2HTML(FVariables.Items[i].Value));
            end;

            s := ServerConfig.GetValue('server.http.indexfile');
            FResultPage := '\' + s;
            FHTMLExport.FileName := FPath + FResultPage;
            try
              FReport.Export(FHTMLExport);
              if (not FHTMLExport.Navigator) and FHTMLExport.Multipage then
                FResultPage := '\' + ChangeFileExt(s, '.1.html')
            except
              FError := 'HTML export error';
              DoError;
            end;
          finally
            FHTMLExport.Free;
          end
        end;
    end
    else
    begin
      FAuth := True;
      FReport.Errors.Add('Authentification required')
    end;
  end;
  FMessage := FReport.Errors.Text;
  Active := False;
  LogWriter.StatRemoveCurrentReport;
  Sleep(3000);
end;

procedure TfrxReportSession.DoError;
begin
  FReportErrors := True;
  LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + FSessionId + #9'report session error: ' + FError);
  LogWriter.ErrorReached;
end;

procedure TfrxReportSession.ShowReportDialog(Page: TfrxDialogPage);
begin
  CurPage := Page;
  FCached := False;
  DoSaveForm;
  Continue := False;
  DialogActive := True;
  FReport.DoNotifyEvent(Page, Page.OnActivate);
  while (not Continue) and (not Terminated) do
    PMessages;
  DoFillForm;
  DialogActive := False;
  FReport.DoNotifyEvent(Page, Page.OnDeactivate);
  while (not Readed) and (not Terminated) do
    PMessages;
  Sleep(300);
end;

procedure TfrxReportSession.DoFillForm;
var
  i, j: Integer;
  Control: TfrxDialogControl;
  s: String;
  Reader: TfrxXMLSerializer;
begin
  if FNativeClient and (FStream.Size > 0) then
  begin
    FStream.Position := 0;
    Reader := TfrxXMLSerializer.Create(FStream);
    try
      Reader.Owner := FReport;
      try
        Reader.ReadRootComponent(CurPage, nil);
      except
      end;
    finally
      Reader.Free;
    end
  end
  else if (not Terminated) and Assigned(FVariables) then
  begin
    for i := 0 to CurPage.AllObjects.Count - 1 do
    begin
       Control := TfrxDialogControl(CurPage.AllObjects[i]);
       if Control.Parent <> nil then
         s := Control.Parent.Name + '_' + Control.Name
       else
         s:= Control.Name;
       j := FVariables.IndexOf(s);
       if (j = -1) and (Control.Parent <> nil) and (Pos('_', s) > 0) then
         j := FVariables.IndexOf(Control.Parent.Name);
       if j <> -1 then
       begin
         s := FVariables.Items[j].Value;
         s := UnQuoteStr(s);
         if Control is TfrxEditControl then
           TfrxEditControl(Control).Text := s;
         if Control is TfrxDateEditControl then
           TfrxDateEditControl(Control).Date := StrToDate(s);
         if (Control is TfrxCheckBoxControl) then
         begin
           if (Pos(Control.Name, s) > 0) then
             TfrxCheckBoxControl(Control).Checked := True
           else
             TfrxCheckBoxControl(Control).Checked := False;
         end;
         if (Control is TfrxRadioButtonControl) then
         begin
           if (Pos(Control.Name, s) > 0) then
             TfrxRadioButtonControl(Control).Checked := True
           else
             TfrxRadioButtonControl(Control).Checked := False;
         end;
         if Control is TfrxMemoControl then
           TfrxMemoControl(Control).Text := s;
         if Control is TfrxComboBoxControl then
           TfrxComboBoxControl(Control).ItemIndex := StrToInt(s);
       end else
       begin
         if Control is TfrxCheckBoxControl then
           TfrxCheckBoxControl(Control).Checked := False;
         if Control is TfrxRadioButtonControl then
           TfrxRadioButtonControl(Control).Checked := False;
       end;
    end;
  end;
end;

procedure TfrxReportSession.DoSaveForm;
var
  WebForm: TfrxWebForm;
  f: TFileStream;
begin
  if not FNativeClient then
  begin
    WebForm := TfrxWebForm.Create(CurPage, FSessionId);
    try
      WebForm.ReportName := ExtractReportName(FReport.FileName);
      WebForm.Prepare;
      FResultPage := '\' + 'form.html';
      WebForm.SaveFormToFile(FPath + FResultPage);
    finally
      WebForm.Free;
    end;
  end
  else begin
    FResultPage := '\' + 'result.frm';
    f := TFileStream.Create(FPath + FResultPage, fmCreate);
    try
      CurPage.SaveToStream(f);
    finally
      FlushFileBuffers(f.Handle);
      f.Free;
    end;
  end;
end;

procedure TfrxReportSession.DoOnGetReport;
begin
  TfrxReportServer(FParentReportServer).OnGetReport(ExtractReportName(FName), FReport, FUserLogin);
end;

procedure TfrxReportSession.DoAfterBuildReport;
begin
  TfrxReportServer(ParentReportServer).OnAfterBuildReport(FName, FVariables, FUserLogin);
end;

function TfrxReportSession.ExtractReportName(const FileName: String): String;
begin
  Result := StringReplace(FileName, frxGetAbsPathDir(ServerConfig.GetValue('server.reports.path'), ServerConfig.ConfigFolder), '', [])
end;

end.
