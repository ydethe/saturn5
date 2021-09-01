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
theta2sc1sup=90;%*pi/180;
theta2sc2sup=90;%*pi/180;
theta31sup=90;%*pi/180;
theta32sup=90;%*pi/180;

% Definition du vecteur borne inf Xb
Xb=[thetab2inf theta2sc1inf theta2sc2inf theta31inf theta32inf];

% Definition du vecteur borne sup Xa
Xa=[thetab2sup theta2sc1sup theta2sc2sup theta31sup theta32sup];

global zpvise;
global zavise;
zavise=6378137+185.9e3;
zpvise=6378137+183.2e3;

X = [7.115477172377632  81.224050622968633  91.524271295050724  91.904867943938370];
% nlin_sys(X)
X = fsolve(@nlin_sys, X);

% simulateur(X);
% post_traitement;
