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
thetab2inf=0.2;
theta2sc1inf=10;%*pi/180;
theta2sc2inf=10;%*pi/180;
theta31inf=40;%*pi/180;
theta32inf=40;%*pi/180;

% Bornes sup des variables
thetab2sup=5;%*pi/180;
theta2sc1sup=90;%*pi/180;
theta2sc2sup=90;%*pi/180;
theta31sup=110;%*pi/180;
theta32sup=180;%*pi/180;

% Definition du vecteur borne inf Xb
Xb=[thetab2inf theta2sc1inf theta2sc2inf theta31inf theta32inf];

% Definition du vecteur borne sup Xa
Xa=[thetab2sup theta2sc1sup theta2sc2sup theta31sup theta32sup];

global zpvise;
zpvise=6628137.;
global zavise;
zavise=42164137;

X = 1e2 * [0.05000000000000   0.54719155000781   0.71104854568181   0.78954716998717   1.01384492718288];

options = optimset('DiffMinChange', 1e-4);

X=fmincon(@criterePerigee, X,[],[],[],[],Xb,Xa,@contraintePerigee,options);
X
X=fmincon(@critereApogee, X,[],[],[],[],Xb,Xa,@contrainteApogee,options);
X

simulateur(X);
post_traitement;


