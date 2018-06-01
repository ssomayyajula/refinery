(*

Core (like LCF)
-- Generate proof system from term + formula language specification and inference rules
-- Determine term extraction with optional irrelevance erasure

Language/Assistant (like Isabelle)
-- Generate standalone proof assistant from proof system with:
     a generic & extensible tactics language with namespaces

*)

open Core.Std

(*module type TERM_LANG = [%import: (module Kernel.TERM_LANG)]
module type FORM_LANG = [%import: (module Kernel.FORM_LANG)]*)

module type TERM_LANG = sig
  type t
  type var
  val sexp_of_var : var -> Sexp.t
end

module type FORM_LANG = sig
  type t
end

module Logic (T : TERM_LANG) (F : FORM_LANG) = struct
  type goal =
    { con : F.t;
      hs : (T.var, F.t) List.Assoc.t }
  
  type rule =
    { dec : goal -> goal list;
      vl  : (goal * T.t) list -> T.t }
  
  type proof = rule list
  
  type complete
  
  type _ theorem = goal * proof
  
  let prove ({hs} as s) p =
    List.exn_if_dup (List.map hs fst) T.sexp_of_var;
    s, p
  
  let goal_of  = fst
  
  let proof_of = snd
  
  let subgoals (s, rs) =
    let rs = Stream.of_list rs in
    let rec helper s =
      try
        let {dec} = Stream.next rs in
        List.concat (List.map (dec s) helper)
      with
        Stream.Failure -> [s] in
    helper s
  
  exception IncompleteProof of goal list
  
  let verify thm =
    match subgoals thm with
    | [] -> thm
    | ss -> raise @@ IncompleteProof ss
  
  let extract_term (s, rs) =
    let rs = Stream.of_list rs in
    let rec helper s =
      let {dec; vl} = Stream.next rs in
      (*vl [s', helper s' | s' <- dec s] in*)
      vl (List.map (dec s) (fun s' -> s', helper s')) in
    helper s

  let skip =
    { dec = (fun s -> [s]);
      vl  = function [_, t] -> t
    }

  let sorry =
    { dec = Fn.const [];
      vl  = fun _ -> raise @@ Failure "proof uses sorry"
    }

  
  let all_goals ((s, rs) as thm) : proof =
    match subgoals (s, rs @ ) with
end

module RWS : functor (W : MONOID) sig
  type ('r, 's, 'a) t
  
  val asks : ('r -> 'a) -> ('r, 's, 'a) t
  
  val eval_rws : ('r, 's, 'a) t -> 'r -> 's -> 'a
end = struct
  type ('r, 's, 'a) t = 'r -> 's -> 'a * 's * W.t
  
  let asks f r s = return (f r, s, W.zero)

  
end

module Tactics : sig
  type 'a t
  let by : rule -> unit t
end = struct
  
end
(*
Tactic 

It's a state monad:
type 'a tactic = 'b. (goal, 'b theorem, unit, 'a) RWS.t

let all_goals (tac : 'a tactic) : 'a tactic =
  fmap subgoals get_theorem >>=
  
  
  by r >>
  by x >>
  

let fails tac : bool tactic = do
  try
    fmap (runState tac) get >> return false
  with _ -> return true

let by r =
  RWS.modify (fun p -> p @ [r])

let

let l : theorem ref = ref ... in
all_goals 

tactically goal @@
S THENR skip

let repeat tac =
  tac >> repeat tac

State monad over proof (or theorem?)

 *)
 
 module PropLang = struct
  type t = Atom of string
         | Implies of t * t
         | And of t * t
         | Or of t * t
         | Not of t
end

module PropLogic (T : TERM_LANG) : sig
  include module type of Logic(T)(PropLang)
  
  val impliesL : T.var -> rule
  val andL     : T.var -> rule
  val orL      : T.var -> rule
  val notL     : T.var -> rule
  
  val impliesR : rule
  val andR     : rule
  val orR1     : rule
  val orR2     : rule
  val notR     : rule
  val axiom    : rule
end = struct
  include Logic(T)(PropLang)
  
  let impliesL f =
    { decomposition = fun {hypotheses = hs; conclusion = c} ->
        let (h, hs') = find_and_remove hs f in
        match h with
        | Implies (a, b) ->
            [Goal.create ((f,           h) :: hs') a;
             Goal.create ((T.fresh hs', b) :: hs') c]
        | _              -> raise (InvalidHypothesis f)
      validation = function
      | [(_, a); ({hypotheses = (b, _) :: _}, c)] ->
          `App (Lambda (b, c), `App (`Var f, a))
      
    }
    
  let impliesR =
    { decomposition = fun {hypotheses = hs; conclusion = c} ->
        match c with
        | Implies (a, b) -> [Goal.create ((T.fresh hs, a) :: hs) b]
        | _ -> failwith "",
      
    }
end

