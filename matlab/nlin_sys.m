function y=nlin_sys(X)
global zpvise
global zavise
[za, zp, a, e, mf, pdynmax, fluxmax] = simulateur(X);
y(1)=za-zavise;
y(2)=zp-zpvise;
y(3)=pdynmax-3589.41433*9.81;
y(4)=fluxmax-18535548;
X
y
end
