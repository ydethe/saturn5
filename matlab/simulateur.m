% Pdyn doit rester inferieur a 40 000 Pa
% Pdyn à la séparation etage 1 et 2 doit rester inferieur a 1500-2000 Pa
% accel max < 5g
% Flux thermique < 1135 W/m^2

function [za, zp, a, e, mf, pdynmax, fluxmax, incmax]=simulateur(X)
    global thetab2;
    global theta2sc1;
    global theta2sc2;
    global theta31;
    global theta32;
    global tv;
    global T;
    global Y;
    global Talph;
    global temps_simulation1;
    global t2c;
    global temps_simulation2;
    global temps_simulation3;
    global tb;
    global pitch_rate;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                 %
    % Initialisation de la simulation %
    %                                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %close all;
    init;
    ii = 1;
    
%     Angle de basculement initial (après montée verticale)
    thetab2 = X(ii)*pi/180;ii=ii+1;
    
%     Angle theta début EP2
    theta2sc1 = X(ii)*pi/180;ii=ii+1;
    
%     Angle theta fin EP2
    theta2sc2 = X(ii)*pi/180;ii=ii+1;  
    
%     Angle theta début EP3 
%     theta31 = X(ii)*pi/180;ii=ii+1;
    theta31 = theta2sc2;
    
%     Angle theta fin EP3 
    theta32 = X(ii)*pi/180;ii=ii+1;

    options = odeset('MaxStep', 10., 'RelTol', 1e-3);
    
    temps_simulation1 = env.fusee.etages(1).duree;
    Talph=env.fusee.etages(1).Tcu(3);
    temps_simulation2 = env.fusee.etages(2).dateDebut + env.fusee.etages(2).duree;
    temps_simulation3 = env.fusee.etages(3).dateDebut + env.fusee.etages(3).duree;
    tb=thetab2/pitch_rate;
    
    try
        %%%%%%%%%%%%%%%%%%%%%%%
        %                     %
        % Première simulation %
        %                     %
        %%%%%%%%%%%%%%%%%%%%%%%
        [T, Y] = ode45(@acceleration,[0, tv], Y0, options);
        Yi=Y(end,:);
        
        if tb > 1e-6
            [Tb, Yb] = ode45(@acceleration,[tv, tv+tb], Yi, options);
            T=[T; Tb];
            Y=[Y; Yb];
            Yi=Yb(end,:);
        end
        
        [Ta,Ya] = ode45(@acceleration,[tv+tb, Talph], Yi, options);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %                       %
        % Calcul de l'incidence %
        %                       %
        %%%%%%%%%%%%%%%%%%%%%%%%%
        [Talph, Ialph] = detecteIncidenceNulle(Ta, Ya);
        if Ialph == -1
            Talph = 40;
            [a, e, inc, Omega, omega, v] = inertiel_vers_orbparam(Y(end,:));
            za=a*(1+e);
            zp=a*(1-e);
            mf=Y(end,7);
            pdynmax=80000;
            fluxmax = 0;
            incmax = 0;
            disp('Incidence non convergee');
            return
        end
        
%         [0 tv tb+tv Talph temps_simulation1 temps_simulation2 temps_simulation3]
        
        % Calcul du poids à donner à Ya(Ialph+1) pour interpoler l'état et
        % trouver l'état atteint à l'instant où l'incidence devient nulle
        pds = (Talph - Ta(Ialph))/(Ta(Ialph+1) - Ta(Ialph));
        
        Yalph = Ya(Ialph,:)*(1-pds) + Ya(Ialph+1,:)*pds;
        T=[T; Ta(1:Ialph); Talph];
        Y=[Y; Ya(1:Ialph,:); Yalph];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                               %
        % On continue la simulation,                                    %
        % à partir de l'instant où on est arrivé à incidence nulle      %
        %                                                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Yi=Y(end,:);
        [T1,Y1] = ode45(@acceleration, [Talph, temps_simulation1], Yi, options);
        Y=[Y; Y1];
        T=[T; T1];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                         %
        % Simulation de l'étage 2 %
        %                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        % T et Y sont les données jusqu'à la fin de l'étage 1
        t2c = temps_simulation2;

        env.fusee.etage_courant=2;
        Yii=Y(end,:);

        % Larguage etage 1
        Yii(7)=Y(1,7)-env.fusee.etages(1).Ms-env.fusee.etages(1).Me;
        [T2,Y2] = ode45(@acceleration, [temps_simulation1, temps_simulation2], Yii, options);
        
        T=[T; T2];
        Y=[Y; Y2];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                         %
        % Simulation de l'étage 3 %
        %                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        env.fusee.etage_courant=3;
        Yii=Y(end,:);
        %Yii(7)=Yii(7)-env.fusee.etages(2).Ms;
        Yii(7)=Y(1,7)-env.fusee.etages(1).Ms-env.fusee.etages(1).Me-env.fusee.etages(2).Ms-env.fusee.etages(2).Me;
        [T3,Y3] = ode45(@acceleration, [temps_simulation2, temps_simulation3], Yii, options);
        Y=[Y; Y3];
        T=[T; T3];

        %toc
        [a e inc Omega omega v] = inertiel_vers_orbparam(Y(end,:));

        za = a*(1+e);
        zp = a*(1-e);

        N = numel(T);
        pdynmax=0;
        fluxmax=0;
        incmax=0;
        courbe_inci = zeros(N);
        for i=1:N
            t = T(i);
            pos = Y(i,1:3);
            vel = Y(i,4:6);
            
            inc = incidenceAbs(Y(i,:), t)*180/pi;
            [~, ~, h] = latlong(pos, t);
            courbe_inci(i) = h;
            if t>temps_simulation2
                incmax = incmax + inc^2/N;
            end
            
            % Vitesse de l'atmosphère dans le repere inertiel
            rr = rho(pos, t);
            va = Vair(pos, vel, t);
            pdyn = 0.5*rr*va^2;
            if pdyn > pdynmax
                pdynmax=pdyn;
            end
            
            flux = fluxThermique(pos, vel, t);
            if flux > fluxmax
                fluxmax=flux;
            end
            
        end
        
        mf=Y(end,7);
% 
%         clf;
%         plot(T,courbe_inci);
%         grid on;
%         drawnow;

%         clf;
%         traceEllipse(a*(1-e^2), e, 0, 'r');
%         hold on;
%         traceEllipse(env.Re, 0, 0, 'b');
%         axis equal;
%         xlim([-6878137 6878137]);
%         ylim([-6878137 6878137]);
%         drawnow;
        
    catch exception
        if strcmp(exception.identifier, 'Lanceur:crash')
            za=0;
            zp=0;
            inc=0;
            pdynmax=80000;
            disp('Crash intercepte');
            return;
        else
            rethrow(exception);
        end
    end
end
