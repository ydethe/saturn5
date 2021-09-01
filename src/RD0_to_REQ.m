function y=RD0_to_REQ(xD0)
    global env;
    
    x=xD0(1);
    y=xD0(2);
    z=xD0(3);
    
    lambda = env.pdt.longitude;
    phig0=env.pdt.latitude;
        
    xEQ=-sin(lambda)*x-cos(lambda)*sin(phig0)*y+cos(lambda)*cos(phig0)*z;
    yEQ=cos(lambda)*x-sin(lambda)*sin(phig0)*y+sin(lambda)*cos(phig0)*z;
    zEQ=cos(phig0)*y+sin(phig0)*z;
    
    y=[xEQ yEQ zEQ];
    
end
