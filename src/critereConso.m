function z=critereConso(X)
    global zavise;
    global zpvise;
    
    [za, zp, a, e, mf, pdynmax, fluxmax, incmax] = simulateur(X);
    z = incmax;
    
    X
    [(zp-6378137)/1000, (za-6378137)/1000, 100*pdynmax/33838, 100*fluxmax/18535548, sqrt(incmax)]
    
end
