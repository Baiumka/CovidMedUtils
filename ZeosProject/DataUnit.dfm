object dmSimpleClient: TdmSimpleClient
  Tag = 1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 843
  Top = 363
  Height = 266
  Width = 249
  object conDB: TZConnection
    Protocol = 'postgresql-8'
    Left = 16
    Top = 8
  end
  object dsMessages: TDataSource
    DataSet = zqrMessage
    Left = 176
    Top = 56
  end
  object mntrQuery: TZSQLMonitor
    AutoSave = True
    FileName = 'd:\sql.log'
    MaxTraceCount = 100
    OnTrace = mntrQueryTrace
    Left = 16
    Top = 56
  end
  object zqrMessage: TZQuery
    Connection = conDB
    UpdateObject = zuqEmpty
    CachedUpdates = True
    SQL.Strings = (
      '')
    ParamCheck = False
    Params = <>
    Left = 176
    Top = 8
  end
  object zuqEmpty: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 120
    Top = 8
  end
  object zqrAny: TZQuery
    Connection = conDB
    UpdateObject = zuqEmpty
    Params = <>
    Left = 120
    Top = 56
  end
  object zqrRealAccess: TZQuery
    Connection = conDB
    UpdateObject = zuqRealAccess
    SQL.Strings = (
      '')
    Params = <>
    Left = 24
    Top = 112
  end
  object zuqRealAccess: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 24
    Top = 160
  end
  object zsqNextValue: TZSequence
    Connection = conDB
    Left = 160
    Top = 168
  end
  object zqrNextValue: TZQuery
    Connection = conDB
    UpdateObject = zuqEmpty
    CachedUpdates = True
    SQL.Strings = (
      '')
    ParamCheck = False
    Params = <>
    Left = 160
    Top = 120
  end
end
