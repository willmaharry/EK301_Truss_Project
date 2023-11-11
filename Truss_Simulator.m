clc;clear;
%Preliminary Design Review Code:

%Definition of truss parameters

joints = 5;  %Number of rows of C
members = 7;  %Number of columns of C

%Connection matrix, members are the columns and joints are the rows (M<J)

C = [1 1 0 0 0 0 0;
    1 0 1 0 1 1 0;
    0 1 1 1 0 0 0;
    0 0 0 1 1 0 1;
    0 0 0 0 0 1 1];

%Check the connection matrix is properly defined (M = 2J-3)
if width(C) ~= 2*height(C) - 3
    fprintf("Incorrect dimensions\n")
end
if ~all(sum(C) == 2)
    fprintf("Not all columns add to 2\n")
end

%Support force matrices, each should have J rows and 3 columns
%Which joint has the x reaction force?
sx =   [1 0 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 0;];

if height(sx) ~= height(C)
    fprintf("sx has incorrect dimensions\n")
end
if ~isequal(sum(sx),[1,0,0])
    fprintf("Invalid inputs for sx\n")
end

%Which joints have the y reaction forces?
sy =   [0 1 0;
        0 0 0;
        0 0 0;
        0 0 0;
        0 0 1;];

if height(sy) ~= height(C)
    fprintf("sy has incorrect dimensions\n")
end
if ~isequal(sum(sy),[0,1,1])
    fprintf("Invalid inputs for sy\n")
end

%Location vectors X and Y. 0,0 is defined as the joint where both X and Y
%reaction forces act
%x and y are measured in inches
x = [0,1,2,3,4];
if width(x) ~= height(C)
   fprintf("x has incorrect dimensions\n")
end

y = [0,1,0,1,0];
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
        % Y external loads (signs should be positive?)
        0;   
        100; % this is an arbitrary 100 unit load at joint 2 in the y   
        0;   
        0;
        0;];

if height(L) ~= 2*height(C)
    fprintf("L has incorrect dimensions\n")
end
if ~any(L)
    fprintf("Invalid inputs for L\n")
end

% Okay so basically we need to do the following steps
% We need to do [A][T] = [L] and we're trying to find [T] 
% So do a classic T = A^-1(L)

% But what are A, T, & L
% A is a chongo matrix that consists of 4 segments
% it has the dimensions: 2j, m+3
% Top left quadrant: Matrix C mult by the x unit vector at all points
% Bottom left quadrant: Matrix C mult by the y unit vector at all points
% Top right quadrant: Support matrix X
% Bottom right quadrant: Support matrix Y

% Okay so to calculate this we will define quadrant 2 & 3 in a loop 
% (we have 1 & 4)
% To do this we first clone C to make it quadrant 2
Csize = size(C);
A = zeros(height(L),width(C)+3);
% now loop through and fill out the unit vectors
for i = 1:Csize(1)
    for j = 1:Csize(2)
        if C(i,j) == 1
            disp(i)
            % I gotta find the other connected memeber, gonna do a function
            % call for this one
            % So first grab the column and make the current index a zero
            finderCol = C(:,j);
            finderCol(i,j) = 0;

            % then call the function and get the value
            otherJoint = otherJointFinder(finderCol);

            % Now we have the other member so we can compute the unit vecs
            % now we need the 2 positions
            m1pos = [x(i), y(i)];
            m2pos = [x(otherJoint), y(otherJoint)];

            % And compute the radial distance
            r = sqrt((m2pos(1)-m1pos(1))^2 + (m2pos(2)-m1pos(2))^2);

            % now write in each value for both the top and bottom matrix
            % for x
            A(i,j) = (m2pos(1)-m1pos(1))/r;
            % for y
            A(i+size(C,1),j) = (m2pos(2)-m1pos(2))/r;
        end
    end
end
disp(A);

% And vultron those mofos

% L is the load on each join
% it has the dimensions 2j,1

% We already have this so no calculations


% T is the tension on each member
% it has dimensions of m+3,1

% We are solving for this so do it last
%T = ...



