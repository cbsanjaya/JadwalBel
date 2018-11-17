object FormUtama: TFormUtama
  Left = 0
  Top = 0
  Caption = 'Jadwal Bel Sekolah'
  ClientHeight = 384
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LabelTime: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 572
    Height = 48
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = '00:00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 201
  end
  object LabelDate: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 57
    Width = 572
    Height = 23
    Align = alTop
    Alignment = taCenter
    Caption = 'Senin, 01 Januari 2018'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 192
  end
  object LabelNext: TLabel
    AlignWithMargins = True
    Left = 3
    Top = 86
    Width = 572
    Height = 19
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
    ExplicitLeft = 0
    ExplicitTop = 83
    ExplicitWidth = 46
  end
  object LvBells: TListView
    AlignWithMargins = True
    Left = 3
    Top = 111
    Width = 572
    Height = 251
    Align = alTop
    Columns = <
      item
        Caption = 'Nama'
        Width = 200
      end
      item
        Caption = 'Jam'
        Width = 100
      end
      item
        Caption = 'Sound'
        Width = 250
      end>
    Items.ItemData = {
      051A0000000100000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
      0000}
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitTop = 105
  end
  object TmCheck: TTimer
    OnTimer = TmCheckTimer
    Left = 16
    Top = 272
  end
end
