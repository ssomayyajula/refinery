{
  open PropParser
}

(* Whitespace characters. *)
let white = [' ' '\t']+

(* An identifier is one or more alphabetic letters. *)
let letter = ['a'-'z' 'A'-'Z']
let id = letter+

rule read =
  parse
  | white { read lexbuf }
  | "("     { LPAREN }
  | ")"     { RPAREN }
  | "~"     { NOT }
  | "/\\"   { AND }
  | "\\/"   { OR }
  | "=>"    { IMPLIES }
  | "false" { FALSE }
  | "id"    { ID (Lexing.lexeme lexbuf) }
  | eof     { EOF }
