open Core.Std
open Format

module type TERM_LANG = [%import: (module Base.TERM_LANG)]

module type FORM_LANG = [%import: (module Base.FORM_LANG)]

module type LOGIC = [%import: (module Base.LOGIC)]

module Logic (T : TERM_LANG) (F : FORM_LANG) : LOGIC = struct
  type term_var       = T.var
  type term           = T.t
  type form           = F.t
  type decl           = [%import: LOGIC.decl]
  type sequent        = [%import: LOGIC.sequent]
  type decomposition  = [%import: LOGIC.decomposition]
  type validation     = [%import: LOGIC.validation]
  type rule           = [%import: LOGIC.rule]
  type proof          = [%import: LOGIC.proof]
  type complete_proof = [%import: LOGIC.complete_proof]
  (*type decl    = term_var * form
  type sequent = decl list * form
  
  type decomposition = sequent -> sequent list
  type validation    = (sequent * term) list -> term
  type rule          = decomposition * validation
  
  type proof = Sequent of sequent
             | Proof of sequent * rule * proof list
  
  type complete_proof = Proof of sequent * rule * complete_proof list*)
  
  exception InvalidDecomposition of term_var option * sequent
  exception InvalidSubgoals of term_var option * sequent list
  
  let pp_decl fmt (v, f) = fprintf fmt "%a : %a" T.pp_var v F.pp_form f
  
  let pp_hypos fmt =
    pp_print_list ~pp_sep:(fun fmt () -> String.pp fmt ", ") pp_decl fmt
  
  let pp_sequent fmt (h, f) = fprintf fmt "%a |- %a" pp_hypos h F.pp_form f
  
  let rec pp_proof fmt = function
      Sequent s         -> pp_sequent fmt s
    | Proof (s, _, sub) -> fprintf fmt "@[<v 2>%a@,%a@;<0 -2>@]"
                             pp_sequent s (pp_print_list pp_proof) sub
  
  let proof_of_sequent ((h, _) as s) =
    if List.contains_dup (List.map h fst) then
      Or_error.errorf "Duplicate label in hypotheses"
    else Ok (Sequent s)
  
  let apply_rule ((dec, _) as r) s = Proof (s, r, dec s)
  
  let rec complete = function
    | Sequent _         -> None
    | Proof (s, r, sub) ->
        List.map sub complete |> Option.all |>
          Option.value_map
            ~default:None
            ~f:(fun sub' -> Some (Proof (s, r, sub')))
  
  let rec extract_term (Proof (_, (_, va), sub)) =
    List.map sub (fun (Proof (s, _, _) as p) -> (s, extract_term p)) |> va
    
  let rec prove inp = function
    | Sequent s         -> prove (apply_rule (inp ()) p)
    | Proof (s, r, sub) -> Proof (s, r, List.map sub interactive)
end

(*let extract h i =
  let d = nth_exn h i in
  let (hl, hr) = split_n h i in
  (hl, d, hr)
*)