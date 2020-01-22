function [maxVal,meanVal] = CalcDiff(Calibrated,Reference)

[lc,ac,bc] = xyz2lab(Calibrated(1,:),Calibrated(2,:),Calibrated(2,:));

[lr,ar,br] = xyz2lab(Reference(1,:),Reference(2,:),Reference(2,:));

diff = sqrt((lc-lr).^2 +(ac-ar).^2 +(bc-br).^2);
maxVal = max(diff)
meanVal = mean(diff)
end

