open Base

module FOLLang = struct
  
  type var = string
  
  module VarSet = Set.Make(struct
    type t = var
    let compare = Pervasives.compare
  end)
  
  type t = Prop of var * var list
         | And of t * t
         | Or of t * t
         | Implies of t * t
         | Not of t
         | Forall of var * t
         | Exists of var * t
         | False
  
  let pp_form _ = failwith ""
  let parse_form _ = failwith ""
  
  let rec fvs = function
    | Prop (_, l) -> VarSet.of_list l
    | And (a, b)
    | Or (a, b)
    | Implies (a, b) -> VarSet.union (fvs a) (fvs b)
    | Not a -> fvs a
    | Forall (v, t)
    | Exists (v, t) -> VarSet.remove v (fvs t)
    | False -> VarSet.empty
  
  (* Taken from CS 4110 *)
  let rec fresh v fv =
    let rec helper x n =
      let xn = x ^ "_" ^ string_of_int n in
      if VarSet.mem xn fv then
        helper x (n + 1)
      else xn in
    if VarSet.mem v fv then
      helper v 0
    else
      v
  
  let rec subst p t x =
    match p with
    | Prop (v, l)    -> Prop (v, List.map (fun param -> if param = x then t else param) l)
    | And (a, b)     -> And (subst a t x, subst b t x)
    | Or (a, b)      -> Or (subst a t x, subst b t x) 
    | Implies (a, b) -> Implies (subst a t x, subst b t x)
    | Not a          -> Not (subst a t x)
    | Forall (v, t')  -> let v' = fresh v (VarSet.of_list [x; t]) in Forall (v', subst (subst t' v' v) t x)
    | Exists (v, t')  -> let v' = fresh v (VarSet.of_list [x; t]) in Exists (v', subst (subst t' v' v) t x)
  
  let i = ref 0
  
  let make_form_var () =
    i := !i + 1;
    "v" ^ (string_of_int !i)
end

module FOL (T : Caml.CAML_LIKE) : PROOF_SYSTEM = struct
  include Logic(T)(FOLLang)
  
  open Core.Std
  open T
  open FOLLang
  
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
  
  let existsR (t : var) =
    ((fun ((h, c) as s) ->
        match c with
        | Exists (x, p) -> [(h, subst p t x)]
        | _ -> raise (InvalidDecomposition (None, s))),
     (function
        | [(_, pf)] -> `Pair (t, pf)))
  
  let exL (z : term_var) : rule =
    ((fun ((hs, c) as s) ->
        let (h, ex, h') = split hs z in
        match ex with
        | Exists (x, p) -> [(h @ h' @ [(make_var (), subst p (make_form_var) x)], c)]
        | _             -> raise (InvalidDecomposition (Some z, s))),
     (function
      | [(_, c)] -> `App (`App (c, `Fst (`Var z)), `Snd (`Var z))
      | sub -> raise (InvalidSubgoals (Some z, sub))))
  
  let parse_rule _ = failwith ""
end
