function surpassed = surpassedMaxLoad(Tmax, memberMaxLoads)
    surpassed = 0;
    for i = 1:height(Tmax)-3 % So we don't accidentally calculate the S forces
        % Calculate Max load for member i
        if (Tmax(i) > memberMaxLoads(i))
            surpassed = 1;
        end
    end    
end