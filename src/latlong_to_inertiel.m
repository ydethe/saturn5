function pos=latlong_to_inertiel(lambda, phi, h)
    global env;
    e = sqrt(1-env.Rp^2/env.Re^2);
    N=env.Re/sqrt(1-e^2*sin(phi)^2);
    x=(N+h)*cos(phi)*cos(lambda);
    y=(N+h)*cos(phi)*sin(lambda);
    z=(N*(1-e^2)+h)*sin(phi);
    pos=[x; y; z];
end
