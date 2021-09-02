function [c,ceq] = supernonlcon(x)
    global zpvise
    
    ceq=[];
    
    c = [x(1)-x(2)
        x(2)-x(3)
        x(3)-x(4)];
    
end
