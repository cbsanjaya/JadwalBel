unit Log.Sql;

interface


uses
  System.SysUtils,
  Aurelius.Drivers.Interfaces,
  Aurelius.Mapping.Explorer,
  Aurelius.Events.Manager;

type
  TSqlLog = class
  private
    FSqlExecutingProc: TSQLExecutingProc;
    procedure SqlExecutingHandler(Args: TSQLExecutingArgs);
  private
    procedure LogFile(const S: string);
  public
    constructor Create;
  end;
implementation

{ TSqlLog }

constructor TSqlLog.Create;
var
  E: TManagerEvents;
begin
  FSqlExecutingProc := SqlExecutingHandler;

  E := TMappingExplorer.Default.Events;
  E.OnSQLExecuting.Subscribe(FSqlExecutingProc);
end;

procedure TSqlLog.LogFile(const S: string);
var
  Filename: string;
  LogFile: TextFile;
begin
  // prepares log file
  Filename := 'SqlLog.txt';
  AssignFile (LogFile, Filename);
  if FileExists (FileName) then
    Append (LogFile) // open existing file
  else
    Rewrite (LogFile); // create a new one
  try
    Writeln (LogFile, S);
  finally
    // close the file
    CloseFile (LogFile);
  end;
end;

procedure TSqlLog.SqlExecutingHandler(Args: TSQLExecutingArgs);
var
  Param: TDBParam;
begin
  LogFile(Args.SQL);
  if Args.Params <> nil then
    for Param in Args.Params do
      LogFile(Param.ToString);
  LogFile('================================================');
end;

end.
