unit Settings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Calculus, Vcl.Grids;

type
  TForm1 = class(TForm)
    InfoPanel: TPanel;
    SaveButton: TButton;
    AbortButton: TButton;
    ObjectEdit: TEdit;
    ObjectLabel: TLabel;
    AdressEdit: TEdit;
    AdressLabel: TLabel;
    OtherEdit: TEdit;
    OtherLabel: TLabel;
    ProfileEdit: TEdit;
    ProfileLabel: TLabel;
    NamesEdit: TEdit;
    NamesLabel: TLabel;
    DateLabel: TLabel;
    DateTime: TDateTimePicker;
    PageControl1: TPageControl;
    PicketEdit: TEdit;
    PicketLabel: TLabel;
    PointLabel: TLabel;
    PointEdit: TEdit;
    KEdit: TEdit;
    KLabel: TLabel;
    F1LoadButton: TButton;
    SpeedLoadButton: TButton;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure F1LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SpeedLoadButtonClick(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);
    procedure ObjShow();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingForm1: TForm1;
  TempObj:TCalculus;
  TempF1,TempSpeed:TStringGrid;

implementation

{$R *.dfm}

uses PGplug;

procedure TForm1.FormCreate(Sender: TObject);
begin
DateTime.Date:=Date;
end;

procedure TForm1.AbortButtonClick(Sender: TObject);
begin
TempObj.Destroy;
close;
end;

procedure TForm1.F1LoadButtonClick(Sender: TObject);
begin
if OpenDialog1.Execute then
  TempObj.LoadF1(OpenDialog1.FileName);

ObjShow();
end;



procedure TForm1.FormShow(Sender: TObject);
begin
TempObj:=TCalculus.Create;// Создаем временный экземпляр объекта
TempObj.Picket:=MainObj.Picket;
TempObj.Point:=MainObj.Point;
TempObj.K:=MainObj.K;
TempObj.F1:=MainObj.F1;
TempObj.Speed:=MainObj.Speed;
TempObj.Info:=MainObj.Info;

with TempObj.Info do
begin
  ObjectEdit.Text:=sObject;
  ProfileEdit.Text:=sProfile;
  NamesEdit.Text:=sNames;
  AdressEdit.Text:=sAdress;
  OtherEdit.Text:=Other;
  DateTime.Date:=dDate;
end;

ObjShow();
end;

procedure TForm1.SaveButtonClick(Sender: TObject);
Begin
with TempObj.Info do
begin
  sObject:=ObjectEdit.Text;
  sProfile:=ProfileEdit.Text;
  sNames:=NamesEdit.Text;
  sAdress:=AdressEdit.Text;
  Other:=OtherEdit.Text;
  dDate:=DateTime.Date;
end;
TempObj.K:=strtofloat(KEdit.Text);
TempObj.LoadFromGridF1(TempF1);
TempObj.LoadFromGridSpeed(TempSpeed);

MainObj.Info:=TempObj.Info;
MainObj.Picket:=TempObj.Picket;
MainObj.Point:=TempObj.Point;
MainObj.K:=TempObj.K;
MainObj.Speed:=TempObj.Speed;
MainObj.F1:=TempObj.F1;


TempObj.Destroy;

close;
end;

procedure TForm1.SpeedLoadButtonClick(Sender: TObject);
begin
if OpenDialog1.Execute then
TempObj.LoadSpeed(OpenDialog1.FileName);

ObjShow();
end;

procedure TForm1.ObjShow;
var
i:integer;
begin
for i := 0 to PageControl1.PageCount-1 do PageControl1.Pages[0].Destroy;

TempF1:=TempObj.ShowTable(1,TempObj.F1,'1-F',PageControl1,Self);
TempSpeed:=TempObj.ShowTable(3,TempObj.Speed,'Скорости',PageControl1,Self);

KEdit.Text:=floattostr(TempObj.K);
PicketEdit.Text:=inttostr(TempObj.Picket+1);
PointEdit.Text:=inttostr(TempObj.Point+1);
end;
end.
