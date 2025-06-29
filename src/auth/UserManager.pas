unit UserManager;

interface

uses
  System.SysUtils, System.Classes,
  User, UserStorage, SessionManager;

type
  TLoginResult = (lrSuccess, lrInvalidCredentials, lrUserNotFound, lrUserInactive, lrError);
  
  TUserManager = class
  private
    FUserStorage: TUserStorage;
    FSessionManager: TSessionManager;
    
    class var FInstance: TUserManager;
    constructor CreatePrivate;
  public
    destructor Destroy; override;
    
    class function Instance: TUserManager;
    class procedure ReleaseInstance;
    
    function Login(const Username, Password: string): TLoginResult;
    procedure Logout;
    function IsLoggedIn: Boolean;
    function GetCurrentUser: TUser;
    function GetSessionInfo: string;
    
    function RegisterUser(const Username, Password, DisplayName: string): Boolean;
    function ChangePassword(const Username, OldPassword, NewPassword: string): Boolean;
    function DeleteUser(const Username: string): Boolean;
    function GetUserList: TStringList;
    
    function GetLoginResultMessage(const LoginResult: TLoginResult): string;
  end;

implementation

class function TUserManager.Instance: TUserManager;
begin
  if not Assigned(FInstance) then
    FInstance := TUserManager.CreatePrivate;
  Result := FInstance;
end;

class procedure TUserManager.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

constructor TUserManager.CreatePrivate;
begin
  inherited Create;
  FUserStorage := TUserStorage.Create;
  FSessionManager := TSessionManager.Instance;
end;

destructor TUserManager.Destroy;
begin
  FUserStorage.Free;
  // セッションマネージャーはシングルトンなので解放しない
  inherited Destroy;
end;

function TUserManager.Login(const Username, Password: string): TLoginResult;
var
  User: TUser;
begin
  try
    // 入力検証
    if (Trim(Username) = '') or (Trim(Password) = '') then
    begin
      Result := lrInvalidCredentials;
      Exit;
    end;
    
    // ユーザー存在チェック
    if not FUserStorage.UserExists(Username) then
    begin
      Result := lrUserNotFound;
      Exit;
    end;
    
    // パスワード検証
    if not FUserStorage.ValidatePassword(Username, Password) then
    begin
      Result := lrInvalidCredentials;
      Exit;
    end;

    // ユーザー情報取得
    User := FUserStorage.LoadUser(Username);
    try
      if not Assigned(User) then
      begin
        Result := lrError;
        Exit;
      end;
      
      // アクティブ状態チェック
      if not User.IsActive then
      begin
        Result := lrUserInactive;
        Exit;
      end;
      
      // セッション作成
      if FSessionManager.Login(User) then
        Result := lrSuccess
      else
        Result := lrError;
        
    finally
      User.Free;
    end;
    
  except
    on E: Exception do
      Result := lrError;
  end;
end;

procedure TUserManager.Logout;
begin
  FSessionManager.Logout;
end;

function TUserManager.IsLoggedIn: Boolean;
begin
  Result := FSessionManager.IsValidSession;
end;

function TUserManager.GetCurrentUser: TUser;
begin
  Result := FSessionManager.GetCurrentUser;
end;

function TUserManager.GetSessionInfo: string;
begin
  Result := FSessionManager.GetSessionInfo;
end;

function TUserManager.RegisterUser(const Username, Password, DisplayName: string): Boolean;
var
  User: TUser;
begin
  Result := False;
  
  try
    // 入力検証
    if (Trim(Username) = '') or (Trim(Password) = '') then
      Exit;
    
    // ユーザー重複チェック
    if FUserStorage.UserExists(Username) then
      Exit;
    
    // 新規ユーザー作成
    User := TUser.Create(Username, DisplayName);
    try
      Result := FUserStorage.SaveUser(User, Password);
    finally
      User.Free;
    end;
    
  except
    on E: Exception do
      Result := False;
  end;
end;

function TUserManager.ChangePassword(const Username, OldPassword, NewPassword: string): Boolean;
var
  User: TUser;
begin
  Result := False;
  
  try
    // 現在のパスワード検証
    if not FUserStorage.ValidatePassword(Username, OldPassword) then
      Exit;
    
    // ユーザー情報取得
    User := FUserStorage.LoadUser(Username);
    try
      if not Assigned(User) then
        Exit;
      
      // 新しいパスワードで保存
      Result := FUserStorage.SaveUser(User, NewPassword);
      
    finally
      User.Free;
    end;
    
  except
    on E: Exception do
      Result := False;
  end;
end;

function TUserManager.DeleteUser(const Username: string): Boolean;
begin
  Result := False;
  
  try
    // 現在ログイン中のユーザーは削除不可
    if IsLoggedIn and (GetCurrentUser.Username = Username) then
      Exit;
    
    Result := FUserStorage.DeleteUser(Username);
    
  except
    on E: Exception do
      Result := False;
  end;
end;

function TUserManager.GetUserList: TStringList;
begin
  Result := FUserStorage.GetAllUsernames;
end;

function TUserManager.GetLoginResultMessage(const LoginResult: TLoginResult): string;
begin
  case LoginResult of
    lrSuccess: Result := string('ログインに成功しました');
    lrInvalidCredentials: Result := string('ユーザー名またはパスワードが間違っています');
    lrUserNotFound: Result := string('ユーザーが見つかりません');
    lrUserInactive: Result := string('ユーザーアカウントが無効です');
    lrError: Result := string('ログイン処理でエラーが発生しました');
  end;
end;

end.