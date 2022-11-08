
{******************************************}
{                                          }
{             FastReport v4.0              }
{            HTTP Report Server            }
{                                          }
{         Copyright (c) 1998-2007          }
{          by Alexander Fediachov,         }
{             Fast Reports Inc.            }
{                                          }
{******************************************}

unit frxServer;

{$I frx.inc}

interface

uses
  Forms, Windows, Classes, frxClass, ScktComp, Registry,
  WinSock, frxVariables, frxGZip, frxServerLog,
  frxServerSessionManager, frxServerStat, frxServerReports,
  frxServerVariables, frxServerSSI, frxServerUtils, frxNetUtils, frxMD5,
  frxServerCache, frxServerReportsList, frxUnicodeUtils, frxUsers

  , SysUtils, frxServerConfig, frxServerTemplates;

type
  TfrxHTTPServer = class;
  TfrxServerSession = class;
  TfrxServerData = class;
  TfrxServerGuard = class;
  TfrxServerGetReportEvent = procedure(const ReportName: String;
    Report: TfrxReport; User: String = '') of object;
  TfrxServerGetVariablesEvent = procedure(const ReportName: String;
    Variables: TfrxVariables; User: String = '') of object;
  TfrxServerAfterBuildReport = procedure(const ReportName: String;
    Variables: TfrxVariables; User: String = '') of object;

  TfrxReportServer = class(TComponent)
  private
    FActive: Boolean;
    FAllow: TStrings;
    FConfig: TfrxServerConfig; // obsolete
    FDeny: TStrings;
    FGetReport: TfrxServerGetReportEvent;
    FPDFPrint: Boolean;
    FTotals: TStrings;
    FVariables: TfrxServerVariables;
    FWebServer: TfrxHTTPServer;
    FGetVariables: TfrxServerGetVariablesEvent;
    FBuildReport: TfrxServerAfterBuildReport;
    FReportList: TfrxServerReportsList;

    FConfigFileName: String;
    FGuard: TfrxServerGuard;
    function GetTotals: TStrings;
    procedure SetActive(const Value: Boolean);
    procedure SetConfig(const Value: TfrxServerConfig);
    procedure StatToVar;
//    procedure IdleEventHandler(Sender: TObject; var Done: Boolean);
    procedure Initialize;
  public
    constructor Create(AOwner: TComponent); override;

    destructor Destroy; override;
    procedure Open;
    procedure Close;

    procedure LoadConfigs;
    property Totals: TStrings read GetTotals;
    property Variables: TfrxServerVariables read FVariables;
    property ReportsList: TfrxServerReportsList read FReportList;
  published
    property Configuration: TfrxServerConfig read FConfig write SetConfig; // obsolete
    property Active: Boolean read FActive write SetActive;
    property AllowIP: TStrings read FAllow write FAllow;
    property DenyIP: TStrings read FDeny write FDeny;
    property PrintPDF: Boolean read FPDFPrint write FPDFPrint;
    property OnGetReport: TfrxServerGetReportEvent read FGetReport
      write FGetReport;
    property OnGetVariables: TfrxServerGetVariablesEvent read FGetVariables
      write FGetVariables;
    property OnAfterBuildReport: TfrxServerAfterBuildReport read FBuildReport
      write FBuildReport;

    property WebServer: TfrxHTTPServer read FWebServer;
  end;

  TfrxHTTPServer = class(TServerSocket)
  private
    FBasePath: String;
    FGzip: Boolean;
    FMainDocument: String;
    FNoCacheHeader: Boolean;
    FParentReportServer: TfrxReportServer;
    FReportPath: String;
    FSocketTimeOut: Integer;
    procedure ClientAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket;
         ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
         var SocketThread: TServerClientThread);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property BasePath: String read FBasePath write FBasePath;
    property Gzip: Boolean read FGzip write FGzip;
    property MainDocument: String read FMainDocument write FMainDocument;
    property NoCacheHeader: Boolean read FNoCacheHeader write FNoCacheHeader;
    property ParentReportServer: TfrxReportServer read FParentReportServer
      write FParentReportServer;
    property ReportPath: String read FReportPath write FReportPath;
    property SocketTimeOut: Integer read FSocketTimeOut write FSocketTimeOut;
  end;

  TfrxServerSession = class(TServerClientThread)
  private
    FAuthNeeded: Boolean;
    FDialog: Boolean;
    FDialogSessionId: String;
    FErrorCode: Integer;
    FErrorText: String;
    FFormat: TfrxServerFormat;
    FGzip: Boolean;
    FHeader: String;
    FHost: String;
    FHTTPVersion: String;
    FIsReport: Boolean;
    FKeepAlive: boolean;
    FMethod: AnsiString;
    FMIMEType: String;
    FMultipage: Boolean;
    FName: String;
    FNoCacheHeader: Boolean;
    FPageNavigator: Boolean;
    FPageRange: String;
    FParentHTTPServer: TfrxHTTPServer;
    FParentReportServer: TfrxReportServer;
    FRedirect: Boolean;
    FReferer: String;
    FRemoteIP: String;
    FReplyBody: TStringList;
    FReplyHeader: TStringList;
    FRepSession: TfrxReportSession;
    FResultPage: String;
    FServerReplyData: TStringList;
    FSessionId: String;
    FSessionItem: TfrxSessionItem;
    FSize: integer;
    FUserAgent: String;
    FVariables: TfrxVariables;
    FStream: TMemoryStream;
    FFileDate: TDateTime;
    FCacheId: String;
    FLogin: String;
    FPassword: String;
    FReportMessage: String;
    FReturnData: String;
    FInParams: TStringList;
    FOutParams: TStringList;
    FData: TfrxServerData;
    FActive: Boolean;

    function CheckBadPath: Boolean;
    function CheckDeflate(FileName: String): Boolean;
    function CheckSSI(FileName: String): Boolean;
    function ParseHeaderField(Field: String): String;
    function ParseParam(S: String): String;
    procedure CheckAuth;
    procedure CloseSession;
    procedure CreateReplyHTTPData;
    procedure ErrorLog;
    procedure GetFileMIMEType;
    procedure MakeServerReply;
    procedure ParseHTTPHeader;
    procedure UpdateSessionFName;
    procedure WriteLogs;
    procedure DoGetVariables;
    procedure AddOutData(const Name: String; const Value: String);
  public
    constructor Create(CreateSuspended: Boolean;
      ASocket: TServerClientWinSocket);
    destructor Destroy; override;
    procedure ClientExecute; override;
    procedure PrepareReportQuery;

    property NoCacheHeader: Boolean read FNoCacheHeader write FNoCacheHeader;
    property ParentHTTPServer: TfrxHTTPServer read FParentHTTPServer
      write FParentHTTPServer;
    property ParentReportServer: TfrxReportServer read FParentReportServer
      write FParentReportServer;
    property SessionId: String read FSessionId write FSessionId;
    property SessionItem: TfrxSessionItem read FSessionItem write FSessionItem;
    property Login: String read FLogin;
    property Password: String read FPassword;
    property Data: TfrxServerData read FData write FData;
    property Active: Boolean read FActive write FActive;
  end;

  TfrxServerData = class(TObject)
  private
    FErrorCode: Integer;
    FInParams: TStringList;
    FOutParams: TStringList;
    FStream: TMemoryStream;
    FFileName: String;
    FHeader: String;
    FRepHeader: String;
    FHTTPVer: String;
    FLastMod: TDateTime;
    FExpires: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TfrxServerData);

    property InParams: TStringList read FInParams;
    property OutParams: TStringList read FOutParams;
    property ErrorCode: Integer read FErrorCode write FErrorCode;
    property Stream: TMemoryStream read FStream;
    property FileName: String read FFileName write FFileName;
    property Header: String read FHeader write FHeader;
    property RepHeader: String read FRepHeader write FRepHeader;
    property HTTPVer: String read FHTTPVer write FHTTPVer;
    property Expires: TDateTime read FExpires write FExpires;
    property LastMod: TDateTime read FLastMod write FLastMod;
  end;

  TfrxServerGuard = class(TThread)
  private
    FTimeOut: Integer;
    FServer: TfrxReportServer;
    FListTimeOut: Integer;
    procedure DoLoadConf;
  protected
    procedure Execute; override;
  public
    constructor Create(Server: TfrxReportServer);
    destructor Destroy; override;

    property TimeOut: Integer read FTimeOut write FTimeOut;
    property ListTimeOut: Integer read FListTimeOut write FListTimeOut;
  end;

