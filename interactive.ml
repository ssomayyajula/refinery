open Core.Std
open Or_error

module ProofAssistant (P : Base.PROOF_SYSTEM) = struct
  open P
  
  (* Depth-first proof of given incomplete proof.
   * If it terminates without error, it is guaranteed
   * to return a complete proof. *)
  let rec helper inp fmt p =
    pp_proof fmt p;
    String.pp fmt "\n> ";
    match p with
    | Sequent s ->
      Option.value_map (inp () |> parse_rule)
        ~default:(String.pp fmt "Invalid rule given\n";
                  helper inp fmt p)
        ~f:(fun r ->
              helper inp fmt
                (try apply_rule r s with e -> Exn.pp fmt e; p))
    | Proof (s, r, sub) ->
        Proof (s, r, List.map sub (helper inp fmt))
  
  let prove inp fmt s =
    proof_of_sequent s >>=
    Fn.compose return (helper inp fmt) >>=
    fun p -> Option.value_map (complete p)
      ~default:(error_string "impossible")
      ~f:(fun c -> Ok c)
end
