open Core.Std

module type CAML_LIKE = [%import: (module Caml.CAML_LIKE)]

module OCaml : CAML_LIKE = struct
  type var = string
  
  type t = [ `Var of var
           (* Precedence: 0 *)
           | `Lambda of var * t
           (* Precedence: 2 *)
           | `App of t * t
           | `Fst of t
           | `Snd of t
           (* Precedence: 1 *)
           | `Pair of t * t
           (* Precedence: 0 *)
           | `Match of t * ((string * var) * t) * ((string * var) * t)
           (* Precedence: 2 *)
           | `L of t
           | `R of t
           | `Any of t ]
  
  let i = ref 0
  
  let parse_var v = v
  
  let make_var () =
    i := !i + 1;
    "v" ^ (string_of_int !i)
  
  let pp_var = String.pp
  
  let pp_t fmt t =
    (* Taken from https://caml.inria.fr/pub/docs/manual-ocaml/coreexamples.html *)
    let lparen prec cprec =
      if prec > cprec then String.pp fmt "(" in
    let rparen prec cprec =
      if prec > cprec then String.pp fmt ")" in
    let rec pp prec = function
      | `Var v -> String.pp fmt v
      | `Lambda (x, e) ->
          lparen prec 0;
          String.pp fmt "fun ";
          String.pp fmt x;
          String.pp fmt " -> ";
          pp 0 e;
          rparen prec 0
      | `App (e1, e2) ->
          lparen prec 2;
          pp 2 e1;
          pp 2 e2;
          rparen prec 2
      | `Fst e -> pp prec (`App (`Var "fst", e))
      | `Snd e -> pp prec (`App (`Var "snd", e))
      | `Any e -> pp prec (`App (`Var "any", e))
      | `Pair (e1, e2) ->
          lparen prec 1;
          pp 1 e1;
          String.pp fmt ", ";
          pp 1 e2;
          rparen prec 1
      | `Match (e, ((c1, v1), e1), ((c2, v2), e2)) ->
          lparen prec 0;
          String.pp fmt "match ";
          pp 0 e;
          String.pp fmt (" with " ^ (c1 ^ v1) ^ " -> ");
          pp 0 e1;
          String.pp fmt (" | " ^ (c2 ^ v2) ^ " -> ");
          pp 0 e2;
          rparen prec 0;
      | `L e ->
          lparen prec 2;
          String.pp fmt "`L ";
          pp 2 e;
          rparen prec 2
      | `R e ->
          lparen prec 2;
          String.pp fmt "`R ";
          pp 2 e;
          rparen prec 2
    in
    String.pp fmt
    "type void = {none:'a.'a}\nlet any (x : void) = failwith \"any\" in ";
    pp 0 t
end
