inherited fmUserRole: TfmUserRole
  Left = 319
  Top = 219
  Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' '#1080' '#1088#1086#1083#1077#1081
  Icon.Data = {
    0000010001001010000001002000680400001600000028000000100000002000
    0000010020000000000000000000130B0000130B000000000000000000000000
    00040000001A0000003E00000060000000750000007F00000080000000780000
    006700000049000000240000000A000000010000000000000000000000000000
    001A01000071050203C90B0304EA0F0006F30F0008F6090008F0060102E00100
    01C7000000990000005E0000002D000000180000001000000008000000020502
    067459314BF9AC5880FFC52D74FFBD0C5FFFB30B62FFAD065FFF90094FFF4D06
    26FD080508DB0101019E010000740000005E0000004D00000035000000195816
    3AF3FFD6EBFFFBC7D8FFEB668DFFF6B0CAFFF5BED6FFC8397CFFCF1766FFE633
    82FF4A0E25F8000501DC020502D1000200C4000000A9000000850000004C4501
    24B2E1508DFFE25A84FFC05683FFD3F0F7FFD4EDEFFFCD8AA3FFED437BFFC83E
    72FF215311FF027B04FF028405FF016105FE012203F5000101D0000000753C00
    2D1E6D0033E2991E65FF2A6DA2FF0681AEFF066B9BFF4278A2FFC46F9DFF6F6E
    4EFF07BA1FFF0FCD24FF17C12DFF18CE35FF2ACE44FF041606F6000000700000
    00000D092394235D87FF52E2F7FF24ADDBFF07A0D7FF06A1D6FF176692FF2772
    40FF22A231FF1E9121FF3CC44EFF4DD770FF58E881FF041605E6000000480022
    2A0500222FD61A6074FFA4E6F6FF69D3FAFF3DB8E8FF41C4F7FF1881B2FF0329
    36FF0A495DFF045059FF399774FF84EF9FFF2B9D38FD0105028F000000200024
    3605002A3EE6043C5EFF3D7381FF8BE2F9FF89E5FEFF6BD5FCFF2F93BFFF032A
    45FF0F78B3FF0894E2FF0667BAFF28795EFE1B3515CC00000052000000100029
    3C04002837C9004871FF022945FF3D687EFFB8E2EEFFD1FAFFFF5197B8FF0326
    3AFF399FC2FF40D0FBFF28BBF6FF005289FE0C0B0DB50000005500000013001F
    3004002130AD004B6AFF004368FF032C49FF37586AFF789EB1FF24526DFF0626
    3AFF5AB1D3FF6ECFF8FF56DEFDFF0976C5FF020408C90000005E00000017004C
    700200476D52004767FF004464FF004165FF002E48FF06354AFF03273CFF457E
    92FFB2EFFBFFDAFAFFFFA0F0FFFF0C47A1FF000106CD00000058000000130000
    000000557E0A0043649700415BFF013C57FF003549FF00293FFF0C608BFF308E
    C1FF438CBAFF749FC7FF61AED7FF0848A2FF000207BA000000410000000A0000
    0000000000000044660B00568156035879BF02426AAC002262C70B71B3FF6FC0
    E3FFC7DAE4FF93BCD5FF2DACDDFF015591FD0002047B0000001F000000030000
    0000000000000000000000598A030353740B02426D0A00165A2D065B98E739C5
    E5FF6BD9F2FF60DBF3FF1E91D2FF010E25AA0000002C00000007000000000000
    00000000000000000000000000000000000000000000001E65010031761F0143
    83AE005F98F8024B8FE501081D780000051D000000050000000000000000FDFF
    FFFFC03FFFFF801FFFFF0001FFFF0001FFFF8001FFFF8001FFFF8001FFFF8003
    FFFF8003FFFF8003FFFFC003FFFFC003FFFFF007FFFFFE07FFFFFF1FFFFF}
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlCommand: TPanel
    inherited edtCalcDay: TDBDateTimeEditEh
      EditFormat = 'DD/MM/YYYY'
    end
  end
  object pgcMain: TPageControl [1]
    Left = 0
    Top = 32
    Width = 784
    Height = 429
    ActivePage = tsUsers
    Align = alClient
    TabOrder = 1
    object tsUsers: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      object dbgUsers: TDBGridEh
        Left = 0
        Top = 26
        Width = 776
        Height = 214
        Align = alClient
        DataSource = dsUsers
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        OnGetCellParamsEh = dbgUsersGetCellParamsEh
        Columns = <
          item
            AutoFitColWidth = False
            Color = clInfoBk
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Caption = #1089#1083#1091#1078'. #'
            Width = 55
          end
          item
            EditButtons = <
              item
                ShortCut = 0
                Style = ebsEllipsisEh
                OnClick = dbgUsersColumns1EditButtons0Click
              end>
            FieldName = 'fio'
            Footers = <>
            Title.Caption = #1060#1048#1054
            Width = 120
          end
          item
            EditButtons = <>
            FieldName = 'login'
            Footers = <>
            Title.Caption = #1051#1086#1075#1080#1085
            Width = 80
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'pass'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Lucida Console'
            Font.Style = []
            Footers = <>
            PopupMenu = pmPassword
            ReadOnly = True
            Title.Caption = #1055#1072#1088#1086#1083#1100
            Width = 160
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'job'
            Footers = <>
            Title.Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            Width = 160
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'phone'
            Footers = <>
            Title.Caption = #1058#1077#1083#1077#1092
            Width = 70
          end
          item
            Checkboxes = True
            EditButtons = <>
            FieldName = 'active'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            Title.Caption = #1044#1086#1089#1090'.'
            Width = 50
          end
          item
            Checkboxes = True
            DblClickNextVal = True
            EditButtons = <>
            FieldName = 'is_prog'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            NotInKeyListIndex = 1
            Title.Caption = #1040#1076#1084#1080#1085
            Width = 50
          end>
      end
      object grpExtra: TGroupBox
        Left = 351
        Top = 59
        Width = 235
        Height = 163
        Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
        TabOrder = 1
        OnExit = grpExtraExit
        object lbl5: TLabel
          Left = 3
          Top = 14
          Width = 88
          Height = 13
          Caption = #1060#1048#1054' '#1085#1072' '#1088#1091#1089#1089#1082#1086#1084
        end
        object lbl7: TLabel
          Left = 3
          Top = 85
          Width = 106
          Height = 13
          Caption = #1060#1048#1054' '#1085#1072' '#1072#1085#1075#1083#1080#1081#1089#1082#1086#1084
        end
        object lbl8: TLabel
          Left = 3
          Top = 50
          Width = 119
          Height = 13
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1085#1072' '#1088#1091#1089#1089#1082#1086#1084
        end
        object lbl9: TLabel
          Left = 3
          Top = 121
          Width = 137
          Height = 13
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1085#1072' '#1072#1085#1075#1083#1080#1081#1089#1082#1086#1084
        end
        object edFioR: TDBEditEh
          Left = 3
          Top = 28
          Width = 225
          Height = 21
          DataField = 'fio_r'
          DataSource = dsUsers
          EditButtons = <>
          TabOrder = 0
          Visible = True
        end
        object edJobR: TDBEditEh
          Left = 3
          Top = 64
          Width = 225
          Height = 21
          DataField = 'job_r'
          DataSource = dsUsers
          EditButtons = <>
          TabOrder = 1
          Visible = True
        end
        object edFioA: TDBEditEh
          Left = 3
          Top = 100
          Width = 225
          Height = 21
          DataField = 'fio_a'
          DataSource = dsUsers
          EditButtons = <>
          TabOrder = 2
          Visible = True
        end
        object edJobA: TDBEditEh
          Left = 3
          Top = 136
          Width = 225
          Height = 21
          DataField = 'job_a'
          DataSource = dsUsers
          EditButtons = <>
          TabOrder = 3
          Visible = True
        end
      end
      object pgcUserExtra: TPageControl
        Left = 0
        Top = 240
        Width = 776
        Height = 161
        ActivePage = tsUserRole
        Align = alBottom
        TabOrder = 2
        object tsUserRole: TTabSheet
          Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1075#1088#1091#1087#1087#1091
          DesignSize = (
            768
            133)
          object dbgUserRole: TDBGridEh
            Left = 11
            Top = 27
            Width = 361
            Height = 105
            Anchors = [akLeft, akBottom]
            AutoFitColWidths = True
            DataSource = dsUserRole
            FooterColor = clWindow
            FooterFont.Charset = DEFAULT_CHARSET
            FooterFont.Color = clWindowText
            FooterFont.Height = -11
            FooterFont.Name = 'MS Sans Serif'
            FooterFont.Style = []
            Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
            OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            UseMultiTitle = True
            Columns = <
              item
                Color = clInfoBk
                EditButtons = <>
                FieldName = 'id'
                Footers = <>
                Title.Caption = #1089#1083#1091#1078'. #'
                Width = 65
              end
              item
                DropDownBox.Columns = <
                  item
                    AutoFitColWidth = False
                    FieldName = 'id'
                    Title.Caption = #1089#1083#1091#1078'. #'
                    Width = 60
                  end
                  item
                    FieldName = 'name'
                    Title.Caption = #1048#1084#1103' '#1075#1088#1091#1087#1087#1099
                    Width = 100
                  end>
                DropDownBox.UseMultiTitle = True
                DropDownShowTitles = True
                DropDownWidth = 350
                EditButtons = <>
                FieldName = 'u_name'
                Footers = <>
                LookupDisplayFields = 'name;id'
                Title.Caption = #1048#1084#1103' '#1075#1088#1091#1087#1087#1099
                Width = 250
              end>
          end
          object dbnvUserRole: TDBNewNav
            Left = 11
            Top = 2
            Width = 160
            Height = 21
            DataSource = dsUserRole
            VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert, nbDelete, nbPost, nbCancel]
            Anchors = [akLeft, akBottom]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
        end
      end
      object pnlUserTop: TPanel
        Left = 0
        Top = 0
        Width = 776
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        object btnExtra: TSpeedButton
          Left = 208
          Top = 2
          Width = 20
          Height = 20
          Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
          Glyph.Data = {
            36060000424D3606000000000000360000002800000020000000100000000100
            1800000000000006000000000000000000000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            C6C6C68484848484848484848484848484848484848484848484848484848484
            84848484848484848484FF00FFFF00FFC6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FF00FFFF00FF
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
            C6C6C6C6C6C6C6848484FF00FFFF00FFC6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFC6C6C6848484FF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFF000000FFFFFF8484848484848484848484848484848484848484
            84FFFFFFC6C6C6848484FF00FFFF00FFC6C6C6FFFFFFC6C6C6FFFFFFC6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFC6C6C6848484FF00FFFF00FFC6C6C6C6C6C6C6C6C6C6C6C6FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6000000FFFFFF0000000000008484848484848484848484848484848484
            84FFFFFFC6C6C6848484FF00FFFF00FFC6C6C6C6C6C6FFFFFFC6C6C6C6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFC6C6C6848484FF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFC6C6C6C6
            C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFF000000FFFFFF8484848484848484848484848484848484848484
            84FFFFFFC6C6C6848484FF00FFFF00FFC6C6C6FFFFFFC6C6C6FFFFFFC6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFC6C6C6848484FF00FFFF00FFC6C6C6C6C6C6C6C6C6C6C6C6FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6000000FFFFFF0000000000008484848484848484848484848484848484
            84FFFFFFC6C6C6848484FF00FFFF00FFC6C6C6C6C6C6FFFFFFC6C6C6C6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFC6C6C6848484FF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFC6C6C6C6
            C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFF848484848484848484848484848484FFFFFF8484
            84848484848484848484FF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFC6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6FFFFFFC6C6C6C6C6C6C6C6C6C6C6C6FF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6
            C6FFFFFF848484FF00FFFF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6FFFFFFC6C6C6FF00FFFF00FFFF00FF
            C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6
            C6848484FF00FFFF00FFFF00FFFF00FFC6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFC6C6C6C6C6C6FF00FFFF00FFFF00FFFF00FF
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
            C6FF00FFFF00FFFF00FFFF00FFFF00FFC6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6
            C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6C6FF00FFFF00FFFF00FF}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = btnExtraClick
        end
        object dbnvUsers: TDBNewNav
          Left = 5
          Top = 2
          Width = 200
          Height = 20
          DataSource = dsUsers
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
      end
    end
    object tsRoles: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082' '#1075#1088#1091#1087#1087
      ImageIndex = 1
      DesignSize = (
        776
        401)
      object lbl6: TLabel
        Left = 2
        Top = 7
        Width = 37
        Height = 13
        Caption = #1043#1088#1091#1087#1087#1099
      end
      object lbl3: TLabel
        Left = 2
        Top = 253
        Width = 156
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' '#1075#1088#1091#1087#1087#1099
      end
      object dbnvRoles: TDBNewNav
        Left = 46
        Top = 3
        Width = 200
        Height = 21
        DataSource = dsRoles
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object dbnvRoleUser: TDBNewNav
        Left = 162
        Top = 250
        Width = 80
        Height = 20
        DataSource = dsRoleUser
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Anchors = [akLeft, akBottom]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object dbgRoleUser: TDBGridEh
        Left = 2
        Top = 272
        Width = 632
        Height = 131
        Anchors = [akLeft, akRight, akBottom]
        AutoFitColWidths = True
        DataSource = dsRoleUser
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
        TabOrder = 2
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        Columns = <
          item
            AutoFitColWidth = False
            Color = clInfoBk
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Caption = #1089#1083#1091#1078'. #'
            Width = 66
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
            Width = 200
          end
          item
            AutoFitColWidth = False
            EditButtons = <>
            FieldName = 'phone'
            Footers = <>
            Title.Caption = #1058#1077#1083#1077#1092
            Width = 70
          end>
      end
      object dbgRoles: TDBGridEh
        Left = 2
        Top = 26
        Width = 632
        Height = 222
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = dsRoles
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        Columns = <
          item
            Color = clInfoBk
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Caption = #1089#1083#1091#1078'. #'
            Width = 65
          end
          item
            EditButtons = <>
            FieldName = 'name'
            Footers = <>
            Title.Caption = #1048#1084#1103' '#1075#1088#1091#1087#1087#1099
            Width = 250
          end>
      end
    end
    object tsAccess: TTabSheet
      Caption = #1044#1086#1089#1090#1091#1087#1099
      ImageIndex = 2
      DesignSize = (
        776
        401)
      object lbl4: TLabel
        Left = 7
        Top = 0
        Width = 121
        Height = 13
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1080' '#1075#1088#1091#1087#1087#1099
      end
      object sbtnRefreshForms: TSpeedButton
        Left = 613
        Top = 13
        Width = 19
        Height = 18
        Anchors = [akTop, akRight]
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          08000000000000010000750A0000750A00000001000000000000F5F5F500FDFD
          FD00FBFBFB00F8F8F800D7D7D700FCFCFC00C5C5C50087878700CCCCCC00B0B0
          B000EFEFEF00EDEDED00212B23000E6F1E0031523600101F13002A482E00058C
          16008A8A8A0004991800047014006161610047584B00104B1B004F5E52000154
          10002188320005CF1E00BBC3BD00E7E7E70005B91D0006DE2000E1E1E10004A1
          19000E931F0006AB1B00049F18000F601B00C4C4C40052525200049A1800193D
          1F007C857E0002310C009A9A9A00ECECEC00686868000CF72A005C806200585B
          59000A6B1B0006731400E6E6E600616762006A776D007B847D0009611700666B
          670024662D0005AD1A00B6BCB80002560F008E8E8E000B6C1900CDCFCE00DDDD
          DD0071727200F9FAF900D9D9D9000EFF2E00B6C2B9000B5D1A0015FD350018EF
          370017E235003A684000EEEEEE008282820009641900082D0F00335A3C001D2B
          2000D3D3D300114C1C000B761B002A2A2A00025C11003050360005AC1A000E6D
          1C0059605A0004C91D00252B27008B8B8B00161D180074757500233326000AC7
          22001D512600D6D6D60064686500059B19007777770052565200E8E8E8000036
          0C00ADB5AF009C9C9C0015F1320036633E006262620044484500036010004747
          47000B4E1600969997000AEF2500A1A1A10015992A0005E42000096016001C30
          1F002F6D3800A2A5A30004D91D004C4C4C0027A43B00616362002F7A3C005454
          540005C91E00E0E0E000BAC2BC0003661000025210000F781F0009BD20001850
          24001C231E003C3F3D00B9BBB900B4B4B400E3E3E3006F7C72003B403D002A2B
          2A00AAAAAA0004A51B00818783006871690004BC1B0005E11E00087D18005D5E
          5D00CBCBCB00151D170005CC1E00026B1200161A170006390F00888888001A2E
          1E00025E1100A4A4A4006C6C6C00FFFFFF000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000A5A5A5A5A501
          8E0975060B01A5A5A5A5A5A5A5A5031D185C7D07264C01A5A5A5A5A5A5000412
          89475E715D0800A5A5A5A5A503063179544A0D9E8192200001A5A5A563169D21
          822F49878B2C8D082DA5A5A53714961B9C7C4576357F6E3E9A00A5A54B281378
          3F5B229536178A27A334A5A53A11726F62595A6B2A382B910704A5A57A8551A4
          8F6490995F25869B6652A5A5303DA12EA0579F556098A20F4D41A5A51C532915
          1023704F3365560C090AA5A54384946D61973B24589369428302A5A5A5A54080
          6C74771F1E19394403A5A5A5A5A5026A1A48884E0E736802A5A5A5A5A5A5A505
          3C7E32678C0AA5A5A5A5A5A5A5A5A5A5A546507B0B05A5A5A5A5}
        OnClick = sbtnRefreshFormsClick
      end
      object dbgAll: TDBGridEh
        Left = 7
        Top = 39
        Width = 190
        Height = 363
        AllowedOperations = []
        Anchors = [akLeft, akTop, akBottom]
        AutoFitColWidths = True
        DataSource = dsAll
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        OnGetCellParamsEh = dbgAllGetCellParamsEh
        Columns = <
          item
            AutoFitColWidth = False
            Color = clInfoBk
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Caption = #1089#1083#1091#1078'. #'
            Width = 55
          end
          item
            EditButtons = <>
            FieldName = 'fio'
            Footers = <>
            Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            ToolTips = True
            Width = 100
          end>
      end
      object dbgAccess: TDBGridEh
        Left = 203
        Top = 37
        Width = 570
        Height = 364
        AllowedOperations = [alopUpdateEh]
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoFitColWidths = True
        ColumnDefValues.ToolTips = True
        DataSource = dsAccess
        FooterColor = clWindow
        FooterFont.Charset = DEFAULT_CHARSET
        FooterFont.Color = clWindowText
        FooterFont.Height = -11
        FooterFont.Name = 'MS Sans Serif'
        FooterFont.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs]
        OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghIncSearch, dghPreferIncSearch, dghDialogFind, dghDialogColumnEdit, dghNoColumnMove]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        Columns = <
          item
            Color = clInfoBk
            EditButtons = <>
            FieldName = 'id'
            Footers = <>
            Title.Caption = #1089#1083#1091#1078'. #'
            Visible = False
            Width = 55
          end
          item
            EditButtons = <>
            FieldName = 'formname'
            Footers = <>
            ReadOnly = True
            Title.Caption = #1060#1086#1088#1084#1072
            Width = 140
          end
          item
            EditButtons = <>
            FieldName = 'caption'
            Footers = <>
            ReadOnly = True
            Title.Caption = #1048#1084#1103' '#1082#1086#1085#1090#1088#1086#1083#1072
            Width = 100
          end
          item
            AutoFitColWidth = False
            Checkboxes = True
            DblClickNextVal = True
            EditButtons = <>
            FieldName = 'enable'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099'|'#1044#1086#1089#1090#1091#1087#1085#1086#1089#1090#1100
            Width = 80
          end
          item
            AutoFitColWidth = False
            Checkboxes = True
            DblClickNextVal = True
            EditButtons = <>
            FieldName = 'visible'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099'|'#1042#1080#1076#1080#1084#1086#1089#1090#1100
            Width = 80
          end
          item
            AutoFitColWidth = False
            Checkboxes = True
            DblClickNextVal = True
            EditButtons = <>
            FieldName = 'readonly'
            Footers = <>
            KeyList.Strings = (
              '1'
              '0')
            Title.Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099'|'#1058#1086#1083#1100#1082#1086' '#1095#1090#1077#1085#1080#1077
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'name'
            Footers = <>
            ReadOnly = True
            Title.Caption = #1048#1084#1103' '#1082#1086#1085#1090#1088#1086#1083#1072
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'fullname'
            Footers = <>
            ReadOnly = True
            Visible = False
            Width = 120
          end
          item
            EditButtons = <>
            FieldName = 'fmname'
            Footers = <>
            ReadOnly = True
            Visible = False
            Width = 120
          end>
      end
      object dbnvAll: TDBNewNav
        Left = 7
        Top = 13
        Width = 100
        Height = 20
        DataSource = dsAll
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbRefresh]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object cbfmName: TDBComboBoxEh
        Left = 203
        Top = 11
        Width = 569
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditButtons = <>
        TabOrder = 3
        Visible = True
        OnChange = cbfmNameChange
        OnKeyPress = cbfmNameKeyPress
      end
    end
  end
  object zuqRoles: TZUpdateSQL
    UseSequenceFieldForRefreshSQL = False
    Left = 76
    Top = 132
  end
  object dsRoles: TDataSource
    DataSet = zqrRoles
    Left = 44
    Top = 164
  end
  object zqrRoles: TZQuery
    AfterScroll = zqrRolesAfterScroll
    UpdateObject = zuqRoles
    BeforePost = zqrRolesBeforePost
    SQL.Strings = (
      '')
    Params = <>
    Left = 76
    Top = 164
  end
  object dsUsers: TDataSource
    DataSet = zqrUsers
    Left = 44
    Top = 196
  end
  object zqrUsers: TZQuery
    SortedFields = 'fio'
    AfterScroll = zqrUsersAfterScroll
    UpdateObject = zuqUsers
    BeforePost = zqrUsersBeforePost
    SQL.Strings = (
      '')
    Params = <>
    IndexFieldNames = 'fio Asc'
    Left = 76
    Top = 196
  end
  object zqrAll: TZQuery
    AfterScroll = zqrAllAfterScroll
    SQL.Strings = (
      '')
    Params = <>
    Left = 172
    Top = 139
  end
  object dsAll: TDataSource
    DataSet = zqrAll
    Left = 172
    Top = 171
  end
  object pmPassword: TPopupMenu
    Left = 356
    Top = 131
    object miGetPass: TMenuItem
      Caption = #1047#1072#1076#1072#1090#1100' '#1087#1072#1088#1086#1083#1100
      OnClick = miGetPassClick
    end
    object miGenerate: TMenuItem
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100
      OnClick = miGenerateClick
    end
  end
  object dsAccess: TDataSource
    DataSet = zqrAccess
    Left = 300
    Top = 179
  end
  object zqrAccess: TZQuery
    UpdateObject = zuqAccess
    Params = <>
    Left = 332
    Top = 179
  end
  object zuqAccess: TZUpdateSQL
    RefreshSQL.Strings = (
      '')
    UseSequenceFieldForRefreshSQL = False
    Left = 332
    Top = 212
  end
  object dsUserRole: TDataSource
    DataSet = zqrUserRole
    Left = 44
    Top = 340
  end
  object zuqUserRole: TZUpdateSQL
    DeleteSQL.Strings = (
      '')
    InsertSQL.Strings = (
      '')
    ModifySQL.Strings = (
      'select 1')
    UseSequenceFieldForRefreshSQL = False
    BeforeModifySQL = zuqUserRoleBeforeModifySQL
    Left = 108
    Top = 340
  end
  object zqrRoleUser: TZQuery
    ReadOnly = True
    SQL.Strings = (
      'select * from kadr.p_get_role_user(:id)')
    Params = <
      item
        DataType = ftUnknown
        Name = 'id'
        ParamType = ptUnknown
      end>
    Left = 76
    Top = 372
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'id'
        ParamType = ptUnknown
      end>
  end
  object dsRoleUser: TDataSource
    DataSet = zqrRoleUser
    Left = 44
    Top = 372
  end
  object zqrUserRole: TZQuery
    UpdateObject = zuqUserRole
    SQL.Strings = (
      '')
    Params = <>
    Left = 76
    Top = 340
    object zqrUserRoleid: TIntegerField
      FieldName = 'id'
      ReadOnly = True
    end
    object zqrUserRolename: TStringField
      FieldName = 'name'
      ReadOnly = True
      Size = 255
    end
    object zqrUserRoleu_name: TStringField
      FieldKind = fkLookup
      FieldName = 'u_name'
      LookupDataSet = zqrRoles
      LookupKeyFields = 'id'
      LookupResultField = 'name'
      KeyFields = 'id'
      Lookup = True
    end
  end
  object zuqUsers: TZUpdateSQL
    InsertSQL.Strings = (
      '')
    ModifySQL.Strings = (
      '')
    UseSequenceFieldForRefreshSQL = False
    Left = 76
    Top = 228
  end
end
