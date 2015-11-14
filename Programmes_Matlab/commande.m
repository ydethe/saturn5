function c=commande(t)
   global env;
   [ti td theta1,theta2] = obtPhaseCourante(t); 
   etage=obtEtageCourant(t);
   a=(theta2-theta1)/td;
   b=theta1;
   c=a*(t-ti)+b;
end
