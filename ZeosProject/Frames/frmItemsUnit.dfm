object frmItemsBase: TfrmItemsBase
  Left = 0
  Top = 0
  Width = 250
  Height = 350
  TabOrder = 0
  object tvItems: TTreeView
    Left = 0
    Top = 0
    Width = 250
    Height = 350
    Align = alClient
    Constraints.MinHeight = 350
    Constraints.MinWidth = 200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HideSelection = False
    Images = ilItems
    Indent = 19
    ParentFont = False
    PopupMenu = pmItems
    ReadOnly = True
    TabOrder = 0
    OnCompare = tvItemsCompare
    OnCreateNodeClass = tvItemsCreateNodeClass
    OnCustomDrawItem = tvItemsCustomDrawItem
    OnDragDrop = tvItemsDragDrop
    OnDragOver = tvItemsDragOver
    OnKeyPress = tvItemsKeyPress
    OnMouseDown = tvItemsMouseDown
  end
  object zqrItems: TZQuery
    SQL.Strings = (
      '')
    Params = <>
    Left = 104
    Top = 40
  end
  object pmItems: TPopupMenu
    Left = 80
    Top = 165
    object miN4: TMenuItem
      Caption = '-'
    end
    object miSubShow: TMenuItem
      AutoCheck = True
      Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1093
      Checked = True
      OnClick = miSubShowClick
    end
  end
  object ilItems: TImageList
    Left = 56
    Top = 56
  end
end
