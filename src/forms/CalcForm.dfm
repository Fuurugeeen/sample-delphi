object CalculatorForm: TCalculatorForm
  Left = 0
  Top = 0
  Caption = '電卓アプリケーション'
  ClientHeight = 450
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  
  object DisplayPanel: TPanel
    Left = 8
    Top = 8
    Width = 304
    Height = 48
    BevelInner = bvLowered
    TabOrder = 0
    object DisplayLabel: TLabel
      Left = 8
      Top = 8
      Width = 288
      Height = 32
      Alignment = taRightJustify
      AutoSize = False
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  
  object ButtonPanel: TPanel
    Left = 8
    Top = 64
    Width = 304
    Height = 328
    BevelOuter = bvNone
    TabOrder = 1
    
    object BtnClear: TButton
      Left = 8
      Top = 8
      Width = 64
      Height = 48
      Caption = 'C'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnClearClick
    end
    
    object BtnClearEntry: TButton
      Left = 80
      Top = 8
      Width = 64
      Height = 48
      Caption = 'CE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnClearEntryClick
    end
    
    object BtnDivide: TButton
      Left = 232
      Top = 8
      Width = 64
      Height = 48
      Caption = '÷'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = OperationButtonClick
    end
    
    object Btn7: TButton
      Left = 8
      Top = 64
      Width = 64
      Height = 48
      Caption = '7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = NumberButtonClick
    end
    
    object Btn8: TButton
      Left = 80
      Top = 64
      Width = 64
      Height = 48
      Caption = '8'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = NumberButtonClick
    end
    
    object Btn9: TButton
      Left = 152
      Top = 64
      Width = 64
      Height = 48
      Caption = '9'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = NumberButtonClick
    end
    
    object BtnMultiply: TButton
      Left = 232
      Top = 64
      Width = 64
      Height = 48
      Caption = '×'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = OperationButtonClick
    end
    
    object Btn4: TButton
      Left = 8
      Top = 120
      Width = 64
      Height = 48
      Caption = '4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = NumberButtonClick
    end
    
    object Btn5: TButton
      Left = 80
      Top = 120
      Width = 64
      Height = 48
      Caption = '5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      OnClick = NumberButtonClick
    end
    
    object Btn6: TButton
      Left = 152
      Top = 120
      Width = 64
      Height = 48
      Caption = '6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = NumberButtonClick
    end
    
    object BtnSubtract: TButton
      Left = 232
      Top = 120
      Width = 64
      Height = 48
      Caption = '-'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      OnClick = OperationButtonClick
    end
    
    object Btn1: TButton
      Left = 8
      Top = 176
      Width = 64
      Height = 48
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = NumberButtonClick
    end
    
    object Btn2: TButton
      Left = 80
      Top = 176
      Width = 64
      Height = 48
      Caption = '2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      OnClick = NumberButtonClick
    end
    
    object Btn3: TButton
      Left = 152
      Top = 176
      Width = 64
      Height = 48
      Caption = '3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      OnClick = NumberButtonClick
    end
    
    object BtnAdd: TButton
      Left = 232
      Top = 176
      Width = 64
      Height = 48
      Caption = '+'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 14
      OnClick = OperationButtonClick
    end
    
    object Btn0: TButton
      Left = 8
      Top = 232
      Width = 136
      Height = 48
      Caption = '0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 15
      OnClick = NumberButtonClick
    end
    
    object BtnDecimal: TButton
      Left = 152
      Top = 232
      Width = 64
      Height = 48
      Caption = '.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 16
      OnClick = BtnDecimalClick
    end
    
    object BtnEquals: TButton
      Left = 232
      Top = 232
      Width = 64
      Height = 48
      Caption = '='
      Color = clHighlight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      TabOrder = 17
      OnClick = BtnEqualsClick
    end
  end
  object MainMenu: TMainMenu
    Left = 288
    Top = 16
    object FileMenu: TMenuItem
      Caption = 'ファイル(&F)'
      object LogoutMenuItem: TMenuItem
        Caption = 'ログアウト(&L)'
        OnClick = LogoutMenuItemClick
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 431
    Width = 320
    Height = 19
    Panels = <
      item
        Width = 160
      end
      item
        Width = 50
      end>
  end
end