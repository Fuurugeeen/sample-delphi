program Project1;

uses
  System.UITypes, Vcl.Forms, Vcl.Dialogs, Vcl.Controls,
  Unit1 in 'Unit1.pas' {Form1},
  CalculatorEngine in 'src\engines\CalculatorEngine.pas',
  User in 'src\models\User.pas',
  UserStorage in 'src\storage\UserStorage.pas',
  SessionManager in 'src\auth\SessionManager.pas',
  UserManager in 'src\auth\UserManager.pas',
  LoginForm in 'src\forms\LoginForm.pas',
  CalcForm in 'src\forms\CalcForm.pas';

{$R *.res}

var
  Login: TLoginForm;
  Calculator: TCalculatorForm;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // ログインフォームを表示
  Login := TLoginForm.Create(Application);
  try
    if Login.ShowLogin = mrOk then
    begin
      // ログイン成功時は電卓フォームを表示
      Application.CreateForm(TCalculatorForm, Calculator);
      Application.Run;
    end
    else
    begin
      // ログインキャンセル時はアプリケーション終了
      Application.Terminate;
    end;
  finally
    Login.Free;
    
    // セッションマネージャーのクリーンアップ
    TSessionManager.ReleaseInstance;
    TUserManager.ReleaseInstance;
  end;
end.
