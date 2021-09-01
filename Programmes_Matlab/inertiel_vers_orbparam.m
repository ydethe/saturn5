function [a e inc Omega omega v] = inertiel_vers_orbparam(etat)
    global env;
    posREQ = etat(1:3);
    vitREQ = etat(4:6);
    r = norm(posREQ);
    v2 = norm(vitREQ)^2;
    h = cross(posREQ, vitREQ);
    p = norm(h)^2/env.Mu;
    W = v2/2 - env.Mu / r;
    
    C=norm(h);
    e=sqrt(1+C^2/env.Mu^2*v2-2*C^2/(env.Mu*r));
    a=1/2*(p/(1+e)+p/(1-e));
    
    rp = a*(1-e);
    ra = a*(1+e);
    inc = acos(h(3)/C);
    v = acos((p/r - 1)/e);
    
    % Calcul de Omega
    sinOmega = h(1) / norm(h(1:2));
    cosOmega = -h(2) / norm(h(1:2));
    Omega = angle(cosOmega + sinOmega*1i);

    % Calcul de omega
    sinomega = (posREQ(2)*cosOmega - posREQ(1)*sinOmega)/(r*cos(inc));
    cosomega = (posREQ(1)*cosOmega + posREQ(2)*sinOmega)/r;
    omega = (angle(cosomega + 1i*sinomega) - v);
end
