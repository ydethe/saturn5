% Pdyn doit rester inferieur a 40 000 Pa
% Pdyn à la séparation etage 1 et 2 doit rester inferieur a 1500-2000 Pa
% accel max < 5g
% Flux thermique < 1135 W/m^2

function [za, zp, pdynmax]=simulateur(X)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                 %
    % Initialisation de la simulation %
    %                                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('=============================================');
    X
    %close all;
    init;
    ii = 1;
    global thetab2;
    global theta2sc1;
    global theta2sc2;
    global theta31;
    global theta32;
    
    thetab2 = X(ii)*pi/180;ii=ii+1;
    theta2sc1 = X(ii)*pi/180;ii=ii+1;
    theta2sc2 = X(ii)*pi/180;ii=ii+1;    
    theta31 = X(ii)*pi/180;ii=ii+1;
    theta32 = X(ii)*pi/180;ii=ii+1;

    options = odeset('MaxStep', 1., 'RelTol', 1e-3);
    
    global T;
    global Y;
    global Talph;
    global temps_simulation1;
    global t2c;
    global temps_simulation2;
    global temps_simulation3;
    temps_simulation1 = env.fusee.etages(1).duree;
    Talph=env.fusee.etages(1).Tcu(2);
    temps_simulation2 = env.fusee.etages(2).dateDebut + env.fusee.etages(2).duree;
    temps_simulation3 = env.fusee.etages(3).dateDebut + env.fusee.etages(3).duree;

    try
        %%%%%%%%%%%%%%%%%%%%%%%
        %                     %
        % Première simulation %
        %                     %
        %%%%%%%%%%%%%%%%%%%%%%%
        [T, Y] = ode45(@acceleration,[0, tv], Y0, options);
        Yi=Y(end,:);
        [Tb, Yb] = ode45(@acceleration,[tv, tv+tb], Yi, options);
        T=[T; Tb];
        Y=[Y; Yb];

        Yi=Yb(end,:);
        options = odeset('MaxStep', 1., 'RelTol', 1e-3);
        [Ta,Ya] = ode45(@acceleration,[tv+tb, Talph], Yi, options);
        options = odeset('MaxStep', 10., 'RelTol', 1e-3);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        %                       %
        % Calcul de l'incidence %
        %                       %
        %%%%%%%%%%%%%%%%%%%%%%%%%

        [Talph, Ialph] = detecteIncidenceNulle(Ta, Ya);
        if Ialph == -1
            Talph = 40;
            [a e inc Omega omega v] = inertiel_vers_orbparam(Y(end,:));
            za=a*(1+e);
            zp=a*(1-e);
            pdynmax=80000;
            disp('Incidence non convergee');
            return
        end 
        
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
        % jusqu'au changement de debit                                  %
        %                                                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        temps_simulation11 = env.fusee.etages(1).Tcu(2);
        Yi=Y(end,:);
        [T1,Y1] = ode45(@acceleration, [Talph, temps_simulation11], Yi, options);

        Y=[Y; Y1];
        T=[T; T1];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                               %
        % On finit la simulation de l'etage 1,                          %
        %                                                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Yi=Y(end,:);
        [T1,Y1] = ode45(@acceleration, [temps_simulation11, temps_simulation1], Yi, options);

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
        %Yii(7)=Yii(7)-env.fusee.etages(1).Ms;
        Yii(7)=Y(1,7)-env.fusee.etages(1).Ms-env.fusee.etages(1).Me;
        [T2,Y2] = ode45(@acceleration, [temps_simulation1, temps_simulation2], Yii, options);

        % T=[T; T2];
        % Y=[Y; Y2];
        % post_traitement;
        % return;

        % Detection du flux thermique < 1500
        [t2c, Ic]=detecteFluxThermique(T2, Y2);

        if temps_simulation1 == t2c
            T=[T; T2];
            Y=[Y; Y2];
        else
            Yi=Yii;
            [T21, Y21] = ode45(@acceleration, [temps_simulation1, t2c], Yi, options);

            Yii = Y21(end, :);
            % Larguage coiffe
            %Yii(7) = Yii(7) - env.fusee.coiffe_masse;
            Yii(7)=Y(1,7)-env.fusee.etages(1).Ms-env.fusee.etages(1).Me-env.fusee.coiffe_masse-(t2c-env.fusee.etages(2).dateDebut)*debit(t2c,env.fusee.etages(2));
            [T22, Y22] = ode45(@acceleration, [t2c, temps_simulation2], Yii, options);

            T=[T; T21; T22];
            Y=[Y; Y21; Y22];
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                         %
        % Simulation de l'étage 3 %
        %                         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%

        env.fusee.etage_courant=3;
        Yii=Y(end,:);
        %Yii(7)=Yii(7)-env.fusee.etages(2).Ms;
        Yii(7)=Y(1,7)-env.fusee.etages(1).Ms-env.fusee.etages(1).Me-env.fusee.coiffe_masse-env.fusee.etages(2).Ms-env.fusee.etages(2).Me;
        [T3,Y3] = ode45(@acceleration, [temps_simulation2, temps_simulation3], Yii, options);
        Y=[Y; Y3];
        T=[T; T3];

        %toc
        global e;
        [a e inc Omega omega v] = inertiel_vers_orbparam(Y(end,:));

        za=a*(1+e);
        zp=a*(1-e);
        %global debugZ;
        %pourcentageAugmentation=(zp-debugZ)/debugZ*100
        %debugZ=zp;

        N = numel(T);
        va=[];
        rr=[];
        for i=1:N
            pos=Y(i,1:3);
            vel=Y(i,4:6);
            % Vitesse de l'atmosphère dans le repere inertiel
            %axe=axePousse(T(i), pos, vel);
            rr(i)=rho(pos, T(i));
            va=[va Vair(Y(i,1:3),Y(i,4:6) , T(i))];
        end
        pdyn = 0.5.*rr.*va.^2;
        pdynmax = max(pdyn);

        % Altitude finale approximative
        [lambda0, phi0, h] = latlong(Y(end, 1:3), T(end));

        clf;
        traceEllipse(a*(1-e^2), e, 0, 'r');
        hold on;
        traceEllipse(env.Re, 0, 0, 'b');
        axis equal;
        xlim([-36000000-6378000 6378000+250000]);
        ylim([-2e7 2e7]);
        drawnow;
%         clf;
%         plot(T, pdyn);
%         ylim([0 4e4]);
%         grid on;
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
