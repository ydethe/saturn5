function [t2c, Ic]=detecteFluxThermique(T,Y)
    global env;
    N=numel(T);
    flux=[];
    for i=1:N
        flux=[flux fluxThermique(Y(i,1:3), Y(i,4:6), T(i))-env.fluxSeuil];
    end
    [fluxMax, iMax] = max(flux);
    
    % Si le seuil est atteint pendant l'etage 1, on largue la coiffe au
    % début de l'etage 2
    if fluxMax < 0
        t2c = T(1);
        Ic = 1;
    else
        if flux(end) > 0
            disp('Flux trop fort en fin d etage 2')
            t2c=T(end-1);
            Ic=numel(T)-1;
        else
            [t2c, Ic]=trouveZero(T(iMax:end), flux(iMax:end));
        end
    end
end
