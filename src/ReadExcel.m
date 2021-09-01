global ms1
global me1
global q11
global q12
global q13
global t11
global t12
global t13
global t1i
global is11
global is12
global is13
global s1

global ms2
global me2
global q21
global q22
global q23
global t21
global t22
global t23
global t2i
global is21
global is22
global is23
global s2

global ms3
global me3
global q3
global t3
global t3i
global is3
global s3

global cu

data=xlsread('C:\Users\blaudiy\Downloads\sat5_sim.xlsx', 'matlab', 'B2:N5');

ms1=data(1,1);
me1=data(1,2);
t1i=data(1,3);
t11=data(1,4);
q11=data(1,5);
is11=data(1,6);
t12=data(1,7);
q12=data(1,8);
is12=data(1,9);
t13=data(1,10);
q13=data(1,11);
is13=data(1,12);
s1=data(1,13);

ms2=data(2,1);
me2=data(2,2);
t2i=data(2,3);
t21=data(2,4);
q21=data(2,5);
is21=data(2,6);
t22=data(2,7);
q22=data(2,8);
is22=data(2,9);
t23=data(2,10);
q23=data(2,11);
is23=data(2,12);
s2=data(2,13);

ms3=data(3,1);
me3=data(3,2);
t3i=data(3,3);
t3=data(3,4);
q3=data(3,5);
is3=data(3,6);
s3=data(3,13);

cu=data(4,1);

disp('Donnees de l excel lues avec succes');

