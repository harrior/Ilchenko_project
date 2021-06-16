unit Calculus;

interface
uses
 System.SysUtils, System.Variants, Vcl.Dialogs, System.Classes, Vcl.ComCtrls, Vcl.Grids,ComObj;


type
TArray2=array of array of real;                //Двумерный динамический массив
TArray3=array of array of array of real;       //Трехмерный динамический массив
Tinfo=record
sObject,sProfile,sNames,sAdress,Other:string;
dDate:Tdate;
end;

//TCalculus = class(TObject)
TCalculus = class
  private
  public
    Info:Tinfo;                                 //Информация об объекте
    Picket:integer;                             //Кол-во пикетов (от нуля включительно)
    Point:integer;                              //Кол-во точек (от нуля включительно)
    K:real;                                     //Коэффициент частоты
    //Таблица 1-F -- исходные данные (Picket x Point)
    //Таблицы 1-H 1-Hv 1-Fv -- рассчитываются на основе 1-F, размерность Picket x Point
    //Таблица скоростей, Исходные данные, размерность Point x 2
    //Сводные таблицы скоростей V1, V2 и V1/V2
    F1,H1,Hv1,Fv1,Speed,TableV1,TableV2,TableV12:TArray2;

    TablesV:TArray3;                            //Таблицы скоростей для каждого пикета. номер пикета, номер поля (Hp,t1,t2,V1,V2,V1/v2),точка на пикете


    procedure LoadF1(FileName:string);          //метод загрузки таблицы 1-F из файла
    procedure LoadSpeed(FileName:string);       //Метод загрузки таблицы Скоростей из файла
    procedure CalcHFTables();                   //метод расчета Таблиц 1-H 1-Hv 1-Fv
    procedure CalcVTables();                    //метод рассчета Таблиц V и V1 V2 V1/V2
    function ShowTable(tType:integer; tArr:TArray2; TName:string; PControl:TPageControl;Sender:TComponent):TStringGrid;
    procedure ShowTable3(tType:integer; tArr:TArray3; TName:string; PControl:TPageControl;Sender:TComponent);
    procedure ShowAllTable(PControl:TPageControl;Sender:TComponent);
    procedure LoadFromGridF1(StringGrid:TStringGrid);
    procedure LoadFromGridSpeed(StringGrid:TStringGrid);
    constructor Create();
    Destructor Destroy(); override;
    function ExportTableToExcel(XLApp:Variant;TableName,Text:String; tArr: TArray2;Mode:integer):Variant;
    procedure ExportSumTablesToExcel(XLApp:Variant;Num:integer);
    procedure ExportToExcel();
    procedure ExcelDrawChart(XLApp,Sheet:Variant);
  end;


implementation
Destructor TCalculus.Destroy;
begin

  inherited;
end;

constructor TCalculus.Create;
var
i,j:integer;
begin
Picket:=5;
Point:=5;
K:=2500;
setlength(F1,Picket+1,Point+1);
setlength(Speed,Point+1,2);
for i := 0 to Picket-1 do
  for j := 0 to Point-1 do
  F1[i,j]:=0;

for i := 0 to Point-1 do
  begin
  Speed[i,0]:=0;
  Speed[i,1]:=0;
  end;

with Info do
  Begin
  sObject:='';
  sProfile:='';
  sNames:='';
  sAdress:='';
  Other:='';
  dDate:=Date();
  end;
end;

procedure TCalculus.LoadF1;
var
Str:TStringList;
s,s2:string;
i,j:integer;
a,b,k:integer;
begin

