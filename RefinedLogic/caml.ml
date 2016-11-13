module type CAML_LIKE = [%import: (module Caml.CAML_LIKE)]

module Caml : CAML_LIKE = struct
  type var = string
  
  let i = ref 0
  
  let make_var () =
    i := !i + 1;
    "v" ^ (string_of_int !i)
end
