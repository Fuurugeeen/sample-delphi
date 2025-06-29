unit TestAuthSystem;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  User, UserStorage, UserManager, SessionManager;

type
  [TestFixture]
  TTestAuthSystem = class
  private
    FUserStorage: TUserStorage;
    FUserManager: TUserManager;
    FSessionManager: TSessionManager;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure Test_User_Create_ShouldInitializeCorrectly;
    [Test]
    procedure Test_User_IsValid_ShouldReturnTrueForValidUser;
    [Test]
    procedure Test_User_IsValid_ShouldReturnFalseForInvalidUser;
    
    [Test]
    procedure Test_UserStorage_SaveAndLoad_ShouldWorkCorrectly;
    [Test]
    procedure Test_UserStorage_ValidatePassword_ShouldReturnTrueForCorrectPassword;
    [Test]
    procedure Test_UserStorage_ValidatePassword_ShouldReturnFalseForIncorrectPassword;
    [Test]
    procedure Test_UserStorage_UserExists_ShouldReturnTrueForExistingUser;
    
    [Test]
    procedure Test_UserManager_Login_ShouldSucceedWithValidCredentials;
    [Test]
    procedure Test_UserManager_Login_ShouldFailWithInvalidCredentials;
    [Test]
    procedure Test_UserManager_RegisterUser_ShouldCreateNewUser;
    [Test]
    procedure Test_UserManager_IsLoggedIn_ShouldReturnTrueAfterLogin;
    
    [Test]
    procedure Test_SessionManager_Login_ShouldCreateValidSession;
    [Test]
    procedure Test_SessionManager_Logout_ShouldClearSession;
    [Test]
    procedure Test_SessionManager_IsValidSession_ShouldReturnTrueForActiveSession;
  end;

implementation

uses
  System.IOUtils;

procedure TTestAuthSystem.Setup;
begin
  // テスト用のクリーンな環境を作成
  FUserStorage := TUserStorage.Create;
  FUserManager := TUserManager.Instance;
  FSessionManager := TSessionManager.Instance;
  
  // 既存のセッションをクリア
  FSessionManager.Logout;
end;

procedure TTestAuthSystem.TearDown;
begin
  // セッションクリア
  FSessionManager.Logout;
  
  // ストレージ解放
  FUserStorage.Free;
  
  // テストユーザーをクリーンアップ
  try
    FUserStorage := TUserStorage.Create;
    try
      FUserStorage.DeleteUser('testuser');
    finally
      FUserStorage.Free;
    end;
  except
    // クリーンアップエラーは無視
  end;
end;

procedure TTestAuthSystem.Test_User_Create_ShouldInitializeCorrectly;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    Assert.AreEqual('testuser', User.Username);
    Assert.AreEqual('Test User', User.DisplayName);
    Assert.IsTrue(User.IsActive);
    Assert.AreEqual('', User.PasswordHash);
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_User_IsValid_ShouldReturnTrueForValidUser;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    User.PasswordHash := 'somehash';
    Assert.IsTrue(User.IsValid);
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_User_IsValid_ShouldReturnFalseForInvalidUser;
var
  User: TUser;
begin
  User := TUser.Create;
  try
    // Username and PasswordHash are empty
    Assert.IsFalse(User.IsValid);
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_UserStorage_SaveAndLoad_ShouldWorkCorrectly;
var
  SaveUser, LoadUser: TUser;
begin
  SaveUser := TUser.Create('testuser', 'Test User');
  try
    // ユーザーを保存
    Assert.IsTrue(FUserStorage.SaveUser(SaveUser, 'testpass'));
    
    // ユーザーを読み込み
    LoadUser := FUserStorage.LoadUser('testuser');
    try
      Assert.IsNotNull(LoadUser);
      Assert.AreEqual('testuser', LoadUser.Username);
      Assert.AreEqual('Test User', LoadUser.DisplayName);
      Assert.IsTrue(LoadUser.IsActive);
    finally
      LoadUser.Free;
    end;
  finally
    SaveUser.Free;
  end;
