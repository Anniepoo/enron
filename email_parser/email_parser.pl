:- module(email_parser, [
              parse_email_file/2
          ]).
/** <module> The actual parser for RFC822/MIME emails
 *
 */
:-use_module(library(dcg/basics)).

%!  parse_email_file(+File:term, -Email:list) is nondet
%
%   @arg  File is one of atom or string (a file name) or a Stream
%   @arg  Email is a list that describes the email with complex terms
%
parse_email_file(File, Email) :-
    is_stream(File),
    (   phrase_from_stream(email(Email), File)
    ;   throw(error(syntax_error(parse_email_file),
                    context(email_parser:parse_email_file/2, 'invalid email format')))
    ),
    !.  % mustn't use trail
parse_email_file(File, Email) :-
    setup_call_cleanup(
        open(File, read, Stream),
        parse_email_file(Stream, Email),
        close(Stream)
    ),
    !. % mustn't use trail

% should be red
email([body(Body) | Headers]) -->
    headers(Headers),
    body(Body).

headers([Header | Headers]) -->
    header(Header),
    headers(Headers).
headers([]) -->
    header_break.

header_break -->
    "\n".
header_break -->
    "\r\n".

header(Header) -->
    string_without(":\r\n", Tag),
    ":",
    whites,
    string_without("\r\n", Val),
    endline,
    continuation_lines(Conts),
    {
        atom_codes(ATag, Tag),
        header_value_from_parts(Val, Conts, SVal),  % returns string!
        Header =.. [ATag, SVal]
    }.

endline --> "\r\n".
endline --> "\n".

continuation_lines([Cont|Conts]) -->
    string_without(":\r\n", Cont),
    {   Cont \= []
    },
    endline,
    continuation_lines(Conts).
continuation_lines([]) --> [].

header_value_from_parts(Val, Conts, SVal) :-
    append([Val | Conts], CodeVal),   % drop the internal newlines
    string_codes(SVal, CodeVal).

body(Body) -->
    string(CBody),
    original_separator,
    grnd_remainder(_),
    {string_codes(Body, CBody)}.
body(Body) -->
    grnd_remainder(CBody),
    {string_codes(Body, CBody)}.

original_separator -->
    " -----Original Message-----\n".

% library remainder//1 reutrns list (codes)
% with hole at end when used with lazy phrase_from_stream
%
% workaround for that
grnd_remainder([]) -->
    eos.
grnd_remainder([H |T]) -->
   \+ eos,
   [H],
   grnd_remainder(T).
