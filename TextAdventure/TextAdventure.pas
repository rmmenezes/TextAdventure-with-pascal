{$mode objfpc}     // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);
uses CRT;
//OBJETO OBJETO
type Objeto = class
    public
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;

        constructor create();
end;
        constructor Objeto.create();
        begin
                id := -1;
                tipo := -1;
                cena_alvo := -1;
                nome := ' ';
                descricao := ' ';
                result_posit := ' ';
                result_negat := ' ';
                comand_correct := ' ';
                resolvido := false;
                obtido := false;
        end;

//OBJETO CENA
type Cena = class
    public
        id: integer;
        titulo, descricao: string;
        itens: array[0..10] of Objeto;
    private
        constructor create();
end;

        constructor Cena.create();
        var
                i : integer;
        begin
                id := 0;
                titulo := ' ';
                descricao := ' ';
                for i := 0 to 10 do
                begin
                        itens[i] := Objeto.create();
                end;
        end;



//OBJETO JOGO
type Jogo = class
    public
        cena_atual: integer;
        cenas: array[0..10] of Cena;
        constructor create();
end;

        constructor Jogo.create();
        var
                i : integer;
        begin
                cena_atual := 0;
                for i := 0 to 10 do
                begin
                        cenas[i] := Cena.create();
                end;
        end;

//OBJETO IVENTARIO
type Inventario = class
    public
        itens: array[0..10] of Objeto;
        constructor create();

end;

        constructor Inventario.create();
        var
                i : integer;
        begin
                for i := 0 to 10 do
                begin
                    itens[i] := Objeto.create();
                end;
        end;


function ReadScene() : Cena;
	var
                cs : Cena;
		linha : string;
		index : integer;
                cena : text;

        begin

        Assign(cena,'./Files/Cenas.txt');
        reset(cena);

       while not EOF(cena) do
       begin
            index := 0;

            readln(cena, linha);        //le o id
            cs.id := 0;

            readln(cena, linha);        //le o titulo
            cs.titulo := linha;

            readln(cena, linha);        //le a descricao
            cs.descricao := linha;

       end;
       close(cena);

       ReadScene := cs;
end;

function NewGame() : Jogo;
var
        jg : Jogo;

begin
        jg.create()
end;



var
        title: text;
        linha: string;
        game : Jogo;

begin
    clrscr(); 					//Limpa o console

	Assign(title,'./Files/Title.txt');
        reset(title);
        while not EOF(title) do
        begin
            readln(title, linha);
            writeln(linha);
            Delay(200);
        end;
        close(title);



        game.cenas[0] := ReadScene();

        Delay(1000);
       // clrscr(); 					//Limpa o console

end.






