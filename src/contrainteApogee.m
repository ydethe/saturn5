function [C, Ceq]=contrainteApogee(X)
    global zacontrainte;
    global zavise;
    
    % On divise la différence périgée atteint/périgée visé par le périgée
    % visé de façon à ne pas avoir des valeurs trop élevées de l'égalité à
    % vérifer Ceq
    Ceq = (zacontrainte-zavise)/zavise;
    C=[];
end
