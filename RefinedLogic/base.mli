open Core.Std

module type TERM_LANG = sig
  type t
  type var
  val make_var : unit -> var
  val pp_var : Format.formatter -> var -> unit
end

module type FORM_LANG = sig
  type t
  val pp_form : Format.formatter -> t -> unit
end

module type LOGIC = sig
  type term_var
  type term
  type form
  
  type decl    = term_var * form
  type sequent = decl list * form
  
  type decomposition = sequent -> sequent list
  type validation    = (sequent * term) list -> term
  type rule          = decomposition * validation
  
  type proof
  type complete_proof
  
  exception InvalidDecomposition of term_var option * sequent
  exception InvalidSubgoals of term_var option * sequent list
  
  val proof_of_sequent : sequent -> proof Or_error.t
  val apply_rule : rule -> sequent -> proof
  val complete : proof -> complete_proof option
  val extract_term : complete_proof -> term
  val pp_proof : Format.formatter -> proof -> unit
end

module Logic : functor (T : TERM_LANG) (F : FORM_LANG) -> LOGIC

module type PROOF_SYSTEM = sig
  include module type of Logic(T)(F)
  val parse_rule : string -> rule
end

(*val extract : ('a * 'b) list -> 'a -> ('a * b) list * 'b * ('a * b) list
*)
