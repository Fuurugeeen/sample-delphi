unit CalculatorEngine;

interface

uses
  System.SysUtils;

type
  TOperation = (opNone, opAdd, opSubtract, opMultiply, opDivide);
  
  TCalculatorEngine = class
  private
    FCurrentValue: Double;
    FStoredValue: Double;
    FCurrentOperation: TOperation;
    FWaitingForOperand: Boolean;
    FHasError: Boolean;
    FErrorMessage: string;
    
    function PerformOperation(Value1, Value2: Double; Operation: TOperation): Double;
  public
    constructor Create;
    
    procedure Clear;
    procedure ClearEntry;
    procedure EnterNumber(const Number: string);
    procedure EnterOperation(Operation: TOperation);
    procedure Calculate;
    
    function GetDisplay: string;
    function HasError: Boolean;
    function GetErrorMessage: string;
    
    property CurrentValue: Double read FCurrentValue;
  end;

implementation

constructor TCalculatorEngine.Create;
begin
  inherited Create;
  Clear;
end;

procedure TCalculatorEngine.Clear;
begin
  FCurrentValue := 0;
  FStoredValue := 0;
  FCurrentOperation := opNone;
  FWaitingForOperand := True;
  FHasError := False;
  FErrorMessage := '';
end;

procedure TCalculatorEngine.ClearEntry;
begin
  FCurrentValue := 0;
  FHasError := False;
  FErrorMessage := '';
end;

procedure TCalculatorEngine.EnterNumber(const Number: string);
var
  Value: Double;
begin
  if FHasError then
    Clear;
    
  if TryStrToFloat(Number, Value) then
  begin
    if FWaitingForOperand then
    begin
      FCurrentValue := Value;
      FWaitingForOperand := False;
    end
    else
    begin
      // 既存の数値に新しい桁を追加
      FCurrentValue := Value;
    end;
  end;
end;

procedure TCalculatorEngine.EnterOperation(Operation: TOperation);
begin
  if FHasError then
    Exit;
    
  if not FWaitingForOperand then
  begin
    if FCurrentOperation <> opNone then
      Calculate;
  end;
  
  FStoredValue := FCurrentValue;
  FCurrentOperation := Operation;
  FWaitingForOperand := True;
end;

procedure TCalculatorEngine.Calculate;
var
  Result: Double;
begin
  if FHasError or (FCurrentOperation = opNone) then
    Exit;
    
  try
    Result := PerformOperation(FStoredValue, FCurrentValue, FCurrentOperation);
    FCurrentValue := Result;
    FCurrentOperation := opNone;
    FWaitingForOperand := True;
  except
    on E: Exception do
    begin
      FHasError := True;
      FErrorMessage := E.Message;
    end;
  end;
end;

function TCalculatorEngine.PerformOperation(Value1, Value2: Double; Operation: TOperation): Double;
begin
  case Operation of
    opAdd: Result := Value1 + Value2;
    opSubtract: Result := Value1 - Value2;
    opMultiply: Result := Value1 * Value2;
    opDivide: 
    begin
      if Value2 = 0 then
        raise Exception.Create(string('ゼロで割ることはできません'))
      else
        Result := Value1 / Value2;
    end;
    else
      Result := Value2;
  end;
end;

function TCalculatorEngine.GetDisplay: string;
begin
  if FHasError then
    Result := string('エラー')
  else
    Result := FloatToStr(FCurrentValue);
end;

function TCalculatorEngine.HasError: Boolean;
begin
  Result := FHasError;
end;

function TCalculatorEngine.GetErrorMessage: string;
begin
  Result := FErrorMessage;
end;

end.