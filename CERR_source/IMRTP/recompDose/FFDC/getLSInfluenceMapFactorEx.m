function [inflMap, colXCoord, rowYCoord, colDividerXCoord, rowDividerYCoord, rowLeafPositions] = getLSInfluenceMapFactorEx(LS,leak,beamIndex)
%"getLSInfluenceMap"
%   Gets an image of the influence generated by the beam described in LS.
%   Use getDICOMLeafPositions to generate LS.
%
%JRA&KZ 02/8/05
%
%Usage:
%   function inflMap = getLSInfluenceMap(LS);
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

%Maximum precision of leaf position, in mm.
precision = .1;

%Get x max, min and round to precision value.
% xMax = ceil(max(vertcat(LS.xLimits{1}),[],1) / precision) * precision;
% xMin = floor(min(vertcat(LS.xLimits{1}),[],1) / precision) * precision;
% fieldSize.x = max(xMax) - min(xMin);
% fieldLim.x  = [max(xMax) min(xMin)];

%Siemens no X jaws exist
if ~isfield(LS,'xLimits')
    xMax = ceil(max(vertcat(LS.xLeafPositions{:}),[],1) / precision) * precision;
    xMin = floor(min(vertcat(LS.xLeafPositions{:}),[],1) / precision) * precision;
    LS.xLimits{1}(1) = xMin;
    LS.xLimits{1}(2) = xMax;
end

xMax = ceil(max(vertcat(LS.xLimits{:}),[],1) / precision) * precision;
xMin = floor(min(vertcat(LS.xLimits{:}),[],1) / precision) * precision;
fieldSize.x = max(xMax) - min(xMin);
fieldLim.x  = [max(xMax) min(xMin)];

yMax = ceil(max(vertcat(LS.yLimits{:}),[],1) / precision) * precision;
yMin = floor(min(vertcat(LS.yLimits{:}),[],1) / precision) * precision;
fieldSize.y = max(yMax) - min(yMin);
fieldLim.y  = [max(yMax) min(yMin)];

yRes = precision;
nyElements = ceil(fieldSize.y/yRes);
xRes = precision;
nxElements = ceil(fieldSize.x/xRes);

inflMap=zeros(nyElements, nxElements);
colDividerXCoord = linspace(fieldLim.x(2), fieldLim.x(1), nxElements+1);
rowDividerYCoord = linspace(fieldLim.y(2), fieldLim.y(1), nyElements+1);

if isfield(LS, 'yLeafPositions')
    rowLeafPositions = round(interp1(rowDividerYCoord, 1:nyElements+1, LS.yLeafPositions,'linear', 'extrap'));
    rowLeafPositions = clip(rowLeafPositions, 1, nyElements+1, 'limits');
    leafBoundariesToKeep = [diff(rowLeafPositions)>0;logical(1)];
    rowLeafPositions = rowLeafPositions(leafBoundariesToKeep);
    leavesToKeep = leafBoundariesToKeep(1:end-1);
else
    %LS.xLeafPositions{1} = [xMin xMax-precision];
    LS.xLeafPositions{1} = [xMin xMax];
    LS.meterSetWeight = {1};
    rowLeafPositions = [1 nyElements+1];
    leavesToKeep = 1;
end

if length(LS.meterSetWeight) == 1
    doses = LS.meterSetWeight{:};
else
    doses = [0 diff([LS.meterSetWeight{:}])];
end

h = waitbar(0,['Generating Fluence Map For Beam ',num2str(beamIndex)]);

for i=1:length(LS.xLeafPositions)
    
    nLeaves = length(LS.xLeafPositions{i})/2;

    if length(LS.xLimits) > 1
        jpL = LS.xLimits{i}(1);
        jpR = LS.xLimits{i}(2);
    else
        jpL = LS.xLimits{1}(1);
        jpR = LS.xLimits{1}(2);
    end

    lpL = LS.xLeafPositions{i}(1:nLeaves);
    lpR = LS.xLeafPositions{i}(nLeaves+1:end);
    lpLK = lpL(leavesToKeep);
    lpRK = lpR(leavesToKeep);
    lpLCols = interp1(colDividerXCoord, 1:nxElements+1, lpLK, 'linear', 'extrap');
    lpRCols = interp1(colDividerXCoord, 1:nxElements+1, lpRK, 'linear', 'extrap');

    %Column divider positions of jaws.
    jpLCol = interp1(colDividerXCoord, 1:nxElements+1, jpL, 'linear', 'extrap');
    jpRCol = interp1(colDividerXCoord, 1:nxElements+1, jpR, 'linear', 'extrap');

    lpLCols = clip(lpLCols, jpLCol, jpRCol, 'limits');
    lpRCols = clip(lpRCols, jpLCol, jpRCol, 'limits');

    lpLCols = round(lpLCols);
    lpRCols = round(lpRCols);

    %head scatter radiation parametrs for varian
    a2 = 0.078;
    beta = 1.79;
    lambda = 7.69;


    for j=1:length(lpLCols)
        %HCF from output ratio for MLC fields Zhu, MedPhys
        YMLC = rowDividerYCoord(rowLeafPositions(j)) + abs((rowDividerYCoord(rowLeafPositions(j+1)) - rowDividerYCoord(rowLeafPositions(j))))/2;
        YMLC = YMLC/10;
        sizeLeaf = abs((rowDividerYCoord(rowLeafPositions(j+1)) - rowDividerYCoord(rowLeafPositions(j))));
        sizeLeaf = sizeLeaf/10;
        HCF_UP = 1 + a2*(erf(2*lpLK(j)*beta/(10*lambda)) +  erf(2*lpRK(j)*beta/(10*lambda)))*(erf(2*(YMLC + sizeLeaf/2)/lambda) - erf(2*(YMLC - sizeLeaf/2)/lambda))/4;
        HCF_Down = 1 + a2*(erf(2*jpL/(10*lambda)) +  erf(2*jpR/(10*lambda)))*(erf(2*(YMLC + sizeLeaf/2)/lambda) - erf(2*(YMLC - sizeLeaf/2)/lambda))/4;
        HCF = HCF_UP/HCF_Down;
        inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, lpLCols(j):lpRCols(j)-1) = inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, lpLCols(j):lpRCols(j)-1) + HCF*doses(i);
        inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, jpLCol:lpLCols(j)-1) = inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, jpLCol:lpLCols(j)-1) + leak*doses(i);
        inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, lpRCols(j):jpRCol-1) = inflMap(rowLeafPositions(j):rowLeafPositions(j+1)-1, lpRCols(j):jpRCol-1) + leak*doses(i);
    end
    
    waitbar(i/length(LS.xLeafPositions));
end
close(h);
colXCoord = colDividerXCoord(1:end-1) + precision/2;
rowYCoord = rowDividerYCoord(1:end-1) + precision/2;