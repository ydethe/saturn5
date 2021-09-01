function f=fluxThermique(pos, vel, t)
    global env;
    r = rho(pos, t);
    Va=Vair(pos, vel, t);
    f=0.5*r*Va^3;
end
