{$mode objfpc}     // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);
uses Process, CRT;
//STRUCT OBJETO
type Objeto = record
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;
end;


//STRUCT CENA
type Cena = record
        id, qtd_objetos: integer;
        titulo : string;
        descricao:ansistring;
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

function criaCena(ident : integer; tit : string;  desc : ansistring; qtd_objetos : integer) : Cena;
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
        estaNoInv := false;
        for i := 0 to inv.freePos-1 do
        begin
                if inv.itens[i].nome = obj then
                begin
                        estaNoInv := true;
                end;
        end;
end;

function removeDoInv (inv: Inventario; obj : string) : Inventario;
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
        removeDoInv := inv;
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
    linha, titulo, descricao_objeto, nome, comando_correto, resultado_positivo, resultado_negativo : string;
    descricao_cena : ansistring;
    i, j, id_objeto, qtd_objetos, tipo, cena_alvo : integer;
    id_cena : integer;
    game : Jogo;


begin
        game.cena_atual := 0;
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
//var
    //i : integer;
begin
        writeln(scene.titulo);
        writeln();
        writeln(scene.descricao);
        writeln();
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

procedure gameOver();
var
    arq : text;
    linha : string;
begin
    reset(arq);
    Assign(arq,'./Files/GameOver.txt');
    while not EOF(arq) do
        begin
          readln(arq, linha);
          writeln(linha);
          Delay(150);
    end;
    close(arq);

end;

procedure PrintHelp();

begin
    writeln('Comandos do jogo:');
    writeln('inventory -> mostra inventário');
    writeln('use OBJETO -> interagir com objeto da cena (abrir, usar, pressionar, ...)');
    writeln('use ITEM with OBJETO -> usar item do inventário em objeto da cena');
    writeln('get OBJETO -> obtém objeto para o inventário');
    writeln('save -> Salva o progresso do jogo');
    writeln('exit -> sai do jogo');
end;

procedure motorzera (game : Jogo; cenaInicial : integer);
var
        kbImput : string;
        i, controlPrintCena : integer;
        invent : Inventario;
        arq : text;
begin
        //show initial screen
        kbImput := 'nada';
        game.cena_atual := cenaInicial;
        controlPrintCena := 0;
        invent.freePos := 0;

        printaCena(game.cenas[game.cena_atual]);
        writeln('escreva [help] para instrucoes');
        while kbImput <> 'exit' do
        begin
            if game.cena_atual <> controlPrintCena then
            begin
                    clrscr();
                    printaCena(game.cenas[game.cena_atual]);
                    controlPrintCena := game.cena_atual;
                    writeln('escreva [help] para instrucoes');
            end;
            readln(kbImput);

            if kbImput = 'help' then
            begin
                    PrintHelp();
            end;
            if kbImput = 'save' then
            begin
                   Assign(arq,'./Files/Save.txt');
                   rewrite(arq); 
                   writeln(arq, 'salve');
                   writeln('Voce salvou o Jogo');
            end;

            if kbImput = 'inventory' then
            begin
                    printaInventario(invent, invent.freePos);
            end;

            for i:=0 to game.cenas[game.cena_atual].qtd_objetos-1 do
            begin
            	if (Split(kbImput, ' ').[0] = 'check') and (Split(kbImput, ' ').[1] = game.cenas[game.cena_atual].itens[i].nome) then
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
                   	end;
            	end
                else if (game.cenas[game.cena_atual].itens[i].tipo = 1) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		        begin
               	    if game.cenas[game.cena_atual].itens[i].resolvido = false then
                    begin
		      		    game.cenas[game.cena_atual].itens[i].resolvido := true;
			     	    write(game.cenas[game.cena_atual].itens[i].result_posit);
				        game.cena_atual := game.cena_atual + 1;
                        write('.');Delay(500);write('.');Delay(500);writeln('.');Delay(500);
                    end;
		    end
		    else if (game.cenas[game.cena_atual].itens[i].tipo = 2) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		    begin
			    if (estaNoInv(invent, Split(kbImput, ' ').[1]) = true) and (game.cenas[game.cena_atual].itens[i].resolvido = false) then
			    begin
				    invent := removeDoInv(invent, Split(kbImput, ' ').[1]);
                    game.cenas[game.cena_atual].itens[i].resolvido := true;
                    write(game.cenas[game.cena_atual].itens[i].result_posit);
                    game.cena_atual := game.cena_atual + 1;
                    write('.');Delay(500);write('.');Delay(500);writeln('.');Delay(500);
                end;
            end
            else if (game.cenas[game.cena_atual].itens[i].tipo = 3) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		    begin
           	    if (estaNoInv(invent, Split(kbImput, ' ').[1]) = true) and (game.cenas[game.cena_atual].itens[i].resolvido = false) then
			    begin
				    removeDoInv(invent, Split(kbImput, ' ').[1]);
                    game.cenas[game.cena_atual].itens[i].resolvido := true;
                    //gameOver();
                    writeln(game.cenas[game.cena_atual].itens[i].result_posit);
                    Delay(12000);
                    kbImput := 'exit';
                end;
            end
            else if (game.cenas[game.cena_atual].itens[i].tipo = 4) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
            begin
                //gameOver();
                writeln(game.cenas[game.cena_atual].itens[i].result_posit);
                Delay(12000);
			    kbImput := 'exit';
		    end
		    else if (game.cenas[game.cena_atual].itens[i].tipo = 5) and (kbImput = game.cenas[game.cena_atual].itens[i].comand_correct) then
		    begin
			    writeln(game.cenas[game.cena_atual].itens[i].result_posit);
		    end;
		    //else
		    //begin
			  //  writeln(game.cenas[game.cena_atual].itens[i].result_negat);
		    //end;

	    end; // for
    end; // while
