function z=critereApogee(X)
    global zpvise;
    global zavise;
    global env;
    
    [za, zp, a, e, mf, pdynmax, fluxmax]= simulateur(X);
    z = ((za-zavise)/env.Rp)^2;
    
    X
    [(zp-6378137)/1000 (za-6378137)/1000]
    
end
