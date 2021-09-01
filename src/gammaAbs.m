function ga=gammaAbs(etat, t)
    global env;
    pos = etat(1:3);
    vel = etat(4:6);
    vert = -gravite(pos);
    vert = vert/norm(vert);
    
    r = rho(pos, t);
    % Vitesse de l'atmosphère dans le repere inertiel
    omega = [0.; 0.; env.OmegaT];
    v=vel-cross(omega, pos);
    
    nv=norm(v);
    if nv == 0.
        ga=0;
    else
        ga = pi/2-acos(dot(vert, v/nv));
    end
end
