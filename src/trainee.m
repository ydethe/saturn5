function Fa=trainee(pos, vel, t)
    global env
    r = rho(pos, t);
    Va = Vair(pos, vel , t);
    M = Va/vson(pos, t);
    Fa=-0.5*r*Va^2*env.fusee.Sref*CA(M);
end
