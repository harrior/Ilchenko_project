unit PGplug;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Grids, Settings, Calculus;

type
  TForm2 = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    EnterDataButton: TButton;
    ExportExcelButton: TButton;
    procedure EnterDataButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExportExcelButtonClick(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
 end;



 var
  MainForm: TForm2;
  MainObj: TCalculus;

implementation
{$R *.dfm}

procedure TForm2.EnterDataButtonClick(Sender: TObject);
begin
SettingForm1.ShowModal;
MainObj.CalcHFtables;
MainObj.CalcVTables;
MainObj.ShowAllTable(PageControl1,Self);
ExportExcelButton.Enabled:=True;
end;

procedure TForm2.ExportExcelButtonClick(Sender: TObject);
begin
{MainObj.LoadF1('D:\git_tutorial\work\powergraph plugin ref\DataPad1.ts.txt');
MainObj.LoadSpeed('D:\git_tutorial\work\powergraph plugin ref\DataPad 2 - рабочий.txt');
MainObj.CalcHFtables;
MainObj.CalcVTables;
MainObj.ShowAllTable(PageControl1,Self);}
MainObj.ExportToExcel;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
MainObj:=TCalculus.Create;
end;

procedure TForm2.FormResize(Sender: TObject);
begin
PageControl1.Height:=MainForm.Height-15;
PageControl1.Width:=MainForm.Width-30;
end;



end.
