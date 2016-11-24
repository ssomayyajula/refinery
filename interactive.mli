open Core.Std

module ProofAssistant : functor (P : Base.PROOF_SYSTEM) -> sig
  val prove :
    (unit -> string) -> (* Rule input function *)
    Format.formatter -> (* Output formatter for proof *)
    P.sequent ->        (* Input sequent *)
    P.complete_proof Or_error.t
end
