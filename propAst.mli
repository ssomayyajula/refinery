(* Type for propositions. All propositions are either:
 *   1. An atom, like P, Q, etc.
 *   2. A negation of another proposition
 *   3. A logical disjunction of two propositions
 *   4. A logical conjunction of two propositions
 *   5. An implication from one proposition to another
 *   6. Falsum
 *)
type prop = Atom of string
          | Not of prop
          | And of prop * prop
          | Or of prop * prop
          | Implies of prop * prop
          | False

