object MainForm: TMainForm
  Left = 225
  Top = 195
  Width = 664
  Height = 422
  Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1072#1084#1080
  Color = cl3DLight
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clRed
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lblTitle: TLabel
    Left = 12
    Top = 12
    Width = 282
    Height = 28
    Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1072#1084#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object pnlOutput: TPanel
    Left = 12
    Top = 204
    Width = 621
    Height = 163
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object lblTask: TLabel
      Left = 12
      Top = 6
      Width = 48
      Height = 18
      Caption = #1047#1072#1076#1072#1095#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblResult: TLabel
      Left = 12
      Top = 84
      Width = 71
      Height = 18
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCaptionText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object pnlInput: TPanel
    Left = 12
    Top = 60
    Width = 621
    Height = 127
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    object lblLeftPol: TLabel
      Left = 12
      Top = 6
      Width = 108
      Height = 18
      Caption = '1-'#1099#1081' '#1084#1085#1086#1075#1086#1095#1083#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblRightPol: TLabel
      Left = 322
      Top = 6
      Width = 106
      Height = 18
      Caption = '2-'#1086#1081' '#1084#1085#1086#1075#1086#1095#1083#1077#1085
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblOptions: TLabel
      Left = 12
      Top = 72
      Width = 74
      Height = 18
      Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblLeftPolInputError: TLabel
      Left = 12
      Top = 54
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lblRightPolInputError: TLabel
      Left = 306
      Top = 54
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object edtLeftPol: TEdit
    Left = 24
    Top = 90
    Width = 289
    Height = 26
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '1 0 1 0 -3 -3 8 2 -5'
    OnExit = edtLeftPolExit
    OnKeyPress = edtLeftPolKeyPress
  end
  object edtRightPol: TEdit
    Left = 334
    Top = 90
    Width = 283
    Height = 26
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '3 0 5 0 -4 -9 21'
    OnEnter = edtRightPolEnter
    OnExit = edtRightPolExit
    OnKeyPress = edtRightPolKeyPress
  end
  object cbbOptions: TComboBox
    Left = 24
    Top = 153
    Width = 211
    Height = 24
    Style = csDropDownList
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemHeight = 16
    ItemIndex = 0
    ParentFont = False
    TabOrder = 2
    Text = #1057#1091#1084#1084#1091' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074
    OnChange = cbbOptionsChange
    Items.Strings = (
      #1057#1091#1084#1084#1091' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074
      #1056#1072#1079#1085#1086#1089#1090#1100' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074
      #1055#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074
      #1063#1072#1089#1090#1085#1086#1077' '#1084#1085#1086#1075#1086#1095#1083#1077#1085#1086#1074)
  end
  object btnCalculate: TButton
    Left = 498
    Top = 138
    Width = 121
    Height = 38
    Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = btnCalculateClick
  end
  object mmoTask: TMemo
    Left = 24
    Top = 234
    Width = 593
    Height = 43
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
  object mmoResult: TMemo
    Left = 24
    Top = 312
    Width = 593
    Height = 43
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
  end
end