SetLength(F1,100,20);
a:=-1;
b:=-1;
Str:=TStringList.Create;
Str.LoadFromFile(FileName);
for i:=0 to Str.Count-1 do
  Begin
    s:=Str[i];
    s:=Trim(s);
    IF (s='') Then
     continue //пропускаем пустые строки
    ELSE IF pos('F, Hz',s)<>0 Then
      continue //пропускаем строки с пояснениями
    ELSE IF pos('Блок',s)<>0 Then
     Begin
       a:=a+1; //Увеличивем номер строки
       b:=-1;
     end
   ELSE
     Begin
     b:=b+1;
     k:=pos(chr(9),s);
     if(k=0)then k:=length(s)+1;
      s2:='';
      for j:=1 to k-1 do
        s2:=s2+s[j];
     F1[a,b]:=strtofloat(s2);
     End;
  End;
  Picket:=a;
  Point:=b;
SetLength(F1,Picket+1,Point+1);
SetLength(Speed,Point+1,2);
for I := 0 to 1 do
  for j := 0 to Point do
    Speed[j,i]:=0;
end;

procedure TCalculus.CalcHFtables;
var
i,j:integer;
begin
SetLength(H1,Picket+1,Point+1);
SetLength(Hv1,Picket+1,Point+1);
SetLength(Fv1,Picket+1,Point+1);

for i := 0 to Picket do
  for j := 0 to Point do
    begin
      if F1[i,j]=0 then H1[i,j]:=0 else H1[i,j]:=K/F1[i,j];
      if j=0 then Hv1[i,j]:=H1[i,j]/2 else Hv1[i,j]:=(H1[i,j]+H1[i,j-1])/2;
      if Hv1[i,j]=0 then Fv1[i,j]:=0 else  Fv1[i,j]:=K/Hv1[i,j];
    end;
end;

