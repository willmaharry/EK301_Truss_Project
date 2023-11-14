function index = otherJointFinder(x)
    index = 0;
    for i = 1:length(x)
        if x(i) == 1
            index = i;
            break;
        end
    end
end

