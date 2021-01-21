program PolOperations;

uses
  Forms,
  PolOperationsGUI in 'PolOperationsGUI.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
