object fmLogin: TfmLogin
  Left = 1252
  Top = 339
  BorderStyle = bsDialog
  Caption = #1042#1093#1086#1076' '#1074' '#1089#1080#1089#1090#1077#1084#1091
  ClientHeight = 153
  ClientWidth = 221
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object bvl2: TBevel
    Left = 8
    Top = 96
    Width = 202
    Height = 50
    Shape = bsFrame
  end
  object bvl1: TBevel
    Left = 8
    Top = 8
    Width = 202
    Height = 81
    Shape = bsFrame
  end
  object lbl1: TLabel
    Left = 16
    Top = 24
    Width = 29
    Height = 16
    Caption = #1048#1084#1103':'
  end
  object lbl2: TLabel
    Left = 16
    Top = 63
    Width = 52
    Height = 16
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object btnOk: TBitBtn
    Left = 16
    Top = 112
    Width = 88
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    TabOrder = 0
    OnClick = btnOkClick
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 119
    Top = 112
    Width = 82
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    Kind = bkCancel
  end
  object edPass: TDBEditEh
    Left = 69
    Top = 56
    Width = 134
    Height = 24
    EditButtons = <>
    PasswordChar = '*'
    TabOrder = 2
    Visible = True
  end
  object cbLogin: TDBComboBoxEh
    Left = 69
    Top = 24
    Width = 134
    Height = 24
    EditButtons = <>
    TabOrder = 3
    Text = 'cbLogin'
    Visible = True
    OnCloseUp = cbLoginCloseUp
    OnUpdateData = cbLoginUpdateData
  end
end
