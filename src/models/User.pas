unit User;

interface

uses
  System.SysUtils, System.Classes;

type
  TUser = class
  private
    FUsername: string;
    FPasswordHash: string;
    FDisplayName: string;
    FCreatedAt: TDateTime;
    FLastLogin: TDateTime;
    FIsActive: Boolean;
  public
    constructor Create; overload;
    constructor Create(const AUsername, ADisplayName: string); overload;
    
    function IsValid: Boolean;
    function ToString: string; override;
    
    property Username: string read FUsername write FUsername;
    property PasswordHash: string read FPasswordHash write FPasswordHash;
    property DisplayName: string read FDisplayName write FDisplayName;
    property CreatedAt: TDateTime read FCreatedAt write FCreatedAt;
    property LastLogin: TDateTime read FLastLogin write FLastLogin;
    property IsActive: Boolean read FIsActive write FIsActive;
  end;

implementation

constructor TUser.Create;
begin
  inherited Create;
  FUsername := '';
  FPasswordHash := '';
  FDisplayName := '';
  FCreatedAt := Now;
  FLastLogin := 0;
  FIsActive := True;
end;

constructor TUser.Create(const AUsername, ADisplayName: string);
begin
  Create;
  FUsername := AUsername;
  FDisplayName := ADisplayName;
end;

function TUser.IsValid: Boolean;
begin
  Result := (Trim(FUsername) <> '') and (Trim(FPasswordHash) <> '') and FIsActive;
end;

function TUser.ToString: string;
begin
  if FDisplayName <> '' then
    Result := FDisplayName
  else
    Result := FUsername;
end;

end.