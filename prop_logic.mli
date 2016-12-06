open Base

(* Propositional logic uses a caml-like language to produce a proof system
 * defined over caml-like variables/terms. *)
module PropLogic : functor (T : Caml.CAML_LIKE) ->
  PROOF_SYSTEM with type term_var = T.var and type term = T.t
