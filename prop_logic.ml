open Base

module PropLang = struct
  open Core.Std
  open Sexplib
  
  type t = Prop of string
         | And of t * t
         | Or of t * t
         | Implies of t * t
         | Not of t
         | False
  
  let parse_form s = failwith "TODO implement"
  
  (* Taken from https://caml.inria.fr/pub/docs/manual-ocaml/coreexamples.html *)
  let pp_form fmt p =
    let lparen prec cprec =
      if prec > cprec then String.pp fmt "(" in
    let rparen prec cprec =
      if prec > cprec then String.pp fmt ")" in
    let rec pp prec = function
      | Prop p -> String.pp fmt p
      | False -> String.pp fmt "false"
      | And (a, b) ->
          lparen prec 2;
          pp 2 a;
          String.pp fmt " ^ ";
          pp 2 b;
          rparen prec 2
      | Or (a, b) ->
          lparen prec 1;
          pp 1 a;
          String.pp fmt " \\/ ";
          pp 1 b;
          rparen prec 1
      | Implies (a, b) ->
          lparen prec 0;
          pp 0 a;
          String.pp fmt " => ";
          pp 0 b;
          rparen prec 0
      | Not a ->
          String.pp fmt "~";
          lparen prec 3;
          pp 3 a;
          rparen prec 3;
    in pp 0 p
end

module PropLogic (T : Caml.CAML_LIKE) :
  PROOF_SYSTEM with type term_var = T.var and
                    type term     = T.t =
struct
  include Logic(T)(PropLang)
  
  open Core.Std
  open T
  open PropLang
  
  let impliesL (f : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, ab, h') = split hs f in
         match ab with
         | Implies (a, b) -> [(h @ h' @ [(f, ab)], a);
                              (h @ h' @ [(make_var (), b)], c)]
         | _ -> raise (InvalidDecomposition (Some f, s))),
     (function
      | [(_, a); ((h', _), c)] ->
          let b = fst (List.last_exn h') in
          `App (`Lambda (b, c), `App (`Var f, a))
      | sub -> raise (InvalidSubgoals (Some f, sub))))

  let impliesR : rule =
    ((fun ((h, c) as s) ->
        match c with
        | Implies (a, b) -> [(h @ [(make_var (), a)], b)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [((h, _), b)] -> `Lambda (fst (List.last_exn h), b)
      | sub -> raise (InvalidSubgoals (None, sub))))
  
  let andL (x : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, ab, h') = split hs x in
        match ab with
        | And (a, b) -> [(h @ h' @ [(make_var (), a); (make_var (), b)], c)]
        | _          -> raise (InvalidDecomposition (Some x, s))),
     (function
      | [((h, _), c)] ->
          let [(a, _); (b, _)] = take_last h 2 in
          let x' = `Var x in
          `App (`App (`Lambda (a, `Lambda (b, c)), `Fst x'), `Snd x')
      | sub -> raise (InvalidSubgoals (Some x, sub))))
  
  let andR : rule =
    ((fun ((h, c) as s) ->
        match c with
        | And (a, b) -> [(h, a); (h, b)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [(_, a); (_, b)] -> `Pair (a, b)
      | sub -> raise (InvalidSubgoals (None, sub))))
  
  let orL (x : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, ab, h') = split hs x in
        match ab with
        | Or (a, b) -> [(h @ h' @ [(make_var (), a)], c); (h @ h' @ [(make_var (), b)], c)]
        | _          -> raise (InvalidDecomposition (Some x, s))),
     (function
      | [((h, _), c1); ((h', _), c2)] ->
          let [(a, _)] = take_last h  1 in
          let [(b, _)] = take_last h' 1 in
          `Match (`Var x, (("`L ", a), c1), (("`R ", b), c2))
      | sub -> raise (InvalidSubgoals (Some x, sub))))
  
  let orR1 : rule =
    ((fun ((h, c) as s) ->
        match c with
        | Or (a, b) -> [(h, a)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [(_, a)] -> `L a
      | sub -> raise (InvalidSubgoals (None, sub))))
      
  let orR2 : rule =
    ((fun ((h, c) as s) ->
        match c with
        | Or (a, b) -> [(h, b)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [(_, b)] -> `R b
      | sub -> raise (InvalidSubgoals (None, sub))))
  
  let notL (f : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, na, h') = split hs f in
        match na with
        | Not a -> [(h @ h' @ [(f, na)], a)]
        | _          -> raise (InvalidDecomposition (Some f, s))),
     (function
      | [(_, a)] -> `Any (`App (`Var f, a))
      | sub -> raise (InvalidSubgoals (Some f, sub))))
  
  let notR : rule =
    ((fun ((h, c) as s) ->
        match c with
        | Not a -> [(h @ [(make_var (), a)], False)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [((h, _), b)] ->
          let [(a, _)] = take_last h 1 in
          `Lambda (a, b)
      | sub -> raise (InvalidSubgoals (None, sub))))
  
  let axiom (a : term_var) : rule =
    ((fun (h, _) -> let _ = split h a in []), (fun _ -> `Var a))
  
  let parse_rule s =
    Option.value_map (String.lsplit2 ~on:' ' s)
      ~default:begin
        match s with
        | "impliesR" -> Some impliesR
        | "andR" -> Some andR
        | "orR1" -> Some orR1
        | "orR2" -> Some orR2
        | "notR" -> Some notR
        | _ -> None
      end
      ~f:begin
        fun (r, l) ->
        let l = parse_var l in
        match r with
        | "impliesL" -> Some (impliesL l)
        | "andL" -> Some (andL l)
        | "orL" -> Some (orL l)
        | "notL" -> Some (notL l)
        | "axiom" -> Some (axiom l)
        | _ -> None
      end
end
