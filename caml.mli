module type CAML_LIKE = sig
  type var
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

module OCaml : CAML_LIKE
