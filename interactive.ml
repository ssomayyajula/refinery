open Core.Std
open Or_error

module ProofAssistant (P : Base.PROOF_SYSTEM) = struct
  open P
  
  (* Depth-first proof of given incomplete proof.
   * If it terminates without error, it is guaranteed
   * to return a complete proof. *)
  let rec helper inp fmt p indent =
    match p with
    | Sequent s ->
        for j = 1 to indent do
          String.pp fmt " ";
          Format.pp_print_flush fmt ()
        done;
        pp_proof fmt p;
        String.pp fmt " by ";
        Format.pp_print_flush fmt ();
        let i = read_line () in
        let r = parse_rule i in begin
        match r with
        | Some ru ->
            helper inp fmt
              (try apply_rule ru s with
                 e -> Exn.pp fmt e;
                 String.pp fmt "\n";
                 Format.pp_print_flush fmt ();
                 p) indent
        | None -> String.pp fmt "Invalid rule given\n";
                  Format.pp_print_flush fmt ();
                  helper inp fmt p indent
    end
    | Proof (s, r, sub) ->
        Proof (s, r, List.map sub (fun x -> helper inp fmt x (indent + 2)))
  
  let prove inp fmt s =
    proof_of_sequent s >>=
    fun x -> return (helper inp fmt x 0) >>=
    fun p -> Option.value_map (complete p)
      ~default:(error_string "impossible")
      ~f:(fun c -> Ok c)
end
