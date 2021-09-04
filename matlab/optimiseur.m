clear all;
ReadExcel;
format long;

% Les paramètres d'optimisation sont les suivants:
%
% thetab2     : angle de basculement
% theta2sc1   : angle de debut d'etage 2
% theta2sc2   : angle de fin d'etage 2
% theta31     : angle de debut d'etage 3
% theta32     : angle de fin d'etage 3

% Bornes inf des variables
thetab2inf=0.;
theta2sc1inf=00;%*pi/180;
theta2sc2inf=10;%*pi/180;
theta31inf=40;%*pi/180;
theta32inf=60;%*pi/180;

% Bornes sup des variables
thetab2sup=20;%*pi/180;
theta2sc1sup=120;%*pi/180;
theta2sc2sup=120;%*pi/180;
theta31sup=120;%*pi/180;
theta32sup=130;%*pi/180;

% Definition du vecteur borne inf Xb
Xb=[thetab2inf theta2sc1inf theta2sc2inf theta32inf];

% Definition du vecteur borne sup Xa
Xa=[thetab2sup theta2sc1sup theta2sc2sup theta32sup];

global zpvise;
global zavise;
zavise=6378137+185.9e3;
zpvise=6378137+183.2e3;

X = [0.079170759672270   0.760135318934298   0.913805672718938   1.001412197906766]*100;
% X = fmincon(@criterePerigee, X,[],[],[],[],Xb,Xa, @supernonlcon);
% X = fmincon(@critereConso, X,[],[],[],[],Xb,Xa, @supernonlcon2);

simulateur(X);
post_traitement;

