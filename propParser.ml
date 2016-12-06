
module Basics = struct
  
  exception Error
  
  type token = 
    | RPAREN
    | OR
    | NOT
    | LPAREN
    | IMPLIES
    | ID of (
# 21 "propParser.mly"
       (string)
# 16 "propParser.ml"
  )
    | FALSE
    | EOF
    | AND
  
end

include Basics

let _eRR =
  Basics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state = 
  | MenhirState11
  | MenhirState9
  | MenhirState7
  | MenhirState2
  | MenhirState1
  | MenhirState0

# 1 "propParser.mly"
  
  open PropAst

# 48 "propParser.ml"

let rec _menhir_run7 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_prop -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState7 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState7
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState7

and _menhir_run11 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_prop -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState11 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState11
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState11

and _menhir_run9 : _menhir_env -> 'ttv_tail * _menhir_state * 'tv_prop -> 'ttv_return =
  fun _menhir_env _menhir_stack ->
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState9
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState9 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState9
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState9
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState9

and _menhir_goto_prop : _menhir_env -> 'ttv_tail -> _menhir_state -> 'tv_prop -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_stack = (_menhir_stack, _menhir_s, _v) in
    match _menhir_s with
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv25 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AND ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack)
        | IMPLIES ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack)
        | OR ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack)
        | RPAREN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv21 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let _menhir_env = _menhir_discard _menhir_env in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv19 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_prop)) = _menhir_stack in
            let _3 = () in
            let _1 = () in
            let _v : 'tv_prop = 
# 41 "propParser.mly"
                             ( p )
# 132 "propParser.ml"
             in
            _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv20)) : 'freshtv22)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : ('freshtv23 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv24)) : 'freshtv26)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv31 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AND ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack)
        | EOF | IMPLIES | OR | RPAREN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv27 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, (p1 : 'tv_prop)), _, (p2 : 'tv_prop)) = _menhir_stack in
            let _2 = () in
            let _v : 'tv_prop = 
# 44 "propParser.mly"
                              ( Or  (p1,p2) )
# 158 "propParser.ml"
             in
            _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv28)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv29 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv30)) : 'freshtv32)
    | MenhirState9 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv35 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv33 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s, (p1 : 'tv_prop)), _, (p2 : 'tv_prop)) = _menhir_stack in
        let _2 = () in
        let _v : 'tv_prop = 
# 43 "propParser.mly"
                              ( And (p1,p2) )
# 178 "propParser.ml"
         in
        _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv34)) : 'freshtv36)
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : (('freshtv41 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AND ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack)
        | IMPLIES ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack)
        | OR ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack)
        | EOF | RPAREN ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv37 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let ((_menhir_stack, _menhir_s, (p1 : 'tv_prop)), _, (p2 : 'tv_prop)) = _menhir_stack in
            let _2 = () in
            let _v : 'tv_prop = 
# 45 "propParser.mly"
                                  ( Implies (p1,p2) )
# 201 "propParser.ml"
             in
            _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv38)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : (('freshtv39 * _menhir_state * 'tv_prop)) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv40)) : 'freshtv42)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv45 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv43 * _menhir_state) * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((let ((_menhir_stack, _menhir_s), _, (p : 'tv_prop)) = _menhir_stack in
        let _1 = () in
        let _v : 'tv_prop = 
# 42 "propParser.mly"
                  ( Not p )
# 221 "propParser.ml"
         in
        _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv44)) : 'freshtv46)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv59 * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
        ((assert (not _menhir_env._menhir_error);
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | AND ->
            _menhir_run9 _menhir_env (Obj.magic _menhir_stack)
        | EOF ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv55 * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv53 * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, (p : 'tv_prop)) = _menhir_stack in
            let _2 = () in
            let _v : (
# 31 "propParser.mly"
       (PropAst.prop)
# 242 "propParser.ml"
            ) = 
# 37 "propParser.mly"
                  ( p )
# 246 "propParser.ml"
             in
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv51) = _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 31 "propParser.mly"
       (PropAst.prop)
# 254 "propParser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv49) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let (_v : (
# 31 "propParser.mly"
       (PropAst.prop)
# 262 "propParser.ml"
            )) = _v in
            ((let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv47) = Obj.magic _menhir_stack in
            let (_menhir_s : _menhir_state) = _menhir_s in
            let ((_1 : (
# 31 "propParser.mly"
       (PropAst.prop)
# 270 "propParser.ml"
            )) : (
# 31 "propParser.mly"
       (PropAst.prop)
# 274 "propParser.ml"
            )) = _v in
            (Obj.magic _1 : 'freshtv48)) : 'freshtv50)) : 'freshtv52)) : 'freshtv54)) : 'freshtv56)
        | IMPLIES ->
            _menhir_run11 _menhir_env (Obj.magic _menhir_stack)
        | OR ->
            _menhir_run7 _menhir_env (Obj.magic _menhir_stack)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv57 * _menhir_state * 'tv_prop) = Obj.magic _menhir_stack in
            ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
            _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv58)) : 'freshtv60)

and _menhir_errorcase : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    match _menhir_s with
    | MenhirState11 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv7 * _menhir_state * 'tv_prop)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv8)
    | MenhirState9 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv9 * _menhir_state * 'tv_prop)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv10)
    | MenhirState7 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : ('freshtv11 * _menhir_state * 'tv_prop)) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s, _) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv12)
    | MenhirState2 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv13 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv14)
    | MenhirState1 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv15 * _menhir_state) = Obj.magic _menhir_stack in
        ((let (_menhir_stack, _menhir_s) = _menhir_stack in
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) _menhir_s) : 'freshtv16)
    | MenhirState0 ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv17) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv18)

and _menhir_run1 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState1
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState1 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState1
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState1
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState1

and _menhir_run2 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_stack = (_menhir_stack, _menhir_s) in
    let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState2 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState2
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState2

and _menhir_run3 : _menhir_env -> 'ttv_tail -> _menhir_state -> (
# 21 "propParser.mly"
       (string)
# 363 "propParser.ml"
) -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s _v ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv5) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    let ((s : (
# 21 "propParser.mly"
       (string)
# 373 "propParser.ml"
    )) : (
# 21 "propParser.mly"
       (string)
# 377 "propParser.ml"
    )) = _v in
    ((let _v : 'tv_prop = 
# 46 "propParser.mly"
           ( Atom s )
# 382 "propParser.ml"
     in
    _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv6)

and _menhir_run4 : _menhir_env -> 'ttv_tail -> _menhir_state -> 'ttv_return =
  fun _menhir_env _menhir_stack _menhir_s ->
    let _menhir_env = _menhir_discard _menhir_env in
    let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
    let (_menhir_s : _menhir_state) = _menhir_s in
    ((let _1 = () in
    let _v : 'tv_prop = 
# 47 "propParser.mly"
          ( False )
# 396 "propParser.ml"
     in
    _menhir_goto_prop _menhir_env _menhir_stack _menhir_s _v) : 'freshtv4)

and _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 31 "propParser.mly"
       (PropAst.prop)
# 415 "propParser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv1) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | FALSE ->
        _menhir_run4 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | ID _v ->
        _menhir_run3 _menhir_env (Obj.magic _menhir_stack) MenhirState0 _v
    | LPAREN ->
        _menhir_run2 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | NOT ->
        _menhir_run1 _menhir_env (Obj.magic _menhir_stack) MenhirState0
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        _menhir_errorcase _menhir_env (Obj.magic _menhir_stack) MenhirState0) : 'freshtv2))

# 220 "/Users/Home/.opam/system/lib/menhir/standard.mly"
  


# 451 "propParser.ml"
