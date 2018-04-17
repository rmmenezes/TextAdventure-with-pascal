﻿
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
        freePos: integer;
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

function estaNoInv (inv : Inventario; obj : string) : boolean;
var
        i : integer;
begin
        for i := 0 to inv.freePos-1 do
        begin
                if inv.itens[i].nome = obj then
                begin
                        estaNoInv := true;
                end;
        end;
        estaNoInv := false;
end;

procedure removeDoInv (inv: Inventario, obj : string);
var
	i : integer;
begin
	for i := 0 to inv.freePos-1 do
	begin
		if inv.itens[i].nome = obj then
		begin
			inv.itens[i].obtido := false;
		end;
	end;
end;


procedure printaInventario (inv : Inventario; freePos : integer);
var
        i : integer;
begin
        for i:= 0 to freePos-1 do
        begin
		if inv.itens[i].obtido = true then
                	write(inv.itens[i].nome);
                	write(' ');
        end;
	writeln();
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
        //writeln(id_cena);
        readln(arq, titulo);
        //writeln(titulo);
        readln(arq, descricao_cena);
        //writeln(descricao_cena);
        readln(arq, qtd_objetos);
        //writeln(qtd_objetos);

        game.cenas[i] := criaCena(id_cena, titulo, descricao_cena, qtd_objetos);


   for j:=0 to qtd_objetos - 1 do
    begin
        readln(arq, id_objeto);
        //writeln(id_objeto);
        readln(arq, tipo);
        //writeln(tipo);
        readln(arq, nome);
        //writeln(nome);
        readln(arq, descricao_objeto);
        //writeln(descricao_objeto);
        readln(arq, resultado_positivo);
        //writeln(resultado_positivo);
        readln(arq, resultado_negativo);
        //writeln(resultado_negativo);
        readln(arq, comando_correto);
        //writeln(comando_correto);
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
        //writeln('##XxCENA-OBJETOSxX##');
        //for i:=0 to scene.qtd_objetos-1 do
        //begin
            //writeln(scene.itens[i].nome);
            //write('Comando Correto: ');
            //writeln(scene.itens[i].comand_correct);
        //end;
end;

type
  TSarray = array of string;

function Split(Texto, Delimitador: string): TSarray;

var
  o: integer;
  PosDel: integer;
  Aux: string;

begin

  o := 0;
  Aux := Texto;
  SetLength(Result, Length(Aux));

  repeat

    PosDel := Pos(Delimitador, Aux) - 1;

    if PosDel = -1 then
    begin
      Result[o] := Aux;
      break;
    end;

    Result[o] := copy(Aux, 1, PosDel);
    delete(Aux, 1, PosDel + Length(Delimitador));
    inc(o);
  until Aux = '';
end;

procedure PrintHelp();

begin
    writeln('Comandos do jogo:');
    writeln('inventory -> mostra inventário');
    writeln('use OBJETO -> interagir com objeto da cena (abrir, usar, pressionar, ...)');
    writeln('use ITEM with OBJETO -> usar item do inventário em objeto da cena');
    writeln('get OBJETO -> obtém objeto para o inventário');
    writeln('exit -> sai do jogo');
end;

procedure motorzera (game : Jogo);
var
        kbImput : string; i, pos, controlPrintCena : integer;
        invent : Inventario;
begin
        //show initial screen
        game.cena_atual := 0;
        controlPrintCena := 0;
        invent.freePos := 0;

        printaCena(game.cenas[game.cena_atual]);
        writeln('escreva [help] para instrucões');
        while kbImput <> 'exit' do
        begin
            if game.cena_atual <> controlPrintCena then
            begin
                    printaCena(game.cenas[game.cena_atual]);
                    controlPrintCena := game.cena_atual;
                    writeln('escreva [help] para instrucões');
            end;
            readln(kbImput);

            if kbImput = 'help' then
            begin
                    PrintHelp();
            end;
            if kbImput = 'inventory' then
            begin
                    printaInventario(invent, invent.freePos);
            end;


            for i:=0 to game.cenas[game.cena_atual].qtd_objetos-1 do
            begin
            	if (Split(kbImput, ' ').[0] = 'check') and (Split(kbImput, ' ').[0] = game.cenas[game.cena_atual].itens[i].nome) then
                begin
                	writeln(game.cenas[game.cena_atual].itens[i].descricao);
                end
		else if (game.cenas[game.cena_atual].itens[i].tipo = 0) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
                begin
                	if game.cenas[game.cena_atual].itens[i].obtido = false then
                        begin
                        	game.cenas[game.cena_atual].itens[i].obtido := true;
                                invent.itens[invent.freePos] := game.cenas[game.cena_atual].itens[i];
                                invent.freePos := invent.FreePos + 1;
                                writeln(game.cenas[game.cena_atual].itens[i].result_posit);
                   	end
			else
			begin
				writeln(game.cenas[game.cena_atual].itens[i].result_negat);
			end;
            	end
                else if (game.cenas[game.cena_atual].itens[i].tipo = 1) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		begin
                	if game.cenas[game.cena_atual].itens[i].resolvido = false then
                        begin
				game.cenas[game.cena_atual].itens[i].resolvido := true;
				writeln(game.cenas[game.cena_atual].itens[i].result_posit);
				game.cena_atual := game.cena_atual + 1;
                        end
			else
			begin
				writeln(game.cenas[game.cena_atual].itens[i].result_negat);
			end;
		end
		else if (game.cenas[game.cena_atual].itens[i].tipo = 2) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		begin
			if (estaNoInv(invent, Split(kbImput, ' ').[1]) = true) and (game.cenas[game.cena_atual].itens[i].resolvido = false) then
			begin
				removeDoInv(invent, Split(kbImput, ' ').[1]);
                                game.cenas[game.cena_atual].itens[i].resolvido := true;
                                writeln(game.cenas[game.cena_atual].itens[i].result_posit);
                                game.cena_atual := game.cena_atual + 1;
                        end
			else
			begin
				writeln(game.cenas[game.cena_atual].itens[i].result_negat);
			end;
                end
                else if (game.cenas[game.cena_atual].itens[i].tipo = 3) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		begin
                	if (estaNoInv(invent, Split(kbImput, ' ').[1]) = true) and (game.cenas[game.cena_atual].itens[i].resolvido = false) then
			begin
				removeDoInv(invent, Split(kbImput, ' ').[1]);
                                game.cenas[game.cena_atual].itens[i].resolvido := true;
                                writeln(game.cenas[game.cena_atual].itens[i].result_posit);
				kbImput := 'exit';
			end;
		end
		else if (game.cenas[game.cena_atual].itens[i].tipo = 4) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		begin
			writeln(game.cenas[game.cena_atual].itens[i].result_posit);
			kbImput := 'exit';
		end
		else if (game.cenas[game.cena_atual].itens[i].tipo = 5) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		begin
			writeln(game.cenas[game.cena_atual].itens[i].result_posit);	
		end
		else
		begin
			writeln(game.cenas[game.cena_atual].itens[i].result_negat);
		end;
		
	end; // while
end; // procedure

var
        game : Jogo;
        title : text;
        linha, kbImput, um : string;

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

        //printaCena(game.cenas[1]);
        motorzera(game);
        readln(kbImput);                        //so para congelar o texto

        //Delay(1000);

end.
