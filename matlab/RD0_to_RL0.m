function y=RD0_to_RL0(xD0)
    global Az;
    x=xD0(1);
    y=xD0(2);
    z=xD0(3);
    
    xp=z;
    yp=sin(Az)*x + cos(Az)*y;
    zp=-cos(Az)*x + sin(Az)*y;
    y=[xp yp zp];
end