const
  MAX_IE_GZIP = 4096;
  SERVER_NAME = 'FastReport Server';
  SERVER_VERSION = {$I frxServerVersion.inc};
  SERVER_DATA = '';
  SID_SIGN = 'sid_f';



implementation

uses frxUtils, frxFileUtils, SyncObjs;

const
  SERVER_COPY = '&copy; Copyright 1998-2007 by Fast Reports Inc.';
  METHOD_GET = 'GET';
  HTML = 'text/html';
  ERR_UNKNOWN_METHOD = '1';
  ERR_OK = '0';



{ TfrxReportServer }

procedure TfrxReportServer.LoadConfigs;
begin
  ServerConfig.LoadFromFile(FConfigFileName);
  ServerUsers.LoadFromFile(frxGetAbsPathDir(ServerConfig.GetValue('server.security.usersfile'), ServerConfig.ConfigFolder));
end;

procedure TfrxReportServer.Initialize;
var
  s: String;
begin
  LogWriter := TfrxServerLog.Create;
  FConfig := TfrxServerConfig.Create; // obsolete
  FConfigFileName :=  ServerConfig.ConfigFolder  + 'config.xml';

  LoadConfigs;

  LogWriter.MaxLogSize := StrToInt(ServerConfig.GetValue('server.logs.rotatesize'));
  LogWriter.MaxLogFiles := StrToInt(ServerConfig.GetValue('server.logs.rotatefiles'));
  LogWriter.LogDir := frxGetAbsPathDir(ServerConfig.GetValue('server.logs.path'), ServerConfig.ConfigFolder);
  LogWriter.AddLevel(ServerConfig.GetValue('server.logs.errorlog'));
  LogWriter.AddLevel(ServerConfig.GetValue('server.logs.accesslog'));
  LogWriter.AddLevel(ServerConfig.GetValue('server.logs.refererlog'));
  LogWriter.AddLevel(ServerConfig.GetValue('server.logs.agentlog'));
  LogWriter.AddLevel(ServerConfig.GetValue('server.logs.serverlog'));



  FAllow := TStringList.Create;
  FDeny := TStringList.Create;

  s := frxGetAbsPathDir(ServerConfig.GetValue('server.security.allowfile'), ServerConfig.ConfigFolder);
  if FileExists(s) then
    FAllow.LoadFromFile(s);
  s := frxGetAbsPathDir(ServerConfig.GetValue('server.security.denyfile'), ServerConfig.ConfigFolder);
  if FileExists(s) then
    FDeny.LoadFromFile(s);

  FTotals := TStringList.Create;
  LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'Started');
  LogWriter.Write(SERVER_LEVEL, 'Logs path:' + #9 + frxGetAbsPathDir(ServerConfig.GetValue('server.logs.path'), ServerConfig.ConfigFolder));
  LogWriter.Write(SERVER_LEVEL, 'Reports path:' + #9 + frxGetAbsPathDir(ServerConfig.GetValue('server.reports.path'), ServerConfig.ConfigFolder));
  LogWriter.Write(SERVER_LEVEL, 'Reports cache path:' + #9 + frxGetAbsPathDir(ServerConfig.GetValue('server.cache.path'), ServerConfig.ConfigFolder));
  LogWriter.Write(SERVER_LEVEL, 'Root path:' + #9 + frxGetAbsPathDir(ServerConfig.GetValue('server.http.rootpath'), ServerConfig.ConfigFolder));
  if FileExists(FConfigFileName) then
    LogWriter.Write(SERVER_LEVEL, 'Config file:' + #9 + FConfigFileName)
  else
    LogWriter.Write(SERVER_LEVEL, 'ERROR! Config file ' + FConfigFileName + ' not found!');

  SessionManager := TfrxSessionManager.Create;
  FWebServer := TfrxHTTPServer.Create(nil);
  FWebServer.ParentReportServer := Self;
  ReportCache := TfrxServerCache.Create;
  ServerStatistic := TfrxServerStatistic.Create;
  FVariables := TfrxServerVariables.Create;

  ServerUsers.LoadFromFile(ServerConfig.GetValue('server.security.usersfile'));


  FVariables.AddVariable('SERVER_NAME', ServerConfig.GetValue('server.name'));


  FVariables.AddVariable('SERVER_COPYRIGHT', SERVER_COPY);
  FVariables.AddVariable('SERVER_SOFTWARE', SERVER_VERSION);
  FVariables.AddVariable('SERVER_LAST_UPDATE', SERVER_DATA);

  FPDFPrint := True;
  Active := False;

  ReportCache.Clear;
  FReportList := TfrxServerReportsList.Create;


  LogWriter.Active := ServerConfig.GetBool('server.logs.active');

  FGuard := TfrxServerGuard.Create(Self);
end;



constructor TfrxReportServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ServerConfig.ConfigFolder := GetAppPath;

  Initialize;
end;

destructor TfrxReportServer.Destroy;
begin
  FGuard.Free;

  FReportList.Free;
  ReportCache.Free;
  FAllow.Free;
  FDeny.Free;
  FWebServer.Free;
  LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'Stopped'#9 + #13#10 + Totals.Text);
  LogWriter.Flush;
  if Active then
    Active := False;
  ServerStatistic.Free;
  SessionManager.Free;
  FConfig.Free;
  FTotals.Free;
  FVariables.Free;
  LogWriter.Free;
  PMessages;
  inherited;
end;

procedure TfrxReportServer.SetActive(const Value: Boolean);
begin

    try
      FWebServer.Active := Value;
    except
      if Value then
        LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'Port open failed. ' + #13#10)
      else
        LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'Port close failed. ' + #13#10)
    end;

  if FWebServer.Active = Value then
    FActive := Value;
//  if Value and LogWriter.Suspended then
//    LogWriter.Resume;
end;

procedure TfrxReportServer.Open;
begin
  if ServerConfig.GetBool('server.security.reportslist') then
  begin
    FReportList.ReportsPath := frxGetAbsPathDir(ServerConfig.GetValue('server.reports.path'), ServerConfig.ConfigFolder);
    FReportList.BuildListOfReports;
    FVariables.AddVariable('SERVER_REPORTS_LIST', FReportList.Lines.Text);
    FVariables.AddVariable('SERVER_REPORTS_HTML', FReportList.Html);
  end;
  Active := True;
end;

procedure TfrxReportServer.Close;
begin
  Active := False;
  ReportCache.Clear;
end;

procedure TfrxReportServer.SetConfig(const Value: TfrxServerConfig);
begin
  FConfig.Assign(Value);
end;

function TfrxReportServer.GetTotals: TStrings;
begin
  FTotals.Clear;
  FTotals.Add('Uptime: ' + ServerStatistic.FormatUpTime);
  FTotals.Add('Total sessions: ' + IntToStr(ServerStatistic.TotalSessionsCount));
  FTotals.Add('Total reports: ' + IntToStr(ServerStatistic.TotalReportsCount));
  FTotals.Add('Total cache hits: ' + IntToStr(ServerStatistic.TotalCacheHits));
  FTotals.Add('Total errors: ' + IntToStr(ServerStatistic.TotalErrors));
  FTotals.Add('Max sessions: ' + IntToStr(ServerStatistic.MaxSessionsCount));
  FTotals.Add('Max reports: ' + IntToStr(ServerStatistic.MaxReportsCount));
  Result := FTotals;
end;

procedure TfrxReportServer.StatToVar;
begin
  FVariables.AddVariable('SERVER_UPTIME', ServerStatistic.FormatUpTime);
  FVariables.AddVariable('SERVER_TOTAL_SESSIONS', IntToStr(ServerStatistic.TotalSessionsCount));
  FVariables.AddVariable('SERVER_TOTAL_REPORTS', IntToStr(ServerStatistic.TotalReportsCount));
  FVariables.AddVariable('SERVER_TOTAL_ERRORS', IntToStr(ServerStatistic.TotalErrors));
  FVariables.AddVariable('SERVER_TOTAL_CACHE', IntToStr(ServerStatistic.TotalCacheHits));
  FVariables.AddVariable('SERVER_MAX_SESSIONS', IntToStr(ServerStatistic.MaxSessionsCount));
  FVariables.AddVariable('SERVER_MAX_REPORTS', IntToStr(ServerStatistic.MaxReportsCount));
end;



{ TfrxHTTPServer }

constructor TfrxHTTPServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Active := False;
  ServerType := stThreadBlocking;
  Port := StrToInt(ServerConfig.GetValue('server.http.port'));
  FGzip := ServerConfig.GetBool('server.http.compression');
  FMainDocument := ServerConfig.GetValue('server.http.indexfile');
  FBasePath := frxGetAbsPathDir(ServerConfig.GetValue('server.http.rootpath'), ServerConfig.ConfigFolder);
  FSocketTimeOut := StrToInt(ServerConfig.GetValue('server.http.sockettimeout'));
  FNoCacheHeader := ServerConfig.GetBool('server.http.nocacheheader');
  OnClientError := ClientError;
  OnClientDisconnect := ClientDisconnect;
  OnAccept := ClientAccept;
  OnGetThread := GetThread;
  LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'HTTP server created');
end;

destructor TfrxHTTPServer.Destroy;
begin
  LogWriter.Write(SERVER_LEVEL, DateTimeToStr(Now) + #9'HTTP server closed');
  PMessages;
  inherited;
end;

procedure TfrxHTTPServer.ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + Socket.RemoteAddress + #9 + GetSocketErrorText(ErrorCode));
  LogWriter.ErrorReached;
  ErrorCode := 0;
  SessionManager.CompleteSessionId(String(TCustomWinSocket(Socket).Data));
  Socket.Close;
end;

procedure TfrxHTTPServer.ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  SessionManager.CompleteSessionId(String(TCustomWinSocket(Socket).Data));
end;

procedure TfrxHTTPServer.GetThread(Sender: TObject;
  ClientSocket: TServerClientWinSocket;  var SocketThread: TServerClientThread);
begin
  try
    SocketThread := TfrxServerSession.Create(True, ClientSocket);
    SocketThread.FreeOnTerminate := True;
    SocketThread.KeepInCache := False;
    TfrxServerSession(SocketThread).ParentReportServer := ParentReportServer;
    TfrxServerSession(SocketThread).ParentHTTPServer := Self;
    if ClientSocket <> nil then
      ClientSocket.Data := PChar(TfrxServerSession(SocketThread).SessionId);
    TfrxServerSession(SocketThread).SessionItem := SessionManager.AddSession(TfrxServerSession(SocketThread).SessionId, TCustomWinSocket(ClientSocket));

      SocketThread.Resume;
    FParentReportServer.StatToVar;
  except
    LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + ClientSocket.RemoteAddress + ' client session creation error');
  end;
end;

procedure TfrxHTTPServer.ClientAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if ParentReportServer.DenyIP.IndexOf(Socket.RemoteAddress) <> -1 then
  begin
    LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + Socket.RemoteAddress + ' denial of client connection');
    Socket.Close;
  end
  else if (ParentReportServer.AllowIP.Count > 0) and
     (ParentReportServer.AllowIP.IndexOf(Socket.RemoteAddress) = -1) then
  begin
    LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + Socket.RemoteAddress + ' client connection not allowed');
    Socket.Close;
  end;
end;

{ TfrxServerSession }

constructor TfrxServerSession.Create(CreateSuspended: Boolean; ASocket: TServerClientWinSocket);
begin
  inherited Create(CreateSuspended, ASocket);
  FSessionId := SID_SIGN + MakeSessionId;
  FIsReport := False;
  FSize := 0;
  FKeepAlive := False;
  FRemoteIP := ClientSocket.RemoteAddress;
  FServerReplyData := TStringList.Create;
  FReplyHeader := TStringList.Create;
  FReplyBody := TStringList.Create;
  FFormat := sfHTM;
  FPageRange := '';
  FGzip := False;
  FResultPage := '';
  FRedirect := False;
  FStream := TMemoryStream.Create;
  FInParams := TStringList.Create;
  FOutParams := TStringList.Create;
  FData := nil;
end;

destructor TfrxServerSession.Destroy;
begin
  PMessages;
  FInParams.Free;
  FOutParams.Free;
  FStream.Free;
  FServerReplyData.Free;
  FReplyHeader.Free;
  FReplyBody.Free;
  inherited;
end;

function TfrxServerSession.ParseHeaderField(Field: String): String;
var
  i: integer;
  s: string;
begin
  i := Pos(Field, FHeader);
  Result := '';
  if i > 0 then
  begin
    s := Copy(FHeader, i + Length(Field), Length(FHeader) - i + Length(Field));
    i := Pos(#13#10, s);
    if i > 0 then
      Result := Copy(s, 1, i - 1);
  end;
end;

procedure TfrxServerSession.ParseHTTPHeader;
var
  i, j: Integer;
  s: string;
  P, V: String;
  RepName: String;
begin
  FMethod := ERR_UNKNOWN_METHOD;
  FErrorCode := 0;
  FReturnData := '';
  if Pos(METHOD_GET, FHeader) > 0 then
  begin
    i := Pos('/', FHeader);
    if i > 0 then
    begin
      FName := Trim(Copy(FHeader, i + 1, Pos('HTTP', FHeader) - i - 2));
      FHTTPVersion := Copy(FHeader, Pos('HTTP/', FHeader), 8);
      FHost := ParseHeaderField('Host: ');
      FKeepAlive := ParseHeaderField('Connection: ') = 'keep-alive';
      FReferer := ParseHeaderField('Referer: ');
      FUserAgent := ParseHeaderField('User-Agent: ');
      s := ParseHeaderField('Accept-Encoding: ');
      if Length(s) > 0 then
        if (Pos('gzip', LowerCase(s)) > 0) and (FParentHTTPServer.Gzip) then
          FGzip := True;
      CheckAuth;
      FMethod := METHOD_GET;
      WriteLogs;
      if not FAuthNeeded then
      begin
        i := Pos('?', FName);
        if i > 0 then
          FName := Copy(FName, i + 1, Length(FName) - i);
        s := ParseParam('getvariable');
        if Length(s) = 0 then
        begin
          RepName := ParseParam('report');
          if (Length(RepName) > 0) then
          begin
            FIsReport := True;
            FDialogSessionId := ParseParam('sessionid');
            FCacheId := ParseParam('cacheid');
            if Length(FDialogSessionId) > 0 then
              FDialog := True;
            s := ParseParam('format');
            if Length(s) > 0 then
            begin
              s := UpperCase(s);
              if s = 'PDF' then FFormat := sfPDF else
              if s = 'ODS' then FFormat := sfODS else
              if s = 'ODT' then FFormat := sfODT else
              if s = 'XML' then FFormat := sfXML else
              if s = 'XLS' then FFormat := sfXLS else
              if s = 'RTF' then FFormat := sfRTF else
              if s = 'TXT' then FFormat := sfTXT else
              if s = 'CSV' then FFormat := sfCSV else
              if s = 'JPG' then FFormat := sfJPG else
              if s = 'BMP' then FFormat := sfBMP else
              if s = 'GIF' then FFormat := sfGIF else
              if (s = 'TIFF') or (s = 'TIF') then FFormat := sfTIFF else
              if (s = 'FRP') or (s = 'FP3') then FFormat := sfFRP else
              FFormat := sfHTM;
            end;
            s := ParseParam('multipage');
            if s = '0' then FMultipage := False
            else if s = '1' then FMultipage := True
            else FMultipage := not ServerConfig.GetBool('server.exports.html.singlepage');
            s := ParseParam('pagenav');
            if s = '0' then FPageNavigator := False
            else if s = '1' then FPageNavigator := True
            else FPageNavigator := ServerConfig.GetBool('server.exports.html.navigator');
            s := ParseParam('pagerange');
            FPageRange := s;
            if Pos('=', FName) > 0 then
            begin
              FVariables := TfrxVariables.Create;
              i := 1;
              while i > 0 do
              begin
                j := 1;
                while (j <= i) and (j <> 0) do
                begin
                  i := Pos('=', FName);
                  j := Pos('&', FName);
                  if (j < i) and (j <> 0) then
                    FName := Copy(FName, j + 1, Length(FName) - j);
                end;
                if i > 0 then
                begin
                  P := Copy(FName, 1, i - 1);
                  V := '''' + UTF8Decode(ParseParam(P)) + '''';
                  FVariables[P] := V;
                end;
              end;
            end else
              FVariables := nil;
            FName := frxGetAbsPathDir(ServerConfig.GetValue('server.reports.path'), ServerConfig.ConfigFolder) + RepName;
            PrepareReportQuery;
            if Assigned(FVariables) then
              FVariables.Free;
          end else
            if i > 0 then
              FErrorCode := 403;
        end else
        begin
          FReturnData := TfrxReportServer(ParentReportServer).Variables.GetValue(s);
          if Length(FReturnData) = 0 then
            FErrorCode := 404;
        end;
      end;
    end
  end;
end;

function TfrxServerSession.ParseParam(S: String): String;
var
  i, j: integer;
begin
  i := Pos(UpperCase(S) + '=', UpperCase(FName));
  if i > 0 then
  begin
    Result := Copy(FName, i + Length(S) + 1, Length(FName) - i + Length(S) + 1);
    j := Pos('&', Result);
    if j > 0 then
      Result := Copy(Result, 1, j - 1);
    Delete(FName, i, Length(S) + Length(Result) + 1);
  end else
    Result := '';
  if Length(FName) > 0 then
  begin
    i := 1;
    while (FName[i] = '&') and (i < Length(FName)) do
      Inc(i);
    Delete(FName, 1, i - 1);
  end;
  Result := HTML2Str(Result);
end;

function TfrxServerSession.CheckBadPath: Boolean;
begin
  Result := (Pos('..\', FName) > 0) or (Pos('../', FName) > 0);
end;

procedure TfrxServerSession.CreateReplyHTTPData;
var
  SearchRec: TSearchRec;
  s, sn: String;
begin
  FServerReplyData.Clear;
  FReplyHeader.Clear;

  if Length(FReturnData) > 0 then
    FErrorCode := 200;

  if (FErrorCode = 0) then
    if CheckBadPath then
      FErrorCode := 403
    else if FAuthNeeded then
      FErrorCode := 401
    else if (Length(FResultPage) > 0) and FileExists(FParentHTTPServer.BasePath + FResultPage) then
    begin
      FErrorCode := 301;
      FRedirect := True;
    end else
    begin
      if FName = '' then
        FName := FParentHTTPServer.MainDocument;
      if (FindFirst(FParentHTTPServer.BasePath + FName, faReadOnly + faArchive, SearchRec) = 0) or
         (FindFirst(FParentHTTPServer.BasePath + FName + FParentHTTPServer.MainDocument, faReadOnly + faArchive, SearchRec) = 0)
      then
      begin
        FErrorCode := 200;
        FSize := SearchRec.Size;
        FFileDate := FileDateToDateTime(SearchRec.Time);
      end else
        FErrorCode := 404;
      FindClose(SearchRec);
    end;
  UpdateSessionFName;
  GetFileMIMEType;
  s := '';
  if FErrorCode = 401 then
    s := ' Unauthorized'
  else if FErrorCode = 403 then
    s := ' Forbidden';
  if FData <> nil then
    FData.HTTPVer := FHTTPVersion;
  if FData <> nil then
    FData.ErrorCode := FErrorCode;
  FReplyHeader.Add(FHTTPVersion + ' ' + IntToStr(FErrorCode) + s);
  if Length(s) = 0 then
  begin
    sn := 'Server';

    FReplyHeader.Add(sn + ': ' + SERVER_NAME);
    AddOutData(sn, SERVER_NAME);

    if FErrorCode = 200 then
    begin
      sn := 'Content-type';
      AddOutData(sn, FMIMEType);
      FReplyHeader.Add(sn + ': ' + FMIMEType);
    end;
    if (FParentHTTPServer.FNoCacheHeader) and (not FRedirect) then
    begin
      sn := 'Cache-Control';
      s := 'must-revalidate, max-age=0';
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s);
      sn := 'Pragma';
      s := 'no-cache';
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s);
    end;
    sn := 'Accept-ranges';
    s := 'none';
    AddOutData(sn, s);
    FReplyHeader.Add(sn + ': ' + s);
    sn := 'Last-Modified';
    s := DateTimeToRFCDateTime(FFileDate);
    AddOutData(sn, s);
    FReplyHeader.Add(sn + ':' + s);
    sn := 'Expires';
    s := DateTimeToRFCDateTime(FFileDate);
    if FData <> nil then
    begin
      FData.Expires := FFileDate;
      FData.LastMod := FFileDate;
    end;
    AddOutData(sn, s);
    FReplyHeader.Add(sn + ':' + s);
    if FGzip and CheckDeflate(FName) and (FErrorCode = 200)
       
       then
    begin
      sn := 'Content-Encoding';
      s := 'gzip';
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s)
    end else
      FGzip := False;
    if FRedirect then
    begin
      sn := 'Location';
      s := FResultPage;
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s);
    end;
    if FIsReport then
    begin
      sn := 'SessionId';
      if FDialogSessionId <> '' then
        s := FDialogSessionId
      else
        s := FSessionId;
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s);
    end;
  end;
