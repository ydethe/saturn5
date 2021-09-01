function [c,ceq] = supernonlcon(x)
    global zpvise
    
    ceq=[];
    
    c = [x(1)-x(2)
        x(2)-x(3)
        x(3)-x(4)
        x(4)-x(5)];
% 
%     [za, zp, a, e, mf, pdynmax]= simulateur(x);
%     ceq = [zp-zpvise];
    
end
