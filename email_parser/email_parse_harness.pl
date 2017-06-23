:-module(email_parse_harness, [
             email_parse_harness/0
         ]).
/** <module> Command line util based on email parser
 *
 */

:- use_module(library(optparse)).
:- use_module(library(semweb/rdf_db)).
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
    !.
email_parse_harness :-
    writeln('Usage: swipl email_load <wildcard to emails> <output file>\n').

:- rdf_register_prefix(enron, 'http://pomny.io/rdf/enron/').

expand_file(Stream, File) :-
    catch(
        (   parse_email_file(File, Email),
            writeq(Stream, email(Email)),
            write(Stream, '.\n'),
            flush_output(Stream),
				add_to_rdf(Email)
        ),
        _,
        true).
expand_file(_) :- 
	rdf_save_turtle('enronrdf.ttl', []).

add_to_rdf(Email) :- 
	gensym(enron, Sym), 
	format(atom(URI), 'http://pomny.io/rdf/enron/email/~w', [Sym]),
	traverse(URI, Email).

traverse(_Sym, []).
traverse(Sym, [H|T]) :-
	H =.. [Key, Val],
	key_uri(Key, Pred),
	rdf_assert(Sym, Pred, literal(Val)),
	traverse(Sym, T).

key_uri(Key, Pred) :- 
	format(atom(Pred), 'http://pomny.io/rdf/enron/relation/~w', [Key]).
