unit UserStorage;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.Generics.Collections,
  User;

type
  TUserStorage = class
  private
    FIniFile: TIniFile;
    FFilePath: string;
    
    function GetUserFilePath: string;
    function HashPassword(const Password: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    
    function SaveUser(const AUser: TUser; const PlainPassword: string): Boolean;
    function LoadUser(const Username: string): TUser;
    function ValidatePassword(const Username, PlainPassword: string): Boolean;
    function UserExists(const Username: string): Boolean;
    function GetAllUsernames: TStringList;
    function DeleteUser(const Username: string): Boolean;
    
    procedure CreateDefaultUser;
  end;

implementation

uses
  System.IOUtils, System.Hash;

constructor TUserStorage.Create;
begin
  inherited Create;
  FFilePath := GetUserFilePath;
  FIniFile := TIniFile.Create(FFilePath);
  
  // デフォルトユーザーが存在しない場合は作成
  if not UserExists('admin') then
    CreateDefaultUser;
end;

destructor TUserStorage.Destroy;
begin
  FIniFile.Free;
  inherited Destroy;
end;

function TUserStorage.GetUserFilePath: string;
var
  AppDataPath: string;
begin
  AppDataPath := TPath.Combine(TPath.GetHomePath, 'Calculator');
  if not TDirectory.Exists(AppDataPath) then
    TDirectory.CreateDirectory(AppDataPath);
  Result := TPath.Combine(AppDataPath, 'users.ini');
end;

function TUserStorage.HashPassword(const Password: string): string;
begin
  // 簡易ハッシュ化（実際の運用ではbcryptなどを使用すべき）
  Result := THashSHA2.GetHashString(Password + 'salt_calculator_2024');
end;

function TUserStorage.SaveUser(const AUser: TUser; const PlainPassword: string): Boolean;
var
  Section: string;
begin
  Result := False;
  if not Assigned(AUser) or not AUser.IsValid then
    Exit;
    
  try
    Section := 'User_' + AUser.Username;
    
    FIniFile.WriteString(Section, 'Username', AUser.Username);
    FIniFile.WriteString(Section, 'PasswordHash', HashPassword(PlainPassword));
    FIniFile.WriteString(Section, 'DisplayName', AUser.DisplayName);
    FIniFile.WriteDateTime(Section, 'CreatedAt', AUser.CreatedAt);
    FIniFile.WriteDateTime(Section, 'LastLogin', AUser.LastLogin);
    FIniFile.WriteBool(Section, 'IsActive', AUser.IsActive);
    
    Result := True;
  except
    on E: Exception do
      // ログ出力など
  end;
end;

function TUserStorage.LoadUser(const Username: string): TUser;
var
  Section: string;
begin
  Result := nil;
  if Trim(Username) = '' then
    Exit;
    
  Section := 'User_' + Username;
  if not FIniFile.SectionExists(Section) then
    Exit;
    
  try
    Result := TUser.Create;
    Result.Username := FIniFile.ReadString(Section, 'Username', '');
    Result.PasswordHash := FIniFile.ReadString(Section, 'PasswordHash', '');
    Result.DisplayName := FIniFile.ReadString(Section, 'DisplayName', '');
    Result.CreatedAt := FIniFile.ReadDateTime(Section, 'CreatedAt', Now);
    Result.LastLogin := FIniFile.ReadDateTime(Section, 'LastLogin', 0);
    Result.IsActive := FIniFile.ReadBool(Section, 'IsActive', True);
  except
    on E: Exception do
    begin
      Result.Free;
      Result := nil;
    end;
  end;
end;

function TUserStorage.ValidatePassword(const Username, PlainPassword: string): Boolean;
var
  User: TUser;
  HashedPassword: string;
begin
  Result := False;
  User := LoadUser(Username);
  try
    if Assigned(User) and User.IsActive then
    begin
      HashedPassword := HashPassword(PlainPassword);
      Result := User.PasswordHash = HashedPassword;
      
      if Result then
      begin
        // ログイン時刻を更新
        User.LastLogin := Now;
        SaveUser(User, PlainPassword);
      end;
    end;
  finally
    User.Free;
  end;
end;

function TUserStorage.UserExists(const Username: string): Boolean;
var
  Section: string;
begin
  Section := 'User_' + Username;
  Result := FIniFile.SectionExists(Section);
end;

function TUserStorage.GetAllUsernames: TStringList;
var
  Sections: TStringList;
  I: Integer;
  Username: string;
begin
  Result := TStringList.Create;
  Sections := TStringList.Create;
  try
    FIniFile.ReadSections(Sections);
    for I := 0 to Sections.Count - 1 do
    begin
      if Sections[I].StartsWith('User_') then
      begin
        Username := Copy(Sections[I], 6, Length(Sections[I]) - 5);
        Result.Add(Username);
      end;
    end;
  finally
    Sections.Free;
  end;
end;

function TUserStorage.DeleteUser(const Username: string): Boolean;
var
  Section: string;
begin
  Result := False;
  if Username = 'admin' then // 管理者ユーザーは削除不可
    Exit;
    
  Section := 'User_' + Username;
  if FIniFile.SectionExists(Section) then
  begin
    FIniFile.EraseSection(Section);
    Result := True;
  end;
end;

procedure TUserStorage.CreateDefaultUser;
var
  DefaultUser: TUser;
begin
  DefaultUser := TUser.Create('admin', string('管理者'));
  try
    SaveUser(DefaultUser, 'admin123'); // デフォルトパスワード
  finally
    DefaultUser.Free;
  end;
end;

end.