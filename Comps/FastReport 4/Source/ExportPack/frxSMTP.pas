
{******************************************}
{                                          }
{              FastReport 4.0              }
{        SMTP connection client unit       }
{                                          }
{         Copyright (c) 2006-2008          }
{         by Alexander Fediachov,          }
{            Fast Reports Inc.             }
{                                          }
{******************************************}

unit frxSMTP;

interface

{$I ..\frx.inc}

uses
  Windows, SysUtils, Classes, ScktComp, frxNetUtils, frxUtils, frxProgress
{$IFDEF Delphi6}, Variants {$ENDIF}, frxMD5, frxUnicodeUtils;


type
  TfrxSMTPClientThread = class;

  TfrxSMTPClient = class(TComponent)
  private
    FActive: Boolean;
    FBreaked: Boolean;
    FErrors: TStrings;
    FHost: String;
    FPort: Integer;
    FThread: TfrxSMTPClientThread;
    FTimeOut: Integer;
    FPassword: String;
    FMailTo: WideString;
    FUser: String;
    FMailFiles: TStringList;
    FMailFrom: WideString;
    FMailSubject: WideString;
    FMailText: WideString;
    FAnswer: String;
    FAccepted: Boolean;
    FAuth: String;
    FCode: Integer;
    FSending: Boolean;
    FProgress: TfrxProgress;
    FShowProgress: Boolean;
    FLogFile: String;
    FLog: TStringList;
    FAnswerList: TStringList;
    F200Flag: Boolean;
    F210Flag: Boolean;
    F215Flag: Boolean;
    FOrganization: WideString;
    FMailCc: WideString;
    FMailBcc: WideString;
    procedure DoConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DoError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SetActive(const Value: Boolean);
    procedure AddLogIn(const s: String);
    procedure AddLogOut(const s: String);
    function DomainByEmail(const addr: String): String;
    function UnicodeField(const Str: WideString): String;
    function UnicodeString(const Str: WideString): String;
    function GetEmailAddress(const Str: String): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    procedure Disconnect;
    procedure Open;
    procedure Close;
    property Breaked: Boolean read FBreaked;
    property Errors: TStrings read FErrors write Ferrors;
    property LogFile: String read FLogFile write FLogFile;
  published
    property Active: Boolean read FActive write SetActive;
    property Host: String read FHost write FHost;
    property Port: Integer read FPort write FPort;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property User: String read FUser write FUser;
    property Password: String read FPassword write FPassword;
    property MailFrom: WideString read FMailFrom write FMailFrom;
    property MailTo: WideString read FMailTo write FMailTo;
    property MailCc: WideString read FMailCc write FMailCc;
    property MailBcc: WideString read FMailBcc write FMailBcc;
    property MailSubject: WideString read FMailSubject write FMailSubject;
    property MailText: WideString read FMailText write FMailText;
    property MailFiles: TStringList read FMailFiles write FMailFiles;
    property ShowProgress: Boolean read FShowProgress write FShowProgress;
    property Organization: WideString read FOrganization write FOrganization;
  end;

  TfrxSMTPClientThread = class (TThread)
  protected
    FClient: TfrxSMTPClient;
    procedure DoOpen;
    procedure Execute; override;
  public
    FSocket: TClientSocket;
    constructor Create(Client: TfrxSMTPClient);
    destructor Destroy; override;
  end;

implementation

uses frxRes, frxrcExports{$IFDEF Delphi7}, StrUtils{$ENDIF};

const
  MIME_STRING_SIZE = 57;
  boundary = '----------';

type
  THackThread = class(TThread);


{ TfrxSMTPClient }

constructor TfrxSMTPClient.Create(AOwner: TComponent);
begin
  inherited;
  FErrors := TStringList.Create;
  FHost := '127.0.0.1';
  FPort := 25;
  FActive := False;
  FTimeOut := 60;
  FBreaked := False;
  FThread := TfrxSMTPClientThread.Create(Self);
  FThread.FSocket.OnConnect := DoConnect;
  FThread.FSocket.OnRead := DoRead;
  FThread.FSocket.OnDisconnect := DoDisconnect;
  FThread.FSocket.OnError := DoError;
  FShowProgress := False;
  FLogFile := '';
  FLog := TStringList.Create;
  FAnswerList := TStringList.Create;
  FMailFiles := TStringList.Create;
