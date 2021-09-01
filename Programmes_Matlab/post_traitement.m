% Elements de post-traitement. Donne accès aux grandeurs suivantes :
% -le temps :...............................T (s)
% -l'altitude :.............................alt (m)
% -pente de trajectoire :...................gam (deg)
% -l'assiette :.............................pit (deg)
% -la commande :............................theta (deg)
% -l'incidence :............................inci (deg)
% -l'incidence absolue :....................inciAbs (rad)
% -la poussée :.............................pou (N)
% -la pression atmosphérique :..............press (Pa)
% -la masse volumique de l'air locale :.....rr (kg/m3)
% -la masse :...............................mass (kg)
% -le débit :...............................Vdebit (kg/s)
% -le flux thermique :......................flux (W/m2)
% -le nombre de Mach :......................mach (-)
% -la vitesse air :.........................va (m/s)
% -la trainée :.............................drag (N)
% -le coefficient de trainée :..............frtt (-)
% -l'accélération fournie par les moteurs :.acc (m/s2)
% -la pression dynamique :..................pdyn (Pa)

global T;
global Y;

global t2c;
global env;

N=numel(T);
alt=[];
gam=[];
pit=[];
theta=[];
inci=[];
inciAbs=[];
pou=[];
press=[];
acc=[];
rr=[];
mass=[];
Vdebit=[];
x=[];
y=[];
z=[];
vx=[];
vy=[];
vz=[];
flux=[];
mach=[];
va=[];
drag=[];
frtt=[];
acc2=[];
for i=1:N
    pos=Y(i,1:3);
    vel=Y(i,4:6);
    m=Y(i,7);
    t=T(i);
    [lo la h]=latlong(pos,t);
    alt=[alt h];
    gam = [gam 180/pi*gammaAbs(Y(i,:),t)];
    pit = [pit 180/pi*pitch(Y(i,:),t)];
    
    % Vitesse de l'atmosphère dans le repere inertiel
    axe=axePousse(t, pos, vel);
    verticale=RD0_to_REQ(RL0_to_RD0([1, 0, 0]))';
    x=dot(verticale, axe);
    y=norm(cross(verticale,axe));
    theta=[theta 180/pi*atan2(y, x)];
    
    inci(i)=180/pi*incidence(axe, pos, vel, t);
    inciAbs(i)=180/pi*incidenceAbs(Y(i,:), t);
    pou=[pou pousse(pos,t)];
    press=[press pression(pos,t)];
    rr(i)=rho(pos, t);
    mass(i)=m;
    etage=obtEtageCourant(t);
    Vdebit = [Vdebit debit(t, etage)];
    x=[x pos(1)];
    y=[y pos(2)];
    z=[z pos(3)];
    vx=[vx vel(1)];
    vy=[vy vel(2)];
    vz=[vz vel(3)];
    flux=[flux fluxThermique(pos,vel,t)];
    mach=[mach Vair(pos,vel,t)/vson(pos,t)];
    va=[va Vair(pos,vel,t)];
    drag=[drag trainee(pos, vel, t)];
    frtt=[frtt CA(mach(i))];
    Detat = acceleration(t, Y(i,:)');
    acc2=[acc2 norm(Detat(4:6))/norm(gravite(pos))];
    acc=[acc (pousse(pos,t)-trainee(pos, vel, t))/(m*norm(gravite(pos)))];
end
pdyn=0.5.*rr.*va.*va;

vx3=vx(1:3:end);
vy3=vy(1:3:end);
vz3=vz(1:3:end);
alt3=alt(1:3:end);
inci3=inci(1:3:end);

save('vx.txt','vx3','-ASCII');
save('vy.txt','vy3','-ASCII');
save('vz.txt','vz3','-ASCII');
save('alt.txt','alt3','-ASCII');
save('inci.txt','inci3','-ASCII');

pertesdV=pertes(T, Y)

[a e inc Omega omega v] = inertiel_vers_orbparam(Y(end,:));
za=a*(1+e)/1000-6378
zp=a*(1-e)/1000-6378

Vf=norm(Y(end,4:6))

% Période de l'orbite finale atteinte
Trevol = 2*pi*sqrt(abs(a)^3/env.Mu);
% Etat final atteint
Yi=Y(end,:);
ti = T(end);
[Ts,Ys] = ode45(@acceleration, [ti, ti+Trevol*1.1], Yi);
Tlat=[];
Tlong=[];
Ns=numel(Ts);
for i=1:Ns
    poss=Ys(i,1:3);
    [lo la h]=latlong(poss,Ts(i));
    Tlat=[Tlat la*180/pi];
    Tlong=[Tlong lo*180/pi];
end

% figure();
% TraceSol(Tlat, Tlong);
% 
% figure();
% traceEllipse(a*(1-e^2), e, 0, 'r');
% hold on;
% traceEllipse(env.Re, 0, 0, 'b');
% axis equal;
% xlim([-36000000-6378000 6378000+250000]);
% ylim([-2e7 2e7]);
% 

