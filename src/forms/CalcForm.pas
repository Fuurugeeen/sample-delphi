unit CalcForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.ComCtrls,
  CalculatorEngine, UserManager, SessionManager, User;

type
  TCalculatorForm = class(TForm)
    DisplayPanel: TPanel;
    DisplayLabel: TLabel;
    ButtonPanel: TPanel;
    Btn0: TButton;
    Btn1: TButton;
    Btn2: TButton;
    Btn3: TButton;
    Btn4: TButton;
    Btn5: TButton;
    Btn6: TButton;
    Btn7: TButton;
    Btn8: TButton;
    Btn9: TButton;
    BtnAdd: TButton;
    BtnSubtract: TButton;
    BtnMultiply: TButton;
    BtnDivide: TButton;
    BtnEquals: TButton;
    BtnClear: TButton;
    BtnClearEntry: TButton;
    BtnDecimal: TButton;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    LogoutMenuItem: TMenuItem;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NumberButtonClick(Sender: TObject);
    procedure OperationButtonClick(Sender: TObject);
    procedure BtnEqualsClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnClearEntryClick(Sender: TObject);
    procedure BtnDecimalClick(Sender: TObject);
    procedure LogoutMenuItemClick(Sender: TObject);
  private
    FCalculator: TCalculatorEngine;
    FCurrentInput: string;
    FDecimalEntered: Boolean;
    FUserManager: TUserManager;
    procedure UpdateDisplay;
    procedure UpdateStatusBar;
  public
    { Public 宣言 }
  end;


implementation

{$R *.dfm}

procedure TCalculatorForm.FormCreate(Sender: TObject);
begin
  FCalculator := TCalculatorEngine.Create;
  FCurrentInput := '0';
  FDecimalEntered := False;
  FUserManager := TUserManager.Instance;
  
  UpdateDisplay;
  UpdateStatusBar;
end;

procedure TCalculatorForm.FormDestroy(Sender: TObject);
begin
  FCalculator.Free;
  // UserManagerはシングルトンなので解放しない
end;

procedure TCalculatorForm.FormShow(Sender: TObject);
begin
  // セッション有効性チェック
  if not FUserManager.IsLoggedIn then
  begin
    ShowMessage(string('セッションが無効です。アプリケーションを終了します。'));
    Application.Terminate;
  end
  else
    UpdateStatusBar;
end;

procedure TCalculatorForm.LogoutMenuItemClick(Sender: TObject);
begin
  if MessageDlg(string('ログアウトしますか？'), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FUserManager.Logout;
    Application.Terminate;
  end;
end;

procedure TCalculatorForm.NumberButtonClick(Sender: TObject);
var
  Digit: string;
begin
  Digit := TButton(Sender).Caption;
  
  if FCurrentInput = '0' then
    FCurrentInput := Digit
  else
    FCurrentInput := FCurrentInput + Digit;
    
  UpdateDisplay;
end;

procedure TCalculatorForm.OperationButtonClick(Sender: TObject);
var
  Operation: TOperation;
begin
  FCalculator.EnterNumber(FCurrentInput);
  
  if Sender = BtnAdd then
    Operation := opAdd
  else if Sender = BtnSubtract then
    Operation := opSubtract
  else if Sender = BtnMultiply then
    Operation := opMultiply
  else if Sender = BtnDivide then
    Operation := opDivide
  else
    Operation := opNone;
    
  FCalculator.EnterOperation(Operation);
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TCalculatorForm.BtnEqualsClick(Sender: TObject);
begin
  FCalculator.EnterNumber(FCurrentInput);
  FCalculator.Calculate;
  FCurrentInput := FCalculator.GetDisplay;
  FDecimalEntered := Pos('.', FCurrentInput) > 0;
  UpdateDisplay;
end;

procedure TCalculatorForm.BtnClearClick(Sender: TObject);
begin
  FCalculator.Clear;
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TCalculatorForm.BtnClearEntryClick(Sender: TObject);
begin
  FCalculator.ClearEntry;
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TCalculatorForm.BtnDecimalClick(Sender: TObject);
begin
  if not FDecimalEntered then
  begin
    FCurrentInput := FCurrentInput + '.';
    FDecimalEntered := True;
    UpdateDisplay;
  end;
end;

procedure TCalculatorForm.UpdateDisplay;
begin
  if FCalculator.HasError then
    DisplayLabel.Caption := FCalculator.GetDisplay + ': ' + FCalculator.GetErrorMessage
  else
    DisplayLabel.Caption := FCurrentInput;
end;

procedure TCalculatorForm.UpdateStatusBar;
var
  CurrentUser: TUser;
begin
  if FUserManager.IsLoggedIn then
  begin
    CurrentUser := FUserManager.GetCurrentUser;
    if Assigned(CurrentUser) then
    begin
      StatusBar.Panels[0].Text := string('ユーザー: ') + CurrentUser.ToString;
      StatusBar.Panels[1].Text := FUserManager.GetSessionInfo;
    end;
  end
  else
  begin
    StatusBar.Panels[0].Text := string('ログインしていません');
    StatusBar.Panels[1].Text := '';
  end;
end;

end.