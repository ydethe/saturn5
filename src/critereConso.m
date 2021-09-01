function z=critereConso(X)
    global zavise;
    global zpvise;
    
    [za, zp, a, e, mf, pdynmax, fluxmax]= simulateur(X);
    z = pdynmax;
    
    X
    [(zp-6378137)/1000, (za-6378137)/1000]
    
end
