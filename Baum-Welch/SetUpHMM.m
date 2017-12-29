function [transStates, obsStates, transDist, obsDist, initialDist, endDist] = SetUpHMM(allFields)
%SetUpHMM Returns parameters for a Hiddem Markov Model used in demos

%Input 'allFields' as True or False to determine whether the function
%returns only the state/observation definitions, or if it returns the state
%transition matrix and observation probability table.  This option is useful for the
%different demos.


%The scenario described below is that of the ice cream cone problem
%discussed in class. Based on a month's-worth of daily diary entries on how
%many ice cream cones were consumed per day, a Hidden Markov model is
%constructed to estimate the hidden states of Hot and Cold Weather.

%Initialize the names of the hidden states in 'transStates':
transStates = {'C', 'H'};

%Introduce the observation states (must be strings. Future enhancements 
%will allow numbers):
obsStates = {'one', 'two', 'three'};

%If allFields is True, return all the parameters:
if (allFields)
%We're starting with a known distribution, with transition matrix headers 
%arranged as:
%       State1  State2 ...
%State1  (#)    (#)
%State2  (#)    (#)
%...

%Note: If the distribution is unknown,
%leave transDist blank ([]), and the ForwardBackward function will put in
%random starting values.
transDist = [.8 .2;
            .2 .8;
             ];

%The observation probabilities for each state. Transition matrix in the form of:
%       Observation1  Observation2   Observation3  ...
%State1
%State2
%...
%Again, if observation probabilities are unknown, simply pass in an empty
%obsDist ([]).
obsDist = [
    0.7	0.2, 0.1; 
    0.1 0.2 0.7;  
     
];

%initialDist - The probability that one state will be the starting state vs
%another. In the format [State1 State2 ...]. If this is blank, an equal
%distribution will be applied to the starting states.
initialDist = [.5, .5];

%endDist - The probability that one state will be the ending state vs
%another. In the format [State1 State2 ...]. If this is blank, an equal
%distribution will be applied to the starting states.
endDist = [1 1];

end
end

