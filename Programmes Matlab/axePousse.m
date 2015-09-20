function axe=axePousse(t, pos, vel)
    % Retourne l'axe de la poussée dans le repère inertiel
    % Dans la phase de basculement, cette direction est définie par rapport
    % au repère d'attitude RL0
   
    global env;
    global thetab2;
    global tv;
    global tb;
    global Talph;
    global temps_simulation1;
    global t2c;
    global temps_simulation2;
    global temps_simulation3;
    
    if (t<=tv)
        %'Cas 1'
        % Montée verticale
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
        % Fin de combustion de l'étage 1
        % Vitesse de l'atmosphère dans le repere inertiel
        omega = [0.; 0.; env.OmegaT];
        v=vel-cross(omega, pos);
        axe=v/norm(v);
        return;
    elseif (t>temps_simulation1 && t<=temps_simulation3)
        %'Cas 5'
        % Combustion de l'étage 2 et 3
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], commande(t))))';
        return
    else
        axe=[1.; 0.; 0.];
    end
end
 