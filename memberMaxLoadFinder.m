function memberMaxLoads = memberMaxLoadFinder(C, X, Y)
    % We also want to calculate the length of each member to use it in the
    % strength calculations
    Csize = size(C);
    memberLengthsMat = zeros(Csize(1), Csize(2));
    % first make a matrix version based on C
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
                memberLengthsMat(i, j) = sqrt((m2pos(1)-m1pos(1))^2 + (m2pos(2)-m1pos(2))^2);
            end
        end
    end
    % now flatten that mofo
    memberLengths = zeros(1, Csize(2));
    for i = 1:Csize(2)
        tmp = 0;
        for j = 1:Csize(1)
            if (tmp == 0) && (memberLengthsMat(j, i) ~= 0)
                tmp = memberLengthsMat(j, i);
            elseif (tmp ~= 0) && (memberLengthsMat(j, i) ~= 0)
                if (tmp ~= memberLengthsMat(j, i))
                   disp("ERROR: Member lengths don't match.") 
                   break;
                else
                    memberLengths(i) = tmp;
                end
            end
        end
    end
    % and find the max loads
    memberMaxLoads = zeros(1, Csize(2));
    for i = 1:Csize(2)
        memberMaxLoads(i) = 3654.553 * memberLengths(i)^-2.119;
    end
end








