%clc;clear;
%Preliminary Design Review Code:

%Definition of truss parameters

joints = 8;  %Number of rows of C
members = 13;  %Number of columns of C

%Connection matrix, members are the columns and joints are the rows (M<J)

C = [
     1 1 0 0 0 0 0 0 0 0 0 0 0;
     1 0 1 1 0 0 0 0 0 0 0 0 0;
     0 0 0 1 1 0 0 1 0 0 0 0 0;
     0 1 1 0 1 1 1 0 0 0 0 0 0;
     0 0 0 0 0 0 1 1 1 0 0 1 0;
     0 0 0 0 0 1 0 0 1 1 1 0 0;
     0 0 0 0 0 0 0 0 0 0 1 1 1;
     0 0 0 0 0 0 0 0 0 1 0 0 1;
    ];

%Check the connection matrix is properly defined (M = 2J-3)
if width(C) ~= 2*height(C) - 3
    fprintf("Incorrect dimensions\n")
end
if ~all(sum(C) == 2)
    fprintf("Not all columns add to 2\n")
end

%Support force matrices, each should have J rows and 3 columns
%Which joint has the x reaction force?
sx =   [
        1 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        ];

if height(sx) ~= height(C)
    fprintf("sx has incorrect dimensions\n")
end
if ~isequal(sum(sx),[1,0,0])
    fprintf("Invalid inputs for sx\n")
end

%Which joints have the y reaction forces?
sy =   [
        0 1 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 1;
        ];

if height(sy) ~= height(C)
    fprintf("sy has incorrect dimensions\n")
end
if ~isequal(sum(sy),[0,1,1])
    fprintf("Invalid inputs for sy\n")
end

%Location vectors X and Y. (0,0) is defined as the joint where both X and Y
%reaction forces act
%x and y are measured in inches
x = [0 0 4 4 8 8 12 12];
if width(x) ~= height(C)
   fprintf("x has incorrect dimensions\n")
end

y = [0 4 8 4 8 4 4 0];
if width(y) ~= height(C)
   fprintf("y has incorrect dimensions\n")
end

%Load vector L, measured in Oz.

L = [   %X external loads  (signs should be positive?)
        0;   
        0;  
        0;   
        0;   
        0;
        0;
        0;
        0;
        % Y external loads (signs should be positive?)
        0;   
        0; % set any value you want to test the max of to 1 (only 1 at a time)   
        0;   
        1; % y down of 1 unit
        0;
        0;
        0;
        0;
        ];

if height(L) ~= 2*height(C)
    fprintf("L has incorrect dimensions\n")
end
if ~any(L)
    fprintf("Invalid inputs for L\n")
end


% Now lets iterate through and find max load
maxLoad = 100; % This signifies "units" in compresssion, we ignore tension
% This maxTests is basically a recursive test suite. So The following code
% will:
%  - continutally multiply by 2 until it is too large, then it will set
%   the first digit to 1. 
%  - It will then increase by 10% until it reaches the crit. It will set
%    the second digit to 1. 
%  - It will then increase by 1% until it reaches the crit. It will then
%    set the 3rd digit to 1 and be done.
maxTests = [0, 0, 0];
maxReached = 0;
jointLoad = 1;
newJointLoad = 1;
prevT = [];
while ~maxReached
    if maxTests(1) == 0
        newJointLoad = jointLoad * 2;
    elseif maxTests(2) == 0
        newJointLoad = jointLoad * 1.1;
    elseif maxTests(3) == 0
        newJointLoad = jointLoad * 1.01;
    end
    T = trussCalculator(C, sx, sy, x, y, loadModifier(L, newJointLoad));
    if surpassedMaxLoad(T, maxLoad)
        if maxTests(1) == 0
            maxTests(1) = 1;
        elseif maxTests(2) == 0
            maxTests(2) = 1;
        elseif maxTests(3) == 0
            maxTests(3) = 1;
            maxReached = 1;
            T = prevT;
        end
    else
        jointLoad = newJointLoad;
        prevT = T;
    end
end

% find what joint the load is on
loadJoint = 0;
for i = 1:height(L)
    if L(i) == 1
        if i <= height(C)
            loadJoint = i;
        else
            loadJoint = i - height(C);
        end
    end
end

% Now print out the results: 
disp("EK301, Section A6, Group Swashbucklers: Will M., Jake V., Luke M., 11/11/2023")
disp("The Max Load at joint " + string(loadJoint) + " : " + string(jointLoad));
for i = 1:height(T)
    if i < height(T)-2
        % I flipped tension and compresssion but it's fine cuz I can just
        % rewrite it here
        if T(i) < 0
            disp("Member " + string(i) + ": " + string(-1*T(i)) + " (T)")
        else
            disp("Member " + string(i) + ": " + string(T(i)) + " (C)")
        end
    else 
        if i == height(T)-2
            disp("Sx1: " + string(T(i)))
        elseif i == height(T)-1
            disp("Sy1: " + string(T(i)))
        elseif i == height(T)
            disp("Sy2: " + string(T(i)))
        end
    end
end


