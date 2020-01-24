function [output] = Linearization(TRCr,TRCg,TRCb,img)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x = 0:0.01:1;
output(:,:,1) = interp1(TRCr,x,img(:,:,1),'pchip');
output(:,:,2) = interp1(TRCg,x,img(:,:,2),'pchip');
output(:,:,3) = interp1(TRCb,x,img(:,:,3),'pchip');
end

