unit TestCalculatorEngine;

interface

uses
  DUnitX.TestFramework,
  CalculatorEngine;

type
  [TestFixture]
  TCalculatorEngineTest = class
  private
    FCalculator: TCalculatorEngine;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    
    [Test]
    procedure Test_Create_ShouldInitializeCorrectly;
    
    [Test]
    procedure Test_Clear_ShouldResetToZero;
    
    [Test]
    procedure Test_EnterNumber_ShouldDisplayCorrectNumber;
    
    [Test]
    procedure Test_Addition_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_Subtraction_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_Multiplication_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_Division_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_DivisionByZero_ShouldRaiseError;
    
    [Test]
    procedure Test_ChainedOperations_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_DecimalNumbers_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_NegativeNumbers_ShouldCalculateCorrectly;
    
    [Test]
    procedure Test_ClearEntry_ShouldResetCurrentValue;
    
    [Test]
    procedure Test_MultipleOperations_ShouldMaintainAccuracy;
  end;

implementation

uses
  System.SysUtils;

procedure TCalculatorEngineTest.Setup;
begin
  FCalculator := TCalculatorEngine.Create;
end;

procedure TCalculatorEngineTest.TearDown;
begin
  FCalculator.Free;
end;

procedure TCalculatorEngineTest.Test_Create_ShouldInitializeCorrectly;
begin
  Assert.AreEqual('0', FCalculator.GetDisplay);
  Assert.IsFalse(FCalculator.HasError);
  Assert.AreEqual(0.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_Clear_ShouldResetToZero;
begin
  FCalculator.EnterNumber('123');
  FCalculator.EnterOperation(opAdd);
  FCalculator.EnterNumber('456');
  
  FCalculator.Clear;
  
  Assert.AreEqual('0', FCalculator.GetDisplay);
  Assert.IsFalse(FCalculator.HasError);
  Assert.AreEqual(0.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_EnterNumber_ShouldDisplayCorrectNumber;
begin
  FCalculator.EnterNumber('123');
  Assert.AreEqual('123', FCalculator.GetDisplay);
  
  FCalculator.EnterNumber('456.789');
  Assert.AreEqual('456.789', FCalculator.GetDisplay);
end;

procedure TCalculatorEngineTest.Test_Addition_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('10');
  FCalculator.EnterOperation(opAdd);
  FCalculator.EnterNumber('5');
  FCalculator.Calculate;
  
  Assert.AreEqual(15.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_Subtraction_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('10');
  FCalculator.EnterOperation(opSubtract);
  FCalculator.EnterNumber('3');
  FCalculator.Calculate;
  
  Assert.AreEqual(7.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_Multiplication_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('6');
  FCalculator.EnterOperation(opMultiply);
  FCalculator.EnterNumber('7');
  FCalculator.Calculate;
  
  Assert.AreEqual(42.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_Division_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('15');
  FCalculator.EnterOperation(opDivide);
  FCalculator.EnterNumber('3');
  FCalculator.Calculate;
  
  Assert.AreEqual(5.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_DivisionByZero_ShouldRaiseError;
begin
  FCalculator.EnterNumber('10');
  FCalculator.EnterOperation(opDivide);
  FCalculator.EnterNumber('0');
  FCalculator.Calculate;
  
  Assert.IsTrue(FCalculator.HasError);
  Assert.AreEqual('エラー', FCalculator.GetDisplay);
  Assert.Contains(FCalculator.GetErrorMessage, 'ゼロで割ることはできません');
end;

procedure TCalculatorEngineTest.Test_ChainedOperations_ShouldCalculateCorrectly;
begin
  // 2 + 3 * 4 の順序で入力（順次計算）
  FCalculator.EnterNumber('2');
  FCalculator.EnterOperation(opAdd);
  FCalculator.EnterNumber('3');
  FCalculator.EnterOperation(opMultiply);  // ここで 2+3=5 が計算される
  FCalculator.EnterNumber('4');
  FCalculator.Calculate; // 5*4=20
  
  Assert.AreEqual(20.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_DecimalNumbers_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('3.14');
  FCalculator.EnterOperation(opMultiply);
  FCalculator.EnterNumber('2');
  FCalculator.Calculate;
  
  Assert.AreEqual(6.28, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_NegativeNumbers_ShouldCalculateCorrectly;
begin
  FCalculator.EnterNumber('5');
  FCalculator.EnterOperation(opSubtract);
  FCalculator.EnterNumber('10');
  FCalculator.Calculate;
  
  Assert.AreEqual(-5.0, FCalculator.CurrentValue, 0.001);
end;

procedure TCalculatorEngineTest.Test_ClearEntry_ShouldResetCurrentValue;
begin
  FCalculator.EnterNumber('123');
  FCalculator.ClearEntry;
  
  Assert.AreEqual('0', FCalculator.GetDisplay);
  Assert.IsFalse(FCalculator.HasError);
end;

procedure TCalculatorEngineTest.Test_MultipleOperations_ShouldMaintainAccuracy;
begin
  // 複雑な計算: ((10 + 5) * 2) / 3
  FCalculator.EnterNumber('10');
  FCalculator.EnterOperation(opAdd);
  FCalculator.EnterNumber('5');
  FCalculator.EnterOperation(opMultiply);  // 15
  FCalculator.EnterNumber('2');
  FCalculator.EnterOperation(opDivide);    // 30
  FCalculator.EnterNumber('3');
  FCalculator.Calculate;                   // 10
  
  Assert.AreEqual(10.0, FCalculator.CurrentValue, 0.001);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalculatorEngineTest);

end.