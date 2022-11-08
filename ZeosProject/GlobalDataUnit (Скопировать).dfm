object dmGlobalData: TdmGlobalData
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 459
  Top = 498
  Height = 298
  Width = 473
  object zqrAny: TZQuery
    Params = <>
    Left = 32
    Top = 16
  end
  object zuqEmpty: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 88
    Top = 16
  end
  object zqrImportFiles: TZQuery
    Params = <>
    Left = 32
    Top = 80
  end
  object zqrNKorr: TZQuery
    Connection = dmSimpleClient.conDB
    Params = <>
    Left = 240
    Top = 24
  end
  object zqrCashKeyItem: TZQuery
    Params = <>
    Left = 360
    Top = 32
  end
  object zqrTaxH: TZQuery
    Params = <>
    Left = 240
    Top = 168
  end
  object zqrTaxD: TZQuery
    Params = <>
    Left = 288
    Top = 168
  end
end
