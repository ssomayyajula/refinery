open Base

module PropLang = struct
  type t = Prop of string
         | And of t * t
         | Or of t * t
         | Implies of t * t
         | Negation of t
  let pp_form fmt = invalid_arg ""
end

module PropLogic (T : CAML_LIKE) : PROOF_SYSTEM = struct
  include Logic(T)(PropLang)
  
  let impliesL l =
    (fun (h, c) as s ->
       let (hl, ((_, f) as d), hr) = extract h l in
       match f with
       | Implies (a, b) -> [(hl @ d :: hr, a);
                            (hl @ (make_var (), b) :: hr, c)]
       | _ -> raise (InvalidDecomposition (Some l, s)),
     function
     | [((hf, _), a); ((hb, _), c)] ->
         let (f, _) = List.assoc hf l in
         let (b, _) = List.assoc hb l in
         subst c (app (var f) a) (var b)
     | sub -> raise (InvalidSubgoals (Some l, sub)))

  let impliesR =
    (fun (h, c) as s ->
      match c with
      | Implies (a, b) -> [(h @ [(make_var (), a)], b)]
      | _              -> raise (InvalidDecomposition (None, s)),
     function
       [((h, _), b)] -> let (a, _) = last h in lam (var a) b
     | sub -> raise (InvalidSubgoals (None, sub)))
  
  let parse_rule s : L.rule = 
end
