function [C, Ceq]=contrainteApogee(X)
    global zpcontrainte;
    global zpvise;
    
    % On divise la différence périgée atteint/périgée visé par le périgée
    % visé de façon à ne pas avoir des valeurs trop élevées de l'égalité à
    % vérifer Ceq
    Ceq = (zpcontrainte-zpvise)/zpvise;
    C=[];
end
