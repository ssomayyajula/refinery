open Core.Std

(* A ProofAssistant uses a proof system to produce a prover function over
 * sequents in that proof system. *)
module ProofAssistant : functor (P : Base.PROOF_SYSTEM) -> sig
  (* Given a rule and a sequent, completes the proof for the sequent using that
   * rule, if possible, and formats it using the specified formatter. *)
  val prove :
    (unit -> string) -> (* Rule input function *)
    Format.formatter -> (* Output formatter for proof *)
    P.sequent ->        (* Input sequent *)
    P.complete_proof Or_error.t
end
