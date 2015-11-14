function [Talph, Ialph]=detecteIncidenceNulle(T, Y)
    N=numel(T);
    inci=[];
    Icv=0;
    for i=1:N
        pos=Y(i,1:3);
        vel=Y(i,4:6);
        axe=axePousse(T(i), pos, vel);
        inci=[inci incidence(axe, pos, vel, T(i))];
    end
    [Talph, Ialph]=trouveZero(T(1:end-2), inci(1:end-2));
end
