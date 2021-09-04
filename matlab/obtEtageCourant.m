function etage=obtEtageCourant(t)
    global env;
    t1 = env.fusee.etages(1).duree;
    t2 = env.fusee.etages(1).duree + env.fusee.etages(2).duree;
    t3 = env.fusee.etages(1).duree + env.fusee.etages(2).duree + env.fusee.etages(3).duree;
    if (t <= t1)
        etage=env.fusee.etages(1);
    elseif (t1 < t && t <= t2)
        etage=env.fusee.etages(2);
    elseif (t2 < t && t <= t3)
        etage=env.fusee.etages(3);
    else
        etage=env.fusee.etages(3);
    end
end
