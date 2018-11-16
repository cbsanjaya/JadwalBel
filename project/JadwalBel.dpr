program JadwalBel;

uses
  Vcl.Forms,
  MainForm in '..\src\MainForm.pas' {FormUtama};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormUtama, FormUtama);
  Application.Run;
end.
