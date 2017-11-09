program YaziDenetim;

uses
  Vcl.Forms,
  main in 'main.pas' {Form1},
  uTSD in 'uTSD.pas',
  uTools in 'uTools.pas',
  uOneri in 'uOneri.pas' {frmOneri};

{$R *.res}

begin
   Application.Initialize;
   Application.MainFormOnTaskbar := True;
   Application.Title := 'Türkçe Dili Sözcük Denetimi';
   Application.CreateForm(TForm1, Form1);
  Application.Run;

end.
