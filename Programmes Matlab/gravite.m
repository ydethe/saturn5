function g=gravite(posREQ)
    global env;
    x = posREQ(1);
    y = posREQ(2);
    z = posREQ(3);
    r = sqrt(x*x + y*y + z*z);
    A = env.Mu + 3*env.CJ/r^2*(1-5*z^2/r^2);
    gx = -x / r^3 * A;
    gy = -y/r^3 * A;
    gz = -z/r^3*A - env.CJ*6*z/r^5;
    g = [gx; gy; gz];
end
