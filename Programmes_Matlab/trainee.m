function Fa=trainee(pos, vel, t)
    global env;
    r = rho(pos, t);
    % Vitesse de l'atmosphère dans le repere inertiel
    omega = [0.; 0.; env.OmegaT];
    v=vel-cross(omega, pos);
    Va=norm(v);
    M = Vair(pos, vel , t)/vson(pos, t);
    Fa=-0.5*r*Va^2*env.fusee.Sref*CA(M);
end
