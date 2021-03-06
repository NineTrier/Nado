unit UnitmodulK;

interface

  uses
    SysUtils, Dialogs;

  Type
	  Tovar = record //��� ������ ��� ����� ������, ������� ����� ��������� � ���� ������
		  NameTovar:string[30]; //�������� ������
		  ObProdaj:integer; //����� ������ ������� ������
		  CenaTovara:integer; //���� ������
		  FIOProdavca:string[30]; //��� ��������
	  end;
	  PUzel = ^Zl;//��������� �� ��� ������, ��������� ������
	  Zl = record //������, ����������� ������
		  x:Tovar;//����������, ���������� � ����� ������
		  next:puzel;//��������� �� ��������� ����
		  pred:puzel;//��������� �� ���������� ����
	  end;
    Fzap = file of Tovar;//�������������� ����, ��� �������� ���� ������

  procedure BuildSpisok(var f: PUzel);//���������, ��� ���������� ������
  procedure AddFirst(var f: PUzel; a: PUzel);//�������� ���� a ������ � ������
  procedure AddAfter(var old:PUzel; a: PUzel);//�������� ���� a ����� old
  procedure WriteSpTip(var f: PUzel; var ftip:Fzap);//�������� ������ ������ � �������������� ����
  procedure WriteSpText(var f: PUzel; var ftxt:Text); //�������� � ��������� ����
  procedure BuildSpisokFromTip(var f:puzel;var ftip:Fzap); //��������� ������ �� ������, ������ �� ���. �����
  procedure DelFirstElement(var f,a: PUzel);//�������� ������ ������� ������
  procedure DelElement(var old,a: PUzel);//�������� ������� �� ������, ��������� �� old
  procedure ItogDay(var f:puzel;var ftxt:text);//��������� ��� ���������� ������
  procedure DobVSp(var f:puzel);//��������� � ������ ����� ��������, �� ������ ������
  procedure DelSpisok(var f: PUzel); //������� ������
  procedure PoslElem(f:puzel;var a:puzel);
  procedure Sort(f:puzel;var b:puzel);

implementation

procedure AddFirst(var f:puzel;a:puzel);//f-��������� �� ������, a-���� ������� �������� � ������
begin
  a^.next:=f;
  if f<>nil then f^.pred:=a;
  f:=a;
end;

procedure AddAfter(var old:puzel;a:puzel);//old-��������� �� �����, �-����, ������� �������� � �����
begin
  a^.next:=old^.next;
  old^.next:=a;
  if a^.next<>nil then old^.next^.pred:=a;
  a^.pred:=old;
end;

procedure BuildSpisok(var f: PUzel);
var
  d,a:puzel;
  ch,ch2:char;
begin
  f:=nil;
  repeat
    new(a);
    with a^.x do begin
      NameTovar := InputBox('������� �������� ������',' ',' ');
      ObProdaj := StrToInt(InputBox('������� ����� �������',' ',' '));
      CenaTovara := StrToInt(InputBox('������� ���� ������',' ',' '));
      FIOProdavca:= InputBox('������� ��� ��������',' ',' ');
    end;
    a^.next:=nil;
    a^.pred:=nil;//��������� �� ���������� � ��������� ����� ��������, ����� ��� �� ��������� �� ���-�� �� ������ ���.
    ch2:=InputBox('������� ������ � ���� ������?','�-��, �-���','')[1];
    if (ch2 = 'Y') or (ch2='y')or (ch2 = '�') or (ch2 = '�') then begin
      if (f=nil) then begin
        AddFirst(f,a);
        d:=f;
      end
      else begin
        AddAfter(d,a);
        d:=a;
      end;
    end;
    ch:= InputBox('������ ������ ���?','�-�� �-���','')[1];
  until (ch = 'N') or (ch ='n')or (ch = '�') or (ch = '�');
end;

procedure WriteSpTip(var f: PUzel; var ftip:Fzap);
var
  p: PUzel;
  y: tovar;
begin
  p:= f;
  while not(p = nil) do
  begin
    y:= p^.x;
    write(ftip, y);
    p:= p^.next;
  end;
end;

procedure WriteSpText(var f: PUzel; var ftxt:Text);
var
  p: PUzel;
  s: string;
  y: tovar;
begin
  p:= f;
  while not(p = nil) do
  begin
    y:= p^.x;
    s:=y.NameTovar +' � ����������: ' + IntToStr(y.ObProdaj) +' �� ����: '+ IntToStr(y.CenaTovara) + ' ��� ������ ���������: '+ y.FIOProdavca;
    writeln(ftxt, s);
    p:= p^.next;
  end;
  writeln(ftxt,'');
end;

procedure DelFirstElement(var f,a: PUzel);
begin
  a := f;
  f := f^.next;
  a^.next := nil;
  if f<>nil then f^.pred := nil;
end;

procedure DelElement(var old,a: PUzel);
begin
  if (old^.next = nil) then a:= nil                     //old ��������� ���� � ������
  else
    if (old^.next^.next = nil) then             //old ������������� ���� � ������
    begin
      a := old^.next;
      a^.pred:= nil;
      old^.next:= nil;
    end
    else
    begin                                            //�� old �� ����� ���� ����� � ������
      a := old^.next;
      old^.next := a^.next;
      old^.next^.pred:= old;
      a^.next := nil;
      a^.pred:= nil;
    end;
end;

procedure DelSpisok(var f: PUzel);  //������� ������
var
  a: PUzel;
begin
  while (f <> nil) do
  begin
    DelFirstElement(f,a);
    Dispose(a);
  end;
