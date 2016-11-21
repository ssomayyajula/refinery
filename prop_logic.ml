open Core.Std
open Base
open Caml

module PropLang = struct
  type t = Prop of string
         | And of t * t
         | Or of t * t
         | Implies of t * t
         | Negate of t
  let pp_form fmt = failwith ""
end

module PropLogic (T : CAML_LIKE) : PROOF_SYSTEM = struct
  include Logic(T)(PropLang)
  
  open T
  open PropLang
  
  let impliesL (f : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, ab, h') = split hs f in
         match ab with
         | Implies (a, b) -> [(h @ (f, ab) :: h', a);
                              (h @ (make_var (), b) :: h', c)]
         | _ -> raise (InvalidDecomposition (Some f, s))),
     (function
      | [((h, _), a); ((h', _), c)] ->
          let b = get_var h f h' in
          subst c (`App (`Var f, a)) (`Var b)
      | sub -> raise (InvalidSubgoals (Some f, sub))))

  let impliesR : rule =
    ((fun ((h, c) as s) ->
        match c with
        | Implies (a, b) -> [(h @ [(make_var (), a)], b)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
      | [((h, _), b)] -> `Lambda (fst (List.last_exn h), b)
      | sub -> raise (InvalidSubgoals (None, sub))))
  
  let parse_rule s = failwith ""
end
