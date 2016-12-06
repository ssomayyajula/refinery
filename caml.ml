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
  
  let rec pp_t fmt = function
    | `Var v -> String.pp fmt v
    | `Lambda (x, e) ->
        String.pp fmt "(fun ";
        String.pp fmt x;
        String.pp fmt " -> ";
        pp_t fmt e;
        String.pp fmt ")"
    | `App (e1, e2) ->
        String.pp fmt "(";
        pp_t fmt e1;
        pp_t fmt e2;
        String.pp fmt ")"
    | `Fst e -> pp_t fmt (`App (`Var "fst", e))
    | `Snd e -> pp_t fmt (`App (`Var "snd", e))
    | `Any e -> pp_t fmt (`App (`Var "Obj.magic", e))
    | `Pair (e1, e2) ->
        String.pp fmt "(";
        pp_t fmt e1;
        String.pp fmt ", ";
        pp_t fmt e2;
        String.pp fmt ")"
    | `Match (e, ((c1, v1), e1), ((c2, v2), e2)) ->
        String.pp fmt "(match";
        pp_t fmt e;
        String.pp fmt (" with " ^ (c1 ^ v1) ^ " -> ");
        pp_t fmt e1;
        String.pp fmt (" | " ^ (c2 ^ v2) ^ " -> ");
        pp_t fmt e2;
        String.pp fmt ")"
    | `L e ->
        String.pp fmt "(";
        String.pp fmt "`L ";
        pp_t fmt e;
        String.pp fmt ")"
    | `R e ->
        String.pp fmt "(`R";
        pp_t fmt e;
        String.pp fmt ")"
end
