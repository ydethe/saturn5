function res=pression(pos, t)

    global env;
    v=vson(pos, t);
    r=rho(pos, t);
    gamma = 1.4;
    res=v^2/gamma*r;
end
