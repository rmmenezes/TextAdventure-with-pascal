{$mode objfpc} // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

program Geometria;

type Geometrico = class
    private
        largura, altura: integer;
    public
        constructor new(l, a: integer);
        procedure setLargura(l: integer);
        procedure setAltura(a: integer);

       	function getLargura(): integer;
       	function getAltura(): integer;
end;

var g1: Geometrico;
constructor Geometrico.new(l, a: integer);
begin
   largura := l;
   altura := a;
end;
procedure Geometrico.setLargura(l: integer);
begin
    largura := l;
end;
procedure Geometrico.setAltura(a: integer);
begin
    altura := a;
end;
function Geometrico.getLargura() : integer;
begin
	getLargura := largura;
end;
function Geometrico.getAltura() : integer;
begin
	getAltura := altura;
end;

var
        arq: text;
        larg, alt: integer;

begin
    writeln('TextAdventure');

    g1:= Geometrico.new(0,0);

    Assign(arq,'size.txt');
        reset(arq);

        while not EOF(arq) do
        begin
            readln(arq, larg);
            readln(arq, alt);

    		g1.setLargura(larg);
    		g1.setAltura(alt);
        end;

    close(arq);

   	writeln('Largura: ' , g1.getLargura());
   	writeln('Altura: ' , g1.getAltura());


end.
