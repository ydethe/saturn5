function res=rho(pos, t)
    global env;
     [lambda0, phi0, h] = latlong(pos, t);
     if h > 2.3e5
         res=0.;
     elseif h < -2.5e3
         res=1.5473;
     else
         res=interp1(env.atm_info(:,1), env.atm_info(:,2), h);
     end
end
