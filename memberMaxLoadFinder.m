function memberMaxLoads = memberMaxLoadFinder(C, X, Y, uncertainty)
    % We also want to calculate the length of each member to use it in the
    % strength calculations
    memberLengths = zeros(1,width(C));
    % first make a matrix version based on C
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
    
                % Now we have the other member so we can compute the unit vecs
                % now we need the 2 positions
                m1pos = [X(i), Y(i)];
                m2pos = [X(otherJoint), Y(otherJoint)];
    
                % And compute the radial distance
                memberLengths(j) = sqrt((m2pos(1)-m1pos(1))^2 + (m2pos(2)-m1pos(2))^2);
            end
        end
    end
    % and find the max loads
    memberMaxLoads = zeros(1, width(C));
    for i = 1:width(C)
        memberMaxLoads(i) = (3654.553 * (memberLengths(i)^-2.119) + uncertainty);
    end
end

