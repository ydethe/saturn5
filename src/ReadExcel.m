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

global cu

data=xlsread('C:\Users\Darkbook\Desktop\projet-lanceur\Etagement\thebestofthebest.xlsm', 'TODO', 'C27:H35');

ms1=data(5,1);
me1=data(4,1);
q11=data(6,1);
q12=data(7,6);
t1=data(7,1);
s1=data(9,1);

ms2=data(5,2);
me2=data(4,2);
q2=data(6,2);
t2=data(7,2);
s2=data(9,2);

ms3=data(5,3);
me3=data(4,3);
q3=data(6,3);
t3=data(7,3);
s3=data(9,3);

cu=data(1,2);

disp('Donnees de l excel lues avec succes');

