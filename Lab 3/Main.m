%%Lab 3
% 1. Color Gamut
%Disscuss which device is better!
load('Dell.mat');
load('Inkjet.mat')
plot_chrom(XYZdell,'r');

plot_chrom(XYZinkjet,'g');


%The dell is more effecient in producing the color red for example because
%its color gamut reaches out more towards the red corner. This is totally
%dependand on what color we want to reproduce. Overall i would say that the
%inkjet printer is better because it can produce colors that the dell
%screen cann not even though the printer has hard time to produce blue.


%% 2. Mathematical metrics

% 2.1 Grayscale image(MSE/SNR)

img = imread('peppers_gray.tif');
img = im2double(img);

%NearestNeighbour
Nearest_img = imresize(imresize(img,0.25,'nearest'),4,'nearest');

%bilinear
Bilinear_img = imresize(imresize(img,0.25,'bilinear'),4,'bilinear');

%bicubic
Bicubic_img = imresize(imresize(img,0.25,'bicubic'),4,'bicubic');


noise_Nearest = img - Nearest_img;
noise_Bilinear = img - Bilinear_img;
noise_Bicubic = img - Bicubic_img;

% imshow(Nearest_img)
% figure
% imshow(Bilinear_img)
% figure
% imshow(Bicubic_img)

Nearest_Snr = mysnr(img,noise_Nearest)
Bilinear_Snr = mysnr(img,noise_Bilinear)
Bicubic_Snr = mysnr(img,noise_Bicubic)

%The Snr corresponds good to the percieved reproduced quality of the
%images. Because we get to low SNR on the nearest neighbour method compared
%to the bicubic and bilinear method.


%% 2.1.2

img = imread('peppers_gray.tif');
img = im2double(img);

Halftoned_img = img >= 0.5;
Dither_img = dither(img);
Dither_img = im2double(Dither_img);
Halftoned_img = im2double(Halftoned_img);

imshow(Halftoned_img)
figure
imshow(Dither_img)

noise_Halftoned = img - Halftoned_img;
noise_Dither = img - Dither_img;

Halftoned_Snr = mysnr(img,noise_Halftoned)
Dither_Snr = mysnr(img,noise_Dither)

%The result differ alot from the percieved quality of the reproduction,
%This might because of the noisy nature of the dither image.


%% 2.2 Color image

img = imread('peppers_color.tif');
img = im2double(img);


Halftoned_img = img >= 0.5;
Dither_img(:,:,1) = dither(img(:,:,1));
Dither_img(:,:,2) = dither(img(:,:,2));
Dither_img(:,:,3) = dither(img(:,:,3));
Dither_img = im2double(Dither_img);
Halftoned_img = im2double(Halftoned_img);

Haltone_Lab = rgb2lab(Halftoned_img);
Dither_Lab = rgb2lab(Dither_img);
imglab = rgb2lab(img);

E_halftone = sqrt((Haltone_Lab(:,:,1)-imglab(:,:,1)).^2 +(Haltone_Lab(:,:,2)-imglab(:,:,2)).^2 +(Haltone_Lab(:,:,3)-imglab(:,:,3)).^2);

E_dither = sqrt((Dither_Lab(:,:,1)-imglab(:,:,1)).^2 +(Dither_Lab(:,:,2)-imglab(:,:,2)).^2 +(Dither_Lab(:,:,3)-imglab(:,:,3)).^2);
meanDither = (1/(512*512))*sum(sum(E_dither))
meanHalftone = (1/(512*512))*sum(sum(E_halftone))

imshow(Dither_img)
figure
imshow(Halftoned_img)



%% 3. Mathematical metrics involving HVS

img = imread('peppers_gray.tif');
img = im2double(img);

Halftoned_img = img >= 0.5;
Dither_img = dither(img);
Dither_img = im2double(Dither_img);
Halftoned_img = im2double(Halftoned_img);

noise_Halftoned = img - Halftoned_img;
noise_Dither = img - Dither_img;

Halftoned_Snr = snr_filter(img,noise_Halftoned)
Dither_Snr = snr_filter(img,noise_Dither)

%% 3.1

img = imread('peppers_color.tif');
img = im2double(img);
f = MFTsp(15,0.0847,500);

%HSV original image HVS
imgHvs(:,:,1) = conv2(img(:,:,1),f,'same');
imgHvs(:,:,2) = conv2(img(:,:,2),f,'same');
imgHvs(:,:,3) = conv2(img(:,:,3),f,'same');

%threshold original image
imgThresh(:,:,1)=(imgHvs(:,:,1)>0).*imgHvs(:,:,1);
imgThresh(:,:,2)=(imgHvs(:,:,2)>0).*imgHvs(:,:,2);
imgThresh(:,:,3)=(imgHvs(:,:,3)>0).*imgHvs(:,:,3);

%Original to Lab
imglabHSV = rgb2lab(imgThresh);

%Hsv Dither Image HVS
Dither_img(:,:,1) = conv2(dither(img(:,:,1)),f,'same');
Dither_img(:,:,2) = conv2(dither(img(:,:,2)),f,'same');
Dither_img(:,:,3) = conv2(dither(img(:,:,3)),f,'same');

%threshold Dither image
Dither_img(:,:,1)=(Dither_img(:,:,1)>0).*Dither_img(:,:,1);
Dither_img(:,:,2)=(Dither_img(:,:,2)>0).*Dither_img(:,:,2);
Dither_img(:,:,3)=(Dither_img(:,:,3)>0).*Dither_img(:,:,3);
Dither_img = im2double(Dither_img);

%Halftone original image HVS
Halftoned_img = img >= 0.5;
Halftoned_img(:,:,1) = conv2(Halftoned_img(:,:,1),f,'same');
Halftoned_img(:,:,2) = conv2(Halftoned_img(:,:,2),f,'same');
Halftoned_img(:,:,3) = conv2(Halftoned_img(:,:,3),f,'same');

%threshold Dither image
Halftoned_img(:,:,1)=(Halftoned_img(:,:,1)>0).*Halftoned_img(:,:,1);
Halftoned_img(:,:,2)=(Halftoned_img(:,:,2)>0).*Halftoned_img(:,:,2);
Halftoned_img(:,:,3)=(Halftoned_img(:,:,3)>0).*Halftoned_img(:,:,3);
Halftoned_img = im2double(Halftoned_img);

%Convert halftone and dither to lab
Haltone_Lab = rgb2lab(Halftoned_img);
Dither_Lab = rgb2lab(Dither_img);

E_halftone = sqrt((Haltone_Lab(:,:,1)-imglabHSV(:,:,1)).^2 +(Haltone_Lab(:,:,2)-imglabHSV(:,:,2)).^2 +(Haltone_Lab(:,:,3)-imglabHSV(:,:,3)).^2);

E_dither = sqrt((Dither_Lab(:,:,1)-imglabHSV(:,:,1)).^2 +(Dither_Lab(:,:,2)-imglabHSV(:,:,2)).^2 +(Dither_Lab(:,:,3)-imglabHSV(:,:,3)).^2);

meanDither = (1/(512*512))*sum(sum(E_dither))
meanHalftone = (1/(512*512))*sum(sum(E_halftone))

%% 4.ScieLab
















