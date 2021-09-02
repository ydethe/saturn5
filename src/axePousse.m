function axe=axePousse(t, pos, vel)
    % Retourne l'axe de la poussée dans le repère inertiel
    % Dans la phase de basculement, cette direction est définie par rapport
    % au repère d'attitude RL0
   
    global env;
    global thetab2;
    global tv;
    global Talph;
    global temps_simulation1;
    global temps_simulation3;
    global tb;

    % aef is the azimuth of the earth-fixed velocity vector
    omega = [0.; 0.; env.OmegaT];
    v = vel - cross(omega, pos);
    z_env = pos/norm(pos);
    x_env = cross([0,0,1], z_env);
    x_env = x_env/norm(x_env);
    y_env = cross(z_env, x_env);
    v_xe = dot(v, x_env);
    v_ye = dot(v, y_env);
    aef = atan2(v_ye, v_xe);
%     [t, aef*180/pi]
    [c, az] = commande(t, aef);

    if (t<=tv)
        %'Cas 1'
        % Montée verticale
        axe=RD0_to_REQ(RL0_to_RD0([1, 0, 0], az))';
        return;
    elseif (t>tv && t<=tv+tb)
        %'Cas 2'
        % Basculement
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], thetab2/tb*(t-tv)), az))';
        return;
    elseif (t>tv+tb && t<=Talph)
        %'Cas 3'
        % Convergence vers l'incidence nulle
        axe=RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], thetab2), az))';
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
        axe = RD0_to_REQ(RL0_to_RD0(RL_to_RL0([1, 0, 0], c), az))';
        return;
    else
        axe=[1.; 0.; 0.];
    end
end
 