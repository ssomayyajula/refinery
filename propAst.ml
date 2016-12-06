type prop = Atom of string
          | Not of prop
          | And of prop * prop
          | Or of prop * prop
          | Implies of prop * prop
          | False

