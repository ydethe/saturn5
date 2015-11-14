global env;

% Pour les �tages, la loi de commande est une droite, d�finie par l'instant
% de d�but de fonctionnement, et celui de fin; et par la valeur de la
% commande � ces instants. La commande est l'angle entre la verticale du
% pas de tir et l'axe lanceur. Valeur exprim�e en radians

global ms1
global me1
global q11
global q12
global t1
global s1

global ms2
global me2
global q2
global t2
global s2

global ms3
global me3
global q3
global t3
global s3

% D�finition �tage 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solide

etage1.num = 1;
%Masse de la structure
etage1.Ms=ms1;
%Masse du carburant
etage1.Me=me1;
etage1.ISP=288*0.92;
% D�bit en kg/s
% Pour le premier �tage : tq entre 1.2 et 1.5 fois le poids du
% lanceur.
etage1.q(1)=q11;
etage1.q(2)=q12;
etage1.dateDebut = 0;
Tcu=t1;
etage1.Tcu=[0 Tcu/3 Tcu];
% Ss Section de sortie de la tuy�re
etage1.Ss=s1;
%Dur�e de fonctionnement de l'�tage
etage1.duree=Tcu;

% D�finition �tage 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solide

etage2.num = 2;
%Masse de la structure
etage2.Ms=ms2;
%Masse du carburant
etage2.Me=me2;
etage2.ISP=315.6*0.92;
% D�bit pour le deuxi�me �tage : tq environ 0.2-0.5 G
etage2.q=[q2];
etage2.dateDebut = etage1.dateDebut + etage1.duree;
Tcu=t2;
etage2.Tcu=[0 Tcu];
% Ss Section de sortie de la tuy�re
etage2.Ss=s2;
%Dur�e de fonctionnement de l'�tage
etage2.duree=Tcu;

% D�finition �tage 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cryo

etage3.num = 3;
%Masse de la structure
etage3.Ms=ms3;
%Masse du carburant
etage3.Me=me3;
etage3.ISP=469.90*0.95;
% D�bit pour le deuxi�me �tage : tq environ 0.2-0.5 G
etage3.q=[q3];
etage3.dateDebut = etage2.dateDebut + etage2.duree;
Tcu=t3;
etage3.Tcu=[0 Tcu];
% Ss Section de sortie de la tuy�re
etage3.Ss=s3;
%Dur�e de fonctionnement de l'�tage
etage3.duree=Tcu;

% D�finition fus�e
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nombre d'�tages de la fus�e
fusee.etages=[etage1 etage2 etage3];
% Masse de la coiffe
fusee.coiffe_masse=421.941;
fusee.Sref = 8.501;

% Ejout de l'objet fusee � l'environnement
env.fusee=fusee;

% Flux thermique seuil
env.fluxSeuil = 1500;

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

% Param�tres du pas de tir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pdt.latitude=pi/180*5.24;
pdt.longitude=pi/180*(-52.76);
pdt.altitude=0;
env.pdt=pdt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Param�trisation de l'optimiseur
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Param�tres � optimiser:
% *Azimut
% *Angle de basculement
% *Les theta i et f
% *La CU

% tlancement=0;
% Temps au bout duquel on est arriv� � incidence nulle
global Talph;

% Phase 1 : dur�e de la mont�e verticale
global tv;
tv=5;

% Phase 2 : dur�e du basculement
global tb;
tb=5;

global Az;
Az=pi/2;

posi=latlong_to_inertiel(env.pdt.longitude, env.pdt.latitude, env.pdt.altitude);
veli=cross([0.; 0.; env.OmegaT], posi);

m=masse();
Y0=[posi; veli; m];