procedure TCalculus.LoadSpeed(FileName: string);
var
Str:TStringList;
s1,s2:string;
i,b,sN:integer;
begin
SetLength(Speed,Point+1,2);
Str:=TstringList.Create;
Str.LoadFromFile(FileName);
b:=-1;//блок
sN:=-1;
for I := 0 to Str.Count-1 do
  begin
  s1:=Str[i];
  //если текущая строка содержит 'блок', инкремент текущий блок
  if Pos('Блок',s1)>0 then begin b:=b+1; sN:=-1; end
  else
    begin
    //ищем подстроку и копируем числа между табуляциями
     if Pos('Selection',s1)>0 then
      begin
      s2:=copy(s1,pos(#09,s1)+1,5);
      sN:=sN+1;
      s2:=Trim(s2);
      Speed[b,sN]:=strtofloat(s2);
      end;
    end;
  end;
end;

Procedure TCalculus.CalcVTables;
var
i,j:integer;
begin
Setlength(TablesV,Picket+1,6,Point+1);//номер пикета, номер поля (Hp,t1,t2,V1,V2,V1/v2),точка

for I := 0 to Picket do
  for j := 0 to Point do
    begin
    TablesV[i,0,j]:=Hv1[i,j];         // значение точки на пикете
    TablesV[i,1,j]:=Speed[j,0];       //t1 на точке
    TablesV[i,2,j]:=Speed[j,1];;      //t2 на точке

    if TablesV[i,1,j]=0 then TablesV[i,3,j]:=0 else TablesV[i,3,j]:=TablesV[i,0,j]/TablesV[i,1,j];
    if TablesV[i,2,j]=0 then TablesV[i,4,j]:=0 else TablesV[i,4,j]:=TablesV[i,0,j]/TablesV[i,2,j];
    if TablesV[i,4,j]=0 then TablesV[i,5,j]:=0 else TablesV[i,5,j]:=TablesV[i,3,j]/TablesV[i,4,j];
{    TablesV[i,3,j]:=TablesV[i,0,j]/TablesV[i,1,j];  //V1 = Hv1jt1j
    TablesV[i,4,j]:=TablesV[i,0,j]/TablesV[i,2,j];  //V1 = Hv1jt1j
    TablesV[i,5,j]:=TablesV[i,3,j]/TablesV[i,4,j]; //V1/V2}
    end;

SetLength(TableV1,Picket+1,Point+1);
SetLength(TableV2,Picket+1,Point+1);
SetLength(TableV12,Picket+1,Point+1);
for I := 0 to Picket do
  for j := 0 to Point do
  begin
    TableV1[i,j]:=TablesV[i,3,j]; //заполняем таблицу V1
    TableV2[i,j]:=TablesV[i,4,j]; //заполняем таблицу V2
    TableV12[i,j]:=TablesV[i,5,j]; //заполняем таблицу V1/V2
  end;

end;

function TCalculus.ShowTable(tType: Integer; tArr: TArray2; TName:string; PControl: TPageControl;Sender:TComponent):TStringGrid;
var
TabSheet:TTabSheet;
StringGrid:TStringGrid;
  i: Integer;
  j: Integer;
begin
TabSheet:=TTabSheet.Create(Sender);
TabSheet.PageControl:=PControl;
TabSheet.Caption:=TName;
StringGrid:=TStringGrid.Create(Sender);
StringGrid.Parent:=TabSheet;
StringGrid.Left:=0;
StringGrid.Top:=0;
StringGrid.Width:=TabSheet.Width;
StringGrid.Height:=TabSheet.Height;
StringGrid.Options:=StringGrid.Options+[goEditing]+[goRowSizing]+[goColSizing];

  if tType=1 then //форма первого типа -  1-F 1-H и остальные, включая V1 V2 V1/V2
  begin
  StringGrid.RowCount:=Point+2;
  StringGrid.ColCount:=Picket+2;
  for i := 0 to Picket+1 do
    for j := 0 to Point+1 do
    begin
      StringGrid.Cells[0,j]:=inttostr(j);
      StringGrid.Cells[i,0]:=inttostr(i);
    end;
  for i := 0 to Picket do
    for j := 0 to Point do
      StringGrid.Cells[i+1,j+1]:=floattostr(tArr[i,j]);
  end

  else if tType=2 then //форма второго типа - Таблица V
  begin
  StringGrid.RowCount:=Point+2;
  StringGrid.ColCount:=6;
  for i := 1 to Point+1 do
    StringGrid.Cells[0,i]:=inttostr(i);
  StringGrid.Cells[1,0]:='H-p-n-vi';
  StringGrid.Cells[2,0]:='t1,с';
  StringGrid.Cells[3,0]:='t2,с';
  StringGrid.Cells[4,0]:='V1(p),м/c';
  StringGrid.Cells[5,0]:='V2(p),м/c';
  StringGrid.Cells[6,0]:='V1/V2';
  for i := 0 to 5 do
    for j := 0 to Point do
      StringGrid.Cells[i+1,j+1]:=floattostr(tArr[i,j]);
  end

  else if tType=3 then //форма 3 типа - Таблица скоростей
  begin
  StringGrid.RowCount:=Point+2;
  StringGrid.ColCount:=3; //3 колонки
  StringGrid.Cells[1,0]:='t1';
  StringGrid.Cells[2,0]:='t2';
  for i := 1 to Point+1 do
    StringGrid.Cells[0,i]:=inttostr(i);
  for i := 0 to 1 do
    for j := 0 to Point do
      StringGrid.Cells[i+1,j+1]:=floattostr(tArr[j,i]);
  end;
ShowTable:=StringGrid;
end;

procedure TCalculus.ShowTable3(tType: Integer; tArr: TArray3; TName: string; PControl: TPageControl; Sender: TComponent);
var
i,j,pic:integer;
TArr2:TArray2;
begin
SetLength(TArr2,6,Point+1);
for pic := 0 to Picket do
Begin
for i := 0 to Point do
  for j := 0 to 5 do
    TArr2[j,i]:=tArr[pic,j,i];
//номер пикета, номер поля (Hp,t1,t2,V1,V2,V1/v2),точка
  ShowTable(2,TArr2,'Таблица V'+IntToStr(pic+1),PControl,Sender);
end;
end;

procedure TCalculus.ShowAllTable(PControl: TPageControl; Sender: TComponent);
var
i:integer;
begin
  PControl.Visible:=false;
  for i := 0 to PControl.PageCount-1 do PControl.Pages[0].Destroy;
  ShowTable(1,F1,'Таблица 1-F',PControl,Sender);
  ShowTable(1,H1,'Таблица 1-H',PControl,Sender);
  ShowTable(1,Hv1,'Таблица 1-Hv',PControl,Sender);
  ShowTable(1,Fv1,'Таблица 1-Fv',PControl,Sender);
  ShowTable(3,Speed,'Скорости',PControl,Sender);
  ShowTable3(2,TablesV,'',PControl,Sender);
  ShowTable(1,TableV1,'Таблица V1',PControl,Sender);
  ShowTable(1,TableV2,'Таблица V2',PControl,Sender);
  ShowTable(1,TableV12,'Таблица V1/2',PControl,Sender);
  PControl.Visible:=true;
end;

procedure TCalculus.LoadFromGridF1(StringGrid:TStringGrid);//
var
i,j:integer;
str:string;
begin
SetLength(F1,Picket+1, Point+1);
for i := 0 to Picket do
  for j := 0 to Point do
  Begin
  str:=StringGrid.Cells[i+1,j+1];
    F1[i,j]:=strtofloat(str);
  End;
SetLength(Speed,Point+1,2);
end;

procedure TCalculus.LoadFromGridSpeed(StringGrid: TStringGrid);
var
i,j:integer;
str:string;
begin
//SetLength(Speed,Point+1,2);
for i := 0 to 1 do

  for j := 0 to Point do
  begin
    str:=StringGrid.Cells[i+1,j+1];
    str:=Trim(str);
    Speed[j,i]:=strtofloat(str);
  end;
end;

function TCalculus.ExportTableToExcel(XLApp:Variant;TableName,Text:String; tArr: TArray2;Mode:integer):Variant;
var
Sheet:Variant;
i,j:integer;
begin
Sheet:=XLApp.Worksheets.Add();
Sheet.Activate;
Sheet.Name:=TableName;
if Mode=1 then
  begin
  //объединить до конца строки (Picket+1), выравнивание по левому краю
  Sheet.Cells[1,1]:='Объект '+Info.sObject+' '+Info.sAdress;
  Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[1,Picket+2]].Select; XLApp.Selection.MergeCells:=True;
  Sheet.Cells[2,1]:='МССП-РС, Профиль №'+Info.sProfile+', Дата исследований '+ DateToStr(Info.dDate);
  Sheet.Range[Sheet.Cells[2,1],Sheet.Cells[2,Picket+2]].Select; XLApp.Selection.MergeCells:=True;
  Sheet.Cells[3,1]:='Ф.И.О. выполнявших исследования: '+ Info.sNames;
  Sheet.Range[Sheet.Cells[3,1],Sheet.Cells[3,Picket+2]].Select; XLApp.Selection.MergeCells:=True;
  //объеденить 4.1-4.6
  Sheet.Cells[4,1]:='№ точки границ на пикете';
  Sheet.Range[Sheet.Cells[4,1],Sheet.Cells[6,1]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.WrapText:=True;
  XLApp.Selection.RowHeight:=20;
  XLApp.Selection.HorizontalAlignment:=3;
  //объеденить со второго поля и до Picket
  Sheet.Cells[4,2]:='Номер пикета';
  Sheet.Range[Sheet.Cells[4,2],Sheet.Cells[4,Picket+2]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.HorizontalAlignment:=3;
  Sheet.Cells[6,2]:=Text;
  Sheet.Range[Sheet.Cells[6,2],Sheet.Cells[6,Picket+2]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.HorizontalAlignment:=3;
  //Выделяем границы
  Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[7+Point,2+Picket]].Select;
  XLApp.Selection.Borders.LineStyle:=1;
  Sheet.Cells[1,1].Select;
  //подписи Pickets нумерация по горизонтали
  for I := 0 to Picket do
    Sheet.Cells[5,2+i]:=inttostr(i+1);
  //подписи Points по вертикали
  for I := 0 to Point do
    Sheet.Cells[7+i,1]:=inttostr(i+1);

  // вывод значений массива
  for I := 0 to Picket do
    for j := 0 to Point do
      Sheet.Cells[7+j,2+i]:=tArr[i,j];
  end

  else
  if Mode=2 then //Рисуем форму пикетов
  Begin
  //объединить до конца строки (Picket+1), выравнивание по левому краю
  Sheet.Cells[1,1]:='Объект '+Info.sObject+' '+Info.sAdress;
  Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[1,7]].Select; XLApp.Selection.MergeCells:=True;
  Sheet.Cells[2,1]:='МССП-РС, Профиль №'+Info.sProfile+', Дата исследований '+ DateToStr(Info.dDate);
  Sheet.Range[Sheet.Cells[2,1],Sheet.Cells[2,7]].Select; XLApp.Selection.MergeCells:=True;
  Sheet.Cells[3,1]:='Ф.И.О. выполнявших исследования: '+ Info.sNames;
  Sheet.Range[Sheet.Cells[3,1],Sheet.Cells[3,7]].Select; XLApp.Selection.MergeCells:=True;
  //объеденить 4.1-4.6
  Sheet.Cells[4,1]:='№ точки границ на пикете';
  Sheet.Range[Sheet.Cells[4,1],Sheet.Cells[6,1]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.WrapText:=True;
  XLApp.Selection.RowHeight:=20;
  XLApp.Selection.HorizontalAlignment:=3;
  //объеденить со второго поля и до Picket
  Sheet.Cells[4,2]:='Номер пикета';
  Sheet.Range[Sheet.Cells[4,2],Sheet.Cells[4,7]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.HorizontalAlignment:=3;
  Sheet.Cells[5,2]:=Text;
  Sheet.Range[Sheet.Cells[5,2],Sheet.Cells[5,7]].Select;
  XLApp.Selection.MergeCells:=True;
  XLApp.Selection.HorizontalAlignment:=3;
  //Выделяем границы
  Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[7+Point,7]].Select;
  XLApp.Selection.Borders.LineStyle:=1;
  Sheet.Cells[1,1].Select;
  //подписи Pickets подписи по горизонтали
  Sheet.Cells[6,2]:='H p-n-vi, м,';
  Sheet.Cells[6,3]:='t1, c';
  Sheet.Cells[6,4]:='t2, c';
  Sheet.Cells[6,5]:='V1(p),м/c';
  Sheet.Cells[6,6]:='V2(s),м/с';
  Sheet.Cells[6,7]:='V1/V2';
  //подписи Points по вертикали
  for I := 0 to Point do
    Sheet.Cells[7+i,1]:=inttostr(i+1);

  // вывод значений массива
  for i := 0 to 5 do
    for j := 0 to Point do
      Sheet.Cells[7+j,2+i]:=tArr[i,j];
  End;
ExportTableToExcel:=Sheet;
end;

Procedure TCalculus.ExportToExcel;
var
XLApp:Variant;
i,j,pic:integer;
TArr2:TArray2;
begin
XLApp:=CreateOleObject('Excel.Application');
XLApp.Workbooks.Add;
XLApp.Visible:=true;

SetLength(TArr2,6,Point+1);
for pic := 0 to Picket do
Begin
for i := 0 to Point do
  for j := 0 to 5 do
    TArr2[j,i]:=TablesV[pic,j,i];
    ExportTableToExcel(XLApp,'Таблица V-Пикет('+inttostr(pic+1)+')',inttostr(pic+1),TArr2,2);
end;

ExcelDrawChart(XLApp,ExportTableToExcel(XLApp,'Таблица V12','V1/V2',TableV12,1));
ExcelDrawChart(XLApp,ExportTableToExcel(XLApp,'Таблица V2','V2(s),  м/с',TableV2,1));
ExcelDrawChart(XLApp,ExportTableToExcel(XLApp,'Таблица V1','V1(p),  м/с',TableV1,1));
ExportTableToExcel(XLApp,'Таблица 1-Fv','Частота F p-n-vi, Гц',Fv1,1);
ExportTableToExcel(XLApp,'Таблица 1-Hv','Глубина H p-n- vi',Hv1,1);
ExcelDrawChart(XLApp,ExportTableToExcel(XLApp,'Таблица 1-H','Частота F p-n-i, Гц',H1,1));
ExportTableToExcel(XLApp,'Таблица 1-F','Частота F p-n-i, Гц',F1,1);
for I := Picket downto 0 do
  ExportSumTablesToExcel(XLApp,i);
end;

procedure TCalculus.ExcelDrawChart(XLApp,Sheet:Variant);
begin
XLApp.Range[Sheet.Cells[7,2],Sheet.Cells[7+Point,2+Picket]].Select;
Sheet.Shapes.AddChart.Select;
XLApp.ActiveChart.ChartType:=4;
XLApp.ActiveChart.PlotBy:=1;
XLApp.ActiveChart.Axes(2).ReversePlotOrder := True;
XLApp.ActiveChart.Location(1);
end;

procedure TCalculus.ExportSumTablesToExcel(XLApp:Variant;Num:integer);
var
i,j:integer;
Sheet:Variant;
begin
Sheet:=XLApp.Worksheets.Add();
Sheet.Activate;
Sheet.Name:='Пикет '+IntToStr(num+1);

Sheet.Cells[1,1]:='Физические и физико-механические свойства грунтов (средние значения) по профилю Пр.'+Info.sProfile+' Пикет '+IntToStr(num+1);
Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[1,11]].Select;
XLApp.Selection.MergeCells:=True;
XLApp.Selection.WrapText:=True;
XLApp.Selection.HorizontalAlignment:=3;

Sheet.Cells[2,1]:='Номер слоя';
Sheet.Cells[3,1]:='N';
Sheet.Cells[2,2]:='Описание выделенных слоев';
Sheet.Cells[2,3]:='Подошва слоя';
Sheet.Cells[2,4]:='Мощность,м';
Sheet.Cells[3,4]:='h';
Sheet.Cells[2,5]:='Плоность грунта';
Sheet.Cells[3,5]:='Pn';
Sheet.Cells[2,6]:='Коэффициент пористости';
Sheet.Cells[3,6]:='e';
Sheet.Cells[2,7]:='Модуль деформации, Мпа';
Sheet.Cells[3,7]:='E';
Sheet.Cells[2,8]:='Удельное сцепление, Мпа';
Sheet.Cells[3,8]:='Cn';
Sheet.Cells[2,9]:='Скорость, Vp, м/сек';
Sheet.Cells[3,9]:='Vp';
Sheet.Cells[2,10]:='Скорость, Vs, м/сек';
Sheet.Cells[3,10]:='Vs';
Sheet.Cells[2,11]:='Отношение Vp/Vs';
Sheet.Range[Sheet.Cells[2,1],Sheet.Cells[3,11]].Select;
XLApp.Selection.WrapText:=True;
XLApp.Selection.HorizontalAlignment:=3;
XLApp.Selection.VerticalAlignment:=1;
Sheet.Range[Sheet.Cells[1,1],Sheet.Cells[4+Point,11]].Select;
XLApp.Selection.Borders.LineStyle:=1;
Sheet.Cells[4,1].Select;

for I := 0 to Point do
  begin
  Sheet.Cells[4+i,1]:=i+1;
  Sheet.Cells[4+i,3]:=H1[Num,i];
  Sheet.Cells[4+i,9]:=TableV1[num,i];
  Sheet.Cells[4+i,10]:=TableV2[num,i];
  Sheet.Cells[4+i,11]:=TableV12[num,i];
  end;
end;

end.



