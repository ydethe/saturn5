function axe=axePousse(t, pos, vel)
    % Retourne l'axe de la pouss�e dans le rep�re inertiel
    % Dans la phase de basculement, cette direction est d�finie par rapport
    % au rep�re d'attitude RL0
   
    global env;
    global thetab2;
    global tv;
    global Talph;
    global temps_simulation1;
    global temps_simulation3;
    global tb;
    
    if (t<=tv)
        %'Cas 1'
        % Mont�e verticale
        axe=RD0_to_REQ(RL0_to_RD0([1, 0, 0]))';
        return;
    elseif (t>tv && t<=tv+tb)
        %'Cas 2'
        % Basculement
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], thetab2/tb*(t-tv))))';
        return;
    elseif (t>tv+tb && t<=Talph)
        %'Cas 3'
        % Convergence vers l'incidence nulle
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], thetab2)))';
        return;
    elseif (t>Talph && t<=temps_simulation1)
        %'Cas 4'
        % Fin de combustion de l'�tage 1
        % Vitesse de l'atmosph�re dans le repere inertiel
        omega = [0.; 0.; env.OmegaT];
        v=vel-cross(omega, pos);
        axe=v/norm(v);
        return;
    elseif (t>temps_simulation1 && t<=temps_simulation3)
        %'Cas 5'
        % Combustion de l'�tage 2 et 3
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], commande(t))))';
        return;
    else
        axe=[1.; 0.; 0.];
    end
end
 