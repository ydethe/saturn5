procedure stage3;
{Finds the trajectory of the S-IVB of the Saturn V.
 Steven S. Pietrobon 29 Oct 1996. Revised  9 Jun 1997}
var tmp,vo,time,Rum,Tum,Tco:double;
    ans:char;
begin{stage 3}
  write(question,'S-IVB maximum angle of attack? ');
  readln(maxa);
  maxa := maxa*pi/180;

  f0 := SIVB_Nu*UM2_F;
  Fd := 0.0;
  Ar := pi*sqr(SIVB_D)/4;
  Rum := (SIVB_Mu1+SIVB_Mu2+SIVB_Mu3)/UM2_T;
  m1 := -Rum;
  m0 := SIVB_Mu2;
  Me := SIVB_Mu3 + SIVB_Mp1 + SIVB_Mp2 + SIVB_Mp3 + SIVB_Mp4 + SIVB_Mp5 
        + SIVB_Mp6 + SIVB_Ms + SIVB_Muc + APS_Mp1 + APS_Mp2 + IU_M + SC_M;
  dt := 1.0;
  Te := -m0/m1;
  dp := 0.0;
  dRp := 0.0;
  dF := 0.0;
  traj := air;
  fair := false;
  time_traj;

  writeln('S-IVB Ignition!');
  dF := SIVB_N*J2_F4/SIVB_T1;
  dRp := -2.0*SIVB_Mp1/sqr(SIVB_T1);
  m0 := SIVB_Mu3 + SIVB_Mp1;
  Me := Me - m0;
  dt := 1.0;
  Tum := SIVB_Mu3/Rum;
  if SIVB_T1 < Tum then writeln('Error! SIVB_T1 < Tum');
  Te := Tum;
  time_traj;

  writeln('S-IVB Ullage Motor Cutoff!');
  f0 := f0 - SIVB_Nu*UM2_F;
  m1 := m1 + Rum;
  dt := 1.0;
  Te := SIVB_T1 - Tum;
  time_traj;

  writeln('First S-IVB Mainstage Burn!');
  dF := 0.0;
  dRp := 0.0;
  f0 := SIVB_N*J2_F4;
  m1 := -(f0/J2_V4 + APS_Mp1/APS_T1);
  m0 := SIVB_Mp2 + APS_Mp1;
  Me := Me - m0;
  dt := 1.0;
  traj := orb;
  iorb := true;
  pow := 1.0;
  Te := SIVB_T2 - SIVB_T1;
  time_traj;

  writeln('Ullage Motor Case jettison!');
  Me := Me - SIVB_Muc;
  dt := 1.0;
  vo := sqrt(mu/(Re+hpmin));
  repeat
    trajectory
  until 1.01*vi > vo;

  dt := 0.1;
  repeat
    trajectory
  until 1.001*vi > vo;

  dt := 0.01;
  tmp := sqrt((Me + m0 - SIVB_Mp3)/SIVB_Mp3);
  tmp := J2_V4*arctan(1/tmp)/tmp;
  vo := vo - tmp;
  repeat
    trajectory
  until vi > vo;

  writeln('S-IVB Cutoff! ');
  m0 := m0 + SIVB_Mp3;
  Me := Me - SIVB_Mp3;
  m1 := m1 + APS_Mp1/APS_T1;
  dt := 2.0*J2_V4*SIVB_Mp3/(SIVB_N*J2_F4);
  dF := -SIVB_N*J2_F4/dt;
  dRp := -dF/J2_V4;
  traj := air;
  fair := false;
  tmp := vi;
  trajectory;

  if hp > 0
    then writeln('You have successfully reached low Earth orbit!')
    else writeln('Are you sure you know how to fly this thing?');
  write('Perigee = ',(hp/1000):5:1,' km, ');
  write('Apogee = ',(ha/1000):5:1,' km, ');
  writeln('Average Altitude = ',(hp+ha)/2000:5:1,' km');
  write(question,'Do you wish to go for TLI? ');
  readln(ans);
  if (ans = 'y') or (ans = 'Y') then
    begin{go for TLI}
      dF := 0.0;
      dRp := 0.0;
      f0 := 0.0;
      m1 := 0.0;
      Me := Me - SIVB_Mp4;
      tmp := 1 + e*cos(angle2*pi/180);
      h0 := sma*(1-e*e)/tmp - Re;
      x1 := sqrt(mu*tmp/(Re+h0));
      h1 := -sqrt(mu*(2/(Re+h0) - 1/sma) - x1*x1);
      p0 := 0.0;
      dt := 1.0;
      Te := 60 - t0 + 60*trunc(t0/60);
      traj := vac;
      time_traj;

      writeln('S-IVB Reignition!');
      dF := SIVB_N*J2_F5/SIVB_T3;
      dRp := -2.0*SIVB_Mp5/sqr(SIVB_T3);
      m0 := m0 + SIVB_Mp5;
      Me := Me - SIVB_Mp5;
      dt := 1.0;
      Te := SIVB_T3;
      time_traj;

      writeln('Second S-IVB Mainstage Burn!');
      dF := 0.0;
      dRp := 0.0;
      f0 := SIVB_N*J2_F5;
      m1 := -(f0/J2_V5 + APS_Mp2/APS_T2);
      m0 := m0 + APS_Mp2;
      Me := Me - APS_Mp2;
      dt := 1.0;
      Te := SIVB_T4 - SIVB_T3;
      time_traj;

      writeln('Change O/F ratio from ',J2_R5:4:2,':1 to ',J2_R4:4:2,':1');
      Tco := 2.0*J2_V4*SIVB_Mp6/(SIVB_N*J2_F4);
      dt := Tco;
      dF := SIVB_N*(J2_F4 - J2_F5)/dt;
      dRp := SIVB_N*(J2_F5/J2_V5 - J2_F4/J2_V4)/dt;
      trajectory;

      dF := 0.0;
      dRp := 0.0;
      dt := 1.0;
      repeat
        trajectory
      until 1.01*ha > hamax;
      dt := -1.0;
      trajectory;
      dt := 0.1;
      repeat
        trajectory
      until ha > hamax;

      writeln('S-IVB Cutoff!');
      m0 := m0 + SIVB_Mp6;
      Me := Me - SIVB_Mp6;
      m1 := m1 + APS_Mp2/APS_T2;
      dt := Tco;
      dF := -SIVB_N*J2_F4/Tco;
      dRp := -dF/J2_V4;
      trajectory;

      time := pi*sqrt(sma*sma*sma/mu);
      Te := m0*J2_V4/J2_F4;
      writeln('You are on your way to the Moon!');
      write('Perigee = ',(hp/1000):5:1,' km, ');
      write('Apogee = ',(ha/1000):8:1,' km, ');
      writeln('Travel Time = ',time/(86400):4:2,' days.');
      writeln('There is ',m0:5:1,' kg (',Te:5:2,' seconds) of propellant left.');
      write(question,'Continue? ');
      readln(continue);

      dF := 0.0;
      dRp := 0.0;
      f0 := 0.0;
      m1 := 0.0;
      dt := 1.0;
      Te := Tcoast;
      time_traj
    end{go for TLI}
end;{stage 3}
