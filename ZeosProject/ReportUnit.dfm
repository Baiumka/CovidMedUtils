object dmReport: TdmReport
  Tag = 1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 321
  Top = 348
  Height = 441
  Width = 649
  object zqrReports: TZQuery
    UpdateObject = zuqReports
    Params = <>
    Left = 456
    Top = 8
  end
  object frxReport: TfrxReport
    Version = '4.5'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    OldStyleProgress = True
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41933.421651030100000000
    ReportOptions.LastChange = 42926.411234155090000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      ''
      'procedure GroupFooter1OnBeforePrint(Sender: TfrxComponent);'
      'var f : extended;'
      '    s : string;                                            '
      'begin'
      '  exit;            '
      
        '  f := <frxDBDatasetOborot."vos">*<frxDBDatasetOborot."cen"> + <' +
        'frxDBDatasetOborot."prm">*<frxDBDatasetOborot."cen"> -'
      
        '       <frxDBDatasetOborot."rm">*<frxDBDatasetOborot."cen"> - <f' +
        'rxDBDatasetOborot."sum_ost_doc">;'
      ''
      '  f := RoundTo(f,-3);                     '
      '  if f <> 0 then'
      '  begin'
      '    s := <frxDBDatasetOborot."nt">;'
      
        '    s := s + '#39' '#39' + VarToStr(f);                                 ' +
        '                        '
      '    showmessage(s);'
      '  end;                '
      'end;'
      ''
      'begin'
      ''
      'end.')
    StoreInDFM = False
    OnGetValue = frxReportGetValue
    OnUserFunction = frxReportUserFunction
    Left = 72
    Top = 8
  end
  object frxDesigner1: TfrxDesigner
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    Restrictions = []
    RTLLanguage = False
    UseObjectFont = False
    Left = 184
    Top = 8
  end
  object frxRichObject1: TfrxRichObject
    Left = 72
    Top = 56
  end
  object frxCrossObject1: TfrxCrossObject
    Left = 72
    Top = 104
  end
  object frxCheckBoxObject1: TfrxCheckBoxObject
    Left = 72
    Top = 152
  end
  object frxDotMatrixExport1: TfrxDotMatrixExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    EscModel = 0
    GraphicFrames = False
    SaveToFile = False
    UseIniSettings = True
    Left = 72
    Top = 200
  end
  object frxDialogControls1: TfrxDialogControls
    Left = 72
    Top = 248
  end
  object frxChartObject1: TfrxChartObject
    Left = 72
    Top = 296
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    Left = 184
    Top = 64
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 264
    Top = 64
  end
  object frxXMLExport1: TfrxXMLExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 264
    Top = 112
  end
  object frxRTFExport1: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Wysiwyg = True
    Creator = 'FastReport'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 184
    Top = 112
  end
  object frxTIFFExport1: TfrxTIFFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 176
    Top = 160
  end
  object frxODSExport1: TfrxODSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 264
    Top = 208
  end
  object frxODTExport1: TfrxODTExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Background = True
    Creator = 'FastReport'
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 176
    Top = 208
  end
  object frxJPEGExport1: TfrxJPEGExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    Left = 264
    Top = 160
  end
  object zuqReports: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 456
    Top = 64
  end
  object udsSimpleCount: TfrxUserDataSet
    RangeEnd = reCount
    UserName = 'SimpleCount'
    Left = 184
    Top = 288
  end
  object zqrReportSettings: TZQuery
    UpdateObject = dmSimpleClient.zuqEmpty
    Params = <>
    Left = 456
    Top = 120
  end
end
