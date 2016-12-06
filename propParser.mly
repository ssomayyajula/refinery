%{
  open PropAst
%}

(* Tokens to be used in parsing. Support exists for:
 *   1. Parentheses
 *   2. NOT     (~)
 *   3. AND     (/\)
 *   4. OR      (\/)
 *   5. IMPLIES (=>)
 *   6. FALSE   (false)
 *   7. ATOM    (P,Q,etc.)
 *)
%token LPAREN
%token RPAREN
%token NOT
%token AND
%token OR
%token IMPLIES
%token FALSE
%token <string> ATOM
%token EOF

(* Assigns precedence and associativity to the propositional terms. *)
%right IMPLIES
%left  OR
%left  AND
%nonassoc NOT

(* Starts parsing the language. *)
%start <PropAst.prop> prog

%%

(* Rules of propositional logic. *)
prog:
  | p = prop; EOF { p }
  ;

prop:
  | LPAREN; p = prop; RPAREN { p }
  | NOT; p = prop { Not p }
  | p1 = prop; AND; p2 = prop { And (p1,p2) }
  | p1 = prop; OR ; p2 = prop { Or  (p1,p2) }
  | p1 = prop; IMPLIES; p2 = prop { Implies (p1,p2) }
  | s = ATOM { Atom s }
  | FALSE { False }
  ;
