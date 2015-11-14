function y=REQ_to_RD0(xEQ)
    global env;
    x=xEQ(1);
    y=xEQ(2);
    z=xEQ(3);
    lambda = env.pdt.longitude;
    phi=env.pdt.latitude;
    
    xp=-sin(lambda)*x+cos(lambda)*y;
    yp=-cos(lambda)*sin(phi)*x - sin(lambda)*sin(phi)*y + cos(phi)*z;
    zp=cos(lambda)*cos(phi)*x + sin(lambda)*cos(phi)*y + sin(phi)*z;
    y=[xp yp zp];
end
