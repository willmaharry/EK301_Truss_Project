function surpassed = surpassedMaxLoad(L, maxLoad)
    surpassed = 0;
    for i = 1:height(L)-3 % So we don't accidentally calculate the S forces
        if L(i) < -maxLoad
            surpassed = 1;
            break;
        end
    end    
end