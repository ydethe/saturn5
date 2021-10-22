procedure stage1;
{Finds the trajectory of the S-IC for the Saturn V.
 Steven S. Pietrobon 28 Oct 1996. Revised  9 Jun 1997}
var Mnp,Tum,Rum,ta,th,tb,Tco:double;
begin{stage 1}
  f0 := SIC_N*F1_Fv;
  Mnp := SIC_Mnp1 + SIC_Mnp2 + SIC_Mnp3;
  Fd := SIC_N*(F1_Fv-F1_Fs);
  x1s := cos(inc*pi/180)*2*pi*Re/T;
  th := SIC_D/2;
  tb := SIC_R;
  ta := arctan(tb*sqrt(4*th*th-tb*tb)/(2*th*th-tb*tb));
  Ar := pi*th*th + SIC_Nn*(tb*tb*(ta+pi)/2 - th*th*ta + tb*th);
  Me := SIC_Mp2 + SIC_Ms + IS1_Mp1 + IS1_Mp2 + IS1_Mp3 + IS1_Ms + SII_Mp1 
        + SII_Mp2 + SII_Mp3 + SII_Ms + SIVB_Mu1 + SIVB_Mu2 + SIVB_Mu3
        + SIVB_Mp1 + SIVB_Mp2 + SIVB_Mp3 + SIVB_Mp4 + SIVB_Mp5 + SIVB_Mp6 
        + SIVB_Ms + SIVB_Muc + APS_Mp1 + APS_Mp2 + LES_M + IU_M + SC_M;
  t0 := 0.0;
  x0 := 0.0;
  x1 := x1s;
  h0 := 0.0;
  h1 := 0.0;
  r0 := 0.0;
  p0 := 0.0;
  m0 := SIC_Mp1 + Mnp;
  dRp := 0.0;
  dF := 0.0;
  write(t0:7:2,0.0:6:1,0:6,round(h0):8,round(r0):10);
  writeln(90.0:7:2,0.0:7:2,90.0:7:2,0.0:9:1,m0+Me:10:1);

  write(question,'Turn time (s)? ');
  readln(ta);
  if ta < 0 then exit;

  writeln('Lift off!');
  dt := 1.0;
  dp := 0.0;
  traj := air;
  fair := true;
  Te := sqrt(2.0*h_turn/((f0-Fd)/(Me+m0)-gs));
  m1 := -(f0/F1_Vv + Mnp/Te);
  time_traj;

  writeln('Pitch over!');
  m1 := -f0/F1_Vv;
  dt := 1.0;
  dp := angle1*pi/180;
  trajectory;
  dp := 0.0;
  Te := ta;
  time_traj;
  Te := 1.0-Te;
  dt := 1.0;
  dp := -angle1*pi/180;
  trajectory;

  writeln('End turn.');
  dt := Te;
  dp := 0.0;
  trajectory;
  dt := 1.0;
  amax := amax1;
  traj_acc;
  dt := 0.1;
  traj_acc;
  dt := 0.01;
  traj_acc;

  writeln('S-IC Centre Engine Cutoff!');
  Tco := 2.0*F1_Vv*SIC_Mp2/((SIC_N-1)*F1_Fv);
  if SIC_Ts < Tco then writeln('Error! SIC_Ts < Tco');
  dt := Tco;
  dF := -F1_Fv/dt;
  dRp := -dF/F1_Vv;
  trajectory;

  dF := 0.0;
  dRp := 0.0;
  Fd := (SIC_N-1)*(F1_Fv-F1_Fs);
  dt := 1.0;
  Te := -m0/m1;
  time_traj;

  writeln('S-IC Outboard Engine Cutoff!');
  Rum := (IS1_Mp1+IS1_Mp2+IS1_Mp3)/UM1_T;
  Tum := IS1_Mp1/Rum;
  dt := SIC_Ts-Tum;
  if dt > Tco then writeln('Error! SIC_Ts > Tum + Tco');
  Fd := 0.0;
  dF := -(SIC_N-1)*F1_Fv/Tco;
  dRp := -dF/F1_Vv;
  Me := Me - SIC_Mp2;
  m0 := SIC_Mp2;
  fair := false;
  trajectory;

  writeln('S-IC/S-II Ullage Motor Ignition!');
  dt := Tco - dt;
  f0 := f0 + IS1_N*UM1_F;
  m1 := m1 - Rum;
  Me := Me - IS1_Mp1;
  m0 := m0 + IS1_Mp1;
  trajectory;

  dt := Tum - dt;
  dF := 0.0;
  dRp := 0.0;
  trajectory;

  writeln('S-IC Separation!')
end;{stage 1}
