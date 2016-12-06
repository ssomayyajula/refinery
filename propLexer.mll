{
  open PropParser
}

(* Whitespace characters. *)
let white = [' ' '\t']+

(* An atom is one or more alphabetic letters. The first letter must always be
 * uppercase, to distinguish it from OCaml variables/identifiers. *)
let atom = ['A'-'Z'] ['a'-'z' 'A'-'Z']+

rule read =
  parse
  | white   { read lexbuf }
  | "("     { LPAREN }
  | ")"     { RPAREN }
  | "~"     { NOT }
  | "/\\"   { AND }
  | "\\/"   { OR }
  | "=>"    { IMPLIES }
  | "false" { FALSE }
  | "atom"  { ATOM (Lexing.lexeme lexbuf) }
  | _       { failwith ("Unexpected char: " ^ (Lexing.lexeme lexbuf)) }
  | eof     { EOF }
