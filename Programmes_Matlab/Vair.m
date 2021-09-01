function Va=Vair(pos, vel, t)
    global env;
    r = rho(pos, t);
    % Vitesse de l'atmosphère dans le repere inertiel
    omega = [0.; 0.; env.OmegaT];
    v=vel-cross(omega, pos);
    Va=norm(v);
end
