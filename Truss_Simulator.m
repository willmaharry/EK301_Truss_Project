
%Preliminary Design Review Code:
clc;clear;
load("Truss04.mat");

%First, lets just analyze the truss and display the results
T = trussCalculator(C, Sx, Sy, X, Y, L);
T = round(T,3);

%Calculate the cost of the truss: I'll just make another function
cost = calculateCost(C,X,Y);

% find what joint the load is on
loadJoint = 0;
for i = 1:height(L)
    if L(i) ~= 0
        if i <= height(C)
            loadJoint = i;
        else
            loadJoint = i - height(C);
        end
    end
end

% Now print out the results: 
disp("EK301, Section A6, Group Swashbucklers: Will M., Jake V., Luke M., 11/11/2023")
disp("--- Normal Simulating Section ---")
disp(string(sum(L)) + " oz. load applied at joint " + string(loadJoint));
for i = 1:height(T)
    if i < height(T)-2
        % I flipped tension and compresssion but it's fine cuz I can just
        % rewrite it here
        if T(i) > 0
            disp("Member " + string(i) + ": " + string(T(i)) + " oz. (C)")
        else
            disp("Member " + string(i) + ": " + string(-1*T(i)) + " oz. (T)")
        end
    else 
        if i == height(T)-2
            disp("Sx1: " + string(T(i)) + " oz.")
        elseif i == height(T)-1
            disp("Sy1: " + string(T(i)) + " oz.")
        elseif i == height(T)
            disp("Sy2: " + string(T(i)) + " oz.")
        end
    end
end
disp("Cost of truss: $" + string(round(cost,2)))

disp("--- Maximizing Section ---");
%Now we need to figure out what the maximum load is.
%Assume that there's only ever one force acting on the truss

% Now lets iterate through and find max load
% This maxTests is basically a recursive test suite. So The following code
% will:
%  - continutally multiply by 2 until it is too large, then it will set
%   the first digit to 1. 
%  - It will then increase by 10% until it reaches the crit. It will set
%    the second digit to 1. 
%  - It will then increase by 1% until it reaches the crit. It will then
%    set the 3rd digit to 1 and be done.
memberMaxLoads = memberMaxLoadFinder(C, X, Y);
maxTests = [0, 0, 0];
maxReached = 0;
jointLoad = 1;
newJointLoad = 1;
prevTmax = [];
while ~maxReached
    if maxTests(1) == 0
        newJointLoad = jointLoad * 2;
    elseif maxTests(2) == 0
        newJointLoad = jointLoad * 1.1;
    elseif maxTests(3) == 0
        newJointLoad = jointLoad * 1.01;
    end
    Tmax = trussCalculator(C, Sx, Sy, X, Y, loadModifier(L, newJointLoad));
    if surpassedMaxLoad(Tmax, memberMaxLoads)
        if maxTests(1) == 0
            maxTests(1) = 1;
        elseif maxTests(2) == 0
            maxTests(2) = 1;
        elseif maxTests(3) == 0
            maxTests(3) = 1;
            maxReached = 1;
            Tmax = prevTmax;
        end
    else
        jointLoad = newJointLoad;
        prevTmax = Tmax;
    end
end

%Calculate the max load/cost ratio
maxLoadToCostRatio = abs(jointLoad)/cost;

% Now print out the results: 
disp("The Max Load at joint " + string(loadJoint) + " : " + string(jointLoad) + "oz.");
disp("TheoRHETTical max load/cost ratio in oz/$: " + maxLoadToCostRatio)

%What member will fail first?
disp("Member " + string(find(Tmax==max(Tmax))) + " will buckle first.")
disp("Buckling Strength of member " + string(find(Tmax==max(Tmax))) + ": " + string(round(max(Tmax),3)) + " oz.")

%Duddde what if we could plot the truss?! We need an adjacency matrix
XYCoords = [X;Y]';
A = zeros(height(C));
for i = 1:width(C)
    indices = find(C(:,i))';
    A(indices(1),indices(2)) = 1;
end
gplot(A,XYCoords)
title("Da Truss")
xlim([-2,35])
ylim([-9,28])
