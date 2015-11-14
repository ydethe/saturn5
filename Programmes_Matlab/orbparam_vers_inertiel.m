function [pos, vit] = orbparam_vers_inertiel(param)
    global env;
    a=param(1);
    e=param(2);
    inc=param(3);
    Omega=param(4);
    omega=param(5);
    v=param(6);
    
    p = a*(1-e^2);
    r = p/(1+e*cos(v));
    C = sqrt(a*(1-e^2)*env.Mu);
    xt(1) = cos(Omega)*cos(omega+v) - sin(Omega)*cos(inc)*sin(omega+v);
    xt(2) = sin(Omega)*cos(omega+v) + cos(Omega)*cos(inc)*sin(omega+v);
    xt(3) = sin(inc)*sin(omega+v);
    
    yt(1) = -cos(Omega)*sin(omega+v) - sin(Omega)*cos(inc)*cos(omega+v);
    yt(2) = -sin(Omega)*sin(omega+v) + cos(Omega)*cos(inc)*cos(omega+v);
    yt(3) = sin(inc)*cos(omega+v);
    
    pos = r*xt;
    vit = C*e/p*sin(v)*xt + C/r*yt;
end
