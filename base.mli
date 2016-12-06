open Core.Std

(* A term language, such as OCaml, specifies a term type, a variable type over
 * those terms, and a way to parse strings into term variables. *)
module type TERM_LANG = sig
  (* The type of terms. *)
  type t
  (* The type of term variables.*)
  type var

  (* Parses a string into a term variable, if it is in the right form. *)
  val parse_var : string -> var

  (* Produces a fresh term variable. *)
  val make_var : unit -> var

  (* Pretty-prints a term variable to standard output. *)
  val pp_var : Format.formatter -> var -> unit

  (* Pretty-prints a term to standard output. *)
  val pp_t : Format.formatter -> t -> unit
end

(* A formula language, such as propositional logic, specifies a formula type
 * and a way to parse strings into formulas. *)
module type FORM_LANG = sig
  (* The type of formulae. *)
  type t

  (* Parses a string into a formula, if it is in the right form. *)
  val parse_form : string -> t

  (* Pretty-prints a formula to standard output. *)
  val pp_form : Format.formatter -> t -> unit
end

(* A logic system combines terms and formulae into sequents, which are proofs
 * between hypotheses and conclusions. Provides various helper functions
 * associated with the sequents as well as the constituent terms and formulas. *)
module type LOGIC = sig
  (* The type of term variables. *)
  type term_var
  (* The type of terms themselves. *)
  type term
  (* The type of formulae. *)
  type form
 
  (* Hypotheses are a list of individual hypotheses, where a hypothesis is a
   * mapping between a term variable and a formula. *)
  type hypos = (term_var * form) list
  (* Sequents are a collection of hypotheses together with a conclusion formula. *)
  type sequent = hypos * form
  
  (* A rule is a function that maps sequents onto a list together with a
   * function that maps a sequent-to-term association list to terms. *)
  type rule = (sequent -> sequent list) *
              ((sequent * term) list -> term)
  
  (* A proof is either a single sequent or a list of triples, where each triple
   * is a sequent together with a rule for that sequent and a proof for the
   * following reduction based on the specified rule. *)
  type proof = Sequent of sequent
             | Proof of sequent * rule * proof list
  type complete_proof
 
  (* Exceptions if there are invalid terms/hypotheses/sequents defined. *)
  exception InvalidLabel of term_var * hypos
  exception InvalidDecomposition of term_var option * sequent
  exception InvalidSubgoals of term_var option * (sequent * term) list
  
  (* Returns the last element of the sublist of hypotheses starting at the
   * specified index. *)
  val take_last : hypos -> int -> hypos

  (* Splits the specified list of hypotheses by searching for the mapping
   * between the specified term variable and some formula. Returns a triple
   * (h1, form, h2), where the original list was h1 @ [(term_var,form)] @ h2. *)
  val split : hypos -> term_var -> hypos * form * hypos

  (* Parses a string into a sequent, if it is in the right form. *)
  val parse_sequent : string -> sequent

  (* Provides a proof of the specified sequent, if one exists. *)
  val proof_of_sequent : sequent -> proof Or_error.t

  (* Applies the specified rule to the given sequent to produce a proof. *)
  val apply_rule : rule -> sequent -> proof

  (* Completes the specified proof, if possible. *)
  val complete : proof -> complete_proof option

  (* Extracts the term from a completed proof. *)
  val extract_term : complete_proof -> term
  
  (* Pretty-prints the proof to standard output. *)
  val pp_proof : Format.formatter -> proof -> unit
end

(* Logic is a functor that produces a logic system using a provided term
 * language and a formula language. *)
module Logic : functor (T : TERM_LANG) (F : FORM_LANG) ->
  LOGIC with type term_var = T.var and type term = T.t and type form = F.t

(* A proof system is a logic system that also has a set of rules associated with
 * the logic as well as a way to parse strings into a rule, if one applies. *)
module type PROOF_SYSTEM = sig
  include LOGIC
  val parse_rule : string -> rule option
end
