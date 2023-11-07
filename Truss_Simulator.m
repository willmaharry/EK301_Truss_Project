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
        0;   
        0;   
        0;
        0;];

if height(L) ~= 2*height(C)
    fprintf("L has incorrect dimensinos\n")
end
if ~any(L)
    fprintf("Invalid inputs for L\n")
end





