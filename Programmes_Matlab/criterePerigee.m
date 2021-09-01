function z=criterePerigee(X)
    global env;
    zpvise = 6628137;
    
    [za, zp, pdynmax]= simulateur(X);
    
    z=(zp-zpvise)^2/(env.Rp - zpvise)^2;
    disp('Optimisation perigee');
    % Affichage de l'altitude du périgée en km (approx.)
    perigee=zp/1000-6378
    % Affichage de l'altitude de l'apogée en km (approx.)
    apogee=za/1000-6378
end
