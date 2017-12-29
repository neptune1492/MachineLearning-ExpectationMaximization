function [ forward, backward, PO, uniformTransDist, uniformObsDist, uniformInitialDist, uniformEndDist ] = ForwardBackward(transStates, transDist, obsStates, obsDist,initialDist, endDist, obs )
%ForwardBackward Computes forward and backward probability tables for HMM

%Inputs
%   transStates - the hidden states of the HMM
%   transDist - transition distribution among states
%   obsStates - the observation categories/states used in the HMM
%   obsDist - distribution of the observations in the hidden states
%   initialDist - distribution probabilities for state 1
%   endDist - distribution probabilities for ending in each state at t=T
%   obs - vector of observation sequence

%Outputs:
%Every time:
%   forward - Matrix of forward probabilities
%   backward = Matrix of backward probabilities
%   PO - Probability of the Observations
%If input as empty matrix: uniformTransDist, uniformObsDist, uniformInitialDist,
%uniformEndDist

%When an empty transDist, obsDist, initialDist, or endDist is passed into
%the function, a matrix populated with the appropriate uniform probability 
%distribution will be returned:
%
%P(O) = Sigma(A[s,T] * asf) where T is the final timestep and asf is the probability that a state is
%the end state at t=T.


%Preprocessing - check if all arguments exist.
if (nargin ~= 7)
    disp('Not enough arguments')
    return
elseif (isempty(transStates) || isempty(obsStates))
    disp('Check hidden and observation state definitions (trans or obsStates)- empty matrix')
    return
elseif (isempty(obs))
    disp('Error: Observation vector is empty')
    return
end
%if no transition matrix specified, generate a uniform one
if (isempty(transDist))
    for m=1:numel(transStates)
        for n=1:numel(transStates)
            transDist(m,n) = (1/(numel(transStates)));
        end
    end
    uniformTransDist = transDist;
else uniformTransDist = transDist;
end

%if no observation probabilities specified, generate uniform
if (isempty(obsDist))
    for m=1:numel(transStates)
        for n=1:numel(obsStates)
            obsDist(m,n) = (1/numel(obsStates));
        end
    end
    uniformObsDist = obsDist;
    
end

if(isempty(initialDist))
    %assign equal probability to the states
    for d=1:numel(transStates)
         initialDist = [initialDist (1/numel(transStates))];
    end
    uniformInitialDist=initialDist;
end

if(isempty(endDist))
    %assign equal probability to the states
    for d=1:numel(transStates)
        endDist = [endDist (1/numel(transStates))];
    end
    uniformEndDist = endDist;
end

%ForwardBackward Setup:
forward = zeros(numel(transStates), numel(obs));
backward = zeros(numel(transStates), numel(obs));

%Create Forward probability table:
%Work Left to Right,filling the table

%Find index of current observation in observation tables
c = find(strcmp(obsStates, obs{1}));

%For each state, assign column 1 as the initial distribution x the
%likelihood of seeing observation 1 in that state:
for s=1:numel(transStates)
    forward(s,1) = initialDist(s)* obsDist(s,c);
end
%For every subsequent timestep:
%   For every state, sum up the probabilities obtained by:
            %multiplying the previous probability by
            %the likelihood of transitioning to the state from the other states, by 
            %the likelihood of seeing the current observation in the current state.
for o=2:numel(obs)
    c = find(strcmp(obsStates, obs{o}));
    for s=1:numel(transStates)
        sumF=0;
        for w=1:numel(transStates)
            sumF = sumF + (forward(w,o-1) * transDist(w,s) * obsDist(s,c));
        end
        forward(s,o) = sumF;
    end
end

%Backward - Work Right to Left
c = find(strcmp(obsStates, obs{1})); %Find the index of the current observation in the observation table-s

%Assign the likelihood that a state will be the Final State (at t=T) to 
%the right-most column of the table:
for s=1:numel(transStates)
    backward(s,numel(obs)) = endDist(s); 
end

%For each observation, starting with the observation at t=T-1 and working
%back:
    %   For every state, sum up the probabilities obtained by:
        %multiplying the t+1 probability of the current state by
        %the likelihood of transitioning from the state to the other states, by 
        %the likelihood of seeing the observation t+1 in the current state.
for o=(numel(obs)-1):-1:1
    c = find(strcmp(obsStates, obs{o+1}));
    for s=1:numel(transStates)
        sumB=0;
        for w=1:numel(transStates)
            sumB = sumB + (backward(w,o+1) * transDist(s,w) * obsDist(w,c));
        end
        backward(s,o) = sumB;
    end
end

%****Done!******

%But, for convenience, also calculate the total probability of the
%observation sequence...

%Get the probability of the observation sequence:
%P(O) = Sigma(A[s,T] * asf) where T is the final timestep and asf is the probability that a state is
%the end state at t=T.
sumPO = 0;
for p= 1:numel(transStates)
    sumPO = sumPO + (forward(p, numel(obs)) * endDist(p));
end
PO = sumPO; 



end

