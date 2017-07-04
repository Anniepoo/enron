:- module(email_analysis, []).
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

email(_) :- fail.

:- setting(email_analysis:email_location, acyclic, 'mails.pl',
           'path or abstract path as prolog style path to email corpus').

:- setting(email_analysis:email_location, Loc),
    load_files(Loc, [module(email_analysis)]).

:-use_module(swish:email_analysis).

:- multifile sandbox:safe_primitive/1.

sandbox:safe_primitive(email_analysis:email(_)).





