program PK;

uses
  Forms,
  UK in 'UK.pas' {Form1},
  UnitmodulK in 'UnitmodulK.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
