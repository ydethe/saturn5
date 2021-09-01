function p=pertes(T, Y)
    global env;
	inci=[];
	gam=[];
	D=[];
	Th=[];
	m=[];
	g=[];
	N=numel(T);
	for i=1:N
   		t=T(i);
   		state=Y(i,:);
    	pos=state(1:3);
    	vel=state(4:6);
        
    	inci = [inci incidenceAbs(state, t)];
    	gam = [gam gammaAbs(state, t)];
    	m = [m state(7)];
    	D = [D trainee(pos, vel, t)];
    	Th = [Th pousse(pos, t)];
    	g = [g norm(gravite(pos))];
    end
    N1=find(T>=env.fusee.etages(2).dateDebut,1,'first');
    N2=find(T>=env.fusee.etages(3).dateDebut,1,'first');
    
	propu1 = trapz(T(1:N1), Th(1:N1)./m(1:N1))
    propu2 = trapz(T(N1+1:N2), Th(N1+1:N2)./m(N1+1:N2))
    propu3 = trapz(T(N2+1:end), Th(N2+1:end)./m(N2+1:end))
    
    trai = trapz(T, -D./m.*cos(inci))
    grav = trapz(T, g.*sin(gam))
    inc = trapz(T, Th./m.*(1-cos(inci)))
    p = trai + grav + inc;
end
