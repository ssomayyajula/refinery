(* A CAML_LIKE language defines an expression type that is similar to the core
 * sublanguage of Caml. *)
module type CAML_LIKE = sig
  (* The type of caml-like variables. *)
  type var

  (* The caml-like polymorphic variant type, which supports lamdba calculus as
   * well as pairs with projection operations and match statements. *)
  type t = [ `Var of var
           | `Lambda of var * t
           | `App of t * t
           | `Fst of t
           | `Snd of t
           | `Pair of t * t
           | `Match of t * ((string * var) * t) * ((string * var) * t)
           | `L of t
           | `R of t
           | `Any of t ]
  include Base.TERM_LANG with
    type var := var and type t := t
end

(* OCaml is an example of a CAML_LIKE language. *)
module OCaml : CAML_LIKE
