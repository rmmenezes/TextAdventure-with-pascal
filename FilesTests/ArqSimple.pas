program ArquivoPas;


begin
        Assign(arq,'size.txt');
        reset(arq);

        while not EOF(arq) do
        begin
            readln(arq, linha);
            writeln(linha);
        end;

        close(arq);
end.
