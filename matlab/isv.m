function isv_c=isv(date, etage)
    t = abs(date - etage.dateDebut);
    n = numel(etage.Tcu);
    isv_c=0;
    for i=1:n-1
        if etage.Tcu(i) - 1e-5 <= t && t <= etage.Tcu(i+1) + 1e-5
            isv_c=etage.ISV(i);
        end
    end
end
