function pit=pitch(etat,t)
    global env;
    pos = etat(1:3);
    vel = etat(4:6);
    vert = -gravite(pos);
    vert = vert/norm(vert);
    
    axe = axePousse(t, pos, vel);
    pit = pi/2-acos(dot(vert, axe));
end
