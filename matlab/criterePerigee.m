function z=criterePerigee(X)
    global zpvise;
    global env;
    
    [za, zp, a, e, mf, pdynmax, fluxmax]= simulateur(X);
    z = -zp;
    
    X
    (zp-6378137)/1000
    
end
