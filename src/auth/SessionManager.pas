unit SessionManager;

interface

uses
  System.SysUtils, System.Classes,
  User;

type
  TSessionManager = class
  private
    FCurrentUser: TUser;
    FLoginTime: TDateTime;
    FIsLoggedIn: Boolean;
    FSessionTimeout: Integer; // 分単位
    
    class var FInstance: TSessionManager;
    constructor CreatePrivate;
  public
    destructor Destroy; override;
    
    class function Instance: TSessionManager;
    class procedure ReleaseInstance;
    
    function Login(const AUser: TUser): Boolean;
    procedure Logout;
    function IsValidSession: Boolean;
    function GetCurrentUser: TUser;
    function GetSessionInfo: string;
    
    property IsLoggedIn: Boolean read FIsLoggedIn;
    property SessionTimeout: Integer read FSessionTimeout write FSessionTimeout;
  end;

implementation

uses
  System.DateUtils;

class function TSessionManager.Instance: TSessionManager;
begin
  if not Assigned(FInstance) then
    FInstance := TSessionManager.CreatePrivate;
  Result := FInstance;
end;

class procedure TSessionManager.ReleaseInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

constructor TSessionManager.CreatePrivate;
begin
  inherited Create;
  FCurrentUser := nil;
  FLoginTime := 0;
  FIsLoggedIn := False;
  FSessionTimeout := 60; // デフォルト60分
end;

destructor TSessionManager.Destroy;
begin
  if Assigned(FCurrentUser) then
    FCurrentUser.Free;
  inherited Destroy;
end;

function TSessionManager.Login(const AUser: TUser): Boolean;
begin
  Result := False;
  if not Assigned(AUser) or not AUser.IsValid then
    Exit;
  
  // 既存のユーザーセッションをクリア
  if Assigned(FCurrentUser) then
    FCurrentUser.Free;
  
  // 新しいユーザーセッションを作成
  FCurrentUser := TUser.Create;
  FCurrentUser.Username := AUser.Username;
  FCurrentUser.PasswordHash := AUser.PasswordHash;
  FCurrentUser.DisplayName := AUser.DisplayName;
  FCurrentUser.CreatedAt := AUser.CreatedAt;
  FCurrentUser.LastLogin := AUser.LastLogin;
  FCurrentUser.IsActive := AUser.IsActive;
  
  FLoginTime := Now;
  FIsLoggedIn := True;
  Result := True;
end;

procedure TSessionManager.Logout;
begin
  FIsLoggedIn := False;
  FLoginTime := 0;
  
  if Assigned(FCurrentUser) then
  begin
    FCurrentUser.Free;
    FCurrentUser := nil;
  end;
end;

function TSessionManager.IsValidSession: Boolean;
var
  SessionDurationMinutes: Integer;
begin
  Result := False;
  
  if not FIsLoggedIn or not Assigned(FCurrentUser) then
    Exit;
  
  // セッションタイムアウトをチェック
  if FSessionTimeout > 0 then
  begin
    SessionDurationMinutes := MinutesBetween(Now, FLoginTime);
    if SessionDurationMinutes > FSessionTimeout then
    begin
      Logout; // セッションタイムアウト
      Exit;
    end;
  end;
  
  Result := FCurrentUser.IsActive;
end;

function TSessionManager.GetCurrentUser: TUser;
begin
  if IsValidSession then
    Result := FCurrentUser
  else
    Result := nil;
end;

function TSessionManager.GetSessionInfo: string;
var
  SessionDuration: Integer;
begin
  if not IsValidSession then
  begin
    Result := string('ログインしていません');
    Exit;
  end;
  
  SessionDuration := MinutesBetween(Now, FLoginTime);
  Result := Format(string('ユーザー: %s ログイン時間: %d分前'), 
    [FCurrentUser.ToString, SessionDuration]);
end;

end.