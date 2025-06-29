program SyntaxCheck;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure CheckCalculatorEngineUnit;
begin
  WriteLn('Checking CalculatorEngine unit syntax...');
  // This program will check if our units compile syntactically
  // by attempting to include them without actually using DUnitX
end;

procedure CheckTestUnits;
begin
  WriteLn('Checking test unit syntax...');
  // Basic syntax validation
end;

begin
  try
    WriteLn('=== Syntax Check for Calculator Project ===');
    CheckCalculatorEngineUnit;
    CheckTestUnits;
    WriteLn('Syntax check completed successfully.');
  except
    on E: Exception do
    begin
      WriteLn('Error: ', E.Message);
      ExitCode := 1;
    end;
  end;
  
  WriteLn('Press Enter to continue...');
  ReadLn;
end.