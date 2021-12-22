:- initialization main, halt.

main :-
  read_file(user_input, Lines),
  part1(Lines),
  part2(Lines).

part1(Lines) :-
  maplist(score, Lines, Scores),
  sum_list(Scores, TotalScore),
  print(TotalScore), nl.

part2(Lines) :-
  include(incomplete, Lines, IncompleteLines),
  maplist(completion, IncompleteLines, Completions),
  median(Completions, MidScore),
  print(MidScore), nl.

% Reads a file into a list of string lines.
read_file(Stream, []) :-
  at_end_of_stream(Stream).

read_file(Stream, [X|L]) :-
  \+ at_end_of_stream(Stream), % negation
  read_line_to_string(Stream, X),
  read_file(Stream, L).

% Returns the score of a line.
score(Line, Score) :-
  string_chars(Line, Chars),
  compute(Chars, Score).

incomplete(Line) :-
  score(Line, 0).

% Returns the score of a sequence of characters.
compute(Chars, Score) :-
  consume(Chars, Chars2),
  compute2(Chars2, Score).

compute2([], 0).

compute2([H|_], Score) :-
  braces(_, H, Score, _).

compute2([H|T], Score) :-
  braces(H, _, _, _),
  compute(T, Score).

% Removes a maximum well-formed prefix from the list.
consume([], []).

consume([H|T], Rest) :-
  braces(H, HP, _, _),
  consume(T, NRem),
  (NRem = [] ->
    Rest = [H|T];
    NRem = [Next|Rem], Next = HP -> consume(Rem, Rest); Rest = [H|T]).

consume([H|T], [H|T]) :-
  braces(_, H, _, _).

% Compute the numeric completion score of a line.
completion(Line, Score) :-
  string_chars(Line, Chars),
  complete(Chars, Score).

complete(Chars, Score) :-
  consume(Chars, Chars2),
  complete2(Chars2, Score).

complete2([], 0).

complete2([H|T], Score) :-
  braces(H, _, _, Value),
  complete(T, Current),
  Score is 5 * Current + Value.

% Compute the median of a list.
median(List, Value) :-
  sort(List, Sorted),
  length(List, Len),
  Index is div(Len, 2),
  nth0(Index, Sorted, Value).

% Data about brace pairs and scores in the grammar.
braces('(', ')', 3, 1).
braces('[', ']', 57, 2).
braces('{', '}', 1197, 3).
braces('<', '>', 25137, 4).
