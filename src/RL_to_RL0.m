function y=RL_to_RL0(xL0, theta)
    % Le parametre theta est la commande
    x=xL0(1);
    y=xL0(2);
    z=xL0(3);

    xp=cos(theta)*x - sin(theta)*y;
    yp=sin(theta)*x + cos(theta)*y;
    zp=z;
    y=[xp yp zp];
end
