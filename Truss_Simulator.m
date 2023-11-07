%Preliminary Design Review Code:

%Definition of truss parameters

%Connection matrix, rows are the members and columns are the joints
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

%will