end;

destructor TfrxSMTPClient.Destroy;
begin
  FMailFiles.Free;
  Close;
  while FActive do
    PMessages;
  FThread.Free;
  FErrors.Free;
  FLog.Free;
  FAnswerList.Free;
  inherited;
end;

procedure TfrxSMTPClient.Connect;
var
  ticks: Cardinal;
begin
  FLog.Clear;
  if (FLogFile <> '') and FileExists(LogFile) then
    FLog.LoadFromFile(LogFile);
  FLog.Add(DateTimeToStr(Now));
  FErrors.Clear;
  FActive := True;
  FThread.FSocket.Host := FHost;
  FThread.FSocket.Address := FHost;
  FThread.FSocket.Port := FPort;
  FThread.FSocket.ClientType := ctNonBlocking;
  F200Flag := False;
  F210Flag := False;
  F215Flag := False;
  if FShowProgress then
  begin
    FProgress := TfrxProgress.Create(Self);
    FProgress.Execute(100, frxGet(8924) + ' ' + FMailTo, False, True);
  end;
  FThread.Execute;
  try
    ticks := GetTickCount;
    while FActive and (not FBreaked) do
    begin
      PMessages;
      if FShowProgress then
        FProgress.Tick;
      if ((GetTickCount - ticks) > Cardinal(FTimeOut * 1000)) then
      begin
        Errors.Add('Timeout expired (' + IntToStr(FTimeOut) + ')');
        break;
      end;
      if FSending then
        ticks := GetTickCount;
      Sleep(100);
    end;
  finally
    if FShowProgress then
      FProgress.Free;
    Disconnect;
  end;
  FLog.Add('---' + DateTimeToStr(Now));
  FLog.AddStrings(FErrors);
  if FLogFile <> '' then
    FLog.SaveToFile(FLogFile);
end;

procedure TfrxSMTPClient.Disconnect;
begin
  FThread.FSocket.Close;
  FThread.Terminate;
  FActive := False;
end;

procedure TfrxSMTPClient.DoConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  s: String;
begin
  s := 'HELO ' + DomainByEmail(FMailFrom) + #13#10;
  Socket.SendText(s);
  AddLogOut(s);
  FCode := 0;
  FAuth := FUser;
  FAccepted := False;
  FSending := False;
end;

procedure TfrxSMTPClient.DoDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if Pos('221', FAnswer) = 0 then
    Errors.Add(FAnswer);
  FActive := False;
  FSending := False;
end;

procedure TfrxSMTPClient.DoError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  if FAnswer <> '' then
    Errors.Add(FAnswer);
  Errors.Add(GetSocketErrorText(ErrorCode));
  FActive := False;
  ErrorCode := 0;
  FSending := False;
end;

