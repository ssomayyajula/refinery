
(* The type of tokens. *)

type token = 
  | RPAREN
  | OR
  | NOT
  | LPAREN
  | IMPLIES
  | ID of (string)
  | FALSE
  | EOF
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (PropAst.prop)
