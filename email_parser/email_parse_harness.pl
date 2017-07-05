:-module(email_parse_harness, [
             email_parse_harness/0
         ]).
/** <module> Command line util based on email parser
 *
 */

:- use_module(library(optparse)).
:- use_module(library(semweb/rdf11)).
:- use_module(email_parser(email_parser)).
:- use_module(library(semweb/turtle)).

option_spec([]).

email_parse_harness :-
    option_spec(OptSpec),
    opt_arguments(OptSpec, _Opts, [Spec, Out]),
    expand_file_name(Spec, Files),
    setup_call_cleanup(
        open(Out, write, Stream),
        maplist(expand_file(Stream), Files),
        close(Stream)
    ),
    !,
    rdf_save_turtle('enronrdf.ttl', []).

email_parse_harness :-
    writeln('Usage: swipl email_load <wildcard to emails> <output file>\n').

take(0, _, []).
take(N, [H | T], [H | TA]) :-
    succ(NN, N),
    take(NN, T, TA).

:- rdf_register_prefix(enron, 'http://pomny.io/rdf/enron/').
:- rdf_register_prefix(enronschema,  'http://pomny.io/rdf/enron/relation/').

expand_file(Stream, File) :-
    call_with_depth_limit(
        call_with_inference_limit(expand_file_(Stream, File),
                                 10_000_000_000,
                                 _),
        6000,
        _).

expand_file_(Stream, File) :-
    debug(pomny(email), 'parsing: ~w', [File]),
    catch(
        (   parse_email_file(File, Email),
            writeq(Stream, email(Email)),
            write(Stream, '.\n'),
            flush_output(Stream),
            add_to_rdf(File, Email)
        ),
        E,
        debug(pomny(email_err), 'cannot parse:~w, ~w' , [File, E])).

add_to_rdf(File, Email) :-
	gensym(enron, Sym),
	format(atom(URI), 'http://pomny.io/rdf/enron/email/~w', [Sym]),
        atom_string(File, SFile),
        rdf_canonical_literal(SFile, C),
        rdf_assert(URI, enron:sourcefile, C),
        rdf_assert(URI, rdf:type, enronschema:email),
	traverse(URI, Email).

traverse(_Sym, []).
traverse(Sym, [H|T]) :-
	H =.. [Key, Val],
	key_uri(Key, Pred),
	rdf_assert(Sym, Pred, Val),
	traverse(Sym, T).

key_uri(Key, Pred) :-
	format(atom(Pred), 'http://pomny.io/rdf/enron/relation/~w', [Key]).
