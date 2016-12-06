open Core.Std
open Format

module type TERM_LANG = [%import: (module Base.TERM_LANG)]

module type FORM_LANG = [%import: (module Base.FORM_LANG)]

module type LOGIC = sig
  type term_var
  type term
  type form
  
  type hypos = (term_var * form) list
  type sequent = hypos * form
  
  type rule = (sequent -> sequent list) *
              ((sequent * term) list -> term)
  
  type proof = Sequent of sequent
             | Proof of sequent * rule * proof list
  type complete_proof
  
  exception InvalidLabel of term_var * hypos
  exception InvalidDecomposition of term_var option * sequent
  exception InvalidSubgoals of term_var option * (sequent * term) list
  
  val take_last : hypos -> int -> hypos
  val split : hypos -> term_var -> hypos * form * hypos
  val parse_sequent : string -> sequent
  val proof_of_sequent : sequent -> proof Or_error.t
  val apply_rule : rule -> sequent -> proof
  val complete : proof -> complete_proof option
  val extract_term : complete_proof -> term
  val pp_proof : Format.formatter -> proof -> unit
end

module type PROOF_SYSTEM = sig
  include LOGIC
  val parse_rule : string -> rule option
end

module Logic (T : TERM_LANG) (F : FORM_LANG) :
  LOGIC with type term_var = T.var and type term = T.t and type form = F.t = struct
  type term_var = T.var
  type term     = T.t
  type form     = F.t
  
  type hypos = (term_var * form) list
  type sequent = hypos * form
  
  type rule = (sequent -> sequent list) *
              ((sequent * term) list -> term)
  
  type proof = Sequent of sequent
             | Proof of sequent * rule * proof list
  
  type complete_proof = CompleteProof of sequent * rule * complete_proof list
  
  exception InvalidLabel of term_var * hypos
  exception InvalidDecomposition of term_var option * sequent
  exception InvalidSubgoals of term_var option * (sequent * term) list
  
  let take_last h i = List.take (List.rev h) i
  
  let rec index d ?(i=0) = function
    | [] -> invalid_arg "index"
    | h :: t -> if h = d then i else index d ~i:(i + 1) t
  
  let split h v =
    match List.Assoc.find h v with
    | Some f ->
        let i = index (v, f) h in
        let (hl, hr) = List.split_n h i in
        (hl, f, Option.value_map (List.tl hr) ~default:[] ~f:(Fn.id))
    | None   -> raise (InvalidLabel (v, h))

  let print_list lst =
    print_string "[";
    let rec helper lst =
      match lst with
      | []   -> ()
      | h::t -> print_string h; print_string "; "; helper t
    in
      helper lst;
      print_string "]\n"

  let lex_hypo hypo =
    if Str.string_match (Str.regexp "[' ' '\t']") hypo 0 then
      failwith ("Empty hypothesis: " ^ hypo)
    else
      let lst = Str.split (Str.regexp ":") hypo in
      (* print_list lst; *)
      match List.length lst with
      | 0 -> assert false
      | 1 -> failwith ("Unrecognized hypothesis: " ^ hypo)
      | 2     -> 
          begin
            let var  = List.nth_exn lst 0 |> T.parse_var  in
            let prop = List.nth_exn lst 1 |> F.parse_form in
              (var, prop)
          end
      | _     -> let joined_prop = List.fold_left (List.tl_exn lst) ~init:"" ~f:(^) in
                   failwith ("Invalid proposition: " ^ joined_prop)

  let lex_hypos hypotheses =
    let lst = Str.split (Str.regexp ",") hypotheses in
    (* print_list lst; *)
      List.map lst lex_hypo

  let parse_sequent s =
    let lst = Str.split (Str.regexp "|-") s in
    (*print_list lst;*)
    match List.length lst with
    | 0 -> assert false
    | 1 -> failwith ("A sequent must have at least one hypothesis!")
    | 2     ->
        begin
          let hypotheses = List.nth_exn lst 0 in
          let c = List.nth_exn lst 1 |> F.parse_form in
          let hypo_lst = lex_hypos hypotheses in
            (hypo_lst, c)
        end
    | _     -> failwith ("A sequent cannot involve multiple proofs!")
  
  let proof_of_sequent ((h, _) as s) =
    if List.contains_dup (List.map h fst) then
      Or_error.errorf "Duplicate label in hypotheses"
    else Ok (Sequent s)
  
  let apply_rule ((dec, _) as r) s =
    Proof (s, r, List.map (dec s) (fun g -> Sequent g))
  
  let rec complete = function
    | Sequent _         -> None
    | Proof (s, r, sub) ->
        List.map sub complete |> Option.all |>
          Option.value_map
            ~default:None
            ~f:(fun sub' -> Some (CompleteProof (s, r, sub')))
  
  let rec extract_term (CompleteProof (_, (_, va), sub)) =
    va (List.map sub (fun (CompleteProof (s, _, _) as p) -> (s, extract_term p)))
  
  let pp_decl fmt (v, f) = fprintf fmt "%a : %a" T.pp_var v F.pp_form f
  
  let pp_hypos fmt =
    pp_print_list ~pp_sep:(fun fmt () -> String.pp fmt ", ") pp_decl fmt
  
  let pp_sequent fmt (h, f) = fprintf fmt "%a |- %a" pp_hypos h F.pp_form f
  
  let rec pp_proof fmt =
    let rec helper i p =
      for j = 1 to i do
        String.pp fmt " "
      done;
      match p with
      | Sequent s         -> pp_sequent fmt s
      | Proof (s, _, sub) ->
          pp_sequent fmt s;
          String.pp fmt "\n";
          List.iter sub (helper (i + 2))
    in helper 0
end
