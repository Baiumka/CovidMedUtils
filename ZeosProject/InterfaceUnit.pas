unit InterfaceUnit;

interface
uses Classes, Variants, SysUtils;

type
  TSelectedRecord = record
    Id   : integer;
    Name : string;
    Ext  : string;
  end;

  TReportValue    = procedure(const VarName: String; var Value: Variant) of object;
  TReportFunction = function(const MethodName: String; var Params: Variant): Variant of object;

  IReport = interface(IInterface)
  ['{0378FADE-44C8-4643-A0EB-641E0CB3B8D5}']
    procedure ClearCash;
    procedure RegFunction(const Value : string);
    function  SetGlobalGetValue(AFunc : TReportValue) : Boolean;
    function  SetGlobalUserFunc(AFunc : TReportFunction) : Boolean;
    function  SetOnGetValue(AFunc : TReportValue) : Boolean;
    function  SetOnUserFunc(AFunc : TReportFunction) : Boolean;
    function  ShowReport(const AName : String; ADataset: array of const; const NoPrint : Boolean = False) : Boolean;
    function  ReportNameByKey(const AKey : string) : string;
    procedure ReportDate(const dt : TDateTime);
    function  SetFormatSettings(Value : Pointer) : TFormatSettings;
    function  AddReportValue(aName: string; aValue: Variant): Boolean;
  end;

  IGlobal = interface(IInterface)
    ['{D7E77A39-FEE2-4E54-BA30-05185386DD22}']
    function ClearCash(const aRef : integer = 0) : Boolean;
  end;

  IMaster = interface(IInterface)
  ['{1924B6EA-A04F-4550-A305-67AF9E2DD8E9}']
    function  GetData(AQuery : Pointer; HaveResult : Boolean = True;
                AReadOnly : Boolean = False; ARequired : Boolean = False) : boolean;
    procedure ShowAniStatus;
    procedure HideAniStatus;
    procedure ShowError(AText : String; const Args: array of const);
    procedure ShowWarning(AText : String; const Args: array of const);
    procedure ShowScrWarning(AText : String; const Args: array of const);
    procedure ShowInfo(AText : String; const Args: array of const);
    procedure ShowDebug(AText : String; const Args: array of const);
    procedure ShowErrorDlg(AText : String; const Args: array of const);
    procedure ShowWarningDlg(AText : String; const Args: array of const);
    procedure ShowInfoDlg(AText : String; const Args: array of const);

    procedure ShowConnected(AValue : Boolean);

    procedure DeleteFromTabs(AForm : Pointer);
    procedure ActiveFormTabs(AForm : Pointer);
    function  ActiveTabForm : Pointer;

    function  GetModuleName(const AName : String) : string;
    function  GetModuleAction(const AName : String) : Pointer;
    function  GetModuleForm(const AName : String) : Pointer;

    procedure EnabledAction(const AAction : Pointer; const AValue : Boolean = True);
    procedure VisibleAction(const AAction : Pointer; const AValue : Boolean = True);
    function  ReadOnlyAction(const AAction: Pointer): Boolean;
    function  SetActionHelpContext(const AAction : Pointer;
                const AName : string = ''; const AForm : string = ''): Boolean;

    function  OpenNewReport : Boolean;
    function  OpenReportByID(AId : Integer) : Boolean;
    function  OpenReportByKeyWord(AKeyWord : String) : Boolean;
    
    function  Report: IReport;
    function  ClearReport : Boolean;

    function  DebugMode : Boolean;
    function  CheckConnection(Lgn, Pswd : string) : Boolean;
    function  GetUsersInfo : String;
    function  GetIniData(const Section, Ident: string; const Key : Char): Variant;
    function  SetIniData(const Section, Ident: string; Value : Variant): boolean;
    function  GetIniDataSection(const Section: string): string;
    function  GetCalcDate(Origin : Boolean = False) : TDateTime;
    function  GetCalcDateText(Value : TDateTime) : string;
    function  GetCorrectWorkDate(Value : TDateTime) : TDateTime; 
    function  GetActiveFormCalcDate : TDateTime;
    procedure ClearCalcDate;
    function  HaveAccess(const fmName, ctlName : string; const KeyState : Byte; const ShowMessage : Boolean = False) : Boolean;
    procedure RefreshReference(const ARef : integer);

    procedure ChangeFormScale(const Sender : Pointer);
    function  IsAppClosed : Boolean;
    procedure AppTerminate;

    function  DefaultLNG : Integer;
  end;

implementation

end.
