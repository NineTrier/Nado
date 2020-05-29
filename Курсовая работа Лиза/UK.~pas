unit UK;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, UnitmodulK, Grids;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    SaveToTxt1: TMenuItem;
    Open1: TMenuItem;
    Spisok1: TMenuItem;
    Build1: TMenuItem;
    Itog1: TMenuItem;
    Delete1: TMenuItem;
    Look1: TMenuItem;
    SaveDialogTxt: TSaveDialog;
    SaveDialogTip: TSaveDialog;
    OpenDialog1: TOpenDialog;
    DobavitVSpisok1: TMenuItem;
    OpenDialog2: TOpenDialog;
    Tabl: TStringGrid;
    Poisk1: TMenuItem;
    procedure SaveToTxt1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Build1Click(Sender: TObject);
    procedure Itog1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure DobavitVSpisok1Click(Sender: TObject);
    procedure Look1Click(Sender: TObject);
    procedure Poisk1Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ftxt:text;
  ftip:fzap;
  Sp,SpP:puzel;

implementation

{$R *.dfm}

procedure TForm1.SaveToTxt1Click(Sender: TObject);
var
  s,s1:string;
begin
  if (savedialogTxt.execute) then begin
    s:=SaveDialogTxt.FileName;
    AssignFile(ftxt,s);
    Append(ftxt);
    WriteSpText(Sp,ftxt);
    closefile(ftxt);
  end
  else exit;
  if savedialogTip.execute then begin
    s1:=SaveDialogTip.FileName;
    AssignFile(ftip,s1);
    rewrite(ftip);
    WriteSpTip(Sp,ftip);
    closefile(ftip);
  end
  else exit;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  s:string;
begin
  if not OpenDialog1.Execute then exit;
  s:=OpenDialog1.FileName;
  Assignfile(ftip,s);
  reset(ftip);
  BuildSpisokFromTip(Sp,ftip);
  closefile(ftip);
end;

procedure TForm1.Build1Click(Sender: TObject);
begin
  BuildSpisok(Sp);
end;

procedure TForm1.Itog1Click(Sender: TObject);
var
  s:string;
begin
  if not OpenDialog2.Execute then exit;
  s:=OpenDialog2.FileName;
  assignfile(ftxt,s);
  append(ftxt);
  ItogDay(Sp,ftxt);
  closeFile(ftxt);
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  DelSpisok(Sp);
end;

procedure TForm1.DobavitVSpisok1Click(Sender: TObject);
begin
  DobVSp(Sp);
end;

procedure TForm1.Look1Click(Sender: TObject);
var
  a,b:puzel;
  sum,sum1,k:integer;
begin
  a:=sp;
  PoslElem(a,b);
  sum1:=b^.x.ObProdaj*b^.x.CenaTovara;
  a:=sp;
  k:=1;
  tabl.Visible:=true;
  tabl.cells[1,0]:='ФИО продавца';
  tabl.cells[2,0]:='Название товара';
  tabl.cells[3,0]:='Объём продаж';
  tabl.cells[4,0]:='Цена товара';
  tabl.cells[5,0]:='Итого';
  While not(a=nil) do begin
    sum:=a^.x.ObProdaj*a^.x.CenaTovara;
    Tabl.cells[0,k]:=IntToStr(k);
    Tabl.cells[1,k]:=a^.x.FIOProdavca;
    Tabl.cells[2,k]:=a^.x.NameTovar;
    Tabl.cells[3,k]:=IntToStr(a^.x.ObProdaj)+' шт.';
    Tabl.cells[4,k]:=IntToStr(a^.x.CenaTovara)+' руб.';
    Tabl.cells[5,k]:=IntToStr(sum)+' руб.';
    sum1:=sum1+sum;
    inc(k);
    Tabl.RowCount:=k+1;
    Tabl.Height:=Tabl.RowCount*26;
    Form1.Height:=Tabl.height+(3*26);
    Tabl.cells[4,k]:='Итого:';
    Tabl.cells[5,k+1]:=IntToStr(sum1)+ ' руб.';
    a:=a^.next;
  end;

end;

procedure TForm1.Poisk1Click(Sender: TObject);
var
  a:puzel;
  sum,k:integer;
begin
  SpP:=nil;
  a:=Sp;
  sort(a,SpP);
  k:=1;
  tabl.visible:=true;
  While not(a=nil) do begin
    sum:=a^.x.ObProdaj*a^.x.CenaTovara;
    Tabl.cells[0,k]:=IntToStr(k);
    Tabl.cells[1,k]:=a^.x.FIOProdavca;
    Tabl.cells[2,k]:=a^.x.NameTovar;
    Tabl.cells[3,k]:=IntToStr(a^.x.ObProdaj)+' шт.';
    Tabl.cells[4,k]:=IntToStr(a^.x.CenaTovara)+' руб.';
    Tabl.cells[5,k]:=IntToStr(sum)+' руб.';
    inc(k);
    Tabl.RowCount:=k+1;
    Tabl.Height:=Tabl.RowCount*26;
    Form1.Height:=Tabl.height+(3*26);
    a:=a^.next;
  end;
end;

end.
