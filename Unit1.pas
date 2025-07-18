unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  CalculatorEngine;

type
  TForm1 = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NumberButtonClick(Sender: TObject);
    procedure OperationButtonClick(Sender: TObject);
    procedure BtnEqualsClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnClearEntryClick(Sender: TObject);
    procedure BtnDecimalClick(Sender: TObject);
  private
    FCalculator: TCalculatorEngine;
    FCurrentInput: string;
    FDecimalEntered: Boolean;
    procedure UpdateDisplay;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCalculator := TCalculatorEngine.Create;
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FCalculator.Free;
end;

procedure TForm1.NumberButtonClick(Sender: TObject);
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

procedure TForm1.OperationButtonClick(Sender: TObject);
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

procedure TForm1.BtnEqualsClick(Sender: TObject);
begin
  FCalculator.EnterNumber(FCurrentInput);
  FCalculator.Calculate;
  FCurrentInput := FCalculator.GetDisplay;
  FDecimalEntered := Pos('.', FCurrentInput) > 0;
  UpdateDisplay;
end;

procedure TForm1.BtnClearClick(Sender: TObject);
begin
  FCalculator.Clear;
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TForm1.BtnClearEntryClick(Sender: TObject);
begin
  FCalculator.ClearEntry;
  FCurrentInput := '0';
  FDecimalEntered := False;
  UpdateDisplay;
end;

procedure TForm1.BtnDecimalClick(Sender: TObject);
begin
  if not FDecimalEntered then
  begin
    FCurrentInput := FCurrentInput + '.';
    FDecimalEntered := True;
    UpdateDisplay;
  end;
end;

procedure TForm1.UpdateDisplay;
begin
  if FCalculator.HasError then
    DisplayLabel.Caption := FCalculator.GetDisplay + ': ' + FCalculator.GetErrorMessage
  else
    DisplayLabel.Caption := FCurrentInput;
end;

end.