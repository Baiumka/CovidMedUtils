object fmDateBetween: TfmDateBetween
  Left = 490
  Top = 291
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076#1072'?'
  ClientHeight = 86
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object lbl1: TLabel
    Left = 112
    Top = 20
    Width = 12
    Height = 16
    Caption = '---'
  end
  object btnOk: TBitBtn
    Left = 27
    Top = 56
    Width = 89
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100
    TabOrder = 0
    OnClick = btnOkClick
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 123
    Top = 56
    Width = 89
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    Kind = bkCancel
  end
  object edt1: TDBDateTimeEditEh
    Left = 8
    Top = 16
    Width = 100
    Height = 24
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 2
    Visible = True
  end
  object edt2: TDBDateTimeEditEh
    Left = 128
    Top = 16
    Width = 100
    Height = 24
    EditButtons = <>
    Kind = dtkDateEh
    TabOrder = 3
    Visible = True
  end
end
