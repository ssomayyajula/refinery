open Interactive
open Prop_logic
open Caml

(* Generates a proof assistant for refinement propositional logic with extract
 * terms in OCaml. *)
module PL   = PropLogic(OCaml)
module PAPL = ProofAssistant(PL);;

(* REPL for the proof assistant, which utilizes sequent calculus where terms are
 * OCaml variables and formulae are propositions from propositional logic. *)
let () =
  let open Core.Std in
  let fmt = Format.std_formatter in
  Command.basic
    ~summary:"A proof assistant for refinement propositional logic that outputs extract terms in OCaml"
    Command.Spec.(empty +> anon ("sequent" %: (Arg_type.create PL.parse_sequent)))
    (fun s () ->
      match PAPL.prove read_line fmt s with
      | Ok p    -> OCaml.pp_t fmt (PL.extract_term p); String.pp fmt "\n"
      | Error e -> raise (Error.to_exn e)) |>
  Command.run