procedure TfrxSMTPClient.DoRead(Sender: TObject; Socket: TCustomWinSocket);
var
  buf: PChar;
  i, j, k: Integer;
  Stream: TMemoryStream;
  fbuf: PChar;
  FStream: TFileStream;
  s, s1, s2: String;
  bound: String;

  procedure OutStream(const S: String);
  begin
    Stream.Write(S[1], Length(S));
    Stream.Write(#13#10, 2);
{$IFDEF FR_DEBUG}
    FLog.Add(s);
{$ENDIF}
  end;

begin
  i := Socket.ReceiveLength;
  GetMem(buf, i);
  try
    try
      i := Socket.ReceiveBuf(buf^, i);
      SetLength(FAnswer, i);
      CopyMemory(PChar(FAnswer), buf, i);
      FAnswerList.Text := FAnswer;

      for k := 0 to FAnswerList.Count - 1 do
      begin
        FAnswer := FAnswerList[k];
        FCode := StrToInt(Copy(FAnswer, 1, 3));
        AddLogIn(FAnswer);
        if (FCode = 235) then
        begin
          FCode := 220;
          FAccepted := True;
        end;
        if (FUser <> '') and (not FAccepted) and (FCode = 220) then
        begin
          s := 'AUTH LOGIN'#13#10;
          Socket.SendText(s);
          AddLogOut(s);
        end
        else if FCode = 334 then
        begin
          Socket.SendText(Base64Encode(FAuth) + #13#10);
          FAuth := FPassword;
          AddLogOut('****');
        end
        else if (FCode = 220) then
        begin
          s := 'MAIL FROM: ' + '<' + GetEmailAddress(FMailFrom) + '>' + #13#10;
          Socket.SendText(s);
          AddLogOut(s);
          F210Flag := True;
        end
        else if (FCode = 250) and F210Flag then
        begin
          s := 'RCPT TO: ' + '<' + GetEmailAddress(FMailTo) + '>' + #13#10;
          Socket.SendText(s);
          AddLogOut(s);
          F210Flag := False;
          F215Flag := True;
        end
        else if (FCode = 250) and F215Flag then
        begin
          s := 'DATA'#13#10;
          Socket.SendText(s);
          AddLogOut(s);
          F215Flag := False;
        end
        else if (FCode = 250) and F200Flag then
        begin
          s := 'QUIT'#13#10;
          Socket.SendText(s);
          AddLogOut(s);
          F200Flag := False;
        end
        else if (FCode = 354) then
        begin
          FSending := True;
          Stream := TMemoryStream.Create;
          try
            OutStream('Date: ' + DateTimeToRFCDateTime(Now));
            OutStream('From: ' + UnicodeField(FMailFrom));
            OutStream('Reply-To: ' + UnicodeField(FMailFrom));
            if FOrganization <> '' then
              OutStream('Organization: ' + UnicodeString(FOrganization));
            OutStream('X-Priority: 3 (Normal)');
            i := Pos('@', FMailFrom);
            j := PosEx('>', FMailFrom, i);
            if j = 0 then
              j := Length(FMailFrom);
            s := Copy(FMailFrom, i, j - i + 1);
            OutStream('Message-ID: <' + IntToStr(GetTickCount) + '.' + FormatDateTime('YYYYMMDDHHMMSS', Now) + s + '>');
            OutStream('To: ' + UnicodeField(FMailTo));
            if FMailCc <> '' then
              OutStream('CC: ' + UnicodeField(FMailTo));
            if FMailBcc <> '' then
              OutStream('BCC: ' + UnicodeField(FMailTo));
            OutStream('Subject: ' + UnicodeString(FMailSubject));
            bound := boundary + UpperCase(Copy(md5String(DateTimeToStr(Now)), 1, 14));
            OutStream('MIME-Version: 1.0');
            OutStream('Content-Type: multipart/mixed; boundary="' + bound +'"');
            OutStream(#13#10'--' + bound);
            OutStream('Content-Type: text/plain; charset=utf-8');
            OutStream('Content-Transfer-Encoding: 8bit');
            OutStream(#13#10 + UTF8Encode(FMailText));
            for i := 0 to FMailFiles.Count - 1 do
            begin
              if FMailFiles.Names[i] <> '' then
                s2 := FMailFiles.Names[i]
              else
                s2 := FMailFiles[i];
              if FileExists(s2) then
              begin
                s := GetFileMIMEType(s2);
                if FMailFiles.Names[i] = '' then
                  s1 := ExtractFileName(s2)
                else
                  s1 := FMailFiles.Values[FMailFiles.Names[i]];
                OutStream('--' + bound);
                OutStream('Content-Type: ' + s + '; name="' + s1 + '"');
                OutStream('Content-Transfer-Encoding: base64');
                OutStream('Content-Disposition: attachment; filename="' + s1 + '"'#13#10);
                FStream := TFileStream.Create(s2, fmOpenRead + fmShareDenyWrite);
                GetMem(fbuf, MIME_STRING_SIZE);
                try
                  j := MIME_STRING_SIZE;
                  while j = MIME_STRING_SIZE do
                  begin
                    j := FStream.Read(fbuf^, j);
                    SetLength(s, j);
                    CopyMemory(PChar(s), fbuf, j);
                    s := Base64Encode(s);
                    OutStream(s);
                  end;
                finally
                  FreeMem(fbuf);
                  FStream.Free;
                end;
              end;
            end;
            OutStream(#13#10 + '--' + bound + '--');
            OutStream('.');
{$IFNDEF FR_DEBUG}
            AddLogOut('message(skipped)');
{$ENDIF}
            Socket.SendBuf(Stream.Memory^, Stream.Size);
            F200Flag := True;
          finally
            FSending := False;
            Stream.Free;
          end;
        end;
      end;
    except
      on e: Exception do
        Errors.Add('Data receive error: ' + e.Message)
    end;
  finally
    FreeMem(buf);
  end;
end;

procedure TfrxSMTPClient.SetActive(const Value: Boolean);
begin
  if Value then Connect
  else Disconnect;
end;

procedure TfrxSMTPClient.Close;
begin
  FBreaked := True;
  Active := False;
end;

procedure TfrxSMTPClient.Open;
begin
  Active := True;
end;

function TfrxSMTPClient.DomainByEmail(const addr: String): String;
var
  i: Integer;
begin
  i := Pos('@', addr);
  if i > 0 then
    Result := Copy(addr, i + 1, Length(addr) - i)
  else
    Result := addr;
end;

procedure TfrxSMTPClient.AddLogIn(const s: String);
begin
  FLog.Add('<' + s);
end;

procedure TfrxSMTPClient.AddLogOut(const s: String);
begin
  FLog.Add('>' + s);
end;

function TfrxSMTPClient.UnicodeField(const Str: WideString): String;
var
  i1, i2, i3, k: Integer;
  ws1: WideString;
  ws2: String;
begin
  i1 := Pos('<', Str);
  i2 := Pos('@', Str);
  i3 := Pos('>', Str);
  if (i1 <> 0) and (i1 < i2) and (i2 < i3) then
  begin
    ws1 := Copy(Str, 1, i1 - 1);
    ws2 := Copy(Str, i1, Length(Str) - i1 + 1);
  end
  else if i2 > 0 then
  begin
    k := i2;
    while (k > 0) and (Str[k] <> #32) do
      Dec(k);
    ws1 := Copy(Str, 1, k - 1);
    ws2 := '<' + Copy(Str, k, Length(Str) - k + 1) + '>';
  end
  else
  begin
    ws1 := Str;
    ws2 := '';
  end;
  Result := UnicodeString(ws1) + ws2;
end;

function TfrxSMTPClient.UnicodeString(const Str: WideString): String;
begin
  if Str <> '' then
    Result := '=?utf-8?B?' + Base64Encode(UTF8Encode(Str)) + '?='
  else
    Result := '';
end;

function TfrxSMTPClient.GetEmailAddress(const Str: String): String;
var
  i, j, k: Integer;
begin
  Result := '';
  i := Pos('@', Str);
  if i <> 0 then
  begin
    j := i;
    while (Str[j] <> '<') and (Str[j] <> ' ') and (j > 1) do
      Dec(j);
    if (Str[j] = '<') or (Str[j] = ' ') then
      Inc(j);
    k := i;
    while (Str[k] <> '>') and (Str[k] <> ' ') and (k < Length(Str)) do
      Inc(k);
    if (Str[k] = '>') or (Str[k] = ' ') then
      Dec(k);
    Result := Copy(Str, j, k - j + 1);
  end;
end;

{ TfrxSMTPClientThread }

constructor TfrxSMTPClientThread.Create(Client: TfrxSMTPClient);
begin
  inherited Create(True);
  FClient := Client;
  FreeOnTerminate := False;
  FSocket := TClientSocket.Create(nil);
end;

destructor TfrxSMTPClientThread.Destroy;
begin
  FSocket.Free;
  inherited;
end;

procedure TfrxSMTPClientThread.DoOpen;
begin
  FSocket.Open;
end;

procedure TfrxSMTPClientThread.Execute;
begin
  Synchronize(DoOpen);
end;

end.
