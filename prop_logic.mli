open Base

module PropLogic : functor (T : Caml.CAML_LIKE) ->
  PROOF_SYSTEM with type term_var = T.var and type term = T.t
