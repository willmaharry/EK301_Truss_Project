clc; clear;
%Definition of truss parameters

joints = 9;  %Number of rows of C
members = 15;  %Number of columns of C

if members ~= 2*joints-3
    fprintf("M is not equal to 2j - 3\n")
end

%Connection matrix, members are the columns and joints are the rows (M<J)

C = [
    1 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
    1 0 1 1 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 0 1 1 0 0 0 0 0 0 0 0 0;
    0 0 0 1 1 0 1 1 0 0 0 0 0 0 0;
    0 0 0 0 0 1 1 0 1 1 0 0 0 0 0;
    0 0 0 0 0 0 0 1 1 0 1 1 0 0 0;
    0 0 0 0 0 0 0 0 0 1 1 0 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 1 1 0 1;
    0 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
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
Sx =   [
        1 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        ];

if height(Sx) ~= height(C)
    fprintf("sx has incorrect dimensions\n")
end
if ~isequal(sum(Sx),[1,0,0])
    fprintf("Invalid inputs for sx\n")
end

%Which joints have the y reaction forces?
Sy =   [
        0 1 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 1;
        ];

if height(Sy) ~= height(C)
    fprintf("sy has incorrect dimensions\n")
end
if ~isequal(sum(Sy),[0,1,1])
    fprintf("Invalid inputs for sy\n")
end

%Location vectors X and Y. (0,0) is defined as the joint where both X and Y
%reaction forces act
%x and y are measured in inches
X = [0 4 8 12 16 20 24 28 33];
if width(X) ~= height(C)
   fprintf("x has incorrect dimensions\n")
end

Y = [0 sqrt(48) 0 sqrt(48) 0 sqrt(48) 0 sqrt(48) 0];
if width(Y) ~= height(C)
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
        0;
        % Y external loads (signs should be positive?)
        0;   
        0;  
        0;   
        0; % y down of 1 unit
        0;
        0;
        25;
        0;
        0;
        ];

%Lets also check how long each member is!
fprintf("Member lengths:\n")
lengths = zeros(1,width(C));
for i = 1:height(C)
        for j = 1:width(C)
            if C(i,j) == 1
                % I gotta find the other connected memeber, gonna do a function
                % call for this one
                % So first grab the column and make the current index a zero
                finderCol = C(:,j);
                finderCol(i) = 0;
    
                % then call the function and get the value
                otherJoint = otherJointFinder(finderCol);
                m1pos = [X(i), Y(i)];
                m2pos = [X(otherJoint), Y(otherJoint)];
    
                % And compute the length of the member
                length = sqrt((m2pos(1)-m1pos(1))^2 + (m2pos(2)-m1pos(2))^2);
                lengths(j) = length;
            end
        end
    end

%Print the length
for j = 1:width(C)
    fprintf("Member " + string(j) + ": " + string(lengths(j)) + " in. \n")
end

save Truss04.mat

