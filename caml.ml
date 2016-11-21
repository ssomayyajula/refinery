open Core.Std

module type CAML_LIKE = [%import: (module Caml.CAML_LIKE)]

module OCaml : CAML_LIKE = struct
  type var = string
  
  type t = [ `Var of var
           | `Lambda of var * t
           | `App of t * t ]
  
  let i = ref 0
  
  let make_var () =
    i := !i + 1;
    "v" ^ (string_of_int !i)
  
  let pp_var = String.pp
  
  let subst = failwith ""
  
end
