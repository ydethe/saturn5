function z=critereApogee(X)
    % Variable qui sera lue par la fonction de contrainte
    global zpcontrainte;
    global zavise;
    global env;
    
    [za, zp, pdynmax]= simulateur(X);
    % Enregistrement du périgée atteint pour la fonction de contrainte
    zpcontrainte = zp;
    
    %z=-za;
    z=(za-zavise)^2/(env.Rp - zavise)^2;
    
    disp('Optimisation apogee');
    % Affichage de l'altitude du périgée en km (approx.)
    perigee=zp/1000-6378
    % Affichage de l'altitude de l'apogée en km (approx.)
    apogee=za/1000-6378
end