end; // procedure

procedure mainScreen();
begin
    writeln();
    writeln('Em um mundo onde fantasmas, espiritos e seres sobrenaturais sao reais, cada noite eh uma batalha pela sobrevivencia, pois eh a noite que esses seres malignos saem para aterrorizarem suas vitimas. Para aqueles que nao conseguem se abrigar seguramente durante as longas e terriveis noites, apenas a morte esta reservada.');
    writeln('Voce realmente deseja comecar?');                                   
    writeln();
    writeln('Digite:');
    writeln('-> start');
    writeln('-> help');
    writeln('-> load');
    writeln('-> exit');    
end;


procedure startGame();
var
    arq : text;
    linha : string;
begin
    Assign(arq,'./Files/Titulo.txt');
    reset(arq);
    while not EOF(arq) do
        begin
          readln(arq, linha);
          writeln(linha);
          Delay(150);
    end;
    close(arq);

end;

procedure startMusic(musica : string);
var
   RunProgram: TProcess;
    begin
        RunProgram := TProcess.Create(nil);
        RunProgram.CommandLine := 'play -q ' + musica ;
        RunProgram.Execute;
end;

procedure stopMusic();
var
   RunProgram2: TProcess;
begin
        RunProgram2 := TProcess.Create(nil);
        RunProgram2.CommandLine := 'killall play';
        RunProgram2.Execute;
        RunProgram2.Free;
end;



var
        arq : text;
        game : Jogo;
        loading : integer;
        inicial, musica :string;

begin
    clrscr();
    inicial := 'nada';
    loading := 0;
    musica := 'Files/FundoTerror.mp3';
    
    startGame();
    startMusic(musica);
    while inicial <> 'exit' do
    begin
        mainScreen();
        readln(inicial);
        

        game := criaJogo();

        if inicial = 'start' then
        begin
            clrscr();                              //Lim  pa o console
            write('.');Delay(500);write('.');Delay(500);write('.');Delay(500);
            clrscr();
            motorzera(game, 0);
        end    //else if igual a load e etc..
        else if inicial = 'load' then
        begin
            Assign(arq,'./Files/Save.txt');
            reset(arq);
            readln(arq, loading);
            motorzera(game, loading);
        end
        else if inicial = 'help' then
        begin
            PrintHelp();
            readln(inicial);
        end;
        clrscr();
    end;
    stopMusic();
    
end.

