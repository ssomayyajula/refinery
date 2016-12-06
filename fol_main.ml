open Interactive
open Fol
open Caml

(* Generates a proof assistant for refinement first-order logic
   with extract terms in OCaml *)
module FL   = FOL(OCaml)
module PAFL = ProofAssistant(FL);;

let () =
  let open Core.Std in
  let fmt = Format.std_formatter in
  Command.basic
    ~summary:"A proof assistant for refinement first-order logic that outputs extract terms in OCaml"
    Command.Spec.(empty +> anon ("sequent" %: (Arg_type.create FL.parse_sequent)))
    (fun s () ->
      match PAFL.prove read_line fmt s with
      | Ok p    -> OCaml.pp_t fmt (FL.extract_term p); String.pp fmt "\n"
      | Error e -> raise (Error.to_exn e)) |>
  Command.run
