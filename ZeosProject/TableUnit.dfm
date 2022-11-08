inherited fmSimpleTable: TfmSimpleTable
  ActiveControl = dbgTable
  Caption = 'fmSampleTable'
  PixelsPerInch = 96
  TextHeight = 13
  object lblTableTitle: TLabel [0]
    Left = 7
    Top = 32
    Width = 129
    Height = 16
    Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1090#1072#1073#1083#1080#1094#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  inherited pnlCommand: TPanel
    inherited edtCalcDay: TDBDateTimeEditEh
      Left = 650
      EditFormat = 'MM/YYYY'
    end
  end
  object dbgTable: TDBGridEh [2]
    Left = 7
    Top = 80
    Width = 286
    Height = 377
    DataSource = dsTable
    FooterColor = clWindow
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgConfirmDelete]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghIncSearch, dghPreferIncSearch, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
    SortLocal = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
  end
  object nwTable: TDBNewNav [3]
    Left = 7
    Top = 52
    Width = 200
    Height = 20
    DataSource = dsTable
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = nwTableClick
  end
  inherited alBase: TActionList
    Left = 304
    Top = 40
  end
  inherited ilBase: TImageList
    Left = 336
    Top = 40
  end
  object zqrTable: TZQuery
    BeforePost = zqrTableBeforePost
    Params = <>
    Left = 256
    Top = 128
  end
  object dsTable: TDataSource
    DataSet = zqrTable
    Left = 256
    Top = 176
  end
end
