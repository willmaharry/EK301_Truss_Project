function T = trussCalculator(C, Sx, Sy, X, Y, L)
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
                % I gotta find the other connected memeber, gonna do a function
                % call for this one
                % So first grab the column and make the current index a zero
                finderCol = C(:,j);
                finderCol(i) = 0;
    
                % then call the function and get the value
                otherJoint = otherJointFinder(finderCol);
    
                % Now we have the other member so we can compute the unit vecs
                % now we need the 2 positions
                m1pos = [X(i), Y(i)];
                m2pos = [X(otherJoint), Y(otherJoint)];
    
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
    A(:,Csize(2)+1:Csize(2)+3) = vertcat(Sx, Sy);
    
    % And vultron those mofos
    
    % L is the load on each join
    % it has the dimensions 2j,1
    
    % We already have this so no calculations
    
    
    % T is the tension on each member
    % it has dimensions of m+3,1
    
    % We are solving for this so do it last
    T = A\L;
end