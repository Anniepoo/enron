% Pomny Processing Enron
:- use_module(email_parser(email_parse_harness)).
go :- email_parse_harness.

% Your program goes here


/** <examples> Your example queries go here, e.g.
?- X #> 1.


% swipl email_load.pl -- "/home/anniepoo/pomny/maildir/*/*/*" enron.pl
% ?- X = sum(email).

*/
