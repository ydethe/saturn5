function in=incidenceAbs(etat, t)
% Calcule l'incidence du lanceur en degrés. En argument, passer l'axe
% du lanceur, sa position et sa vitesse, les deux dans le repère inertiel.
global env;

pos=etat(1:3);
vel=etat(4:6);
axe=axePousse(t, pos, vel);

if (norm(vel) > env.eps)% && h<2.3e5)
    v=vel/norm(vel);
    g = gravite(pos);
    vert = g/norm(g);
    in=acos(dot(axe, v));
    if (dot(vert, v) > dot(vert, axe))
        in=-in;
    end
else
    in=0;
end
in=real(in);
end
