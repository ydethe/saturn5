function y=RL0_to_RD0(xL0)
    global env;
    global Az;
    
    x=xL0(1);
    y=xL0(2);
    z=xL0(3);
      
    xD0=sin(Az)*y-cos(Az)*z;
    yD0=cos(Az)*y+sin(Az)*z;
    zD0=x;
    
    y=[xD0 yD0 zD0];
    
end
