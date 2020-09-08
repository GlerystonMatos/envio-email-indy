unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdSMTP, StdCtrls,
  IdMessage, IdAntiFreeze, IdIntercept, IdLogBase, IdLogEvent, DLCheckBox,
  Vcl.Mask, DLExtraCompo, DLEdit, Vcl.Buttons, Vcl.ExtDlgs, IdAttachmentFile,
  IdSSLOpenSSL, IdText, IdExplicitTLSClientServerBase;

type
  TfrmPrincipal = class(TForm)
    btnComAnexo: TButton;
    IdLogEvent: TIdLogEvent;
    lbLog: TListBox;
    btnComHTML: TButton;
    gbServidorEmail: TGroupBox;
    lbSMTP: TLabel;
    lbPorta: TLabel;
    lbEmail: TLabel;
    lbUsuario: TLabel;
    lbSenha: TLabel;
    detSmtp: TDLEdit;
    detPorta: TDLEdit;
    detEmail: TDLEdit;
    detUsuario: TDLEdit;
    detSenha: TDLEdit;
    dchRequerSSL: TDLCheckBox;
    dchRequerSTARTTLS: TDLCheckBox;
    gbEnvio: TGroupBox;
    lbDestinatario: TLabel;
    lbAnexo: TLabel;
    edtEmailDestinatario: TEdit;
    btnAnexar: TBitBtn;
    OpenDialog: TOpenPictureDialog;
    procedure btnAnexarClick(Sender: TObject);
    procedure btnComAnexoClick(Sender: TObject);
    procedure IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
    procedure IdLogEventSent(ASender: TComponent; const AText, AData: string);
    procedure IdLogEventReceived(ASender: TComponent; const AText, AData: string);
    procedure btnComHTMLClick(Sender: TObject);
  private
    FAnexo: string;
    procedure Enviar(const AMensagem: string; const AIsHtml: Boolean);
    procedure ConfiguraUsoSSL(var IdSMTP: TIdSMTP);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.DFM}

