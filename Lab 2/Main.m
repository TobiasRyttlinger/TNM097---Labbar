%% Lab 2 1.1
load('TRC_display.mat')
y = 0:0.01:1;
plot(y,TRCr,'r*')
hold on
plot(y,TRCg,'g*')
hold on
plot(y,TRCb,'b*')
legend('RED','GREEN','BLUE')
%% 1.2
load('ramp_display.mat')
load('ramp_linear.mat')

Res = Linearization(TRCr,TRCg,TRCb,Ramp_display);
imshow(Res)
figure
imshow(Ramp_linear)


%% 1.3
Dmax = max(max(Ramp_display));
D(:,:,1) = Dmax(:,:,1)*((Ramp_display(:,:,1)/Dmax(:,:,1)).^(1/2.1));
D(:,:,2) = Dmax(:,:,2)*((Ramp_display(:,:,2)/Dmax(:,:,2)).^(1/2.4));
D(:,:,3) = Dmax(:,:,3)*((Ramp_display(:,:,3)/Dmax(:,:,3)).^(1/1.8));

imshow(D)
%% 2.1

load('DLP.mat')

plot(400:5:700, DLP(:,1),'r')
hold on
plot(400:5:700, DLP(:,2),'g')
hold on
plot(400:5:700, DLP(:,3),'b')
legend('RED','GREEN','BLUE')

%% 2.2
load('DLP.mat');
load('RGB_raw')
load('illum')
load ('xyz.mat');
load ('XYZ_ref');

Srgb =  DLP*RGB_raw;
k = 100/sum(CIED65'.*xyz(:,2));
XYZ_Srgb=k*Srgb'*xyz;

[maxVal,meanVal] = CalcMean(XYZ_Srgb',XYZ_ref);

%% 2.3
load('RGB_cal.mat')

Srgb =  DLP*RGB_cal;
k = 100/sum(CIED65'.*xyz(:,2));
XYZ_Srgb=k*Srgb'*xyz;



[maxVal,meanVal] = CalcMean(XYZ_Srgb',XYZ_ref)
%% 3.1
load('xyz')
load('RGB_cal.mat')
load('DLP.mat')
load('illum.mat')

Acrt = xyz'*DLP;
k = 100/sum(CIED65'.*xyz(:,2));
Acrt_cal = k*Acrt;

%% 3.2
load('XYZ_ref')
load('XYZ_est')

D_prim = Acrt_cal\XYZ_est;

S_rgb = DLP*D_prim;

XYZ_Srgb=k*S_rgb'*xyz;

[maxVal,meanVal] = CalcMean(XYZ_Srgb',XYZ_ref)
%% 3.3
plot(D_prim)

%% 3.4
D_prim(D_prim > 1.0) = 1.0;
D_prim(D_prim < 0.0) = 0.0;

S_rgb= DLP*D_prim;
XYZ_Srgb =k*S_rgb'*xyz;
plot(S_rgb)
[maxVal,meanVal] = CalcMean(XYZ_Srgb',XYZ_ref);
%% 3.5
plot_chrom_sRGB(Acrt_cal);

%% 3.6
[maxVal,meanVal] = CalcMean(XYZ_Srgb',XYZ_ref);
plot(400:5:700, S_rgb(:,1))
hold on
plot(400:5:700, chips20(1,:).*CIED65);
legend('Srgb','Chips20D65')



