{$mode objfpc} // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);

//OBJETO CENA
type Cena = class
    private
        id: integer;
        titulo, descricao: string;
        itens: integer;

    public
	    procedure setId(ident: integer);
	    procedure setTitulo(title: string);
	    procedure setItens(iten: integer);

	    function getId() : integer;
	    function getTitulo() : string;
	    function getItens() : integer;
end;

//OBJETO OBJETO
type Objeto = class
    private
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;

    public

        procedure setTipo(typer: integer);
       	procedure setId(ident: integer);
       	procedure setCena_alvo(scene: integer);
        procedure setNome(namee: string);
        procedure setDescricao(descri: string);
        procedure setResult_posit(positivo: string);
        procedure setResult_negat(negativo: string);
        procedure setComand_correct(correct: string);
        procedure setResolvido(resolved: boolean);
        procedure setObtido(owned: boolean);

        function getId() : integer;
        function getTipo() : integer;
        function getCena() : integer;
        function getNome() : string;
        function getDescricao() : string;
        function getResult_posit() : string;
        function getResult_negat() : string;
        function getComand_correct() : string;
        function getResolvido() : boolean;
        function getObtido() : boolean;
end;

//OBJETO JOGO
type Jogo = class
    private
        cenas: array[0..10] of Cena;
        cena_atual: integer;

    public
        procedure setCenas(Cena arr: scenes);
        procedure setCena_atual(scene: integer);
        function getCena_atual() : integer;
end;

//METODOS DO OBJETO JOGO
var jg: Jogo;
	//SET
	procedure Jogo.setCenas(Cena arr: scenes);
	begin
		cenas := scenes;
	end;
    procedure Jogo.setCena_atual(scene: integer);
	begin
		cena_atual := scene;
	end;

	//GET
    function Jogo.getCena_atual() : integer;
	begin
		getCena_atual := cena_atual;
	end;



//METODOS DO OBJETO OBJETO
var obj1: Objeto;
	//SET
    procedure Objeto.setTipo(typer: integer);
	begin
		tipo := typer;
	end;
    procedure Objeto.setId(ident: integer);
	begin
		id := ident;
	end;
    procedure Objeto.setCena_alvo(scene: integer);
	begin
		cena_alvo := scene;
	end;
    procedure Objeto.setNome(namee: string);
	begin
		nome := namee;
	end;
    procedure Objeto.setDescricao(descri: string);
	begin
		descricao := descri;
	end;
    procedure Objeto.setResult_posit(positivo: string);
	begin
		result_posit := positivo;
	end;
    procedure Objeto.setResult_negat(negativo: string);
	begin
		result_negat := negativo;
	end;
    procedure Objeto.setComand_correct(correct: string);
	begin
		comand_correct := correct;
	end;
    procedure Objeto.setResolvido(resolved: boolean);
	begin
		resolvido := resolved;
	end;
    procedure Objeto.setObtido(owned: boolean);
	begin
		obtido := owned;
	end;

	//GET
    function Objeto.getId() : integer;
	begin
		getId := id;
	end;
    function Objeto.getTipo() : integer;
	begin
		getTipo := tipo;
	end;
    function Objeto.getCena() : integer;
	begin
		getCena := cena_alvo;
	end;
    function Objeto.getNome() : string;
	begin
		getNome := nome;
	end;
    function Objeto.getDescricao() : string;
	begin
		getDescricao := descricao;
	end;
    function Objeto.getResult_posit() : string;
	begin
		getResult_posit := result_posit;
	end;
    function Objeto.getResult_negat() : string;
	begin
		getResult_negat := result_negat;
	end;
    function Objeto.getComand_correct() : string;
	begin
		getComand_correct := comand_correct;
	end;
    function Objeto.getResolvido() : boolean;
	begin
		getResolvido := resolvido;
	end;
    function Objeto.getObtido() : boolean;
	begin
		getObtido := obtido;
	end;



//METODOS DO OBJETO CENA
var c1: Cena;
	//SET
	procedure Cena.setId(ident: integer);
	begin
		id := ident;
	end;
	procedure Cena.setTitulo(title: string);
	begin
		titulo := title;
	end;
	procedure Cena.setItens(iten: integer);
	begin
		itens := iten;
	end;
	
	//GETS
	function Cena.getId() : integer;
	begin
		getId := id;
	end;
	function Cena.getTitulo() : string;
	begin
		getTitulo := titulo;
	end;
	function Cena.getItens() : integer;
	begin
		getItens := itens;
	end;

begin
	writeln('');
	writeln('');
	writeln('');
	writeln('');
	writeln('');
	writeln('');
	writeln('TextAdventure');


end.