function [C, Ceq]=contrainteApogee(X)
    global zpcontrainte;
    global zpvise;
    
    % On divise la diff�rence p�rig�e atteint/p�rig�e vis� par le p�rig�e
    % vis� de fa�on � ne pas avoir des valeurs trop �lev�es de l'�galit� �
    % v�rifer Ceq
    Ceq = (zpcontrainte-zpvise)/zpvise;
    C=[];
end
