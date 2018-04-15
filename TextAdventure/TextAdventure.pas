{$mode objfpc}     // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);
uses CRT, sysutils;

//STRUCT OBJETO
type Objeto = record
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;
end;


//STRUCT CENA
type Cena = record
        id, qtd_objetos: integer;
        titulo, descricao: string;
        itens: array[0..10] of Objeto;
end;


//STRUCT JOGO
type Jogo = record
        cena_atual: integer;
        cenas: array[0..10] of Cena;
end;


//STRUCT IVENTARIO
type Inventario = record
        itens: array[0..10] of Objeto;
end;

function criaObjeto(id_objeto, tipo : integer; nome, descricao_objeto, result_posit, result_negat, comand_correct : string; cena_alvo : integer) : Objeto;
var
    obj : Objeto;
begin
    obj.id := id_objeto;
    obj.tipo := tipo;
    obj.nome := nome;
    obj.descricao := descricao_objeto;
    obj.result_posit := result_posit;
    obj.result_negat := result_negat;
    obj.comand_correct := comand_correct;
    obj.cena_alvo := cena_alvo;
    obj.obtido := false;
    obj.resolvido := false;

    criaObjeto := obj;
end;

function criaCena(ident : integer; tit, desc : string; qtd_objetos : integer) : Cena;
var
        scene : Cena;
begin
        scene.id := ident;
        scene.titulo := tit;
        scene.descricao := desc;
        scene.qtd_objetos := qtd_objetos;
        criaCena := scene;
end;

function criaJogo () : Jogo;
var
    arq: text;
    linha, titulo, descricao_cena, descricao_objeto, nome, comando_correto, resultado_positivo, resultado_negativo : string;
    i, j, id_objeto, qtd_objetos, tipo, cena_alvo : integer;
    id_cena : integer;
    game : Jogo;


begin
        Assign(arq,'./Files/Cenas.txt');
        reset(arq);
        i := 0;
        while not EOF(arq) do
         begin
        readln(arq, linha);  //Linha magica q nao deixa o prog voar heheeh S2
        readln(arq, id_cena);
        writeln(id_cena);
        readln(arq, titulo);
        writeln(titulo);
        readln(arq, descricao_cena);
        writeln(descricao_cena);
        readln(arq, qtd_objetos);
        writeln(qtd_objetos);

        game.cenas[i] := criaCena(id_cena, titulo, descricao_cena, qtd_objetos);


   for j:=0 to qtd_objetos - 1 do
    begin
        readln(arq, id_objeto);
        writeln(id_objeto);
        readln(arq, tipo);
        writeln(tipo);
        readln(arq, nome);
        writeln(nome);
        readln(arq, descricao_objeto);
        writeln(descricao_objeto);
        readln(arq, resultado_positivo);
        writeln(resultado_positivo);
        readln(arq, resultado_negativo);
        writeln(resultado_negativo);
        readln(arq, comando_correto);
        writeln(comando_correto);
        cena_alvo := i;
        game.cenas[i].itens[j] := criaObjeto(id_objeto, tipo, nome, descricao_objeto, resultado_positivo, resultado_negativo, comando_correto, cena_alvo);
    end;
    i := i + 1;
    end;
	close(arq);
    criaJogo := game;
end;

procedure printaCena (scene : Cena);
var
    i : integer;
begin
        writeln('##XxCENAxX##');
        writeln(scene.titulo);
        writeln(scene.descricao);
        writeln('##XxCENA-OBJETOSxX##');
        for i:=0 to scene.qtd_objetos-1 do
        begin
            writeln(scene.itens[i].nome);
            write('Comando Correto: ');
            writeln(scene.itens[i].comand_correct);
        end;
end;

var
        game : Jogo;
        title : text;
        linha : string;

begin
clrscr();                                       //Limpa o console

        Assign(title,'./Files/Title.txt');
        reset(title);
        while not EOF(title) do
        begin
          readln(title, linha);
          writeln(linha);
          Delay(200);
        end;
        close(title);

        clrscr();                               //Limpa o console
        Delay(1000);

        game := criaJogo();

        printaCena(game.cenas[1]);
        //readln(linha);				//so para congelar o texto

        //Delay(1000);

end.
