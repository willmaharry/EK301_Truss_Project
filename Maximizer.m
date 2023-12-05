function [Tmax, failingMemberIndex, jointLoad] = Maximizer(memberMaxLoads, T, L)

members = width(memberMaxLoads);
%We can ignore the support forces
memberForces = T(1:members,:)';
%The multiplier vector contains exactly how much each
%element must be multiplied for it to reach buckling strength
multipliers = memberMaxLoads./ memberForces;
for i = 1:members
    %We can ignore members under tension. Compression will have POSITIVE SIGNS
    if memberForces(i) > 0
        differences = memberForces*multipliers(i)-memberMaxLoads;
        %If the differences vector is all negatives, then the ith
        %member will fail first
        if all(differences <= 0)
            Tmax = memberForces.* multipliers(i);
            jointLoad = sum(L)*multipliers(i);
            failingMemberIndex = i;
        end
    end
end
