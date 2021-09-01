function res=vson(pos, t)
    global env;
     [lambda0, phi0, h] = latlong(pos, t);
     if h > 2.3e5
         res=0.1;
     elseif h<-2.5e3
         res=349.76;
     else
         res=interp1(env.atm_info(:,1), env.atm_info(:,3),h);
     end
end
