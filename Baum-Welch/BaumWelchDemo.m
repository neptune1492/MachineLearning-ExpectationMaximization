%Elizabeth Brennan
%Machine Learning, Fall 2015
%Final (Individual) Project
%Expectation Maximization:  Baum-Welch/Forward-Backward

%DEPENDENCIES!!!
%This script requires the following dependencies in the Matlab folder/Path:
%SetUpHMM.m
%GetFBParameters.m
%ForwardBackward.m

%-----------------------------------------------------------

clc; clear;
%Initialize variables:
FBIteration = 1; %counter to see how long it took to converge
POHolder = []; 
oldPO = 0;

%Begin by setting up the HMM for the ice cream problem.
%Variables:
    %transStates = list of the model's hidden states
    %obsStates = list of the model's observation states
    %transDist = transition matrix for hidden states
    %obsDist = probability distribution for the observations in each state
    %initialDist = initial probabilities of starting in the states
    %endDist = probabilities of finishing in the states

%The program is designed generically to work with any number of hidden
%states, and any number of observation classes.  The 'SetUpHmm' function
%is in its own function to keep things clean.
[transStates, obsStates, transDist, obsDist, initialDist, endDist] = SetUpHMM(true);

%obs - the observations in chronological sequence from t=1 to T:
obs = {'three', 'two', 'three', 'two', 'three', 'one', 'one'};
        
disp('***Beginning iterations of Baum-Welch algorithm. Please wait.***')
%Call ForwardBackward:
[ forward, backward, PO ] = ForwardBackward(transStates, transDist, obsStates, obsDist,initialDist, endDist, obs );

while ((oldPO - PO) ~= 0)
 oldPO = PO;
 %Get new estimates for the parameters
[ newTransDist, newObsDist ] = GetFBParameters( forward, backward, PO, transStates, transDist, obs, obsStates, obsDist );
%Use the new estimates to generate Forward/backward tables
[ forward, backward, PO ] = ForwardBackward(transStates, newTransDist, obsStates, newObsDist,initialDist, endDist, obs );
transDist = newTransDist
obsDist = newObsDist
FBIteration = FBIteration+1;
disp('Processing...Iteration')
disp(FBIteration)
%Keep track of PO values to help with convergence check
POHolder = [POHolder PO]; 

%To prevent bouncing back and forth between a few numbers:
if (find(POHolder == PO))
    break;
end
end

disp('***Convergence!***')
disp('Iterations to Convergence: ')
disp(FBIteration)
disp('Transition Matrix for Hidden States')
disp(newTransDist)
disp('Transition Matrix for Observations/States')
disp(newObsDist)
disp('**Note: The Baum-Welch algorithm does NOT produce a global maximum.**')