procedure TfrmPrincipal.IdSMTPStatus(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
begin
  frmPrincipal.Caption := 'Envio de e-mail com Indy (' + AStatusText + ')';
end;

procedure TfrmPrincipal.IdLogEventReceived(ASender: TComponent; const AText, AData: string);
begin
  lbLog.Items.Add('<< ' + AData);
end;

procedure TfrmPrincipal.IdLogEventSent(ASender: TComponent; const AText, AData: string);
begin
  lbLog.Items.Add('>> ' + AData);
end;

procedure TfrmPrincipal.ConfiguraUsoSSL(var IdSMTP: TIdSMTP);
var
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  //Estas opções requerem as dlls libeay32.dll e ssleay32.dll na pasta do executável.
  IdSSL := nil;
  if ((dchRequerSSL.Checked) or (dchRequerSTARTTLS.Checked)) then
  begin
    try
      IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdSMTP.IOHandler := IdSSL;
    except
      on E: Exception do
        IdSMTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    end;

    if (Assigned(IdSSL)) then
    begin
      if (dchRequerSTARTTLS.Checked) then
      begin
        IdSSL.SSLOptions.Method := sslvTLSv1;
        IdSSL.SSLOptions.Mode := sslmUnassigned;
        IdSMTP.UseTLS := utUseExplicitTLS;
      end
      else if (dchRequerSSL.Checked) then
      begin
        IdSSL.SSLOptions.Method := sslvSSLv23;
        IdSSL.SSLOptions.Mode := sslmClient;
        IdSMTP.UseTLS := utUseImplicitTLS;
      end;
    end;
  end
  else
    IdSMTP.IOHandler := nil;
end;

procedure TfrmPrincipal.Enviar(const AMensagem: string; const AIsHtml: Boolean);
var
  idSMTP: TIdSMTP;
  idMessage: TIdMessage;
  idAttachmentFile: TIdAttachmentFile;
begin
  idSMTP := TIdSMTP.Create(nil);
  try
    idMessage := TIdMessage.Create(nil);
    try
      idSMTP.Intercept := IdLogEvent;
      IdLogEvent.Active := True;
      idSMTP.OnStatus := IdSMTPStatus;
      idSMTP.Host := Trim(detSmtp.Text);
      idSMTP.Port := StrToIntDef(Trim(detPorta.Text), 0);
      idSMTP.Username := Trim(detUsuario.Text);
      idSMTP.Password := Trim(detSenha.Text);

      if (idSMTP.Password <> '') then
        idSMTP.AuthType := satDefault
      else
        idSMTP.AuthType := satNone;

      idMessage.Clear;
      idMessage.ClearBody;
      idMessage.ClearHeader;

      if (AIsHtml) then
        idMessage.ContentType := 'text/html';

      idMessage.Body.Add(AMensagem);

      if (FileExists(FAnexo)) then
      begin
        idAttachmentFile := TIdAttachmentFile.Create(idMessage.MessageParts, FAnexo);
        idAttachmentFile.ContentType := 'image/jpeg';
        idAttachmentFile.ContentDisposition := 'inline';
        idAttachmentFile.ExtraHeaders.Values['content-id'] := ExtractFileName(FAnexo);
      end;

      idMessage.From.Text := Trim(detEmail.Text);
      idMessage.Subject := 'Teste para envio de e-mail com Indy';
      idMessage.Priority := mpNormal;

      idMessage.Recipients.Add;
      idMessage.Recipients.EMailAddresses := Trim(edtEmailDestinatario.Text);

      ConfiguraUsoSSL(idSMTP);

      idSMTP.ConnectTimeout := 3 * 60 * 1000;
      idSMTP.ReadTimeout := 3 * 60 * 1000;
      idSMTP.Connect;
      idSMTP.Send(idMessage);
    finally
      FreeAndNil(idMessage);
    end;
  finally
    idSMTP.Disconnect;
    FreeAndNil(idSMTP);
  end;
end;

procedure TfrmPrincipal.btnAnexarClick(Sender: TObject);
begin
  FAnexo := '';
  if (OpenDialog.Execute) then
    FAnexo := OpenDialog.FileName
  else
    FAnexo := '';
  lbAnexo.Caption := 'Anexo: ' + FAnexo;
end;

procedure TfrmPrincipal.btnComAnexoClick(Sender: TObject);
begin
  lbLog.Clear;
  Enviar('Mensagem com Anexo', False);
end;

procedure TfrmPrincipal.btnComHTMLClick(Sender: TObject);
var
  mensagem: string;
begin
  lbLog.Clear;

  mensagem :=
    '<!DOCTYPE html>' +
    '<html xmlns="http://www.w3.org/1999/xhtml">' +
    '	<head>' +
    '		<title>Envio de e-mail com Indy </title>' +
    '		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">' +
    '		<style type="text/css">' +
    '			.informacao {' +
    '				font-weight: bold;' +
    '			}' +
    '        </style>' +
    '	</head>' +
    '	<body>' +
    '		<div class="container-fluid">' +
    '			<br/>' +
    '			<div class="row informacao">' +
    '				<div class="col-12 campo">' +
    '					Mensagem com HTML' +
    '				</div>' +
    '			</div>' +
    '			<hr>' +
    '			<div class="row">' +
    '				<div class="col-12">' +
		' 		    <span class="informacao">Nome: </span><span>Gleryston Matos</span>' +
		'		     	<br>' +
		'		     	<span class="informacao">GitHub: </span><span>https://github.com/GlerystonMatos</span>' +
		'		     	<br>' +
		'		     	<span class="informacao">E-mail: </span><span>glerystonmatos@gmail.com</span>' +
    '				</div>' +
    '			</div>' +
    '			<hr>' +
    '		</div>' +
    '	</body>' +
    '</html>';

  Enviar(mensagem, True);
end;

end.
