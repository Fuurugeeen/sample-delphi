unit TestCalculatorForm;

interface

uses
  DUnitX.TestFramework,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Unit1;

type
  [TestFixture]
  TCalculatorFormTest = class
  private
    FForm: TForm1;
    procedure ClickButton(Button: TButton);
    procedure EnterSequence(const Sequence: string);
    function GetDisplayText: string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure Test_FormCreate_ShouldInitializeCorrectly;
    
    [Test]
    procedure Test_NumberButtons_ShouldDisplayCorrectNumbers;
    
    [Test]
    procedure Test_BasicCalculation_ShouldWorkCorrectly;
    
    [Test]
    procedure Test_ClearButton_ShouldResetDisplay;
    
    [Test]
    procedure Test_ClearEntryButton_ShouldClearCurrentEntry;
    
    [Test]
    procedure Test_DecimalButton_ShouldAddDecimalPoint;
    
    [Test]
    procedure Test_DecimalButton_ShouldNotAddMultipleDecimals;
    
    [Test]
    procedure Test_ComplexCalculation_ShouldWorkCorrectly;
    
    [Test]
    procedure Test_DivisionByZero_ShouldShowError;
    
    [Test]
    procedure Test_SequentialOperations_ShouldWorkCorrectly;
  end;

implementation

uses
  System.SysUtils,
  Vcl.ExtCtrls;

procedure TCalculatorFormTest.Setup;
begin
  Application.CreateForm(TForm1, FForm);
end;

procedure TCalculatorFormTest.TearDown;
begin
  FForm.Free;
end;

procedure TCalculatorFormTest.ClickButton(Button: TButton);
begin
  if Assigned(Button) and Assigned(Button.OnClick) then
    Button.OnClick(Button);
end;

procedure TCalculatorFormTest.EnterSequence(const Sequence: string);
var
  i: Integer;
  Ch: Char;
begin
  for i := 1 to Length(Sequence) do
  begin
    Ch := Sequence[i];
    case Ch of
      '0': ClickButton(FForm.Btn0);
      '1': ClickButton(FForm.Btn1);
      '2': ClickButton(FForm.Btn2);
      '3': ClickButton(FForm.Btn3);
      '4': ClickButton(FForm.Btn4);
      '5': ClickButton(FForm.Btn5);
      '6': ClickButton(FForm.Btn6);
      '7': ClickButton(FForm.Btn7);
      '8': ClickButton(FForm.Btn8);
      '9': ClickButton(FForm.Btn9);
      '+': ClickButton(FForm.BtnAdd);
      '-': ClickButton(FForm.BtnSubtract);
      '*': ClickButton(FForm.BtnMultiply);
      '/': ClickButton(FForm.BtnDivide);
      '=': ClickButton(FForm.BtnEquals);
      '.': ClickButton(FForm.BtnDecimal);
      'C': ClickButton(FForm.BtnClear);
      'E': ClickButton(FForm.BtnClearEntry);
    end;
  end;
end;

function TCalculatorFormTest.GetDisplayText: string;
begin
  Result := FForm.DisplayLabel.Caption;
end;

procedure TCalculatorFormTest.Test_FormCreate_ShouldInitializeCorrectly;
begin
  Assert.AreEqual('0', GetDisplayText);
  Assert.IsNotNull(FForm.DisplayLabel);
  Assert.IsNotNull(FForm.Btn0);
  Assert.IsNotNull(FForm.BtnAdd);
end;

procedure TCalculatorFormTest.Test_NumberButtons_ShouldDisplayCorrectNumbers;
begin
  ClickButton(FForm.Btn5);
  Assert.AreEqual('5', GetDisplayText);
  
  ClickButton(FForm.Btn3);
  Assert.AreEqual('53', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  ClickButton(FForm.Btn0);
  Assert.AreEqual('0', GetDisplayText);
  
  ClickButton(FForm.Btn7);
  Assert.AreEqual('7', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_BasicCalculation_ShouldWorkCorrectly;
begin
  EnterSequence('5+3=');
  Assert.AreEqual('8', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  EnterSequence('10-4=');
  Assert.AreEqual('6', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  EnterSequence('6*7=');
  Assert.AreEqual('42', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  EnterSequence('15/3=');
  Assert.AreEqual('5', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_ClearButton_ShouldResetDisplay;
begin
  EnterSequence('123+456');
  ClickButton(FForm.BtnClear);
  Assert.AreEqual('0', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_ClearEntryButton_ShouldClearCurrentEntry;
begin
  EnterSequence('123');
  ClickButton(FForm.BtnClearEntry);
  Assert.AreEqual('0', GetDisplayText);
  
  EnterSequence('5+');
  EnterSequence('789');
  ClickButton(FForm.BtnClearEntry);
  Assert.AreEqual('0', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_DecimalButton_ShouldAddDecimalPoint;
begin
  EnterSequence('3.14');
  Assert.AreEqual('3.14', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  EnterSequence('0.5');
  Assert.AreEqual('0.5', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_DecimalButton_ShouldNotAddMultipleDecimals;
begin
  EnterSequence('3.1.4');  // 2番目の小数点は無視される
  Assert.AreEqual('3.14', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_ComplexCalculation_ShouldWorkCorrectly;
begin
  // 2 + 3 * 4 の順次計算（結果は20）
  EnterSequence('2+3*4=');
  Assert.AreEqual('20', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  
  // 小数点計算
  EnterSequence('3.5*2=');
  Assert.AreEqual('7', GetDisplayText);
end;

procedure TCalculatorFormTest.Test_DivisionByZero_ShouldShowError;
begin
  EnterSequence('10/0=');
  Assert.Contains(GetDisplayText, 'エラー');
end;

procedure TCalculatorFormTest.Test_SequentialOperations_ShouldWorkCorrectly;
begin
  // 連続操作: 5 + 3 + 2 = 10
  EnterSequence('5+3+2=');
  Assert.AreEqual('10', GetDisplayText);
  
  ClickButton(FForm.BtnClear);
  
  // 連続操作: 20 - 5 - 3 = 12
  EnterSequence('20-5-3=');
  Assert.AreEqual('12', GetDisplayText);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalculatorFormTest);

end.