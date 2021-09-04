function T=pousse(pos, t)
    global env;
    etage = obtEtageCourant(t);
    q=debit(t, etage);
    isv_c=isv(t, etage);
    
    if q == 0
        T=0;
    else
        Ss=etage.Ss;
        Tv=isv_c*q*env.g0;
        T=Tv-pression(pos, t)*Ss;
    end
end
