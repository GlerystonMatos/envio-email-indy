object frmPrincipal: TfrmPrincipal
  Left = 297
  Top = 242
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Envio de e-mail com Indy (Disconnected.)'
  ClientHeight = 494
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnComAnexo: TButton
    Left = 451
    Top = 13
    Width = 161
    Height = 25
    Caption = 'Enviar Mensagem com Anexo'
    TabOrder = 0
    OnClick = btnComAnexoClick
  end
  object lbLog: TListBox
    Left = 0
    Top = 326
    Width = 619
    Height = 168
    Align = alBottom
    ItemHeight = 13
    TabOrder = 1
    ExplicitTop = 76
    ExplicitWidth = 442
  end
  object btnComHTML: TButton
    Left = 452
    Top = 42
    Width = 161
    Height = 25
    Caption = 'Enviar Mensagem com HTML'
    TabOrder = 2
    OnClick = btnComHTMLClick
  end
  object gbServidorEmail: TGroupBox
    Left = 8
    Top = 8
    Width = 433
    Height = 185
    Caption = 'Servidor de Email'
    TabOrder = 3
    object lbSMTP: TLabel
      Left = 7
      Top = 24
      Width = 33
      Height = 13
      Caption = 'SMTP:'
      FocusControl = detSmtp
    end
    object lbPorta: TLabel
      Left = 259
      Top = 24
      Width = 28
      Height = 13
      Caption = 'Porta:'
      FocusControl = detPorta
    end
    object lbEmail: TLabel
      Left = 7
      Top = 67
      Width = 31
      Height = 13
      Caption = 'E-mail:'
      FocusControl = detEmail
    end
    object lbUsuario: TLabel
      Left = 7
      Top = 108
      Width = 39
      Height = 13
      Caption = 'Usu'#225'rio:'
      FocusControl = detUsuario
    end
    object lbSenha: TLabel
      Left = 259
      Top = 109
      Width = 34
      Height = 13
      Caption = 'Senha:'
      FocusControl = detSenha
    end
    object detSmtp: TDLEdit
      Left = 7
      Top = 40
      Width = 243
      Height = 21
      ReadOnly = False
      TabOrder = 0
      Text = ''
      Visible = True
      Validation = []
      Decimals = 2
      Nullable = True
      EnabledColor = clWindow
      DisabledColor = clBtnFace
      ParentDisabledColor = True
    end
    object detPorta: TDLEdit
      Left = 258
      Top = 40
      Width = 51
      Height = 21
      ReadOnly = False
      TabOrder = 1
      Text = ''
      Visible = True
      Validation = []
      Decimals = 2
      Nullable = True
      EnabledColor = clWindow
      DisabledColor = clBtnFace
      ParentDisabledColor = True
    end
    object detEmail: TDLEdit
      Left = 7
      Top = 83
      Width = 243
      Height = 21
      ReadOnly = False
      TabOrder = 2
      Text = ''
      Visible = True
      Validation = []
      Decimals = 2
      Nullable = True
      EnabledColor = clWindow
      DisabledColor = clBtnFace
      ParentDisabledColor = True
    end
    object detUsuario: TDLEdit
      Left = 7
      Top = 124
      Width = 243
      Height = 21
      ReadOnly = False
      TabOrder = 3
      Text = ''
      Visible = True
      Validation = []
      Decimals = 2
      Nullable = True
      EnabledColor = clWindow
      DisabledColor = clBtnFace
      ParentDisabledColor = True
    end
    object detSenha: TDLEdit
      Left = 259
      Top = 124
      Width = 158
      Height = 21
      PasswordChar = '*'
      ReadOnly = False
      TabOrder = 4
      Text = ''
      Visible = True
      Validation = []
      Decimals = 2
      Nullable = True
      EnabledColor = clWindow
      DisabledColor = clBtnFace
      ParentDisabledColor = True
    end
    object dchRequerSSL: TDLCheckBox
      Left = 8
      Top = 152
      Width = 145
      Height = 17
      Caption = 'Requer Autentica'#231#227'o SSL'
      TabOrder = 5
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      ReadOnly = False
    end
    object dchRequerSTARTTLS: TDLCheckBox
      Left = 156
      Top = 152
      Width = 187
      Height = 17
      Caption = 'Requer Autentica'#231#227'o STARTTLS'
      TabOrder = 6
      ValueChecked = 'True'
      ValueUnchecked = 'False'
      ReadOnly = False
    end
  end
  object gbEnvio: TGroupBox
    Left = 8
    Top = 199
    Width = 433
    Height = 121
    Caption = 'Envio'
    TabOrder = 4
    object lbDestinatario: TLabel
      Left = 12
      Top = 24
      Width = 102
      Height = 13
      Caption = 'Email do Destinat'#225'rio:'
    end
    object lbAnexo: TLabel
      Left = 12
      Top = 66
      Width = 36
      Height = 13
      Caption = 'Anexo: '
    end
    object edtEmailDestinatario: TEdit
      Left = 12
      Top = 40
      Width = 405
      Height = 21
      TabOrder = 0
    end
    object btnAnexar: TBitBtn
      Left = 12
      Top = 82
      Width = 97
      Height = 25
      Caption = 'Anexar arquivo'
      TabOrder = 1
      OnClick = btnAnexarClick
    end
  end
  object IdLogEvent: TIdLogEvent
    OnReceived = IdLogEventReceived
    OnSent = IdLogEventSent
    Left = 495
    Top = 81
  end
  object OpenDialog: TOpenPictureDialog
    Filter = 'All (*.*)|*.*'
    Left = 556
    Top = 81
  end
end
