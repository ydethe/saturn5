function z=critereApogee(X)
    global zpvise;
    global zavise;
    global env;
    
    X
    [za, zp, a, e, mf, pdynmax]= simulateur(X);
    z = ((za-zavise)/env.Rp)^2;
    [(zp-6378137)/1000 (za-6378137)/1000]
    
end
