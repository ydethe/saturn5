function [lambda0, phi0, h] = latlong(position, t)
    % Conversion des coordonnées dans REQ aux latitudes / longitudes.
    global env;
    global posi;
    
    if norm(position) < norm(posi)
        exc = MException('Lanceur:crash', 'Altitude negative');
        throw(exc);
    else
        x = position(1);
        y = position(2);
        z = position(3);
        p = sqrt(x^2+y^2);
        cl = x/p;   % cos(lambda)
        sl = y/p;   % sin(lambda)
        lambda0=angle(cl+1i*sl) - env.OmegaT*t;
        [phi0, h]=Iter_phi_h(position);
    end
    
    if sum(isnan(position))
        exc = MException('Lanceur:crash', 'Position NaN');
        throw(exc);
    else
        x = position(1);
        y = position(2);
        z = position(3);
        p = sqrt(x^2+y^2);
        cl = x/p;   % cos(lambda)
        sl = y/p;   % sin(lambda)
        lambda0=angle(cl+1i*sl) - env.OmegaT*t;
        [phi0, h]=Iter_phi_h(position);
    end
end


