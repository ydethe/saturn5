procedure stage2;
{Finds the trajectory of the S-II for the Saturn V.
 Steven S. Pietrobon 28 Oct 1996. Revised  9 Jun 1997}
var Rum,Tum,Tco:double;
begin{stage 2}
  write(question,'S-II maximum angle of attack? ');
  readln(maxa);
  maxa := maxa*pi/180;

  f0 := IS1_N*UM1_F;
  Fd := 0.0;
  Ar := pi*sqr(SII_D)/4;
  Rum := (IS1_Mp1+IS1_Mp2+IS1_Mp3)/UM1_T;
  m1 := -Rum;
  m0 := IS1_Mp2;
  Me := IS1_Mp3 + IS1_Ms + SII_Mp1 + SII_Mp2 + SII_Mp3 + SII_Ms + SIVB_Mu1 
        + SIVB_Mu2 + SIVB_Mu3 + SIVB_Mp1 + SIVB_Mp2 + SIVB_Mp3 + SIVB_Mp4 
        + SIVB_Mp5 + SIVB_Mp6 + SIVB_Ms + SIVB_Muc + APS_Mp1 + APS_Mp2 + LES_M 
        + IU_M + SC_M;
  dp := 0.0;
  dRp := 0.0;
  dF := 0.0;
  dt := 1.0;
  Te := IS1_Mp2/Rum;
  traj := air;
  fair := false;
  time_traj;

  writeln('S-II Ignition!');
  Tum := IS1_Mp3/Rum;
  if SII_T1 > Tum then writeln('Error! SII_T1 > Tum');
  dF := SII_N*J2_F1/SII_T1;
  dRp := -2.0*SII_Mp1/sqr(SII_T1);
  m0 := IS1_Mp3 + SII_Mp1;
  Me := Me-m0;
  dt := 1.0;
  Te := SII_T1;
  time_traj;

  writeln('S-II Mainstage!');
  dF := 0.0;
  dRp := 0.0;
  m1 := -Rum - SII_N*J2_F1/J2_V1;
  Fd := SII_N*Ps*pi*sqr(J2_D)/4;
  m0 := SII_Mp2;
  Me := Me - m0;
  dt := 1.0;
  Te := Tum - SII_T1;
  traj := orb;
  iorb := true;
  pow := 2.0;
  time_traj;

  writeln('S-IC/S-II Ullage Motor Cutoff!');
  f0 := f0 - IS1_N*UM1_F;
  m1 := m1 + Rum;
  dt := 1.0;
  Te := SII_T2 - Tum;
  time_traj;

  writeln('Change O/F ratio from ',J2_R1:4:2,':1 to ',J2_R2:4:2,':1');
  Tco := 2.0*J2_V3*SII_Mp3/((SII_N-1)*J2_F3);
  if SII_Ts < Tco then writeln('Error! SII_Ts < Tco');
  dt := Tco;
  dF := SII_N*(J2_F2 - J2_F1)/dt;
  dRp := SII_N*(J2_F1/J2_V1 - J2_F2/J2_V2)/dt;
  trajectory;

  dF := 0.0;
  dRp := 0.0;
  dt := 1.0;
  Te := SII_T3 - SII_T2 - dt;
  iorb := true;
  time_traj;

  writeln('S-IC/S-II Interstage Separation!');
  Me := Me - IS1_Ms;
  Te := SII_T4 - SII_T3;
  dt := 1.0;
  hmax := LES_h;
  traj_height;
  dt := 0.1;
  traj_height;
  dt := 0.01;
  traj_height;

  writeln('LET Jettison!');
  dt := 1.0;
  Me := Me - LES_M;
  time_traj;

  writeln('S-II Centre Engine Cutoff!');
  dt := Tco;
  dF := -J2_F2/dt;
  dRp := -dF/J2_V2;
  trajectory;

  dF := 0.0;
  dRp := 0.0;
  Fd := (SII_N-1)*Fd/SII_N;
  Te := SII_T5 - SII_T4 - dt;
  dt := 1.0;
  iorb := true;
  pow := 1.5;
  time_traj;

  writeln('Change O/F ratio to ',J2_R3:4:2,':1');
  dt := Tco;
  dF := (SII_N-1)*(J2_F3 - J2_F2)/dt;
  dRp := (SII_N-1)*(J2_F2/J2_V2 - J2_F3/J2_V3)/dt;
  trajectory;

  dF := 0.0;
  dRp := 0.0;
  Te := -m0/m1;
  dt := 1.0;
  iorb := true;
  time_traj;

  writeln('S-II Engine Cutoff!');
  Fd := 0.0;
  m0 := SII_Mp3;
  Me := Me - m0;
  dt := Tco;
  dF := -(SII_N-1)*J2_F3/dt;
  dRp := -dF/J2_V3;
  traj := air;
  fair := false;
  trajectory;

  dF := 0.0;
  dRp := 0.0;
  m0 := SIVB_Mu1;
  Me := Me - m0;
  Rum := (SIVB_Mu1+SIVB_Mu2+SIVB_Mu3)/UM2_T;
  Tum := SIVB_Mu1/Rum;
  dt := SII_Ts - Tum - Tco;
  trajectory;

  writeln('S-IVB Ullage Motor Ignition!');
  f0 := f0 + SIVB_Nu*UM2_F;
  m1 := m1 - Rum;
  dt := Tum;
  trajectory;

  writeln('S-II Seperation')
end;{stage 2}
