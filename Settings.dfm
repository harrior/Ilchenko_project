object Form1: TForm1
  Left = 0
  Top = 0
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 482
  ClientWidth = 779
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PicketLabel: TLabel
    Left = 16
    Top = 384
    Width = 43
    Height = 13
    Caption = #1055#1080#1082#1077#1090#1086#1074
  end
  object PointLabel: TLabel
    Left = 16
    Top = 414
    Width = 30
    Height = 13
    Caption = #1058#1086#1095#1077#1082
  end
  object KLabel: TLabel
    Left = 232
    Top = 387
    Width = 70
    Height = 13
    Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090
  end
  object InfoPanel: TPanel
    Left = 0
    Top = 0
    Width = 777
    Height = 89
    TabOrder = 0
    object ObjectLabel: TLabel
      Left = 38
      Top = 11
      Width = 39
      Height = 13
      Caption = #1054#1073#1098#1077#1082#1090
    end
    object AdressLabel: TLabel
      Left = 46
      Top = 35
      Width = 31
      Height = 13
      Caption = #1040#1076#1088#1077#1089
    end
    object OtherLabel: TLabel
      Left = 16
      Top = 65
      Width = 61
      Height = 13
      Caption = #1055#1088#1080#1084#1077#1095#1077#1085#1080#1077
    end
    object ProfileLabel: TLabel
      Left = 216
      Top = 11
      Width = 61
      Height = 13
      Caption = #1055#1088#1086#1092#1080#1083#1100' '#8470
    end
    object NamesLabel: TLabel
      Left = 424
      Top = 11
      Width = 109
      Height = 13
      Caption = #1060#1048#1054' '#1080#1089#1089#1083#1077#1076#1086#1074#1072#1090#1077#1083#1077#1081
    end
    object DateLabel: TLabel
      Left = 507
      Top = 35
      Width = 26
      Height = 13
      Caption = #1044#1072#1090#1072
    end
    object ObjectEdit: TEdit
      Left = 83
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object AdressEdit: TEdit
      Left = 83
      Top = 35
      Width = 402
      Height = 21
      TabOrder = 1
    end
    object OtherEdit: TEdit
      Left = 83
      Top = 62
      Width = 686
      Height = 21
      TabOrder = 2
    end
    object ProfileEdit: TEdit
      Left = 283
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object NamesEdit: TEdit
      Left = 539
      Top = 8
      Width = 230
      Height = 21
      TabOrder = 4
    end
    object DateTime: TDateTimePicker
      Left = 539
      Top = 35
      Width = 230
      Height = 21
      Date = 41982.000000000000000000
      Time = 41982.000000000000000000
      TabOrder = 5
    end
  end
  object SaveButton: TButton
    Left = 602
    Top = 449
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = SaveButtonClick
  end
  object AbortButton: TButton
    Left = 693
    Top = 449
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = AbortButtonClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 89
    Width = 777
    Height = 289
    TabOrder = 3
  end
  object PicketEdit: TEdit
    Left = 92
    Top = 384
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 4
    Text = '5'
  end
  object PointEdit: TEdit
    Left = 92
    Top = 411
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 5
    Text = '5'
  end
  object KEdit: TEdit
    Left = 308
    Top = 384
    Width = 121
    Height = 21
    TabOrder = 6
    Text = '2500'
  end
  object F1LoadButton: TButton
    Left = 602
    Top = 384
    Width = 169
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' 1-F '#1080#1079' '#1092#1072#1081#1083#1072
    TabOrder = 7
    OnClick = F1LoadButtonClick
  end
  object SpeedLoadButton: TButton
    Left = 602
    Top = 409
    Width = 169
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1080' '#1080#1079' '#1092#1072#1081#1083#1072
    TabOrder = 8
    OnClick = SpeedLoadButtonClick
  end
  object Button1: TButton
    Left = 260
    Top = 414
    Width = 169
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103
    Enabled = False
    TabOrder = 9
  end
  object OpenDialog1: TOpenDialog
    Left = 528
    Top = 400
  end
end
