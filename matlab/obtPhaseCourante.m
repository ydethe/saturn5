function [ti, duree, theta1, theta2]=obtPhaseCourante(t)
    %global env;
    global tv;
    global tb;
    global Talph;
    global temps_simulation1;
    global temps_simulation2;
    global temps_simulation3;
    
    global theta31;
    global theta32;
    global theta2sc1;
    global theta2sc2;
    global theta11;
    global theta12;
    global thetab1;
    global thetab2;
    global thetav1;
    global thetav2;
    
    if t<=tv
        ti=0;
        duree=tv;
        theta1=thetav1;
        theta2=thetav2;
        return
    end
    if t<=tv+tb
        ti=tv;
        duree=tb;
        theta1=thetab1;
        theta2=thetab2;
        return;
    end
    if t<=temps_simulation1
        ti=tv+tb;
        duree=temps_simulation1-ti;
        theta1=theta11;
        theta2=theta12;
        return;
    end
    if t<=temps_simulation2
        ti=temps_simulation1;
        duree=temps_simulation2-ti;
        theta1=theta2sc1;
        theta2=theta2sc2;
        return;
    end

    if t<=temps_simulation3
        ti=temps_simulation2;
        duree=temps_simulation3-ti;
        theta1=theta31;
        theta2=theta32;
        return;
    end 
end
