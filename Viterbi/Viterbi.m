function [viterbiPath, probability ] = Viterbi( transStates, transDist,  obsStates,obsDist,initialDist,obs  )
%VITERBI Calculates most likely path through HMM
%   Inputs: 
%   transDist - state transition matrix
%   transStates - vector (row) of the system's states
%   obsStates - vector (row) of the categories that observations fall into.
%   obsDist - matrix of probability distributions for the observations.
%           Dimensions are: states x obsStates
%   initialDist - row vector of probabilties for outbound edges from the
%       Start node to the states
%   obs - a row vector of observations

%Begin by filling in the first column of the table based on the start
%transition probabilities x the first observation's probability of arising
%in each state:
c = find(strcmp(obsStates, obs(1))); %find current observation in observation tables
for s=1:numel(transStates)
    table(s,1) = initialDist(s) * obsDist(s,c);
end
%Determine the max probability of the first column, to be used in the next
%column:
[currentState,col] =find(table==max(table(:,1)));
%Keep track of the 'previous probability' (used in next timestep):
prevP = table(currentState,1);

%Add max probability and corresponding state to output array
viterbiPath = transStates(currentState); 
probability = prevP;

%Continue through the rest of the observations:
for i=2:length(obs)
    c = find(strcmp(obsStates, obs{i})); %find the current observation in the observation tables
    p = prevP;
        for s=1:length(transStates) %for every state,
            prevP = p * (transDist(currentState,s) *  obsDist(s,c));
            table(s,i) = prevP;
        end
        %determine which state has max likelihood in this timestep i
    [currentState,col] =find(table==max(table(:,i))); 
    %update output vectors
   viterbiPath = [viterbiPath; transStates(currentState)];
   probability = [probability; prevP];
end

end

