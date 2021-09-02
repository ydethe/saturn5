function [c,az]=commande(t, aef)
%     aef is the azimuth of the earth-fixed velocity vector
    global Az0;
    global dAz;
    global tAz;
    
    [ti, td, theta1, theta2] = obtPhaseCourante(t); 
    a=(theta2-theta1)/td;
    b=theta1;
    c=a*(t-ti)+b;
    
    if t<tAz
        az = Az0;
    else
        az = aef+dAz;
    end
    
end
