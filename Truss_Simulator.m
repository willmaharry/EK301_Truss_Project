
%Preliminary Design Review Code:
clc;clear;
load("Truss01.mat");

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
%We can do this using linearity -- The ratios between the internal forces
%in each member will stay the same as the load increases. Thus, we can find
%the load at which each member will fail, and then check if that member is
%the only one to fail under that load.

%First we need the max loads each member is capable of supporting
memberMaxLoads = memberMaxLoadFinder(C, X, Y);
members = width(C);
%We can ignore the support forces
memberForces = T(1:members,:)';
%The multiplier vector contains a multiplier for exactly how much each
%element must be multiplied for it to reach buckling strength
multipliers = memberMaxLoads./ memberForces;
for i = 1:members
    %We can ignore members under tension
    if memberForces(i) > 0
        differences = memberForces*multipliers(i)-memberMaxLoads;
        %If the differences vector is all negatives, then whichever the ith
        %member will fail first
        if all(differences <= 0)
            Tmax = memberForces.* multipliers(i);
            jointLoad = sum(L)*multipliers(i);
            failingMemberIndex = i;
        end
    end
end
    
%Calculate the max load/cost ratio
maxLoadToCostRatio = abs(jointLoad)/cost;

% Now print out the results: 
disp("The Max Load at joint " + string(loadJoint) + " : " + string(jointLoad) + "oz.");
disp("TheoRHETTical max load/cost ratio in oz/$: " + maxLoadToCostRatio)

%What member will fail first?
disp("Member " + string(failingMemberIndex) + " will buckle first.")
disp("Buckling Strength of member " + string(failingMemberIndex) + ": " + string(round((Tmax(failingMemberIndex)),3)) + " oz.")

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
