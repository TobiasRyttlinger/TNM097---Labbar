%%Load Data
load('Ad.mat')
load('Ad2.mat')


%%Compare the two sensitivity functions 1.1

y = 400:5:700;

plot(y,Ad);
figure
plot(y,Ad2);

%%
load('illum.mat')
load('chips20.mat')

RGB_raw_D65 = Ad' * (chips20.*CIED65)';
RGB_raw2_D65 = Ad2' * (chips20.*CIED65)';

showRGB(RGB_raw_D65');
showRGB(RGB_raw2_D65');


%%

e = ones(1,61);

NormalzationFactor1 = Ad' * e';
NormalzationFactor1 = 1./NormalzationFactor1;
NormalzationFactor2 = Ad2' * e';
NormalzationFactor2 = 1./NormalzationFactor2;


RGB_cal_D65 = RGB_raw_D65.*NormalzationFactor1;
RGB_cal2_D65 = RGB_raw2_D65.*NormalzationFactor2;

showRGB(RGB_cal_D65')
showRGB(RGB_cal2_D65')


%%

plot(y,CIEA)
hold on

plot(y,CIED65)
legend('CIEA','CIED65')
%% 2.4

RGB_raw_A = Ad' * (chips20.*CIEA)';

RGB_cal_A = RGB_raw_A.*NormalzationFactor1;
showRGB(RGB_cal_A')
showRGB(RGB_cal_D65')


%% 2.5

NewNormfactor_A = Ad' * CIEA';
NewNormfactor_A = 1./NewNormfactor_A;
NewNormfactor_D65 = Ad' * CIED65';
NewNormfactor_D65 = 1./NewNormfactor_D65;

RGB_cal_A = RGB_raw_A.* NewNormfactor_A;
RGB_cal_D65 = RGB_raw_D65 .* NewNormfactor_D65;
showRGB(RGB_cal_A')
showRGB(RGB_cal_D65')



%% 3.1

load('xyz.mat')

XYZ_D65_ref = xyz' * (chips20.*e)';
XYZ_norm = xyz'*e';
XYZ_norm = 1./XYZ_norm;
XYZ_cal_D65 = XYZ_D65_ref .* XYZ_norm;
showRGB(XYZ_cal_D65')


%% 3.2

load('M_XYZ2RGB.mat')

MXY_Inverse = inv(M_XYZ2RGB);

XYZ_values = M_XYZ2RGB\RGB_cal_D65;
CalcDiff(XYZ_values,XYZ_D65_ref)



%% 3.3

plot(waverange,Ad);
figure
plot(waverange,xyz);


%% 3.4
D = RGB_cal_D65';
C = XYZ_D65_ref';
A = pinv(D)*C;

XYZ_values = D*A;
save('XYZ_values')
[max,mean]=CalcDiff(XYZ_values',XYZ_D65_ref)

%% 3.5

XYZ_est = Polynomial_regression(RGB_cal_D65,Optimize_poly(RGB_cal_D65,XYZ_D65_ref));

[max,mean] = CalcDiff(XYZ_est,XYZ_D65_ref)






