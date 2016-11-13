module type CAML_LIKE = sig
  include TERM_LANG
end

module Caml : CAML_LIKE
