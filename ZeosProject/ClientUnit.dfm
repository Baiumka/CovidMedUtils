object fmSimpleClient: TfmSimpleClient
  Left = 0
  Top = 224
  Width = 800
  Height = 500
  Caption = #1055#1088#1086#1089#1090#1072#1103' '#1076#1086#1095#1077#1088#1085#1103#1103' '#1092#1086#1088#1084#1072
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCommand: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 32
    Align = alTop
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Color = clGray
    TabOrder = 0
    DesignSize = (
      780
      28)
    object sbtnRefresh: TSpeedButton
      Left = 4
      Top = 2
      Width = 80
      Height = 24
      Action = actRefresh
      Glyph.Data = {
        36080000424D3608000000000000360000002800000020000000100000000100
        2000000000000008000000000000000000000000000000000000FF00FF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FF00FF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FFFFFF0052AD
        FF0018529400185A9C00185A9C00185A9C00185AA500185AA500185A9C00185A
        9C00185294001852940018528C00184A84004AADFF00FFFFFF00FFFFFF00BBBB
        BB005F5F5F006666660066666600666666006969690069696900666666006666
        66005F5F5F005F5F5F005D5D5D0056565600BABABA00FFFFFF00FFFFFF00185A
        A500186BBD001873CE001873CE001873CE001873CE001873CE001873CE001873
        CE001873CE00186BC600186BBD00185AA500104A7B00FFFFFF00FFFFFF006969
        69007A7A7A008484840084848400848484008484840084848400848484008484
        8400848484007D7D7D007A7A7A006969690052525200FFFFFF00FFFFFF001863
        AD001873CE00187BDE00187BDE00187BE700187BE700188CFF00188CFF00188C
        FF00188CFF00187BDE00186BC6001863AD0018528C00FFFFFF00FFFFFF007171
        7100848484008D8D8D008D8D8D009090900090909000A1A1A100A1A1A100A1A1
        A100A1A1A1008D8D8D007D7D7D00717171005D5D5D00FFFFFF00FFFFFF00186B
        C600187BDE001884EF001884EF00FFFFFF00188CFF00ADDEFF00ADDEFF00ADDE
        FF00188CFF001884EF001873CE00186BBD0018529400FFFFFF00FFFFFF007D7D
        7D008D8D8D009898980098989800FFFFFF00A1A1A100E2E2E200E2E2E200E2E2
        E200A1A1A10098989800848484007A7A7A005F5F5F00FFFFFF00FFFFFF001873
        CE00187BE700188CFF00188CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00ADDEFF001884EF001873D600186BC600185A9C00FFFFFF00FFFFFF008484
        840090909000A1A1A100A1A1A100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00E2E2E20098989800868686007D7D7D0066666600FFFFFF00FFFFFF00187B
        DE00188CFF00188CFF00188CFF00FFFFFF00FFFFFF00188CFF00188CFF00188C
        FF00FFFFFF00187BE7001873D6001873CE00185AA500FFFFFF00FFFFFF008D8D
        8D00A1A1A100A1A1A100A1A1A100FFFFFF00FFFFFF00A1A1A100A1A1A100A1A1
        A100FFFFFF0090909000868686008484840069696900FFFFFF00FFFFFF00187B
        E700188CFF00188CFF00188CFF00FFFFFF00FFFFFF00FFFFFF00188CFF00188C
        FF001884EF00187BDE001873CE001873CE001863AD00FFFFFF00FFFFFF009090
        9000A1A1A100A1A1A100A1A1A100FFFFFF00FFFFFF00FFFFFF00A1A1A100A1A1
        A100989898008D8D8D00848484008484840071717100FFFFFF00FFFFFF001884
        EF00188CFF00188CFF00188CFF00188CFF00188CFF00188CFF00188CFF001884
        EF00187BE7001873D6001873CE001873CE001863AD00FFFFFF00FFFFFF009898
        9800A1A1A100A1A1A100A1A1A100A1A1A100A1A1A100A1A1A100A1A1A1009898
        98009090900086868600848484008484840071717100FFFFFF00FFFFFF00188C
        FF002194FF002194FF00188CFF00188CFF00188CFF001884F700FFFFFF00FFFF
        FF00FFFFFF001873CE001873CE001873CE001863AD00FFFFFF00FFFFFF00A1A1
        A100A7A7A700A7A7A700A1A1A100A1A1A100A1A1A1009A9A9A00FFFFFF00FFFF
        FF00FFFFFF0084848400848484008484840071717100FFFFFF00FFFFFF00188C
        FF0039A5FF0039A5FF002194FF00FFFFFF00188CFF00188CFF001884EF00FFFF
        FF00FFFFFF001873D6001873CE001873CE001863AD00FFFFFF00FFFFFF00A1A1
        A100B4B4B400B4B4B400A7A7A700FFFFFF00A1A1A100A1A1A10098989800FFFF
        FF00FFFFFF0086868600848484008484840071717100FFFFFF00FFFFFF002194
        FF0052ADFF004AADFF00299CFF00ADDEFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00187BDE001873CE001873CE001863AD00FFFFFF00FFFFFF00A7A7
        A700BBBBBB00BABABA00ACACAC00E2E2E200FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF008D8D8D00848484008484840071717100FFFFFF00FFFFFF0039A5
        FF006BBDFF0052ADFF0039A5FF00319CFF00ADDEFF00ADDEFF00ADDEFF00188C
        FF00FFFFFF001884EF00187BDE001873CE001863AD00FFFFFF00FFFFFF00B4B4
        B400C7C7C700BBBBBB00B4B4B400ADADAD00E2E2E200E2E2E200E2E2E200A1A1
        A100FFFFFF00989898008D8D8D008484840071717100FFFFFF00FFFFFF004AAD
        FF0084C6FF006BBDFF0052ADFF004AADFF0039A5FF00319CFF00299CFF002194
        FF001894FF00188CFF001884EF001873CE00185A9C00FFFFFF00FFFFFF00BABA
        BA00D0D0D000C7C7C700BBBBBB00BABABA00B4B4B400ADADAD00ACACAC00A7A7
        A700A6A6A600A1A1A100989898008484840066666600FFFFFF00FFFFFF00ADDE
        FF004AADFF00319CFF002194FF00188CFF00188CFF00188CFF00188CFF001884
        EF00187BE700187BDE001873CE00186BBD0063B5FF00FFFFFF00FFFFFF00E2E2
        E200BABABA00ADADAD00A7A7A700A1A1A100A1A1A100A1A1A100A1A1A1009898
        9800909090008D8D8D00848484007A7A7A00C2C2C200FFFFFF00FF00FF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00FF00FF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF00FF00}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
    end
    object lblCalcDate: TLabel
      Left = 670
      Top = 0
      Width = 110
      Height = 28
      Align = alRight
      Alignment = taRightJustify
      AutoSize = False
      Caption = '12 '#1089#1077#1085#1090#1103#1073#1088#1103' 2012  '
      Layout = tlCenter
      OnClick = lblCalcDateClick
    end
    object edtCalcDay: TDBDateTimeEditEh
      Left = 685
      Top = 13
      Width = 87
      Height = 24
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      AutoSize = False
      EditButtons = <>
      TabOrder = 0
      Visible = True
      OnEnter = edtCalcDayEnter
      OnExit = edtCalcDayExit
      OnKeyPress = edtCalcDayKeyPress
      EditFormat = 'MM/YYYY'
    end
  end
  object alBase: TActionList
    Images = ilBase
    Left = 600
    Top = 48
    object actRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1086#1076#1077#1088#1078#1072#1085#1080#1077
      ImageIndex = 0
      ShortCut = 116
      OnExecute = actRefreshExecute
    end
    object actCanselSelected: TAction
      Caption = 'actCanselSelected'
      ShortCut = 16507
      OnExecute = actCanselSelectedExecute
    end
    object actForm: TAction
      Caption = 'actForm'
    end
  end
  object ilBase: TImageList
    Width = 32
    Left = 632
    Top = 48
    Bitmap = {
      494C010103000400040020001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000001000000001002000000000000020
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0052ADFF0018529400185A
      9C00185A9C00185A9C00185AA500185AA500185A9C00185A9C00185294001852
      940018528C00184A84004AADFF00FFFFFF00FFFFFF00BDBDBD005A5A5A006363
      630063636300636363006B6B6B006B6B6B0063636300636363005A5A5A005A5A
      5A005A5A5A0052525200BDBDBD00FFFFFF00FFFFFF0052ADFF0018529400185A
      9C00185A9C00185A9C00185AA500185AA500185A9C00185A9C00185294001852
      940018528C00184A84004AADFF00FFFFFF00FFFFFF00BDBDBD005A5A5A006363
      630063636300636363006B6B6B006B6B6B0063636300636363005A5A5A005A5A
      5A005A5A5A0052525200BDBDBD00FFFFFF00FFFFFF0052ADFF0018529400185A
      9C00185A9C00185A9C00185AA500185AA500185A9C00185A9C00185294001852
      940018528C00184A84004AADFF00FFFFFF00FFFFFF00BDBDBD005A5A5A006363
      630063636300636363006B6B6B006B6B6B0063636300636363005A5A5A005A5A
      5A005A5A5A0052525200BDBDBD00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00185AA500186BBD001873
      CE001873CE001873CE001873CE001873CE001873CE001873CE001873CE00186B
      C600186BBD00185AA500104A7B00FFFFFF00FFFFFF006B6B6B007B7B7B008484
      8400848484008484840084848400848484008484840084848400848484007B7B
      7B007B7B7B006B6B6B0052525200FFFFFF00FFFFFF00185AA500186BBD001873
      CE001873CE001873CE001873CE001873CE001873CE001873CE001873CE00186B
      C600186BBD00185AA500104A7B00FFFFFF00FFFFFF006B6B6B007B7B7B008484
      8400848484008484840084848400848484008484840084848400848484007B7B
      7B007B7B7B006B6B6B0052525200FFFFFF00FFFFFF00185AA500186BBD001873
      CE001873CE001873CE001873CE001873CE001873CE001873CE001873CE00186B
      C600186BBD00185AA500104A7B00FFFFFF00FFFFFF006B6B6B007B7B7B008484
      8400848484008484840084848400848484008484840084848400848484007B7B
      7B007B7B7B006B6B6B0052525200FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001863AD001873CE00187B
      DE00187BDE00187BE700187BE700188CFF00188CFF00188CFF00188CFF00187B
      DE00186BC6001863AD0018528C00FFFFFF00FFFFFF0073737300848484008C8C
      8C008C8C8C009494940094949400A5A5A500A5A5A500A5A5A500A5A5A5008C8C
      8C007B7B7B00737373005A5A5A00FFFFFF00FFFFFF001863AD001873CE00187B
      DE00187BDE00187BE7001884E700188CF700188CF700188CF700188CF700187B
      DE00186BC6001863AD0018528C00FFFFFF00FFFFFF0073737300848484008C8C
      8C008C8C8C0094949400949494009C9C9C009C9C9C009C9C9C009C9C9C008C8C
      8C007B7B7B00737373005A5A5A00FFFFFF00FFFFFF001863AD001873CE00187B
      DE00187BDE00187BE7001884E700188CF700188CF700188CF700188CF700187B
      DE00186BC6001863AD0018528C00FFFFFF00FFFFFF0073737300848484008C8C
      8C008C8C8C0094949400949494009C9C9C009C9C9C009C9C9C009C9C9C008C8C
      8C007B7B7B00737373005A5A5A00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00186BC600187BDE001884
      EF001884EF00FFFFFF00188CFF00ADDEFF00ADDEFF00ADDEFF00188CFF001884
      EF001873CE00186BBD0018529400FFFFFF00FFFFFF007B7B7B008C8C8C009C9C
      9C009C9C9C00FFFFFF00A5A5A500E7E7E700E7E7E700E7E7E700A5A5A5009C9C
      9C00848484007B7B7B005A5A5A00FFFFFF00FFFFFF00186BC600187BDE001884
      EF001884EF001884EF0084C6FF00188CF700188CF700188CF700188CF7001884
      E7001873CE00186BBD0018529400FFFFFF00FFFFFF007B7B7B008C8C8C009C9C
      9C009C9C9C009C9C9C00D6D6D6009C9C9C009C9C9C009C9C9C009C9C9C009494
      9400848484007B7B7B005A5A5A00FFFFFF00FFFFFF00186BC600187BDE001884
      EF00FFFFFF0084C6FF00188CF700188CF700188CF700188CF70084C6FF00FFFF
      FF001873CE00186BBD0018529400FFFFFF00FFFFFF007B7B7B008C8C8C009C9C
      9C00FFFFFF00D6D6D6009C9C9C009C9C9C009C9C9C009C9C9C00D6D6D600FFFF
      FF00848484007B7B7B005A5A5A00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001873CE00187BE700188C
      FF00188CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ADDEFF001884
      EF001873D600186BC600185A9C00FFFFFF00FFFFFF008484840094949400A5A5
      A500A5A5A500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E7E7E7009C9C
      9C00848484007B7B7B0063636300FFFFFF00FFFFFF001873CE001884E700188C
      F700188CFF0084C6FF00FFFFFF0084C6FF00188CF700188CF700188CF7001884
      E7001873D600186BC600185A9C00FFFFFF00FFFFFF0084848400949494009C9C
      9C00A5A5A500D6D6D600FFFFFF00D6D6D6009C9C9C009C9C9C009C9C9C009494
      9400848484007B7B7B0063636300FFFFFF00FFFFFF001873CE001884E700188C
      F700188CFF00FFFFFF0084C6FF00188CF700188CF70084C6FF00FFFFFF001884
      E7001873D600186BC600185A9C00FFFFFF00FFFFFF0084848400949494009C9C
      9C00A5A5A500FFFFFF00D6D6D6009C9C9C009C9C9C00D6D6D600FFFFFF009494
      9400848484007B7B7B0063636300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00187BDE00188CFF00188C
      FF00188CFF00FFFFFF00FFFFFF00188CFF00188CFF00188CFF00FFFFFF00187B
      E7001873D6001873CE00185AA500FFFFFF00FFFFFF008C8C8C00A5A5A500A5A5
      A500A5A5A500FFFFFF00FFFFFF00A5A5A500A5A5A500A5A5A500FFFFFF009494
      940084848400848484006B6B6B00FFFFFF00FFFFFF00187BDE00188CF700188C
      FF0084C6FF00FFFFFF0084C6FF00FFFFFF0084C6FF00188CF700188CF7001884
      E7001873D6001873CE00185AA500FFFFFF00FFFFFF008C8C8C009C9C9C00A5A5
      A500D6D6D600FFFFFF00D6D6D600FFFFFF00D6D6D6009C9C9C009C9C9C009494
      940084848400848484006B6B6B00FFFFFF00FFFFFF00187BDE00188CF700188C
      FF00188CF700188CF700FFFFFF0084C6FF0084C6FF00FFFFFF00188CF7001884
      E7001873D6001873CE00185AA500FFFFFF00FFFFFF008C8C8C009C9C9C00A5A5
      A5009C9C9C009C9C9C00FFFFFF00D6D6D600D6D6D600FFFFFF009C9C9C009494
      940084848400848484006B6B6B00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00187BE700188CFF00188C
      FF00188CFF00FFFFFF00FFFFFF00FFFFFF00188CFF00188CFF001884EF00187B
      DE001873CE001873CE001863AD00FFFFFF00FFFFFF0094949400A5A5A500A5A5
      A500A5A5A500FFFFFF00FFFFFF00FFFFFF00A5A5A500A5A5A5009C9C9C008C8C
      8C00848484008484840073737300FFFFFF00FFFFFF001884E700188CFF0084C6
      FF00FFFFFF0084C6FF00188CF700188CF700FFFFFF0084C6FF001884EF00187B
      DE001873CE001873CE001863AD00FFFFFF00FFFFFF0094949400A5A5A500D6D6
      D600FFFFFF00D6D6D6009C9C9C009C9C9C00FFFFFF00D6D6D6009C9C9C008C8C
      8C00848484008484840073737300FFFFFF00FFFFFF001884E700188CFF00188C
      F700188CF700188CF700188CF700FFFFFF0084C6FF00188CF7001884EF00187B
      DE001873CE001873CE001863AD00FFFFFF00FFFFFF0094949400A5A5A5009C9C
      9C009C9C9C009C9C9C009C9C9C00FFFFFF00D6D6D6009C9C9C009C9C9C008C8C
      8C00848484008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001884EF00188CFF00188C
      FF00188CFF00188CFF00188CFF00188CFF00188CFF001884EF00187BE7001873
      D6001873CE001873CE001863AD00FFFFFF00FFFFFF009C9C9C00A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A500A5A5A500A5A5A5009C9C9C00949494008484
      8400848484008484840073737300FFFFFF00FFFFFF001884EF00188CFF00188C
      FF0084C6FF00188CF700188CF700188CF700188CF700FFFFFF0084C6FF001873
      D6001873CE001873CE001863AD00FFFFFF00FFFFFF009C9C9C00A5A5A500A5A5
      A500D6D6D6009C9C9C009C9C9C009C9C9C009C9C9C00FFFFFF00D6D6D6008484
      8400848484008484840073737300FFFFFF00FFFFFF001884EF00188CFF00188C
      FF00188CF700188CF70084C6FF00FFFFFF00FFFFFF0084C6FF001884E7001873
      D6001873CE001873CE001863AD00FFFFFF00FFFFFF009C9C9C00A5A5A500A5A5
      A5009C9C9C009C9C9C00D6D6D600FFFFFF00FFFFFF00D6D6D600949494008484
      8400848484008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00188CFF002194FF002194
      FF00188CFF00188CFF00188CFF001884F700FFFFFF00FFFFFF00FFFFFF001873
      CE001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A500A5A5A5009C9C9C00FFFFFF00FFFFFF00FFFFFF008484
      8400848484008484840073737300FFFFFF00FFFFFF00188CFF002194FF002194
      FF00188CFF00188CFF00188CF7001884F7001884EF001884EF00FFFFFF0084C6
      FF001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500A5A5A500A5A5
      A500A5A5A500A5A5A5009C9C9C009C9C9C009C9C9C009C9C9C00FFFFFF00D6D6
      D600848484008484840073737300FFFFFF00FFFFFF00188CFF002194FF002194
      FF00188CFF0084C6FF00FFFFFF001884F7001884EF00FFFFFF0084C6FF001873
      CE001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500A5A5A500A5A5
      A500A5A5A500D6D6D600FFFFFF009C9C9C009C9C9C00FFFFFF00D6D6D6008484
      8400848484008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00188CFF0039A5FF0039A5
      FF002194FF00FFFFFF00188CFF00188CFF001884EF00FFFFFF00FFFFFF001873
      D6001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500B5B5B500B5B5
      B500A5A5A500FFFFFF00A5A5A500A5A5A5009C9C9C00FFFFFF00FFFFFF008484
      8400848484008484840073737300FFFFFF00FFFFFF00188CFF0039A5FF0039A5
      FF002194FF001894FF00188CFF00188CFF001884EF001884E700187BDE00FFFF
      FF0084C6FF001873CE001863AD00FFFFFF00FFFFFF00A5A5A500B5B5B500B5B5
      B500A5A5A500A5A5A500A5A5A500A5A5A5009C9C9C00949494008C8C8C00FFFF
      FF00D6D6D6008484840073737300FFFFFF00FFFFFF00188CFF0039A5FF0039A5
      FF0084C6FF00FFFFFF00188CFF00188CFF001884EF001884E700FFFFFF0084C6
      FF001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500B5B5B500B5B5
      B500D6D6D600FFFFFF00A5A5A500A5A5A5009C9C9C0094949400FFFFFF00D6D6
      D600848484008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF002194FF0052ADFF004AAD
      FF00299CFF00ADDEFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00187B
      DE001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500BDBDBD00BDBD
      BD00ADADAD00E7E7E700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008C8C
      8C00848484008484840073737300FFFFFF00FFFFFF002194FF0052ADFF004AAD
      FF00299CFF002194FF002194FF001894FF00188CF7001884EF001884E700187B
      DE00FFFFFF001873CE001863AD00FFFFFF00FFFFFF00A5A5A500BDBDBD00BDBD
      BD00ADADAD00A5A5A500A5A5A500A5A5A5009C9C9C009C9C9C00949494008C8C
      8C00FFFFFF008484840073737300FFFFFF00FFFFFF002194FF0052ADFF004AAD
      FF00FFFFFF002194FF002194FF001894FF00188CF7001884EF001884E700FFFF
      FF001873CE001873CE001863AD00FFFFFF00FFFFFF00A5A5A500BDBDBD00BDBD
      BD00FFFFFF00A5A5A500A5A5A500A5A5A5009C9C9C009C9C9C0094949400FFFF
      FF00848484008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0039A5FF006BBDFF0052AD
      FF0039A5FF00319CFF00ADDEFF00ADDEFF00ADDEFF00188CFF00FFFFFF001884
      EF00187BDE001873CE001863AD00FFFFFF00FFFFFF00B5B5B500C6C6C600BDBD
      BD00B5B5B500ADADAD00E7E7E700E7E7E700E7E7E700A5A5A500FFFFFF009C9C
      9C008C8C8C008484840073737300FFFFFF00FFFFFF0039A5FF006BBDFF0052AD
      FF0039A5FF00319CFF00299CFF00299CFF002194FF00188CFF001884F7001884
      EF00187BDE001873CE001863AD00FFFFFF00FFFFFF00B5B5B500C6C6C600BDBD
      BD00B5B5B500ADADAD00ADADAD00ADADAD00A5A5A500A5A5A5009C9C9C009C9C
      9C008C8C8C008484840073737300FFFFFF00FFFFFF0039A5FF006BBDFF0052AD
      FF0039A5FF00319CFF00299CFF00299CFF002194FF00188CFF001884F7001884
      EF00187BDE001873CE001863AD00FFFFFF00FFFFFF00B5B5B500C6C6C600BDBD
      BD00B5B5B500ADADAD00ADADAD00ADADAD00A5A5A500A5A5A5009C9C9C009C9C
      9C008C8C8C008484840073737300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF004AADFF0084C6FF006BBD
      FF0052ADFF004AADFF0039A5FF00319CFF00299CFF002194FF001894FF00188C
      FF001884EF001873CE00185A9C00FFFFFF00FFFFFF00BDBDBD00D6D6D600C6C6
      C600BDBDBD00BDBDBD00B5B5B500ADADAD00ADADAD00A5A5A500A5A5A500A5A5
      A5009C9C9C008484840063636300FFFFFF00FFFFFF004AADFF0084C6FF006BBD
      FF0052ADFF004AADFF0039A5FF00319CFF00299CFF002194FF001894FF00188C
      F7001884EF001873CE00185A9C00FFFFFF00FFFFFF00BDBDBD00D6D6D600C6C6
      C600BDBDBD00BDBDBD00B5B5B500ADADAD00ADADAD00A5A5A500A5A5A5009C9C
      9C009C9C9C008484840063636300FFFFFF00FFFFFF004AADFF0084C6FF006BBD
      FF0052ADFF004AADFF0039A5FF00319CFF00299CFF002194FF001894FF00188C
      F7001884EF001873CE00185A9C00FFFFFF00FFFFFF00BDBDBD00D6D6D600C6C6
      C600BDBDBD00BDBDBD00B5B5B500ADADAD00ADADAD00A5A5A500A5A5A5009C9C
      9C009C9C9C008484840063636300FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00ADDEFF004AADFF00319C
      FF002194FF00188CFF00188CFF00188CFF00188CFF001884EF00187BE700187B
      DE001873CE00186BBD0063B5FF00FFFFFF00FFFFFF00E7E7E700BDBDBD00ADAD
      AD00A5A5A500A5A5A500A5A5A500A5A5A500A5A5A5009C9C9C00949494008C8C
      8C00848484007B7B7B00C6C6C600FFFFFF00FFFFFF00ADDEFF004AADFF00319C
      FF002194FF00188CFF00188CFF00188CF700188CF7001884EF001884E700187B
      DE001873CE00186BBD0063B5FF00FFFFFF00FFFFFF00E7E7E700BDBDBD00ADAD
      AD00A5A5A500A5A5A500A5A5A5009C9C9C009C9C9C009C9C9C00949494008C8C
      8C00848484007B7B7B00C6C6C600FFFFFF00FFFFFF00ADDEFF004AADFF00319C
      FF002194FF00188CFF00188CFF00188CF700188CF7001884EF001884E700187B
      DE001873CE00186BBD0063B5FF00FFFFFF00FFFFFF00E7E7E700BDBDBD00ADAD
      AD00A5A5A500A5A5A500A5A5A5009C9C9C009C9C9C009C9C9C00949494008C8C
      8C00848484007B7B7B00C6C6C600FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000100000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0080018001800180018001800100000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8001800180018001800180010000000000000000000000000000000000000000
      000000000000}
  end
end
