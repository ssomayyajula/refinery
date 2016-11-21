module type CAML_LIKE = sig
  type var
  type t = [ `Var of var
           | `Lambda of var * t
           | `App of t * t ]
  include Base.TERM_LANG with
    type var := var and type t := t
  (* subst e1 e2 x = e1{e2/x} *)
  val subst : t -> t -> var -> t
end

module OCaml : CAML_LIKE
