inherited fmKadr: TfmKadr
  Left = 491
  Top = 205
  Width = 431
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1088#1077#1076#1087#1088#1080#1103#1090#1080#1103
  Constraints.MinHeight = 0
  Constraints.MinWidth = 0
  FormStyle = fsNormal
  PixelsPerInch = 96
  TextHeight = 13
  inherited lblTableTitle: TLabel
    Visible = False
  end
  inherited pnlCommand: TPanel
    Width = 423
    inherited lblCalcDate: TLabel
      Left = 309
    end
    inherited edtCalcDay: TDBDateTimeEditEh
      Left = 281
      EditFormat = 'MM/YYYY'
    end
    object chkAll: TDBCheckBoxEh
      Left = 96
      Top = 5
      Width = 124
      Height = 17
      Alignment = taLeftJustify
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1091#1074#1086#1083#1077#1085#1085#1099#1093
      TabOrder = 1
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      OnClick = chkAllClick
    end
  end
  inherited dbgTable: TDBGridEh
    Left = 0
    Top = 64
    Width = 423
    Height = 364
    Align = alBottom
    AutoFitColWidths = True
    OnGetCellParamsEh = dbgTableGetCellParamsEh
    Columns = <
      item
        EditButtons = <>
        FieldName = 'tn'
        Footers = <>
        Title.Caption = #1058#1072#1073'. '#8470
        Width = 80
      end
      item
        EditButtons = <>
        FieldName = 'fio'
        Footers = <>
        Title.Caption = #1060#1048#1054
        Width = 150
      end
      item
        EditButtons = <>
        FieldName = 'job'
        Footers = <>
        Title.Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        Width = 150
      end>
  end
  inherited nwTable: TDBNewNav
    Top = 36
    Hints.Strings = ()
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 428
    Width = 423
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      423
      38)
    object btnOk: TBitBtn
      Left = 253
      Top = 9
      Width = 80
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 0
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 337
      Top = 9
      Width = 80
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  inherited zqrTable: TZQuery
    SortedFields = 'fio;tn'
    IndexFieldNames = 'fio Asc;tn Asc'
  end
end
