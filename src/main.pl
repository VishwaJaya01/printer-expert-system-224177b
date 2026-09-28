:- module(main, [main/0, demo/0, show_case/1, show_proof/2]).
:- use_module(knowledge_base).
:- use_module(engine).
:- use_module(examples).
:- use_module(library(readutil)).
:- dynamic current_observations/1.
:- initialization(main, main).

main :-
    current_prolog_flag(argv, Args),
    (Args = ['--demo'] -> demo
    ; Args = [] -> interactive
    ; writeln('Usage: swipl -q -s src/main.pl [-- --demo]'), halt(2)).

interactive :-
    set_prolog_flag(verbose, silent),
    retractall(current_observations(_)), assertz(current_observations([])),
    nl, writeln('PRINTER EXPERT - Windows 11 troubleshooting'),
    writeln('P. K. V. J. Senarathna | 224177B'),
    writeln('Advice only. No printer settings or files are changed.'),
    writeln('Use unknown when you have not checked something.'), menu.

menu :-
    nl, writeln('1. New consultation'), writeln('2. Load demonstration case'),
    writeln('3. Forward chaining: recommendations and rule trace'),
    writeln('4. Backward chaining: check a recommendation'),
    writeln('5. View current observations'), writeln('6. View sources'),
    writeln('7. Reset consultation'), writeln('0. Exit'),
    read_choice('Choice', Choice),
    (memberchk(Choice, ['0',end_of_file]) -> writeln('Goodbye.')
    ; catch(handle(Choice), E, handle_error(E)), menu).

handle_error(cancelled_selection) :- !, writeln('Selection cancelled.').
handle_error(E) :- print_message(error,E).

handle('1') :- !, consultation(Observations), save_case(Observations).
handle('2') :- !,
    findall(Id, example(Id,_,_), Ids),
    forall(nth1(N,Ids,Id), (example(Id,Title,_),format('~d. ~w~n',[N,Title]))),
    choose_number(Ids, Id), example(Id,_,Observations), save_case(Observations).
handle('3') :- !, current_observations(O), show_results(O).
handle('4') :- !,
    findall(A, action(A,_), Actions),
    forall(nth1(N,Actions,A),format('~d. ~w~n',[N,A])),
    choose_number(Actions, Action), current_observations(O),
    (once(backward(O,recommend(Action),Proof)) ->
        format('SUPPORTED: ~w~n',[Action]), show_proof(Proof,0)
    ; format('NOT SUPPORTED by the current observations: ~w~n',[Action]),
      unmet(O,Action,Reasons), maplist(show_reason,Reasons)).
handle('5') :- !, current_observations(O), show_observations(O).
handle('6') :- !, forall(source(Id,Title,URL),format('[~w] ~w~n  ~w~n',[Id,Title,URL])).
handle('7') :- !, save_case([]).
handle(_) :- writeln('Enter a menu number from 0 to 7.').

save_case(O) :- validate_observations(O),
    retractall(current_observations(_)), assertz(current_observations(O)),
    writeln('Consultation saved. Choose 3 for results or 4 to test a goal.').

consultation(Observations) :-
    ask(symptom,S), ask(connection,C), ask(printer_on,P),
    Initial=[obs(symptom,S),obs(connection,C),obs(printer_on,P)],
    relevant_fields(S,C,Keys), ask_fields(Keys,Answers),
    append(Initial,Answers,Observations).

% Ask only fields used by a potentially applicable rule. This selects questions,
% not conclusions; the two inference procedures make all domain decisions.
relevant_fields(S,C,Keys) :-
    findall(K,
      (rule(_,Conditions,finding(_),_),
       compatible(symptom,S,Conditions), compatible(connection,C,Conditions),
       member(obs(K,_),Conditions), \+ memberchk(K,[symptom,connection,printer_on])),
      Raw), list_to_set(Raw,Keys).
compatible(K,V,Conditions) :-
    (memberchk(obs(K,Required),Conditions) -> (V==Required ; V==unknown) ; true).

ask_fields([],[]).
ask_fields([K|Ks],[obs(K,V)|Rest]) :- ask(K,V), ask_fields(Ks,Rest).
ask(K,V) :- field(K,Values,Prompt),
    format('~n~w~nAllowed: ~w~n',[Prompt,Values]),
    read_choice('Answer (Enter = unknown)',A),
    (memberchk(A,['',end_of_file]) -> V=unknown
    ; memberchk(A,Values) -> V=A
    ; writeln('Please use one of the listed answers.'), ask(K,V)).

read_choice(Prompt,Atom) :-
    format('~w: ',[Prompt]), flush_output,
    read_line_to_string(user_input,Line),
    (Line==end_of_file -> Atom=end_of_file
    ; normalize_space(string(Trimmed),Line), string_lower(Trimmed,Lower), atom_string(Atom,Lower)).

choose_number(Items,Item) :-
    read_choice('Number (0 = back)',A),
    (memberchk(A,['0',end_of_file]) -> throw(cancelled_selection)
    ; catch(atom_number(A,N),_,fail), integer(N), nth1(N,Items,Item) -> true
    ; writeln('Choose a listed number.'), choose_number(Items,Item)).

show_observations([]) :- writeln('No observations entered.').
show_observations([O|Os]) :- format('  ~w~n',[O]), show_observation_tail(Os).
show_observation_tail([]).
show_observation_tail([O|Os]) :- format('  ~w~n',[O]), show_observation_tail(Os).

show_results(O) :-
    forward(O,Memory,Steps), recommendations(Memory,Actions),
    nl, writeln('RECOMMENDATIONS (alphabetical, not a probability ranking)'),
    (Actions=[] -> writeln('No supported recommendation. More observations are needed, or the case is outside the stored rules.')
    ; forall(member(A,Actions),
        (action(A,Text),format('~n~w~n  ~w~n',[A,Text]),
         memberchk(node(recommend(A),Proof),Memory), show_proof(Proof,2),
         kb_fact(_,remedy(_,A),Source,_), source(Source,_,URL),
         format('  Source: ~w~n',[URL])))),
    nl, writeln('FORWARD RULE TRACE'),
    forall(nth1(N,Steps,step(Id,H,C)),format('~d. ~w: ~w -> ~w~n',[N,Id,C,H])),
    length(Steps,Count),format('~d rule applications. No further conclusions can be added.~n',[Count]).

show_proof(input(F),Indent) :- tab(Indent),format('Observed: ~w~n',[F]).
show_proof(known(Id,S,F),Indent) :- tab(Indent),format('Fact ~w [~w]: ~w~n',[Id,S,F]).
show_proof(because(Id,S,H,Children),Indent) :-
    tab(Indent),format('Rule ~w [~w] establishes ~w~n',[Id,S,H]),
    Next is Indent+2, forall(member(Child,Children),show_proof(Child,Next)).

show_reason(missing(Id,K,V)) :- format('  ~w needs ~w=~w; this has not been established.~n',[Id,K,V]).
show_reason(different(Id,K,E,A)) :- format('  ~w needs ~w=~w; your answer is ~w.~n',[Id,K,E,A]).

show_case(Id) :- example(Id,Title,O),format('~nCASE: ~w~n',[Title]),
    show_observations(O),show_results(O).
demo :- forall(example(Id,_,_),show_case(Id)).
