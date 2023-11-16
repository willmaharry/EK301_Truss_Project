function surpassed = surpassedMaxLoad(L, memberMaxLoads)
    surpassed = 0;
    for i = 1:height(L)-3 % So we don't accidentally calculate the S forces
        % Calculate Max load for member i
        if (L(i) > memberMaxLoads(i))
            surpassed = 1;
        end
    end    
end