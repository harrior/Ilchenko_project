program Project2;

uses
  Vcl.Forms,
  PGplug in 'PGplug.pas' {Form2},
  Obj in 'Obj.pas',
  Settings in 'Settings.pas' {Form1},
  Calculus in 'Calculus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, MainForm);
  Application.CreateForm(TForm1, SettingForm1);
  Application.Run;
end.
