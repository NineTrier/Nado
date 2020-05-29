unit UnitmodulK;

interface

  uses
    SysUtils, Dialogs;

  Type
	  Building = record //��� ������ ��� ����� ������, ������� ����� ��������� � ���� ������
		  Material:string[30]; //�������� ���������
		  KolMat:integer; //���������� ������� ���������
		  FIOPrin:string[30]; //��� ���������� ��������
		  FIOOtp:string[30]; //��� ������������ ��������
	  end;
	  PUzel = ^Zl;//��������� �� ��� ������, ��������� ������
	  Zl = record //������, ����������� ������
		  x:Building;//����������, ���������� � ����� ������
		  next:puzel;//��������� �� ��������� ����
		  pred:puzel;//��������� �� ���������� ����
	  end;
    Fzap = file of Building;//�������������� ����, ��� �������� ���� ������

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
  procedure PoslElem(f:puzel;var a:puzel);//�������� ��������� ������� ������
  procedure Sort(f:puzel;var b:puzel);//��������� ������

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
      Material := InputBox('������� �������� ���������',' ',' ');
      KolMat := StrToInt(InputBox('������� ���-�� ���������',' ',' '));
      FIOPrin := InputBox('������� ��� ����������',' ',' ');
      FIOOtp:= InputBox('������� ��� ������������',' ',' ');
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
  y: building;
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
  y: building;
begin
  p:= f;
  while not(p = nil) do
  begin
    y:= p^.x;
    s:=y.Material +' ���������� ���������� �� ���: ' + y.FIOOtp +' � ����������: '+ IntToStr(y.KolMat) + '�� ��� ������ ���������� �� ���: '+ y.FIOPrin;
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
  b:building;
begin
  f:=nil;
  while not eof(ftip) do begin
    new(a);
    read(ftip,b);
    with a^.x do begin
      Material :=b.Material;
      KolMat :=b.KolMat;
      FIOPrin :=b.FIOPrin;
      FIOOtp:=b.FIOOtp;
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
  sum:integer;
  d,a:puzel;
  s:string;
begin
  s:='';
  d:=f;
  writeln(ftxt,'����� �� ���� ���� �������� ����� ���������: ');
  while not(d=nil) do begin
    a:=d^.next;
    sum:=d^.x.KolMat;
    while not(a=nil) do begin
      if d^.x.Material = a^.x.Material then sum:=sum+a^.x.KolMat;
      a:=a^.next;
    end;
  s:=s+d^.x.Material+': '+IntToStr(sum)+'��. ';
  d:=d^.next;
  end;
  Showmessage(s);
  writeln(ftxt,s);
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
      Material := InputBox('������� �������� ���������',' ',' ');
      KolMat := StrToInt(InputBox('������� ���-�� ���������',' ',' '));
      FIOPrin := InputBox('������� ��� ����������',' ',' ');
      FIOOtp:= InputBox('������� ��� ������������',' ',' ');
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
  s:=inputbox('����������','������� �� ������ �������� �������� ����������?'+#13#10+'(1-������������ ������,2-���-�� ������'+#13#10+'3-��� ����������,4-��� ������������)','');
  if s ='1' then begin
    c:=f;
    while not(c=nil) do begin
      d:=c^.next;
      while not(d=nil) do begin
        if c^.x.Material >= d^.x.Material then begin
          s:=d^.x.Material;
          d^.x.Material:=c^.x.Material;
          c^.x.Material:=s;
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
        if c^.x.KolMat >= d^.x.KolMat then begin
          s1:=d^.x.KolMat;
          d^.x.KolMat:=c^.x.KolMat;
          c^.x.KolMat:=s1;
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
        if c^.x.FIOPrin>= d^.x.FIOPrin then begin
          s:=d^.x.FIOPrin;
          d^.x.FIOPrin:=c^.x.FIOPrin;
          c^.x.FIOPrin:=s;
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
        if c^.x.FIOOtp >= d^.x.FIOOtp then begin
          s:=d^.x.FIOOtp;
          d^.x.FIOOtp:=c^.x.FIOOtp;
          c^.x.FIOOtp:=s;
        end;
        d:=d^.next;
      end;
      c:=c^.next;
    end;
    b:=c;
    end;
end;


end.