end;

procedure TfrxServerSession.PrepareReportQuery;
var
 Path: String;
 SecAtrtrs: TSecurityAttributes;
begin
  if FIsReport then
  begin
    Path := FParentHTTPServer.BasePath + FSessionId;
    SecAtrtrs.nLength := SizeOf(TSecurityAttributes)  ;
    SecAtrtrs.lpSecurityDescriptor := nil;
    SecAtrtrs.bInheritHandle := true;
    CreateDirectory(PChar(Path), @SecAtrtrs);
    if not FDialog then
    begin
      FRepSession := TfrxReportSession.Create;
      FRepSession.ParentThread := Self;
      FRepSession.NativeClient := Pos('FastReport', FUserAgent) > 0;
      FRepSession.Stream := FStream;
      FRepSession.ParentReportServer := ParentReportServer;
      FRepSession.SessionId := FSessionId;
      FRepSession.CacheId := FCacheId;
      FRepSession.FileName := FName;
      FRepSession.ReportPath := FParentHTTPServer.ReportPath;
      FRepSession.IndexFileName := FParentHTTPServer.MainDocument;
      FRepSession.RootPath := FParentHTTPServer.BasePath;
      FRepSession.PageRange := FPageRange;
      FRepSession.Format := FFormat;
      if Assigned(ParentReportServer.OnGetVariables) then
        Synchronize(DoGetVariables);
      FRepSession.Variables := FVariables;
      FRepSession.FreeOnTerminate := True;

      FRepSession.Password := FPassword;

      FSessionItem.ReportThread := FRepSession;

      FRepSession.PageNav := FPageNavigator;
      FRepSession.Multipage := FMultipage;
      FRepSession.UserLogin := FLogin;

      FRepSession.Resume;
    end else
    begin
      FSessionItem := SessionManager.FindSessionById(FDialogSessionId);
      if FSessionItem <> nil then
      begin
        FRepSession := FSessionItem.ReportThread;
        if FRepSession <> nil then
        begin
          FRepSession.Stream := FStream;
          FRepSession.Variables := FVariables;
          FRepSession.Continue := True;
          while FRepSession.DialogActive and (not Terminated) do
            PMessages;
        end
      end
    end;
    if (FRepSession <> nil) and (not Terminated) then
    begin
      while (not Terminated) and (FRepSession.Active) and (not FRepSession.DialogActive) do
      begin
        Sleep(10);
        PMessages;
      end;
      if FDialog then
        FName := '\' + FDialogSessionId + FRepSession.ResultPage
      else
      begin
        FName := '\' + FSessionId + FRepSession.ResultPage;
      end;

      FReportMessage := FRepSession.ReportMessage;

      if FRepSession.Auth then
        FAuthNeeded := True;

      if (not FRepSession.DialogActive) then
        if FDialog then
        begin
          FRepSession.Terminate;
          SessionManager.FindSessionById(FDialogSessionId).ReportThread := nil;
        end else
          SessionManager.FindSessionById(FSessionId).ReportThread := nil;
      FRepSession.Readed := True;
    end else
      FName := '';
    FResultPage := StringReplace(FName, '\', '/', [rfReplaceAll]);
    FFileDate := Now;
  end;
end;

procedure TfrxServerSession.MakeServerReply;
var
  FStream: TFileStream;
  Buffer, sn, s: String;
  i: Integer;
  MemStream, MemStreamOut: TMemoryStream;
  FSSIStream: TfrxSSIStream;
  FTemplate: TfrxServerTemplate;
begin
  if FData <> nil then
    FData.FileName := FName;
  if FErrorCode = 200 then
  begin
    if ClientSocket.Connected
    
     then
    begin
      MemStream := TMemoryStream.Create;
      FSSIStream := TfrxSSIStream.Create;
      FSSIStream.BasePath := FParentHTTPServer.BasePath;
      FSSIStream.Variables := FParentReportServer.Variables;
      try
        try
          if Length(FReturnData) = 0 then
          begin
            FStream := TFileStream.Create(FParentHTTPServer.BasePath + FName, fmOpenRead + fmShareDenyWrite);
            try
              FSSIStream.CopyFrom(FStream, 0);
            finally
              FStream.Free;
            end;
            if CheckSSI(FName) then
              FSSIStream.Prepare
          end
          else
            FSSIStream.Write(FReturnData[1], Length(FReturnData));

          FSSIStream.Position := 0;
          if FGzip
          
          then
          begin
            try
              frxCompressStream(FSSIStream, MemStream, gzMax, FName);
            except
              FErrorText := 'GZIP pack error';
              ErrorLog;
            end;
          end else
            MemStream.CopyFrom(FSSIStream, 0);
          MemStream.Position := 0;
          sn := 'Content-length';
          s := IntToStr(MemStream.Size);
          AddOutData(sn, s);
          FReplyHeader.Add(sn + ': ' + s);
          if ServerConfig.GetBool('server.http.mic') then
          begin
            sn := 'Content-MD5';
            s := MD5Stream(MemStream);
            AddOutData(sn, s);
            FReplyHeader.Add(sn + ': ' + s);
          end;
          FReplyHeader.Add('');
          Buffer := FReplyHeader.Text;
        except
          FErrorText := 'error prepare output result';
          ErrorLog;
        end;

          MemStreamOut := TMemoryStream.Create;
          try
            MemStream.SaveToStream(MemStreamOut);
            MemStreamOut.Position := 0;
            ClientSocket.SendBuf(Buffer[1], Length(Buffer));
            ClientSocket.SendStreamThenDrop(MemStreamOut);
          except
            MemStreamOut.Free;
            FErrorText := 'error socket stream output result';
            ErrorLog;
          end;

      finally
        MemStream.Free;
        FSSIStream.Free;
      end
    end;
  end else
  begin
    sn := 'Content-type';
    s := 'text/html';
    AddOutData(sn, s);
    FReplyHeader.Add(sn + ': ' + s);

    if FErrorCode = 404 then
    begin
      FTemplate := TfrxServerTemplate.Create;
      try
        FTemplate.SetTemplate('error404');
        FTemplate.Variables.AddVariable('ERROR', FReportMessage + '<br>' + ServerConfig.ServerMessage);
        FTemplate.Prepare;
        Buffer := FTemplate.TemplateStrings.Text;
      finally
        FTemplate.Free;
      end;

      i := Length(Buffer);
      FErrorText := FName + ' document not found ' + FReportMessage;
      ErrorLog;
    end else
    if FRedirect or (FErrorCode = 403) then
    begin
      i := 0;
      Buffer := '';
    end else
    if FErrorCode = 401 then
    begin
      i := 0;
      Buffer := '';
      sn := 'WWW-Authenticate';
      s := 'Basic realm="' + SERVER_NAME + '"';
      AddOutData(sn, s);
      FReplyHeader.Add(sn + ': ' + s);
    end else
    begin
      FTemplate := TfrxServerTemplate.Create;
      try
        FTemplate.SetTemplate('error500');
        FTemplate.Variables.AddVariable('ERROR', '');
        FTemplate.Prepare;
        Buffer := FTemplate.TemplateStrings.Text;
      finally
        FTemplate.Free;
      end;
      i := Length(Buffer);
      FErrorText := 'unknown error';
      ErrorLog;
    end;
    sn := 'Content-length';
    s := IntToStr(i);
    AddOutData(sn, s);
    FReplyHeader.Add(sn + ': ' + s);
    FReplyHeader.Add('');
//    Buffer := FReplyHeader.Text + Buffer;

      try
        ClientSocket.SendText(FReplyHeader.Text);
        ClientSocket.SendText(Buffer);
        ClientSocket.Close;
      except
        FErrorText := 'error socket stream output answer';
        ErrorLog;
      end;

  end;
end;

procedure TfrxServerSession.ClientExecute;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
  TempStream: TMemoryStream;
  i: Integer;
  Len: Integer;
begin
  LogWriter.StatAddCurrentSession;

    FD_ZERO(FDSet);
    FD_SET(ClientSocket.SocketHandle, FDSet);
    TimeVal.tv_sec := FParentHTTPServer.SocketTimeOut;
    TimeVal.tv_usec := 0;
    if (select(0, @FDSet, nil, nil, @TimeVal) > 0) and not Terminated then
    begin
      TempStream := TMemoryStream.Create;
      try
        i := ClientSocket.ReceiveLength;
        TempStream.SetSize(i);
        try
          ClientSocket.ReceiveBuf(TempStream.Memory^, i);
        except
          FErrorText := 'error socket stream read';
          ErrorLog;
        end;
        TempStream.Position := 0;
        i := StreamSearch(TempStream, 0, #13#10#13#10);
        if i <> 0 then
        begin
          Len := i + 4;
          SetLength(FHeader, Len);
          try
            TempStream.Position := 0;
            TempStream.ReadBuffer(FHeader[1], Len);
            try
              FStream.CopyFrom(TempStream, TempStream.Size - Len);
            except
              FErrorText := 'error client query';
              ErrorLog;
            end;
          except
            FErrorText := 'error client stream parsing';
            ErrorLog;
          end;
        end;
      finally
        TempStream.Free;
      end;
    end;
    if (select(0, nil, @FDSet, nil, @TimeVal) > 0) and not Terminated then
      if (Length(FHeader) > 0) and ClientSocket.Connected then
      begin
        ParseHTTPHeader;
        CreateReplyHTTPData;
        MakeServerReply;
      end;
    CloseSession;

  LogWriter.StatRemoveCurrentSession;
end;

procedure TfrxServerSession.GetFileMIMEType;
var
  Registry: TRegistry;
  ext: String;
begin
  ext := ExtractFileExt(FName);
  Registry  := TRegistry.Create;
  try
{$IFNDEF Delphi4}
    Registry.Access := KEY_READ;
{$ENDIF}
    Registry.RootKey := HKEY_CLASSES_ROOT;
    FMIMEType := '';
    if Registry.KeyExists(ext) then
    begin
      Registry.OpenKey(ext, false);
      FMIMEType := Registry.ReadString('Content Type');
      Registry.CloseKey;
    end;
  finally
    Registry.Free;
  end;
end;

procedure TfrxServerSession.WriteLogs;
begin
  LogWriter.Write(ACCESS_LEVEL, DateTimeToStr(Now) + #9 + FSessionId + #9 + FRemoteIP + #9 + FName);
  if Length(FReferer) > 0 then
    LogWriter.Write(REFERER_LEVEL, DateTimeToStr(Now) + #9 + FRemoteIP + #9 + FReferer);
  if Length(FUserAgent) > 0 then
    LogWriter.Write(AGENT_LEVEL, DateTimeToStr(Now) + #9 + FRemoteIP + #9 + FUserAgent);
end;

procedure TfrxServerSession.ErrorLog;
begin
  LogWriter.Write(ERROR_LEVEL, DateTimeToStr(Now) + #9 + FRemoteIP + #9 + FErrorText);
  LogWriter.ErrorReached;
end;

procedure TfrxServerSession.UpdateSessionFName;
begin
  SessionManager.FindSessionById(FSessionId).FileName := FName;
end;

procedure TfrxServerSession.CloseSession;
begin
  SessionManager.CompleteSessionId(SessionId);
end;

function TfrxServerSession.CheckSSI(FileName: String): Boolean;
var
  ext: String;
begin
  ext := LowerCase(ExtractFileExt(FileName));
  Result := (ext = '.htm') or (ext = '.html') or
            (ext = '.shtm') or (ext = '.shtml');
end;

function TfrxServerSession.CheckDeflate(FileName: String): Boolean;
var
  ext: String;
begin
  ext := LowerCase(ExtractFileExt(FileName));
  if Pos('MSIE', FUserAgent) > 0 then
    Result := ((ext = '.htm') or (ext = '.html') or
              (ext = '.shtm') or (ext = '.shtml') or
              (ext = '.css') or (ext = '.txt') or
              (ext = '.bmp')) and (FSize > MAX_IE_GZIP)
  else
    Result := (ext <> '.jpg') and (ext <> '.jpeg') and
              (ext <> '.gif') and (ext <> '.png') and
              (ext <> '.ods') and (ext <> '.odt') and
              (ext <> '.zip') and (ext <> '.rar');
end;

procedure TfrxServerSession.CheckAuth;
var
  i: Integer;
  s: String;
  L, P: String;
begin
  FAuthNeeded := ((Length(ServerConfig.GetValue('server.security.login')) > 0) and
     (Length(ServerConfig.GetValue('server.security.password')) > 0))
     or (ServerConfig.GetBool('server.security.userauth'));
  s := ParseHeaderField('Authorization: ');
  if Length(s) > 0 then
  begin
    i := Pos('Basic ', s);
    if i > 0 then
    begin
      s := Copy(s, i + 6, Length(s) - i - 5);
      s := Base64Decode(s);
      i := Pos(':', s);
      if i > 0 then
      begin
        L := Copy(s, 1, i - 1);
        P := Copy(s, i + 1, Length(s) - i);
        FLogin := L;
        FPassword := P;

        if ServerConfig.GetBool('server.security.userauth') then
        begin
          FAuthNeeded := not ServerUsers.AllowLogin(L, P);
          if FName = '' then
            FName := ServerUsers.GetUserIndex(L);
        end
        else
        if (L = ServerConfig.GetValue('server.security.login')) and
           (P = ServerConfig.GetValue('server.security.password')) then
          FAuthNeeded := False
      end;
    end;
  end;
end;

procedure TfrxServerSession.DoGetVariables;
begin
  ParentReportServer.OnGetVariables(FName, FVariables, FLogin);
end;


procedure TfrxServerSession.AddOutData(const Name: String; const Value: String);
begin
  if FData <> nil then
    FData.OutParams.Add(Name + '=' + Value);
end;

{ TfrxServerData }

procedure TfrxServerData.Assign(Source: TfrxServerData);
begin
  FInParams.Assign(Source.InParams);
  FOutParams.Assign(Source.FOutParams);
  FErrorCode := Source.ErrorCode;
  FStream.Clear;
  if Source.Stream.Size > 0 then
  begin
    Source.Stream.Position := 0;
    FStream.CopyFrom(Source.Stream, 0);
  end;
  FErrorCode := Source.ErrorCode;
  FFileName := Source.FileName;
end;

constructor TfrxServerData.Create;
begin
  FInParams := TStringList.Create;
  FOutParams := TStringList.Create;
  FStream := TMemoryStream.Create;
  FErrorCode := 0;
end;

destructor TfrxServerData.Destroy;
begin
  FStream.Free;
  FInParams.Free;
  FOutParams.Free;
  inherited;
end;

{ TfrxServerGuard }

constructor TfrxServerGuard.Create(Server: TfrxReportServer);
begin
  inherited Create(True);
  FServer := Server;
  FTimeOut := 10;
  FListTimeOut := 30;
  Priority := tpLowest;
  Resume;
end;

destructor TfrxServerGuard.Destroy;
begin
  Terminate;
  PMessages;
  WaitFor;
  inherited;
end;

procedure TfrxServerGuard.DoLoadConf;
begin
  FServer.LoadConfigs;
end;

procedure TfrxServerGuard.Execute;
var
  time1, time2, out1, out2: Cardinal;
begin
  time1 := GetTickCount;
  time2 := time1;
  out1 := FTimeOut * 1000;
  out2 := FListTimeOut * 1000;
  while not Terminated do
  begin
    if (GetTickCount - time1) > out1 then
    begin
      Synchronize(DoLoadConf);
      time1 := GetTickCount;
    end;
    if (GetTickCount - time2) > out2 then
    begin
//      FServer.ReportsList.BuildListOfReports;
      time2 := GetTickCount;
    end;
    Sleep(1);
  end;
end;

initialization


finalization


end.
