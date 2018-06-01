open Core.Std

module Reader : sig
  (** Core interface *)
  type 'a t
  
  val reader : (R.t -> 'a) -> 'a t
  
  val local : (R.t -> R.t) -> 'a t -> 'a t
  
  (** Convenience functions *)
  include Monad.S
  include Applicative.S
end = struct
  type 'a t = R.t -> 'a
  
  let reader = Fn.id
  
  let local f m r = m (f r)
  
  module M = Monad.Make(struct
    type nonrec 'a t = 'a t
    
    let return = failwith ""
    
    let bind = failwith "unimplemented"
  end)
  
  include M
  
  include Applicative.Of_monad(M)
end

module State (S : sig type t end) : sig
  type 'a t
  
  val state : (S.t -> 'a * S.t) -> 'a t
  
  (*val get : S.t t*)
  
  (*val put : S.t -> unit t*)
end = struct
  include Reader(struct type t = S.t ref end)
  
  let state f =
    reader fun s ->
    let (a, s') = f !s in
    s := s';
    return a
  
  let get = state (fun s -> !s, s)
  
  let modify f = state (fun s -> (), f !s)
  
  let put = Fn.compose modify Fn.const
end

