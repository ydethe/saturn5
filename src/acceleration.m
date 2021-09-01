function etat2=acceleration(t, etat)
global env;

pos=etat(1:3);
vel=etat(4:6);
m=etat(7);

% Vitesse de l'atmosph�re dans le repere inertiel
omega = [0.; 0.; env.OmegaT];
axe_vitesse = vel-cross(omega, pos);
if (t ~= 0)
    axe_vitesse = axe_vitesse/norm(axe_vitesse);
else
    axe_vitesse = pos/norm(pos);
end

% Calcul de l'acceleration dans le repere inertiel.
ag=gravite(pos);
ap=pousse(pos, t)/m;
at=trainee(pos, vel, t)/m;
acc = ag + axePousse(t, pos, vel)*ap + axe_vitesse*at;

etage = obtEtageCourant(t);
etat2=[vel; acc; -debit(t, etage)];

end
