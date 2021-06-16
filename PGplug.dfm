object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'PowerGraph Analysis'
  ClientHeight = 539
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 39
    Width = 713
    Height = 497
    TabOrder = 0
  end
  object EnterDataButton: TButton
    Left = 8
    Top = 8
    Width = 89
    Height = 25
    Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
    TabOrder = 1
    OnClick = EnterDataButtonClick
  end
  object ExportExcelButton: TButton
    Left = 120
    Top = 8
    Width = 75
    Height = 25
    Caption = #1042' Excel'
    Enabled = False
    TabOrder = 2
    OnClick = ExportExcelButtonClick
  end
  object OpenDialog1: TOpenDialog
    Left = 520
    Top = 8
  end
end
