open Core.Std

module type TERM_LANG = sig
  type t
  type var
  val sexp_of_var : var -> Sexp.t
end

module type FORM_LANG = sig
  type t
end

module Logic : functor (T : TERM_LANG) (F : FORM_LANG) -> sig
  (** Like any other logic, a refinement logics provides a system to prove mathematical
      claims or _goals_. A goal is... *)
  type goal =
    { (** A conclusion (a mathematical formula) conditioned on a series of... *)
      con : F.t;
      (** _hypotheses_ (also formulas) labeled by term variables *)
      hs  : (T.var, F.t) List.Assoc.t
    }
  
  (** A logic then is just a set of _inference rules_, which each consist of... *)
  type rule =
    { (** A _decomposition_ that converts a goal into a series of _subgoals_.
          Proofs by refinement prove goals by proving its subgoals generated
          by decomposition. *)
      dec : goal -> goal list;
      (** A _validation_ that produces the evidence term for a goal given the
          evidence terms of its subgoals. This is unique to refinement logics. *)
      vl  : (goal * T.t) list -> T.t
    }
  
  (** A proof is a list of inference rules whose decompositions are to be applied
      to an initial goal in depth-first order, like most other proof assistants.
      
      A proof is complete if it has no remaining subgoals i.e. `subgoals thm = []`  *)
  type proof = rule list
  
  (** A theorem consists of a goal and a proof *)
  type complete
  type _ theorem
  
  (** One may establish a /theorem/ by proving a well-formed goal *)
  val prove : goal -> proof -> _ theorem
  
  (** One may access a theorem's goal and proof *)
  val goal_of  : _ theorem -> goal
  val proof_of : _ theorem -> proof
  
  (** Returns a theorem's remaining subgoals in depth-first order *)
  val subgoals : _ theorem -> goal list
  
  exception IncompleteProof of goal list
  
  (** If a theorem's proof doesn't have any more obligations, it is marked complete,
     otherwise this raises IncompleteProof *)
  val verify : _ theorem -> complete theorem
  
  (** Returns the extract term of a theorem with a complete proof *)
  val extract_term : complete theorem -> T.t
end
