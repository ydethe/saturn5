function z=critereApogee(X)
    % Variable qui sera lue par la fonction de contrainte
    global zpcontrainte;
    global zavise;
    global env;
    
    [za, zp, pdynmax]= simulateur(X);
    % Enregistrement du p�rig�e atteint pour la fonction de contrainte
    zpcontrainte = zp;
    
    %z=-za;
    z=(za-zavise)^2/(env.Rp - zavise)^2;
    
    disp('Optimisation apogee');
    % Affichage de l'altitude du p�rig�e en km (approx.)
    perigee=zp/1000-6378
    % Affichage de l'altitude de l'apog�e en km (approx.)
    apogee=za/1000-6378
end
