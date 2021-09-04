function q=debit(date, etage)
    t = abs(date - etage.dateDebut);
    n = numel(etage.Tcu);
    q=0;
    for i=1:n-1
        if etage.Tcu(i) - 1e-5 <= t && t <= etage.Tcu(i+1) + 1e-5
            q=etage.q(i);
        end
    end
end
