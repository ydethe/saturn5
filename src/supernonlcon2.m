function [c,ceq] = supernonlcon2(x)
    global zpvise
    global zavise
    
    c = [x(1)-x(2)
        x(2)-x(3)
        x(3)-x(4)];

    [za, zp, a, e, mf, pdynmax, fluxmax]= simulateur(x);
    ceq = [zp-zpvise za-zavise];
    
end
