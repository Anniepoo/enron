:- module(run, [go/0]).
/** <module> main entry point for dev harness for email parser
 * copyright (C) 2017 The Elgin Works
 * All Rights Reserved
 *
 * license:
 *  This software is the confidential and proprietary property of The
 *  Elgin Works.
 *
*/

:-
    working_directory(CWD, CWD),
    atom_concat(CWD, 'email_parser/', EmailDir),
    asserta(user:file_search_path(email_parser, EmailDir)).

:- use_module(email_parser(email_parse_harness)).

go :-
    email_parse_harness.