end;

procedure TTestAuthSystem.Test_UserStorage_ValidatePassword_ShouldReturnTrueForCorrectPassword;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    FUserStorage.SaveUser(User, 'testpass');
    Assert.IsTrue(FUserStorage.ValidatePassword('testuser', 'testpass'));
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_UserStorage_ValidatePassword_ShouldReturnFalseForIncorrectPassword;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    FUserStorage.SaveUser(User, 'testpass');
    Assert.IsFalse(FUserStorage.ValidatePassword('testuser', 'wrongpass'));
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_UserStorage_UserExists_ShouldReturnTrueForExistingUser;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    FUserStorage.SaveUser(User, 'testpass');
    Assert.IsTrue(FUserStorage.UserExists('testuser'));
    Assert.IsFalse(FUserStorage.UserExists('nonexistentuser'));
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_UserManager_Login_ShouldSucceedWithValidCredentials;
var
  LoginResult: TLoginResult;
begin
  // テストユーザーを作成
  FUserManager.RegisterUser('testuser', 'testpass', 'Test User');
  
  // ログインテスト
  LoginResult := FUserManager.Login('testuser', 'testpass');
  Assert.AreEqual(Ord(lrSuccess), Ord(LoginResult));
  Assert.IsTrue(FUserManager.IsLoggedIn);
end;

procedure TTestAuthSystem.Test_UserManager_Login_ShouldFailWithInvalidCredentials;
var
  LoginResult: TLoginResult;
begin
  // 存在しないユーザーでログイン
  LoginResult := FUserManager.Login('nonexistent', 'wrongpass');
  Assert.AreEqual(Ord(lrUserNotFound), Ord(LoginResult));
  Assert.IsFalse(FUserManager.IsLoggedIn);
end;

procedure TTestAuthSystem.Test_UserManager_RegisterUser_ShouldCreateNewUser;
var
  Result: Boolean;
begin
  Result := FUserManager.RegisterUser('newuser', 'newpass', 'New User');
  Assert.IsTrue(Result);
  
  // 登録されたユーザーでログインできることを確認
  Assert.AreEqual(Ord(lrSuccess), Ord(FUserManager.Login('newuser', 'newpass')));
end;

procedure TTestAuthSystem.Test_UserManager_IsLoggedIn_ShouldReturnTrueAfterLogin;
begin
  FUserManager.RegisterUser('testuser', 'testpass', 'Test User');
  
  Assert.IsFalse(FUserManager.IsLoggedIn);
  FUserManager.Login('testuser', 'testpass');
  Assert.IsTrue(FUserManager.IsLoggedIn);
end;

procedure TTestAuthSystem.Test_SessionManager_Login_ShouldCreateValidSession;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    User.PasswordHash := 'testhash';
    
    Assert.IsTrue(FSessionManager.Login(User));
    Assert.IsTrue(FSessionManager.IsLoggedIn);
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_SessionManager_Logout_ShouldClearSession;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    User.PasswordHash := 'testhash';
    
    FSessionManager.Login(User);
    Assert.IsTrue(FSessionManager.IsLoggedIn);
    
    FSessionManager.Logout;
    Assert.IsFalse(FSessionManager.IsLoggedIn);
  finally
    User.Free;
  end;
end;

procedure TTestAuthSystem.Test_SessionManager_IsValidSession_ShouldReturnTrueForActiveSession;
var
  User: TUser;
begin
  User := TUser.Create('testuser', 'Test User');
  try
    User.PasswordHash := 'testhash';
    
    FSessionManager.Login(User);
    Assert.IsTrue(FSessionManager.IsValidSession);
    
    FSessionManager.Logout;
    Assert.IsFalse(FSessionManager.IsValidSession);
  finally
    User.Free;
  end;
end;

end.