{rocket.pas written by Steven S. Pietrobon 23 Oct 1996. Revised 22 Dec 1997,
 17 Aug 2006 (modified for Free Pascals)}

label 99;

const error = 1e-6;
      inf   = 9999;

type path = (air,orb,vac);

var pi,dF,dRp,Fd,x1s,Ar,dt,dp,Me,t0,x0,x1,h0,h1,r0,p0,m0,m1,f0,a,Te,ho:double;
    vi:double;
    mu,gs,As,Tt,Pt,At,vst,Vat,hp,ha,e,sma,maxa,alpha,pow,amax,hmax,Phr:double;
    traj:path;
    iorb,fair:boolean;
    speed,height,question:text;
    continue:char;
    output_name:string;

procedure init;
{Initialisation procedure.
 Steven S. Pietrobon, 24 Jul 1995}
begin{init}
  write('Enter output filename (return is standard output): ');
  readln(output_name);
  assign(output,output_name);
  rewrite(output);
  assign(question,'');
  rewrite(question);

  pi := 4.0*arctan(1.0);
  mu := G*M;
  gs := mu/(Re*Re);
  writeln('gs = ',gs:7:5,' m/s^2, mu = ',(mu/1e9):8:1,' km^3/s^2. ');

  As := gs/(Le*Rg);  {air pressure constant}
  Tt := Ts - Ht*Le; {temperature at Ht}
  Pt := Ps*exp(As*ln(Tt/Ts)); {pressure at Ht}
  At := gs/(Tt*Rg);
  vst := sqrt(Rs*Rg*Tt);  {speed of sound at Ht}
  Vat := Vas*exp(0.75*ln(Tt/Ts)); {absolute coefficient of viscosity at Ht}
  writeln('At Ht Pt = ',round(Pt):5,' Pa, vst = ',vst:6:2,' m/s');

  writeln;
  write('   t      a     vi     h0       r0      alpha  beta  theta     Pq');
  writeln('     m0+Me');
  write('  sec   m/s^2  m/s   metres   metres     deg    deg   deg      Pa');
  writeln('       kg');
  write('-------------------------------------------------------------------');
  write('----------');
  writeln;
end;{init}

procedure trajectory;
{Calculates the incremental trajectory of a rocket.
 Steven S. Pietrobon 24 Jul 1995
 traj = air: Use for all liftoffs (even in a vacuum).
             Rocket follows air velocity vector.
 traj = orb: Angle of attack automatically adjusted to bring
             rocket into orbit. Vacuum or air operation.
 traj = vac: Vacuum only. Rocket follows velocity vector.
 Inputs:    dF  (N/s, change in vacuum thrust)
            Fd  (N, sea level thrust loss)
            dRp (kg/s^2, change in propellant mass rate)
            Ar  (m^2, cross sectional area of rocket)
            x1s (m/s, surface air speed at launch site)
            Re  (m, equatorial radius of planet)
            mu  (m^3/s^2, G*M, gravitational parameter)
            dt  (s, time increment)
            dp  (rad, angle of attack increment)
            Me  (kg, empty mass)
            ho  (1/s^2, orbital reach factor)
            pi  (rad, 180 degrees)
            hmin (m, perigee altitude)
            maxa (maximum angle of attack for orb)
            traj (trajectory type)
            iorb (initialise orbit)
            fair (follow air vector)
            alpha (rad, angle of attack)
            pow (orbital law factor)
 Outputs:   a   (m/s^2, acceleration strain)
            Pq  (Pa, dynamic pressure)
            sma (m, semi-major axis of orbit)
            e   (eccentricty of orbit)
            hp  (m, perigee altitude of orbit)
            ha  (m, apogee altitude of orbit)
 States:    t0  (s, time)
            x0  (m, distance)
            x1  (m/s, distance speed)
            h0  (m, altitude)
            h1  (m/s, altitude speed)
            r0  (m, range)
            p0  (rad, angle of attack offset)
            m0  (kg, propellant mass) 
            m1  (kg/s, propellant rate)
            f0  (N, vacuum thrust) }

var x0t,x1t,h0t,h1t,r0t,p0t,m0t,m1t,f0t:double;
    x0d,x1d,h0d,h1d,r0d,p0d,m0d,m1d,f0d:array[1..4] of double;
    r,x1a,va,theta,temp,thrust,drag,mass,Pq,angle,beta,fp,Dh,Vk,vs:double;
    I,J:integer;

procedure atmosphere(var h:double);
{Determine International Standard Atmosphere pressure, density, viscocity,
 and speed of sound.
 Steven S. Pietrobon, 24 Jul 1995
 Inputs:  As  (gs/(Le*Rg), lower atmosphere pressure constant)
          At  (gs/(Tt*Rg), upper atmosphere pressure constant)
          Ts  (K, surface temperature)
          Tt  (K, stratosphere temperature)
          Ps  (Pa, surface pressure)
          Pt  (Pa, stratosphere pressure)
          Ht  (m, stratosphere height)
          vst (m/s, stratosphere speed of sound)
          h   (m, height)
 Outputs: Phr (pressure relative to surface)
          Dh  (kg/m^3, density at h)
          Vk  (m^2/s, kinematic coefficient of viscosity)
          vs  (m/s, speed of sound)}