end;

procedure BuildSpisokFromTip(var f:puzel;var ftip:Fzap);
var
  d,a:puzel;
  b:tovar;
begin
  f:=nil;
  while not eof(ftip) do begin
    new(a);
    read(ftip,b);
    with a^.x do begin
      NameTovar :=b.NameTovar;
      ObProdaj :=b.ObProdaj;
      CenaTovara :=b.CenaTovara;
      FIOProdavca:=b.FIOProdavca;
    end;
    a^.next:=nil;
    a^.pred:=nil;//��������� �� ���������� � ��������� ����� ��������, ����� ��� �� ��������� �� ���-�� �� ������ ���.
    if f=nil then begin//��������� ������ ������, �������� ������� ����������� �� ������
      AddFirst(f,a);
      d:=f;
    end
    else begin
      AddAfter(d,a);
      d:=a;
    end;
  end;
end;

procedure ItogDay(var f:puzel;var ftxt:text);
var
  sum,sum2:integer;
  d:puzel;
  s:string;
begin
  writeln(ftxt,'���� ���: ');
  sum2:=0;
  s:='';
  d:=f;
  while not(d=nil) do begin
    sum:=d^.x.ObProdaj*d^.x.CenaTovara;
    sum2:=sum2+sum;
    s:='�������� '+ d^.x.FIOProdavca +  ' ������ �����: '+ d^.x.NameTovar +  ' � ������: '+IntToStr(d^.x.ObProdaj)+ ' ��.' + ' �� �����: '+ IntToStr(sum)+ ' ���.';
    writeln(ftxt,s);
    d^.x.FIOProdavca:='';
    d:=d^.next;
    end;
  writeln(ftxt,'�����: ' + IntToStr(sum2)+ ' ���.');
  writeln(ftxt,'');
end;

procedure DobVSp(var f:puzel);
var
  d,a:puzel;
  ch,ch2:string;
begin
  repeat
    new(a);
    if f<>nil then d:=f;
    with a^.x do begin
      NameTovar := InputBox('������� �������� ������',' ',' ');
      ObProdaj := StrToInt(InputBox('������� ����� �������',' ',' '));
      CenaTovara := StrToInt(InputBox('������� ���� ������',' ',' '));
      FIOProdavca:= InputBox('������� ��� ��������',' ',' ');
    end;
    a^.next:=nil;
    a^.pred:=nil;//��������� �� ���������� � ��������� ����� ��������, ����� ��� �� ��������� �� ���-�� �� ������ ���.
    ch2:= InputBox('������� ������ � ���� ������?','�-��,�-���',' ')[1];
    if (ch2= 'Y') or (ch2='y') or (ch2 = '�') or (ch2 = '�') then begin
      if (f=nil) then begin
        AddFirst(f,a);
        d:=f;
      end
      else begin
        AddAfter(d,a);
        d:=a;
      end;
    end;
    ch:= InputBox('������ ������ ���?','�-��,�-���',' ')[1];
  until (ch = 'N') or (ch ='n')or (ch = '�') or (ch = '�');
end;

procedure PoslElem(f:puzel;var a:puzel);
begin
  if f=nil then a:=nil
  else begin
    while f^.next<> nil do begin
      f:= f^.next;
    end;
    a:=f;
    a^.pred:=nil;
  end;
end;

procedure Sort(f:puzel;var b:puzel);
var
  s:string;
  c,d:puzel;
  s1:integer;
begin
  s:=inputbox('�����','������� �� ������ �������� ����� �����?'+#13#10+'(1-��� ��������,2-�������� ������'+#13#10+'3-����� ������,4-���� ������)','');
  if s ='1' then begin
    c:=f;
    while not(c=nil) do begin
      d:=c^.next;
      while not(d=nil) do begin
        if c^.x.FIOProdavca >= d^.x.FIOProdavca then begin
          s:=d^.x.FIOProdavca;
          d^.x.FIOProdavca:=c^.x.FIOProdavca;
          c^.x.FIOProdavca:=s;
        end;
        d:=d^.next;
      end;
      c:=c^.next;
    end;
    b:=c;
  end;
  if s ='2' then begin
    c:=f;
    while not(c=nil) do begin
      d:=c^.next;
      while not(d=nil) do begin
        if c^.x.NameTovar >= d^.x.NameTovar then begin
          s:=d^.x.NameTovar;
          d^.x.NameTovar:=c^.x.NameTovar;
          c^.x.NameTovar:=s;
        end;
        d:=d^.next;
      end;
      c:=c^.next;
    end;
    b:=c;
  end;
  if s ='3' then begin
    c:=f;
    while not(c=nil) do begin
      d:=c^.next;
      while not(d=nil) do begin
        if c^.x.ObProdaj >= d^.x.ObProdaj then begin
          s1:=d^.x.ObProdaj;
          d^.x.ObProdaj:=c^.x.ObProdaj;
          c^.x.ObProdaj:=s1;
        end;
        d:=d^.next;
      end;
      c:=c^.next;
    end;
    b:=c;
  end;
  if s ='4' then begin
    c:=f;
    while not(c=nil) do begin
      d:=c^.next;
      while not(d=nil) do begin
        if c^.x.CenaTovara >= d^.x.CenaTovara then begin
          s1:=d^.x.CenaTovara;
          d^.x.CenaTovara:=c^.x.CenaTovara;
          c^.x.CenaTovara:=s1;
        end;
        d:=d^.next;
      end;
      c:=c^.next;
    end;
    b:=c;
    end;
end;


end.

