global env;

% Pour les étages, la loi de commande est une droite, définie par l'instant
% de début de fonctionnement, et celui de fin; et par la valeur de la
% commande à ces instants. La commande est l'angle entre la verticale du
% pas de tir et l'axe lanceur. Valeur exprimée en radians

global ms1
global me1
global q11
global q12
global q13
global t1i
global t11
global t12
global t13
global is11
global is12
global is13
global s1

global ms2
global me2
global t2i
global q21
global q22
global q23
global t21
global t22
global t23
global is21
global is22
global is23
global s2

global ms3
global me3
global q3
global t3i
global t3
global is3
global s3

global cu

% Définition étage 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solide

etage1.num = 1;
%Masse de la structure
etage1.Ms=ms1;
%Masse du carburant
etage1.Me=me1;
etage1.ISV=[0 is11 is12 is13];
% Débit en kg/s
% Pour le premier étage : tq entre 1.2 et 1.5 fois le poids du
% lanceur.
etage1.q=[0 q11 q12 q13];
etage1.dateDebut = 0;
etage1.Tcu=[0 t1i t11, t12, t13];
% Ss Section de sortie de la tuyère
etage1.Ss=s1;
%Durée de fonctionnement de l'étage
etage1.duree=t13;

% Définition étage 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solide

etage2.num = 2;
%Masse de la structure
etage2.Ms=ms2;
%Masse du carburant
etage2.Me=me2;
etage2.ISV=[0 is21 is22 is23];
% Débit pour le deuxième étage : tq environ 0.2-0.5 G
etage2.q=[0 q21 q22 q23];
etage2.dateDebut = etage1.dateDebut + etage1.duree;
etage2.Tcu=[0 t2i t21 t22 t23];
% Ss Section de sortie de la tuyère
etage2.Ss=s2;
%Durée de fonctionnement de l'étage
etage2.duree=t23;

% Définition étage 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cryo

etage3.num = 3;
%Masse de la structure
etage3.Ms=ms3;
%Masse du carburant
etage3.Me=me3;
etage3.ISV=[0 is3];
% Débit pour le deuxième étage : tq environ 0.2-0.5 G
etage3.q=[0 q3];
etage3.dateDebut = etage2.dateDebut + etage2.duree;
Tcu=t3;
etage3.Tcu=[0 t3i Tcu];
% Ss Section de sortie de la tuyère
etage3.Ss=s3;
%Durée de fonctionnement de l'étage
etage3.duree=Tcu;

% Définition fusée
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nombre d'étages de la fusée
fusee.etages=[etage1 etage2 etage3];

fusee.Sref = 79.45997;

% Ejout de l'objet fusee à l'environnement
env.fusee=fusee;

% Variables Terre, et
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
env.g0 = 9.81;
env.Re = 6378137.0;
env.Rp = 6356752.0;
env.Mu = 3.986005*10^14;
env.J2 = 1.08263*10^(-3);
env.CJ = 8.777596*10^24;
env.eps=10^(-4);
env.OmegaT = 7.292155*10^(-5);
env.atm_info=importATMdata('Atmosphere_us76.txt');
% env.atm_info=importATMdata('atm_saturn5.txt');

% Paramètres du pas de tir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pdt.latitude=pi/180*28.60838889;
pdt.longitude=pi/180*(-80.64333333);
pdt.altitude=59;
env.pdt=pdt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Paramétrisation de l'optimiseur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Paramètres à optimiser:
% *Azimut
% *Angle de basculement
% *Les theta i et f
% *La CU

% tlancement=0;
% Temps au bout duquel on est arrivé à incidence nulle
global Talph;

global pitch_rate;
pitch_rate=0.728*pi/180;

% Phase 1 : durée de la montée verticale
global tv;
tv=30;

global Az0;
global dAz;
global tAz;
% Az0 = 72.058*pi/180;
% dAz = -0.1368*pi/180;
% tAz = 90;
Az0 = 72.058*pi/180;
dAz = 0*pi/180;
tAz = 10000;

posi=latlong_to_inertiel(env.pdt.longitude, env.pdt.latitude, env.pdt.altitude);
veli=cross([0.; 0.; env.OmegaT], posi);

m=masse();
Y0=[posi; veli; m];

