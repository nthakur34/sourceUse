function [PBXPoints rowLeafPositions ] = getPBXCoorFromFluenceTG(inflMap, rowLeafPositions, minPBX, PBMaxWidth, colXDivider, rowYDivider, gradsense, MLC, TongueGroove);
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

% LM: JC Sept 19, 2007
% Add MLC modeling part.

if (TongueGroove == 1)
    resolution = 0.5; %mm
else
    resolution = 1;  %mm
end

if (MLC == 1)
[newFluenceMap rowLeafPositions] = mergeFluenceMapTG(inflMap, rowLeafPositions, resolution);
iEND =length(newFluenceMap);
else
    iEND = length(rowLeafPositions)-1;
end

for i=1:iEND

    if (MLC == 1)
        mapdiff = diff(newFluenceMap(i).intensity);
     %   mapdiff = [1, mapdiff, 1];   % Question: "1 seems too big", for Bar2-Compl.mat 
        mapdiff = [max(mapdiff), mapdiff, max(mapdiff)];   % Question: "1 seems too big", for Bar2-Compl.mat 
        mapDiffS = mapdiff;
        tmp = abs(mapDiffS);
    else
        mapdiff = diff(inflMap, 1, 2);
        nRows = size(inflMap,1);
        maxDiff = max(mapdiff(:));
        mapdiff = [ones(nRows, 1)*maxDiff, mapdiff, ones(nRows, 1)*maxDiff];
       % mapdiff = [ones(nRows, 1), mapdiff, ones(nRows, 1)];
        tmp = abs(mapdiff(rowLeafPositions(i),:));
    end

    %if maxDiff == 0 maxDiff = 1; end
    %mapdiff = [1, mapdiff, 1];   % What's the purpose of adding "1"s? could use mapdiff(1) and mapdiff(end) instead?
    
    max_tmp = max(tmp(:));
   % tmp(tmp <= max_tmp/gradsense) = 0;
    tmp(tmp < max_tmp/gradsense) = 0;
    tmp(1) = 1; tmp(end) = 1;
    HighGradRow(i).vectorX = find(tmp);
    HighGradRow(i).vectorXinMM = colXDivider(HighGradRow(i).vectorX);

end

% xMin = floor(min(colXDivider)/PBMaxWidth)*PBMaxWidth;
% xMax = ceil(max(colXDivider)/PBMaxWidth)*PBMaxWidth;
% xDividers = xMin:PBMaxWidth:xMax;
% xDividers = clip(xDividers, min(colXDivider), max(colXDivider), 'limits');

for k = 1:length(HighGradRow)
    PBXPoints(k).vectorX = sort([HighGradRow(k).vectorXinMM]);
    PBs = [];
    for j=1:length(PBXPoints(k).vectorX)-1
        PBs = [PBs unique([PBXPoints(k).vectorX(j):PBMaxWidth:PBXPoints(k).vectorX(j+1) PBXPoints(k).vectorX(j+1)])];
    end
    PBXPoints(k).vectorX = sort(unique(PBs));
    PBXPoints(k).vectorXTresh = PBXPoints(k).vectorX;
%     PBXPoints(k).grad = interp1(colXDivider, mapDiffS(rowLeafPositions(k),:), PBXPoints(k).vectorX);
%     PBXPoints(k).grad = abs(PBXPoints(k).grad);
%     PBXPoints(k).gradMax = max(PBXPoints(k).grad(:)); 
end

return;


% for k = 1:length(HighGradRow)
%     j=2;
%     while j <= length(PBXPoints(k).vectorX)
% %         if ((PBXPoints(k).vectorX(j) - PBXPoints(k).vectorX(j-1)) < minPBX) & (PBXPoints(k).grad(j) < PBXPoints(k).gradMax/20) 
% %             if PBXPoints(k).grad(j) < PBXPoints(k).grad(j-1)
% %                 PBXPoints(k).vectorX(j) = [];  
% %             else
% %                 PBXPoints(k).vectorX(j-1) = [];
% %             end
% %         else            
%             j = j+1;
% %         end
%     end
%     PBXPoints(k).vectorXTresh = PBXPoints(k).vectorX; 
% end