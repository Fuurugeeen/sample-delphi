unit LoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  UserManager;

type
  TLoginForm = class(TForm)
    MainPanel: TPanel;
    TitlePanel: TPanel;
    TitleLabel: TLabel;
    LoginPanel: TPanel;
    UsernameLabel: TLabel;
    UsernameEdit: TEdit;
    PasswordLabel: TLabel;
    PasswordEdit: TEdit;
    ButtonPanel: TPanel;
    LoginButton: TButton;
    CancelButton: TButton;
    MessageLabel: TLabel;
    RememberCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoginButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure UsernameEditChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FUserManager: TUserManager;
    procedure UpdateUI;
    procedure ShowMessage(const Msg: string; IsError: Boolean = True);
    procedure ClearMessage;
    function ValidateInput: Boolean;
    procedure LoadRememberedUser;
    procedure SaveRememberedUser;
    procedure ClearRememberedUser;
  public
    function ShowLogin: TModalResult;
  end;

implementation

{$R *.dfm}

uses
  System.IniFiles, System.IOUtils;

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  FUserManager := TUserManager.Instance;
  
  // フォーム設定
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  BorderIcons := [biSystemMenu];
  
  // 初期状態
  PasswordEdit.PasswordChar := '*';
  UpdateUI;
  
  // 記憶されたユーザー情報を読み込み
  LoadRememberedUser;
end;

procedure TLoginForm.FormDestroy(Sender: TObject);
begin
  // UserManagerはシングルトンなので解放しない
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
  ClearMessage;
  if UsernameEdit.Text = '' then
    UsernameEdit.SetFocus
  else
    PasswordEdit.SetFocus;
end;

procedure TLoginForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // Enter key
  begin
    Key := #0;
    if LoginButton.Enabled then
      LoginButtonClick(nil);
  end
  else if Key = #27 then // Escape key
  begin
    Key := #0;
    CancelButtonClick(nil);
  end;
end;

procedure TLoginForm.LoginButtonClick(Sender: TObject);
var
  LoginResult: TLoginResult;
begin
  if not ValidateInput then
    Exit;
    
  ClearMessage;
  LoginButton.Enabled := False;
  try
    LoginResult := FUserManager.Login(UsernameEdit.Text, PasswordEdit.Text);
    
    case LoginResult of
      lrSuccess:
      begin
        ShowMessage(string('ログインしました'), False);
        
        // ユーザー情報を記憶
        if RememberCheckBox.Checked then
          SaveRememberedUser
        else
          ClearRememberedUser;
          
        ModalResult := mrOk;
      end;
      else
        ShowMessage(FUserManager.GetLoginResultMessage(LoginResult));
    end;
  finally
    LoginButton.Enabled := True;
  end;
end;

procedure TLoginForm.CancelButtonClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLoginForm.UsernameEditChange(Sender: TObject);
begin
  UpdateUI;
  ClearMessage;
end;

procedure TLoginForm.PasswordEditChange(Sender: TObject);
begin
  UpdateUI;
  ClearMessage;
end;

procedure TLoginForm.UpdateUI;
begin
  LoginButton.Enabled := (Trim(UsernameEdit.Text) <> '') and (Trim(PasswordEdit.Text) <> '');
end;

procedure TLoginForm.ShowMessage(const Msg: string; IsError: Boolean);
begin
  MessageLabel.Caption := Msg;
  if IsError then
    MessageLabel.Font.Color := clRed
  else
    MessageLabel.Font.Color := clGreen;
  MessageLabel.Visible := True;
end;

procedure TLoginForm.ClearMessage;
begin
  MessageLabel.Visible := False;
  MessageLabel.Caption := '';
end;

function TLoginForm.ValidateInput: Boolean;
begin
  Result := False;
  
  if Trim(UsernameEdit.Text) = '' then
  begin
    ShowMessage(string('ユーザー名を入力してください'));
    UsernameEdit.SetFocus;
    Exit;
  end;
  
  if Trim(PasswordEdit.Text) = '' then
  begin
    ShowMessage(string('パスワードを入力してください'));
    PasswordEdit.SetFocus;
    Exit;
  end;
  
  Result := True;
end;

procedure TLoginForm.LoadRememberedUser;
var
  IniFile: TIniFile;
  ConfigPath: string;
begin
  try
    ConfigPath := TPath.Combine(TPath.GetHomePath, 'Calculator');
    if not TDirectory.Exists(ConfigPath) then
      Exit;
      
    IniFile := TIniFile.Create(TPath.Combine(ConfigPath, 'config.ini'));
    try
      UsernameEdit.Text := IniFile.ReadString('Login', 'RememberedUser', '');
      RememberCheckBox.Checked := IniFile.ReadBool('Login', 'RememberUser', False);
    finally
      IniFile.Free;
    end;
  except
    // 設定ファイル読み込みエラーは無視
  end;
end;

procedure TLoginForm.SaveRememberedUser;
var
  IniFile: TIniFile;
  ConfigPath: string;
begin
  try
    ConfigPath := TPath.Combine(TPath.GetHomePath, 'Calculator');
    if not TDirectory.Exists(ConfigPath) then
      TDirectory.CreateDirectory(ConfigPath);
      
    IniFile := TIniFile.Create(TPath.Combine(ConfigPath, 'config.ini'));
    try
      IniFile.WriteString('Login', 'RememberedUser', UsernameEdit.Text);
      IniFile.WriteBool('Login', 'RememberUser', True);
    finally
      IniFile.Free;
    end;
  except
    // 設定ファイル書き込みエラーは無視
  end;
end;

procedure TLoginForm.ClearRememberedUser;
var
  IniFile: TIniFile;
  ConfigPath: string;
begin
  try
    ConfigPath := TPath.Combine(TPath.GetHomePath, 'Calculator');
    if not TDirectory.Exists(ConfigPath) then
      Exit;
      
    IniFile := TIniFile.Create(TPath.Combine(ConfigPath, 'config.ini'));
    try
      IniFile.DeleteKey('Login', 'RememberedUser');
      IniFile.WriteBool('Login', 'RememberUser', False);
    finally
      IniFile.Free;
    end;
  except
    // 設定ファイル書き込みエラーは無視
  end;
end;

function TLoginForm.ShowLogin: TModalResult;
begin
  Result := ShowModal;
end;

end.