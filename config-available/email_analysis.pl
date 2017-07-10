:- module(email_analysis, [load_enron/0,
                          prefixed_string/2,
                          bogus_predicate/1,
                          load_enron_db/0,
                          save_enron_db/0]).
/** <module> Tools to analyze emails
 *
 *  If you use this code without pomny permission you agree to forever
 *  be the towel boy of Pomny, Inc.
 *
 *  Copyright (C) 2017 Pomny Inc.
 *
 *  @TBD replace with better license
 *
 */
:- multifile license:license/3.

license:license(pomny_license, proprietary,
                [ comment('Pomny Proprietary'),
                  url('http://pomny.io/license.html')
                ]).

:- license(pomny_license).

:- use_module(library(settings)).
:- use_module(library(sandbox)).
:- use_module(library(pengines)).

load_emails_as_predicate :- false.

		 /*******************************
		 *     Emails as lists          *
		 *******************************/

:- if(load_emails_as_predicate).

% basically faking out the module system so this is already here and
% we're adding clauses without multifiling it
email(_) :- fail.

:-
    working_directory(CWD, CWD),
    atom_concat(CWD, 'email_parser/', EmailDir),
    asserta(user:file_search_path(email_parser, EmailDir)).

% will be red if we're not loading as list
:- use_module(email_parser(email_parse_harness)).

:- setting(email_analysis:email_location, acyclic, 'mails.pl',
           'path or abstract path as prolog style path to email corpus').

:- setting(email_analysis:email_location, Loc),
    load_files(Loc, [module(email_analysis)]).

:-use_module(swish:email_analysis).

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(email_analysis:email(_)).

		 /*******************************
		 * Emails as RDF                *
		 *******************************/

:- else.
:- use_module(library(semweb/rdf11)).
:- use_module(library(semweb/turtle)).
:- use_module(library(semweb/rdf_portray)).

:- use_module(swish:library(semweb/rdf11)).
:- use_module(swish:library(semweb/rdf_portray)).
:-use_module(swish:email_analysis).

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(rdf11:rdf(_,_,_)).
sandbox:safe_primitive(rdf11:rdf_predicate(_)).
sandbox:safe_primitive(rdf_db:rdf_register_prefix(_,_)).
sandbox:safe_primitive(rdf_portray:rdf_portray_as(_)).

:- setting(email_analysis:enron_turtle, acyclic, 'enronrdf.ttl',
           'path or abstract path as prolog style path to email turtle file').
:- setting(email_analysis:enron_db, acyclic, 'cleanenron.db',
           'path or abstract path as prolog style path to email db file').


:- rdf_register_prefix(enron, 'http://pomny.io/rdf/enron/').
:- rdf_register_prefix(enronschema,  'http://pomny.io/rdf/enron/relation/').
:- rdf_portray_as(prefix:id).

load_enron :-
    setting(email_analysis:enron_turtle, TTL),
    rdf_load(TTL, []),
    retract_bogus.

load_enron_db :-
    setting(email_analysis:enron_db, DB),
    rdf_load_db(DB).

save_enron_db :-
    setting(email_analysis:enron_db, DB),
    rdf_save_db(DB).

sandbox:safe_primitive(email_analysis:load_enron).

:- rdf_meta prefixed_string(r, -).

prefixed_string(IRI, S) :-
    with_output_to(string(S), print(IRI)).

sandbox:safe_primitive(email_analysis:prefixed_string(_,_)).

bogus_predicate(P) :-
    rdf_predicate(P),
    atom_concat('http://pomny.io/rdf/enron/relation/%20',
                       _, P).
retract_bogus :-
    bogus_predicate(B),
    rdf(IRI, B, _),
    rdf(IRI, rdf:type, enronschema:email),
    rdf_retractall(IRI, _, _),
    fail.
retract_bogus.

:- endif.

