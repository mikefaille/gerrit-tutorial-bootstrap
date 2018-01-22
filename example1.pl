:- package gerrit.

submit_rule(submit(W)) :-
    W = label('Any-Label-Name', ok(user(1000009))).


%% submit_rule(submit(Fix)) :-
%%     gerrit:commit_message_matches('^Fix '),
%%     gerrit:commit_author(A),
%%     Fix = label('Commit-Message-starts-with-Fix', ok(A)),
%%     !.

%% % Message does not start with 'Fix ' so Fix is needed to submit
%% submit_rule(submit(Fix)) :-
%%     Fix = label('Commit-Message-starts-with-Fix', need(_)).