var Th,Ph,tmp:double;
begin{atmosphere}
  if h < Ht
    then begin{lower atmosphere}
           Th := Ts - Le*h;
           tmp := ln(Th/Ts);
           Phr := exp(As*tmp);
           Vk := Vas*exp(0.75*tmp);
           tmp := Rg*Th;
           Dh := (Ps*Phr)/tmp;
           vs := sqrt(Rs*tmp);
           Vk := Vk/Dh
         end{lower atmosphere}
    else begin{upper atmosphere}
           Ph := Pt*exp(At*(Ht-h));
           Dh := Ph/(Rg*Tt);
           Phr := Ph/Ps;
           vs := vst;
           if Dh > 0.0
             then Vk := Vat/Dh
             else Vk := inf
         end{upper atmosphere}
end;{atmosphere}

function cd(M:double):double;
{Coefficient of drag from "The Mars Project" by von Braun.
 Inputs:    M   (Mach number)
 Outputs:   cd  (coefficient of drag)}
begin{cd}
  if M < 5
  then case round(M-0.5) of
         0: cd := 0.4;
         1: if M < 1.4
              then cd := 0.8
              else cd := 0.8 - 0.11*(M-1.4)/0.6;
         2: cd := 0.69 - 0.1*(M-2);
         3,4: cd := 0.59 - 0.02*(M-3)
       end{case}
  else cd := 0.55
end;{cd}

