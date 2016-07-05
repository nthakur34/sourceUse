function mask3M = structMargin3D(structNum, margin, planC)
%"structMargin3D"
%   Returns the uniformized mask of structure structNum, with the specified
%   margin added or removed, depending on the sign of margin.
%
%   If margin is +x, x centimeters are added to the mask, if it is -x, x
%   centimeters are removed from the mask.
%
%JRA 3/27/05
%
%Usage:
%   mask3M = structMargin3D(structNum, margin, planC)
%
% Copyright 2010, Joseph O. Deasy, on behalf of the CERR development team.
% 
% This file is part of The Computational Environment for Radiotherapy Research (CERR).
% 
% CERR development has been led by:  Aditya Apte, Divya Khullar, James Alaly, and Joseph O. Deasy.
% 
% CERR has been financially supported by the US National Institutes of Health under multiple grants.
% 
% CERR is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of CERR is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% CERR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with CERR.  If not, see <http://www.gnu.org/licenses/>.

if ~exist('planC')
    global planC
end
indexS = planC{end};

if margin > 0
    sign = 'add';
else
    sign = 'subtract';
end

margin = abs(margin);

originalMask = getUniformStr(structNum, planC);
marginMask = repmat(logical(0), size(originalMask));
%[surfPoints, planC] = getStructureSurfacePoints(structNum, 'yes', planC);
surfPoints = getSurfacePoints(originalMask);

scanSet = getStructureAssociatedScan(structNum, planC);
scanSet = unique(scanSet);

[xV, yV, zV] = getUniformScanXYZVals(planC{indexS.scan}(scanSet));

delta_xy = abs(xV(2)-xV(1));
sliceThickness = abs(zV(2)-zV(1));

c1 = ceil(margin/delta_xy);
c2 = ceil(margin/delta_xy);
c3 = ceil(margin/sliceThickness);

[uM,vM,wM] = meshgrid(- c1 : c1, -c2 : c2, - c3 : c3);

xM = uM * delta_xy;
yM = vM * delta_xy;
zM = wM * sliceThickness;

rM = (xM.^2 + yM.^2 + zM.^2).^0.5;

ball = [rM <= margin];

[iBallV,jBallV,kBallV] = find3d(ball);

sR = size(rM);

deltaV = (sR - 1)/2 +1;

onesV = repmat(logical(1), [1,length(iBallV)]);

iV = surfPoints(:,1);
jV = surfPoints(:,2);
kV = surfPoints(:,3);

sV = size(marginMask);

ind_surfV = sub2ind(sV,iV,jV,kV);

ball_offsetV = (iBallV - deltaV(1)) + sV(1) * (jBallV - deltaV(2)) + sV(1) * sV(2) * (kBallV - deltaV(3));

for i = 1 : length(ind_surfV) %put ones in

  total_indV = ind_surfV(i) + ball_offsetV;

  total_indV = clip(total_indV,1,prod(sV),'limits');

  marginMask(total_indV) = onesV;

end

if strcmpi(sign, 'add')
    mask3M = originalMask | marginMask;
else
    mask3M = originalMask & (~marginMask); 
end
