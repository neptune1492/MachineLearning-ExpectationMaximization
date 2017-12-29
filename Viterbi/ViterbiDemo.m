%Elizabeth Brennan
%Machine Learning, Fall 2015
%Final (Individual) Project
%Expectation Maximization:  Viterbi

%DEPENDENCIES!!!
%Viterbi.m

%The scenario described below is that of the ice cream cone problem
%discussed in class. Based on a month's-worth of daily diary entries on how
%many ice cream cones were consumed per day, a Hidden Markov model is
%constructed to estimate the hidden states of Hot and Cold Weather.

%Initialize the names of the hidden states in 'transStates':
transStates = {'C', 'H'};

%We're starting with a known distribution, with transition matrix headers 
%arranged as:
%       State1  State2 ...
%State1  (#)    (#)
%State2  (#)    (#)
%...

transDist = [.8 .2;
            .4 .6;
             ];

%Introduce the observation states (must be strings. Future enhancements 
%will allow numbers):
obsStates = {'one', 'two', 'three'};

%The observation probabilities for each state. Transition matrix in the form of:
%       Observation1  Observation2   Observation3  ...
%State1
%State2
%...

obsDist = [
    0.7	0.2, 0.1; 
    0.1 0.2 0.7;
    ];


%initialDist - The probability that one state will be the starting state vs
%another. In the format [State1 State2 ...]. 
initialDist = [.3, .7];

%obs - the observations in chronological sequence from t to T:
obs = {'three', 'two', 'three', 'two', 'three', 'one', 'one'};

%Pass parameters into Viterbi to get the most likely progression through
%the states, and the probabilities at each timestep.
[viterbiPath, probability ] = Viterbi( transStates, transDist,  obsStates,obsDist,initialDist,obs  );

%Print results
disp('Viterbi Path, from t=1 to T:')
disp(transpose(viterbiPath))
disp('Probabilities, from t=1 to T:')
disp(transpose(probability))