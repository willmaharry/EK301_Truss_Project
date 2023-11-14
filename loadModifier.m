function L = loadModifier(L, jointLoad)
    for i = 1:height(L)
        if (L(i) == 1)
            L(i) = jointLoad;
            break;
        end
    end
end