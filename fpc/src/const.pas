{Saturn V constants for Apollo 14. Steven S. Pietrobon 28 Oct 1996. Revised  9 Jun 1997.}
const {S-IC constants}
  SIC_Mp1  = 2076922; {kg, S-IC propellant mass used}
  SIC_Mp2  =    3287; {kg, S-IC cutoff propellant mass loss}
  SIC_Mnp1 =     312; {kg, S-IC non-propellant mass loss}
  SIC_Mnp2 =     221; {kg, S-II non-propellant mass loss}
  SIC_Mnp3 =      91; {kg, S-IVB non-propellant mass loss}
  SIC_Ms   =  166516; {kg, S-IC separation mass}
  SIC_N    =       5; {no. of engines on S-IC}
  SIC_D    = 10.0584; {m,  S-IC mid-stage diameter}
  SIC_R    =  2.7432; {m,  S-IC nacelle radius}
  SIC_Nn   =       4; {no. of nacelles}
  SIC_Ts   =    0.76; {s,  cutoff to seperation time}

  {S-IC/S-II interstage constants}
  IS1_Mp1  =      33; {kg, propellant mass used before S-IC seperation}
  IS1_Mp2  =     271; {kg, propellant mass used before S-II ignition}
  IS1_Mp3  =     312; {kg, propellant mass used during S-II thrust buildup}
  IS1_Ms   =    3957; {kg, structure mass}
  IS1_N    =       4; {no. of ullage motors on interstage}

  {S-II constants}
  SII_Mp1  =     600; {kg, thrust buildup propellant mass}
  SII_Mp2  =  445634; {kg, mainstage propellant mass used}
  SII_Mp3  =     183; {kg, cutoff propellant mass loss}
  SII_Ms   =   45068; {kg, cutoff mass}
  SII_N    =       5; {no. of engines}
  SII_T1   =     2.0; {s,  thrust buildup time}
  SII_T2   =     4.6; {s,  change O/F ratio from R1 to R2}
  SII_T3   =    28.3; {s,  S-IC/S-II interstage separation}
  SII_T4   =   296.6; {s,  Centre engine cutoff}
  SII_T5   =   307.1; {s,  change O/F ratio to R3}
  SII_Ts   =     1.0; {s,  cutoff to seperation time}
  SII_D    = 10.0584; {m,  S-II diameter}

  {S-IVB constants}
  SIVB_Mp1 =     158; {kg, thrust buildup 1 propellant mass}
  SIVB_Mp2 =  104694; {kg, mainstage propellant mass}
  SIVB_Mp3 =      38; {kg, cutoff 1 propellant mass loss}
  SIVB_Mp4 =    1041; {kg, coast propellant mass loss}
  SIVB_Mp5 =     157; {kg, thrust buildup 2 propellant mass}
  SIVB_Mp6 =      37; {kg, cutoff 2 propellant mass loss}
  SIVB_Ms  =   11627; {kg, empty mass}
  SIVB_Muc =      61; {kg, ullage motor case mass}
  SIVB_Mu1 =       2; {kg, ullage motor propellant used before S-II separation}
  SIVB_Mu2 =      41; {kg, ullage motor propellant used before S-IVB ignition}
  SIVB_Mu3 =      10; {kg, ullage motor propellant used after S_IVB ignition}
  APS_Mp1  =       2; {kg, auxillary propulsion system 1st burn propellant mass}
  APS_Mp2  =       2; {kg, auxillary propulsion system 2nd burn propellant mass}
  APS_T1   =  141.29; {s, 1st burn nominal time}
  APS_T2   =  356.34; {s, 2nd burn nominal time}
  SIVB_T1  =     2.5; {s, 1st burn thrust buildup time}
  SIVB_T2  =     8.4; {s, ullage motor case jettison time}
  SIVB_T3  =     2.5; {s, 2nd burn thrust buildup time}
  SIVB_T4  =   144.5; {s, Change O/F ratio from R6 to R5 in 2nd burn}
  SIVB_Nu  =       2; {no. of ullage motors}
  SIVB_D   =   6.604; {m,  S-IVB diameter}
  SIVB_N   =       1; {no. of engines on S-IVB}

  {Spacecraft constants}
  LES_M    =    4093; {kg, Launch Escape System mass}
  LES_h    =   97600; {m,  LET ejection altitude}
  IU_M     =    2037; {kg, Instrument Unit mass}
  SC_M     =   46347; {kg, Spacecraft mass}

  {F-1 constants. Derived from actual thrust values}
  F1_Fv    = 7866000; {N,   vacuum thrust}
  F1_Fs    = 6874019; {N,   sea level thrust}
  F1_Vv    =    3002; {m/s, vacuum exhaust speed}

  {UM-1 constants}
  UM1_F    =  102309; {N, vacuum thrust}
  UM1_T    =    4.10; {s, total thrust time}

  {J-2 constants for S-II}
  J2_R1    =    5.00; {O/F ratio}
  J2_F1    =  927800; {N,   vacuum thrust}
  J2_V1    =    4167; {m/s, vacuum exhaust speed}
  J2_R2    =    5.50; {O/F ratio}
  J2_F2    = 1038566; {N,   vacuum thrust}
  J2_V2    =    4153; {m/s, vacuum exhaust speed}
  J2_R3    =     4.8; {O/F ratio}
  J2_F3    =  883500; {N,   vacuum thrust}
  J2_V3    =    4174; {m/s, vacuum exhaust speed}
  J2_D     =  1.9558; {m,   nozzle exit diameter}

  {J-2 constants for S-IVB}
  J2_R4    =    5.00; {O/F ratio}
  J2_F4    =  888700; {N,   vacuum thrust}
  J2_V4    =    4176; {m/s, vacuum exhaust speed}
  J2_R5    =    4.50; {O/F ratio}
  J2_F5    =  777900; {N,   vacuum thrust}
  J2_V5    =    4197; {m/s, vacuum exhaust speed}

  {UM-2 constants}
  UM2_F    =   15079; {N, vacuum thrust}
  UM2_T    =    3.87; {s, total thrust time}

  {Launch constants}
  inc      =   28.45; {deg, Kennedy Space Center inclination}
  h_turn   =     110; {m,   pitch over altitude}
  angle1   =    -0.1; {deg, pitch over angle rate for stage 1}
  amax1    =   34.75; {m/s^2, maximum acceleration strain}
  hpmin    =  185200; {m,   minimum orbital altitude}
  hamax  = 400242535; {m,   Lunar apogee altitude}
  Tcoast   =      30; {s,   coasting time}
  angle2   =     170; {deg, orbital angle before TLI}
