:- module(engine, [validate_observations/1, forward/3, backward/3,
                   recommendations/2, unmet/3, proof_rules/2]).
:- use_module(knowledge_base).
:- use_module(library(error)).
:- use_module(library(lists)).

% Values are explicit. Unknown is never treated as no.
validate_observations(Observations) :-
    must_be(list, Observations),
    maplist(valid_observation, Observations),
    findall(Key, member(obs(Key, _), Observations), Keys),
    sort(Keys, Unique),
    (same_length(Keys, Unique) -> true
    ; throw(error(domain_error(unique_observation_keys, Keys), _))).

valid_observation(Observation) :-
    must_be(ground, Observation),
    (Observation = obs(Key, Value), field(Key, Values, _),
     memberchk(Value, Values) -> true
    ; throw(error(domain_error(observation, Observation), _))).

initial_memory(Observations, Memory) :-
    validate_observations(Observations),
    findall(node(Term, known(Id, Source, Term)),
            kb_fact(Id, Term, Source, _), Knowledge),
    findall(node(obs(K,V), input(obs(K,V))),
            (member(obs(K,V), Observations), V \== unknown), Inputs),
    append(Knowledge, Inputs, Memory).

% Forward chaining: fire the first rule instance adding a new conclusion.
% Repeat until no new term can be added (the fixed point).
forward(Observations, Memory, Steps) :-
    initial_memory(Observations, Initial),
    saturate(Initial, Memory, Steps).

saturate(Memory0, Memory, Steps) :-
    (next_step(Memory0, Node, Step) ->
        append(Memory0, [Node], Memory1),
        Steps = [Step|Rest], saturate(Memory1, Memory, Rest)
    ; Memory = Memory0, Steps = []).

next_step(Memory, node(Head, because(Id, Source, Head, Proofs)),
          step(Id, Head, Conditions)) :-
    rule(Id, Conditions, Head, Source),
    match_all(Conditions, Memory, Proofs),
    ground(Head),
    \+ memberchk(node(Head, _), Memory), !.

match_all([], _, []).
match_all([Condition|Rest], Memory, [Proof|Proofs]) :-
    member(node(Condition, Proof), Memory),
    match_all(Rest, Memory, Proofs).

recommendations(Memory, Actions) :-
    findall(Action, member(node(recommend(Action), _), Memory), Raw),
    sort(Raw, Actions).

% Backward chaining starts from the requested goal and the original inputs.
% It does not call forward/3 or use forward-derived memory.
backward(Observations, Goal, Proof) :-
    must_be(ground, Goal),
    initial_memory(Observations, Initial),
    prove(Goal, Initial, [], Proof).

prove(Goal, Initial, _, Proof) :- member(node(Goal, Proof), Initial).
prove(Goal, Initial, Trail, because(Id, Source, Goal, Proofs)) :-
    \+ variant_member(Goal, Trail),
    rule(Id, Conditions, Goal, Source),
    prove_all(Conditions, Initial, [Goal|Trail], Proofs).

variant_member(Term, [Head|_]) :- Term =@= Head, !.
variant_member(Term, [_|Rest]) :- variant_member(Term, Rest).

prove_all([], _, _, []).
prove_all([Goal|Rest], Initial, Trail, [Proof|Proofs]) :-
    prove(Goal, Initial, Trail, Proof),
    prove_all(Rest, Initial, Trail, Proofs).

% Why-not support for the finding -> remedy structure of this knowledge base.
% Missing evidence and an explicit different answer are reported separately.
unmet(Observations, Action, Reasons) :-
    validate_observations(Observations),
    kb_fact(_, remedy(Issue, Action), _, _),
    rule(Id, Conditions, finding(Issue), _),
    findall(Reason,
       (member(obs(K,Expected), Conditions),
        (memberchk(obs(K,Actual), Observations), Actual \== unknown ->
            Actual \== Expected,
            Reason = different(Id, K, Expected, Actual)
        ; Reason = missing(Id, K, Expected))), Reasons).

proof_rules(input(_), []).
proof_rules(known(_,_,_), []).
proof_rules(because(Id,_,_,Children), Ids) :-
    maplist(proof_rules, Children, Nested),
    append(Nested, Flat), sort([Id|Flat], Ids).
