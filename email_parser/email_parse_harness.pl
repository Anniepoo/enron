:-module(email_parse_harness, [
             email_parse_harness/0
         ]).
/** <module> Command line util based on email parser
 *
 */

:- use_module(library(optparse)).
:- use_module(email_parser(email_parser)).

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

expand_file(Stream, File) :-
    catch(
        (   parse_email_file(File, Email),
            writeq(Stream, email(Email)),
            write(Stream, '.\n'),
            flush_output(Stream)
        ),
        _,
        true).
expand_file(_).
