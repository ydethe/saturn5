function [z, i]=trouveZero(x, y)
% Cette fonction recherche la valeur de x qui annule y, en interpolant
% linéairement sur un intervalle où y change de signe. Retourne z la valeur
% de x interpolée qui annule y, ainsi que l'indice qui précède z (x(i) < z)
    if y(1) > 0
        i=find(y<=0,1,'first')-1;
    else
        i=find(y>=0,1,'first')-1;
    end
    
    if i==1
        i=i+1;
    end
    
    if numel(i) == 0
        z=0;
        i=-1;
    else
        x1 = x(i-1);
        x2 = x(i);

        y1 = y(i-1);
        y2 = y(i);

        z=x1-y1*(x2-x1)/(y2-y1);
    end
end
