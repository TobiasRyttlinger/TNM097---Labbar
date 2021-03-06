%%Load Data
load('Ad.mat')
load('Ad2.mat')


%%Compare the two sensitivity functions 1.1

y = 400:5:700;

plot(y,Ad(:,1),'r');
hold on
plot(y,Ad(:,2),'g');
hold on
plot(y,Ad(:,3),'b');
legend('Red','Green','Blue')
figure
plot(y,Ad2(:,1),'r');
hold on
plot(y,Ad2(:,2),'g');
hold on
plot(y,Ad2(:,3),'b');
legend('Red','Green','Blue')

%No the result will differ a bit Ad2 will give more green and a little red
%over the entire spectra 
%% 1.2
load('illum.mat')
load('chips20.mat')

RGB_raw_D65 = Ad' * (chips20.*CIED65)';
RGB_raw2_D65 = Ad2' * (chips20.*CIED65)';
showRGB(RGB_raw_D65');
showRGB(RGB_raw2_D65');

%Ad2 makes one of the RGB_raw images much more green because green is
%covering the most of AD2's spectra. meanwhile the other image is better
%represented in colordifference.

%% 2.1

e = ones(1,61);

NormalzationFactor1 = Ad' * e'
NormalzationFactor1 = 1./NormalzationFactor1;
NormalzationFactor2 = Ad2' * e'
NormalzationFactor2 = 1./NormalzationFactor2;


%% 2.2

RGB_cal_D65 = RGB_raw_D65.*NormalzationFactor1;
RGB_cal2_D65 = RGB_raw2_D65.*NormalzationFactor2;


showRGB(RGB_cal_D65')
showRGB(RGB_cal2_D65')

%Seems to work fine the error has been fixed with the help of white point
%calibration

%% 2.3

plot(y,CIEA)
hold on

plot(y,CIED65)
legend('CIEA','CIED65')
%Indoor light is mostly more warm in its color which is represented well in
%the plot

%% 2.4

RGB_raw_A = Ad' * (chips20.*CIEA)';

RGB_cal_A = RGB_raw_A.*NormalzationFactor1;

showRGB(RGB_cal_A')
showRGB(RGB_cal_D65')
RGB_cal_D65
%The result looks different because it is not possible to get a correct
%white point normalization for indoor lights.

%% 2.5

NewNormfactor_A = Ad' * CIEA';
NewNormfactor_A = 1./NewNormfactor_A;
NewNormfactor_D65 = Ad' * CIED65';
NewNormfactor_D65 = 1./NewNormfactor_D65

RGB_cal_A = RGB_raw_A.* NewNormfactor_A;
RGB_cal_D65 = RGB_raw_D65 .* NewNormfactor_D65;
showRGB(RGB_cal_A')
showRGB(RGB_cal_D65')

%Result looks much better when normalizing depending on the lightsource

%% 3.1

load('xyz.mat')

XYZ_norm = xyz(:,2)'*CIED65';
XYZ_norm = 100/sum(XYZ_norm);
XYZ_D65_ref = xyz' * (chips20.*CIED65)';


XYZ_cal_D65 = XYZ_D65_ref * XYZ_norm



%% 3.2

load('M_XYZ2RGB.mat')

XYZ_cal_D65a= inv(M_XYZ2RGB)*RGB_cal_D65;
CalcDiff(XYZ_cal_D65a,XYZ_cal_D65)



%% 3.3

plot(waverange,Ad(:,1),'r');
hold on
plot(waverange,Ad(:,2),'g');
hold on
plot(waverange,Ad(:,3),'b');
legend('Red','Green','Blue')
figure
plot(waverange,xyz(:,1));
hold on
plot(waverange,xyz(:,2));
hold on
plot(waverange,xyz(:,3));
hold on
legend('x','y','z')
%They differ alot!

%% 3.4
D = RGB_cal_D65';
C = XYZ_cal_D65';
A = pinv(D)*C;

XYZ_values = D*A;
CalcDiff(XYZ_values',XYZ_cal_D65);

%% 3.5

XYZ_est = Polynomial_regression(RGB_cal_D65,Optimize_poly(RGB_cal_D65,XYZ_cal_D65));

[max,mean] = CalcDiff(XYZ_est,XYZ_cal_D65)






