open Interactive
open Prop_logic
open Caml

(* Generates a proof assistant for refinement propositional logic
   with extract terms in OCaml *)
module PL   = PropLogic(OCaml)
module PAPL = ProofAssistant(PL);;

let () =
  let open Core.Std in
  let fmt = Format.std_formatter in
  Command.basic
    ~summary:"A proof assistant for refinement propositional logic that outputs the extract term in OCaml"
    ~readme:(fun _ -> "")
    Command.Spec.(empty +> anon ("sequent" %: (Arg_type.create PL.parse_sequent)))
    (fun s () ->
      match PAPL.prove read_line fmt s with
      | Ok p    -> OCaml.pp_t fmt (PL.extract_term p)
      | Error e -> raise (Error.to_exn e)) |>
  Command.run
