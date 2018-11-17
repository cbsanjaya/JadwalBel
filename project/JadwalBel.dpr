program JadwalBel;

uses
  Vcl.Forms,
  Entities in '..\src\Entities.pas',
  View.Main in '..\src\View.Main.pas' {FormUtama},
  ConnectionModule in '..\src\ConnectionModule.pas' {SQLiteSQLiteConnection: TDataModule},
  DbUtils in '..\src\DbUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormUtama, FormUtama);
  Application.Run;
end.
