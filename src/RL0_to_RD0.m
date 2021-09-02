function y=RL0_to_RD0(xL0, az)
    x=xL0(1);
    y=xL0(2);
    z=xL0(3);
      
    xD0=sin(az)*y-cos(az)*z;
    yD0=cos(az)*y+sin(az)*z;
    zD0=x;
    
    y=[xD0 yD0 zD0];
    
end
