function [maxVal,meanVal] = CalcMean(Calibrated,Reference)
[lc,ac,bc] = xyz2lab(Calibrated(1,:),Calibrated(2,:),Calibrated(3,:));
[lr,ar,br] = xyz2lab(Reference(1,:),Reference(2,:),Reference(3,:));
diff = sqrt((lc-lr).^2 +(ac-ar).^2 +(bc-br).^2);
maxVal = max(diff)
meanVal = mean(diff)
diff
end

