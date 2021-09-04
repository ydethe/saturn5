function [c,ceq] = supernonlcon2(x)
    global zpvise
    global zavise

    [za, zp, a, e, mf, pdynmax, fluxmax, incmax]= simulateur(x);
    
    c = [x(1)-x(2)
        x(2)-x(3)
        x(3)-x(4)
        ];
    ceq = [zp-zpvise za-zavise];
    
end
