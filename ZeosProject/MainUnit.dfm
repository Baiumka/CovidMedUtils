object fmMain: TfmMain
  Left = 666
  Top = 216
  Width = 800
  Height = 600
  Caption = #1043#1083#1072#1074#1085#1072#1103' '#1092#1086#1088#1084#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object splConcole: TSplitter
    Left = 0
    Top = 480
    Width = 784
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    Beveled = True
    Color = clTeal
    ParentColor = False
    OnPaint = splConcolePaint
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 515
    Width = 784
    Height = 26
    Constraints.MaxHeight = 34
    Constraints.MinHeight = 26
    Panels = <
      item
        Alignment = taCenter
        Text = 'Status'
        Width = 90
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
    ParentFont = True
    ParentShowHint = False
    ShowHint = True
    UseSystemFont = False
    OnClick = sbMainClick
    OnMouseDown = sbMainMouseDown
    OnMouseUp = sbMainMouseUp
    OnResize = sbMainResize
  end
  object dbgConsole: TDBGridEh
    Left = 0
    Top = 485
    Width = 784
    Height = 30
    Align = alBottom
    AllowedOperations = []
    AutoFitColWidths = True
    Color = clBtnFace
    Constraints.MaxHeight = 250
    Constraints.MinHeight = 30
    DataSource = dmSimpleClient.dsMessages
    DrawMemoText = True
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgColumnResize, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghFitRowHeightToText, dghDialogFind, dghDialogColumnEdit]
    ParentShowHint = False
    PopupMenu = pmConsole
    ReadOnly = True
    RowHeight = 3
    RowLines = 2
    ShowHint = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDblClick = dbgConsoleDblClick
    OnGetCellParams = dbgConsoleGetCellParams
    Columns = <
      item
        AutoFitColWidth = False
        EditButtons = <>
        FieldName = 'TIME'
        Footers = <>
        Width = 115
      end
      item
        EditButtons = <>
        FieldName = 'MESSAGE'
        Footers = <>
        ToolTips = True
        Width = 186
        WordWrap = True
      end>
  end
  object aniStatus: TAnimate
    Left = 24
    Top = 376
    Width = 21
    Height = 21
    StopFrame = 1
  end
  object tcChild: TTabControl
    Left = 0
    Top = 0
    Width = 784
    Height = 40
    Hint = 'ghbfdjklsfh'#13#10'fdshfjklsd'#13#10'fsdfjsdh'
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    HotTrack = True
    Images = ilChildIcon
    MultiLine = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    TabStop = False
    Visible = False
    OnChange = tcChildChange
    OnMouseMove = tcChildMouseMove
    OnResize = tcChildResize
  end
  object edtCalcDate: TDBDateTimeEditEh
    Left = 48
    Top = 376
    Width = 113
    Height = 21
    EditButtons = <>
    TabOrder = 4
    Visible = True
    OnExit = edtCalcDateExit
    OnKeyPress = edtCalcDateKeyPress
    EditFormat = 'DD/MM/YYYY'
  end
  object mmMenu: TMainMenu
    Left = 576
    Top = 8
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object Reconnect1: TMenuItem
        Caption = #1055#1077#1088#1077#1087#1086#1076#1082#1083#1102#1095#1080#1090#1100
        OnClick = Reconnect1Click
      end
      object miClearCash: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1077#1096
        OnClick = miClearCashClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object miDebug: TMenuItem
        Action = actDebug
      end
      object miN14: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Action = actShowConsole
      end
      object N7: TMenuItem
        Action = actHideConsole
      end
      object N8: TMenuItem
        Action = actClearConsole
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N3Click
      end
    end
    object N4: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      object N5: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        OnClick = N5Click
      end
    end
  end
  object alMain: TActionList
    Left = 544
    Top = 8
    object actClearConsole: TAction
      Category = '<'#1050#1086#1085#1089#1086#1083#1100'>'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      OnExecute = actClearConsoleExecute
    end
    object actHideConsole: TAction
      Category = '<'#1050#1086#1085#1089#1086#1083#1100'>'
      Caption = #1059#1073#1088#1072#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      OnExecute = actHideConsoleExecute
    end
    object actShowConsole: TAction
      Category = '<'#1050#1086#1085#1089#1086#1083#1100'>'
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1082#1086#1085#1089#1086#1083#1100
      OnExecute = actShowConsoleExecute
    end
    object actCopyConsoleRow: TAction
      Category = '<'#1050#1086#1085#1089#1086#1083#1100'>'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1077
      OnExecute = actCopyConsoleRowExecute
    end
    object actCopyConsoleAll: TAction
      Category = '<'#1050#1086#1085#1089#1086#1083#1100'>'
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
      OnExecute = actCopyConsoleAllExecute
    end
    object actDebug: TAction
      Category = '<Debug>'
      Caption = #1054#1090#1083#1072#1076#1082#1072
      OnExecute = actDebugExecute
    end
  end
  object pmConsole: TPopupMenu
    Left = 544
    Top = 592
    object N9: TMenuItem
      Action = actHideConsole
    end
    object N10: TMenuItem
      Action = actClearConsole
    end
    object N11: TMenuItem
      Action = actCopyConsoleRow
    end
    object N12: TMenuItem
      Action = actCopyConsoleAll
    end
  end
  object ilChildIcon: TImageList
    Left = 512
    Top = 8
  end
end
