# Project dependencies
DEPS=core,ppx_import
# Compiler and linker flags
CC=ocamlfind ocamlc
CFLAGS=-thread -package $(DEPS)
LDFLAGS=-linkpkg
# Modules in dependency order and project name
MODULES=base interactive caml prop_logic
NAME=refined_logic

$(NAME): $(MODULES)
	$(CC) -c $(CFLAGS) main.ml
	$(CC) -a -o $(NAME).cma $(LDFLAGS) $(CFLAGS) $(addsuffix .cmo, $^) main.cmo

%: %.mli %.ml
	$(CC) -c $(CFLAGS) $^

paper: $(addsuffix .mli, $(MODULES)) $(addsuffix .ml, $(MODULES))
	ocamlweb $^ -o $(NAME).tex
	pdflatex $(NAME).tex

clean:
	rm -rf *.cm* *.tex *.pdf *.log *.aux
