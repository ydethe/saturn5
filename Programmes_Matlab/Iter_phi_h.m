function [phig, hg]=Iter_phi_h(position)
    global env;
    x = position(1);
    y = position(2);
    z = position(3);
    r = norm(position);
    p = sqrt(x^2+y^2);
    
    N = env.Re;
    hg = r-sqrt(env.Re-env.Rp);
    e = sqrt(1-env.Rp^2/env.Re^2);
    phig = atan(z*(N+hg)/(p*(N*(1-e^2)+hg)));
    
    cont = true;
    while cont
        hgp = hg;
        phigp = phig;
        
        N = env.Re/sqrt(1-e^2*sin(phigp)^2);
        hg = p/cos(phigp) - N;
        phig = atan(z*(N+hg)/(p*(N*(1-e^2)+hg)));
        
        if env.eps>max(abs(phigp-phig), abs(hgp-hg))
            cont = false;
        end
    end
end