begin{trajectory}
  for I := 1 to 4 do
    begin{compute data}
      if I = 1 
        then begin{initialise}
                x0t := x0;
                x1t := x1;
                h0t := h0;
                h1t := h1;
                r0t := r0;
                p0t := p0;
                m0t := m0;
                m1t := m1;
                f0t := f0
              end{initialise}
         else begin{iterate}
                if I = 4
                  then temp := 1
                  else temp := 0.5;
                J := I-1;
                x0t := x0 + x0d[J]*temp;
                x1t := x1 + x1d[J]*temp;
                h0t := h0 + h0d[J]*temp;
                h1t := h1 + h1d[J]*temp;
                r0t := r0 + r0d[J]*temp;
                p0t := p0 + p0d[J]*temp;
                m0t := m0 + m0d[J]*temp;
                m1t := m1 + m1d[J]*temp;
                f0t := f0 + f0d[J]*temp
              end;{iterate}

      r := Re+h0t;
      x0d[I] := x1t*dt;
      h0d[I] := h1t*dt;
      r0d[I] := (x1t*Re/r - x1s)*dt;
      p0d[I] := dp*dt;
      m0d[I] := m1t*dt;
      m1d[I] := dRp*dt;
      f0d[I] := dF*dt;

      beta := arctan(h1t/x1t);
      mass := Me + m0t;
      if (traj = air) or (traj = orb) then
        begin{air drag}
          x1a := x1t - x1s*r/Re;
          va := sqrt(x1a*x1a + h1t*h1t);
          if x1a < error then theta := pi/2
                         else theta := arctan(h1t/x1a);
          atmosphere(h0t);
          thrust := f0t - Fd*Phr;
          Pq := Dh*va*va/2;
          drag := Pq*Ar*cd(va/vs);
        end;{air drag}

      case traj of
        air: begin{air}
               if fair = true
                  then angle := theta + p0t
                  else angle := beta + alpha + p0t;
               x1d[I] := ((thrust*cos(angle)-drag*cos(theta))/mass 
                         - x1t*h1t/r)*dt;
               h1d[I] := ((thrust*sin(angle)-drag*sin(theta))/mass 
                         + x1t*x1t/r - mu/(r*r))*dt
             end;{air}
        orb: begin{orbit}
               if iorb = true then
                 begin{initialise orbital parameter}
                   temp := exp(pow*ln(abs(h1t)));
                   ho := ((thrust*sin(beta+alpha)-drag*h1t/va)/mass 
                         + x1t*x1t/r - mu/(r*r))/temp;
                   iorb := false
                 end;{initialise orbital parameter}
               temp := exp(pow*ln(abs(h1t)))*ho;
               if h1t < 0 then temp := -temp;
               fp := mass*(temp - x1t*x1t/r + mu/(r*r)) + drag*h1t/va;
               if fp+error > thrust 
                 then fp := thrust
                 else if -fp+error > thrust then fp := -thrust;
               if fp > 0 
                 then angle := arctan(1/sqrt(1/sqr(fp/thrust)-1)) - beta
                 else angle := -arctan(1/sqrt(1/sqr(fp/thrust)-1)) - beta;
               if abs(angle) > maxa
                 then begin{max attack}
                        if angle > 0
                          then angle := maxa
                          else angle := -maxa;
                        temp := beta + angle;
                        x1d[I] := ((thrust*cos(temp)-drag*x1a/va)/mass
                                  - x1t*h1t/r)*dt;
                        h1d[I] := ((thrust*sin(temp)-drag*h1t/va)/mass
                                  + x1t*x1t/r - mu/(r*r))*dt
                      end{max attack}
                 else begin{adjust attack}
                        x1d[I] := ((sqrt(sqr(thrust)-fp*fp)-drag*x1a/va)/mass
                                  - x1t*h1t/r)*dt;
                        h1d[I] := temp*dt
                      end{adjust attack}
             end;{orbit}
        vac: begin{vacuum}
               a := f0t/mass;
               temp := beta + p0t;
               x1d[I] := (a*cos(temp) - x1t*h1t/r)*dt;
               h1d[I] := (a*sin(temp) + x1t*x1t/r - mu/(r*r))*dt
             end{vacuum}
      end{case}
    end;{compute data}

  x0 := x0 + (x0d[1] + 2*(x0d[2] + x0d[3]) + x0d[4])/6;
  x1 := x1 + (x1d[1] + 2*(x1d[2] + x1d[3]) + x1d[4])/6;
  h0 := h0 + (h0d[1] + 2*(h0d[2] + h0d[3]) + h0d[4])/6;
  h1 := h1 + (h1d[1] + 2*(h1d[2] + h1d[3]) + h1d[4])/6;
  r0 := r0 + (r0d[1] + 2*(r0d[2] + r0d[3]) + r0d[4])/6;
  p0 := p0 + (p0d[1] + 2*(p0d[2] + p0d[3]) + p0d[4])/6;
  m0 := m0 + (m0d[1] + 2*(m0d[2] + m0d[3]) + m0d[4])/6;
  m1 := m1 + (m1d[1] + 2*(m1d[2] + m1d[3]) + m1d[4])/6;
  f0 := f0 + (f0d[1] + 2*(f0d[2] + f0d[3]) + f0d[4])/6;
  t0 := t0 + dt;

  r := Re+h0;
  vi := sqrt(x1*x1+h1*h1);
  mass := Me + m0;

  beta := arctan(h1/x1);
  x1a := x1 - x1s*r/Re;
  va := sqrt(x1a*x1a + h1*h1);
  if x1a < error then theta := pi/2
                 else theta := arctan(h1/x1a);

  if (traj = air) or (traj = orb)
    then begin{air drag}
           atmosphere(h0);
           Pq := Dh*va*va/2;
           thrust := f0 - Fd*Phr;
           a := thrust/mass
         end{air drag}
    else begin{vacuum}
           Pq := 0.0;
           a := f0/mass
         end;{vacuum}

  case traj of
    air: if fair = true then alpha := theta-beta;
    orb: begin{orbit}
           temp := exp(pow*ln(abs(h1)))*ho;
           if h1 < 0 then temp := -temp;
           fp := mass*(temp - x1*x1/r + mu/(r*r)) + drag*h1/va;
           if fp+error > thrust
             then fp := thrust
             else if -fp+error > thrust then fp := -thrust;
           if fp > 0
             then alpha := arctan(1/sqrt(1/sqr(fp/thrust)-1)) - beta
             else alpha := -arctan(1/sqrt(1/sqr(fp/thrust)-1)) - beta;
           if abs(alpha) > maxa
             then begin{max attack}
                    if alpha > 0
                      then alpha := maxa
                      else alpha := -maxa
                  end{max attack}
         end;{orbit}
    vac: alpha := 0
  end;{case}

  temp := 180.0/pi;
  write(t0:7:2,a:6:1,round(vi):6,round(h0):8,round(r0):10);
  writeln(alpha*temp:7:2,beta*temp:7:2,theta*temp:7:2,Pq:9:1,m0+Me:10:1);
  writeln(speed,t0:7:2,round(vi):6);
  writeln(height,t0:7:2,h0/1000:9:3);

  atmosphere(h0);
  a := (f0 - Fd*Phr)/(Me+m0);
  sma := 1/(2/r - (x1*x1+h1*h1)/mu);
  temp := 1 - sqr(r*x1)/(sma*mu);
  if temp >= 0.0
    then e := sqrt(temp)
    else e := 1.0;
  hp := sma*(1-e)-Re;
  ha := sma*(1+e)-Re
end;{trajectory}


procedure time_traj;
{Determines trajectory for a certain time Te.
 Steven S. Pietrobon 23 Dec 1994}
begin{time traj}
  while Te > dt do
    begin{increment time}
      trajectory;
      Te := Te-dt
    end;{increment time}
  dt := Te;
  trajectory
end;{time traj}

procedure traj_acc;
{Continue trajectory until amax is reached
 Steven S. Pietrobon 11 Jul 1996}
begin{traj acc}
  repeat
    trajectory;
    Te := Te-dt
  until a > amax;
  dt := -dt;
  trajectory;
  Te := Te-dt
end;{traj acc}

procedure traj_height;
{Continue trajectory until hmax is reached
 Steven S. Pietrobon 24 Jul 1995}
begin{traj height}
  repeat
    trajectory;
    Te := Te-dt
  until h0 > hmax;
  dt := -dt;
  trajectory;
  Te := Te-dt
end;{traj height}
