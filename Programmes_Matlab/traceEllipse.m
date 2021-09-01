function traceEllipse(p, e, theta0, col)
    step=0.01;
    theta = 0:step:2*pi+step;
    x=p./(1+e*cos(theta-theta0)).*cos(theta);
    y=p./(1+e*cos(theta-theta0)).*sin(theta);
    plot(x,y,col);
end
