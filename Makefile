# Project dependencies
DEPS=core,ppx_import,str
# Compiler and linker flags
CC=ocamlfind ocamlc
CFLAGS=-thread -package $(DEPS)
LDFLAGS=-linkpkg
# Modules in dependency order and project name
MODULES=base interactive caml propAst propParser propLexer prop_logic fol
NAME=refined_logic

prop: $(MODULES)
	$(CC) -c $(CFLAGS) prop_main.ml
	$(CC) -o prop $(LDFLAGS) $(CFLAGS) $(addsuffix .cmo, $^) prop_main.cmo

FOL: $(MODULES)
	$(CC) -c $(CFLAGS) fol_main.ml
	$(CC) -o fol $(LDFLAGS) $(CFLAGS) $(addsuffix .cmo, $^) fol_main.cmo

library: $(MODULES)
	$(CC) -a -o $(NAME).cma $(LDFLAGS) $(CFLAGS) $(addsuffix .cmo, $^)

%: %.mli %.ml
	$(CC) -c $(CFLAGS) $^

clean:
	rm -rf *.cm* prop fol *.tex *.pdf *.log *.aux
