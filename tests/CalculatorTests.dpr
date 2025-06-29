program CalculatorTests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$ENDIF }
  DUnitX.TestFramework,
  CalculatorEngine in '..\src\engines\CalculatorEngine.pas',
  Unit1 in '..\Unit1.pas' {Form1},
  User in '..\src\models\User.pas',
  UserStorage in '..\src\storage\UserStorage.pas',
  SessionManager in '..\src\auth\SessionManager.pas',
  UserManager in '..\src\auth\UserManager.pas',
  TestCalculatorEngine in 'TestCalculatorEngine.pas',
  TestCalculatorForm in 'TestCalculatorForm.pas',
  TestAuthSystem in 'TestAuthSystem.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger : ITestLogger;
{$ENDIF}

begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    // GUI用のフォームが必要な場合はApplication.Initializeを呼ぶ
    TDUnitX.CheckCommandLine;
    runner := TDUnitX.CreateRunner;
    runner.UseRTTI := True;
    
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    
    // NUnit互換のXMLログを生成（CI/CD用）
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;
      
    {$IFNDEF CI}
    // CI環境でない場合は待機
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.