function cost = calculateCost(C,x,y)
    jointCost = 10*height(C);
    memberCost = 0;
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
                m1pos = [x(i), y(i)];
                m2pos = [x(otherJoint), y(otherJoint)];
    
                % And compute the length of the member
                length = sqrt((m2pos(1)-m1pos(1))^2 + (m2pos(2)-m1pos(2))^2);
                
                %Add the cost
                memberCost = memberCost + length;
            end
        end
    end
    
    %The code above counts each member twice, so we just divide memberCost by two
    cost = jointCost + memberCost/2;
end