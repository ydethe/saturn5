function in=incidence(axe, pos, vel, t)
% Calcule l'incidence du lanceur en radians. En argument, passer l'axe
% du lanceur, sa position et sa vitesse, les deux dans le repère inertiel.
global env;
[lambda0, phi0, h] = latlong(pos, t);

% Vitesse de l'atmosphère dans le repere inertiel
omega = [0.; 0.; env.OmegaT];
vel=vel-cross(omega, pos);
if (norm(vel) > env.eps)
    v=vel/norm(vel);
    in=acos(dot(axe, v));
    ur = pos/norm(pos);
    if (dot(ur, v) > dot(ur, axe))
        in=-in;
    end
else
    in=0;
end
in=real(in);
end
