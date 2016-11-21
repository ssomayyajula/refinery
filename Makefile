# Project dependencies
DEPS=core,ppx_import
# Compiler and linker flags
CC=ocamlfind ocamlc
CFLAGS=-thread -package $(DEPS)
LDFLAGS=-linkpkg
# Modules in dependency order and project name
MODULES=base caml prop_logic
NAME=refined_logic

$(NAME): $(MODULES)
	$(CC) -a -o $(NAME).cma $(LDFLAGS) $(CFLAGS)

%: %.mli %.ml
	$(CC) -c $(CFLAGS) $^

paper: $(addsuffix .mli, $(MODULES)) $(addsuffix .ml, $(MODULES))
	ocamlweb $^ -o $(NAME).tex
	pdflatex $(NAME).tex

clean:
	rm -rf *.cm* *.o *.tex *.pdf *.log *.aux
