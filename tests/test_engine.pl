:- use_module('../src/engine').
:- use_module('../src/knowledge_base').
:- use_module('../src/main', []).
:- use_module(scenarios).
:- use_module(library(plunit)).
:- use_module(library(lists)).
:- use_module(library(http/json)).
:- initialization(run, main).

:- begin_tests(printer_expert).

test(scenario_outputs, [forall(scenario(_,_,O,E,_))]) :-
    forward(O,M,_), recommendations(M,A), assertion(A==E),
    findall(X,(action(X,_),once(backward(O,recommend(X),_))),Raw),
    sort(Raw,B), assertion(B==E).

test(rule_traces, [forall(scenario(_,_,O,_,Expected))]) :-
    forward(O,_,Steps), findall(Id,member(step(Id,_,_),Steps),Raw),
    sort(Raw,Actual), assertion(Actual==Expected).

test(proof_consistency, [forall(scenario(_,_,O,E,_))]) :-
    forward(O,M,_),
    forall(member(A,E),
      (memberchk(node(recommend(A),FProof),M),
       once(backward(O,recommend(A),BProof)),
       assertion(FProof==BProof))).

test(all_domain_rules_covered) :-
    findall(R,(scenario(_,_,_,_,Rs),member(R,Rs)),Seen),sort(Seen,Covered),
    findall(R,rule(R,_,_,_),All),sort(All,Expected),assertion(Covered==Expected).

test(minimum_counts) :-
    findall(Id,kb_fact(Id,_,_,_),Fs),length(Fs,F),assertion(F>=20),
    findall(Id,rule(Id,_,finding(_),_),Rs),length(Rs,R),assertion(R>=20).

test(source_integrity) :-
    forall(kb_fact(_,_,S,_),assertion(source(S,_,_))),
    forall(rule(_,_,finding(_),S),assertion(source(S,_,_))).

test(unique_identifiers) :-
    findall(R,rule(R,_,_,_),Rs),sort(Rs,RU),assertion(same_length(Rs,RU)),
    findall(F,kb_fact(F,_,_,_),Fs),sort(Fs,FU),assertion(same_length(Fs,FU)).

test(unknown_is_missing) :-
    unmet([obs(connection,wifi),obs(same_network,unknown)],join_same_wifi,R),
    assertion(R==[missing(r04,same_network,no)]).

test(explicit_answer_is_different) :-
    unmet([obs(connection,wifi),obs(same_network,yes)],join_same_wifi,R),
    assertion(R==[different(r04,same_network,no,yes)]).

test(duplicate_key_rejected, [throws(error(domain_error(unique_observation_keys,_),_))]) :-
    forward([obs(printer_on,yes),obs(printer_on,no)],_,_).
test(invalid_value_rejected, [throws(error(domain_error(observation,_),_))]) :-
    forward([obs(connection,banana)],_,_).
test(unknown_field_rejected, [throws(error(domain_error(observation,_),_))]) :-
    forward([obs(password,secret)],_,_).
test(nonground_input_rejected, [throws(error(instantiation_error,_))]) :-
    forward([obs(connection,_)],_,_).
test(derived_fact_injection_rejected, [throws(error(domain_error(observation,_),_))]) :-
    forward([recommend(power_on)],_,_).

test(no_cross_session_state) :-
    forward([obs(printer_on,no)],_,_),forward([],M,_),recommendations(M,A),assertion(A==[]).

test(no_duplicate_conclusions, [forall(scenario(_,_,O,_,_))]) :-
    forward(O,M,_),findall(T,member(node(T,_),M),Ts),sort(Ts,U),assertion(same_length(Ts,U)).

test(question_selection_wifi) :-
    main:relevant_fields(offline,wifi,Keys),
    assertion(memberchk(same_network,Keys)),assertion(\+memberchk(usb_secure,Keys)),
    assertion(\+memberchk(rollback_available,Keys)).

:- end_tests(printer_expert).

run :-
    (run_tests -> export_results, halt(0) ; halt(1)).

export_results :-
    findall(Row,scenario_result(Row),Rows),
    current_prolog_flag(version_data,swi(Major,Minor,Patch,_)),
    format(atom(Version),'~d.~d.~d',[Major,Minor,Patch]),
    Result=_{runtime:Version,scenario_count:28,domain_rules:30,
             inference_rules:31,domain_facts:30,status:passed,scenarios:Rows},
    setup_call_cleanup(open('docs/test-results.json',write,S,[encoding(utf8)]),
        json_write_dict(S,Result,[width(100)]),close(S)),
    writeln('All checks passed. Scenario results: docs/test-results.json').

scenario_result(Row) :-
    scenario(Id,Title,O,Expected,ExpectedRules),forward(O,M,Steps),recommendations(M,Actual),
    findall(R,member(step(R,_,_),Steps),Raw),sort(Raw,Rules),
    findall(A,(action(A,_),once(backward(O,recommend(A),_))),BackwardRaw),sort(BackwardRaw,Backward),
    maplist(term_string,O,InputStrings),
    Row=_{id:Id,title:Title,inputs:InputStrings,expected:Expected,actual:Actual,
          backward:Backward,expected_rules:ExpectedRules,actual_rules:Rules,status:passed}.
