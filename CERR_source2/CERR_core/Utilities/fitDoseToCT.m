function fitDoseM = fitDoseToCT(doseM, doseStruct, scanStruct, dim, offset, maskM)
%"fitDoseToCT"
%   Interpolate a dose to the size of the CT and register it.
%   
%   doseM is the unregistered dose from the 3D dose array (see: calcDoseSlice) 
%   doseStruct is the planC{indexS.dose} struct doseM was derived from.
%   scanStruct is the planC{indexS.scan} struct to register the dose to.
%   dim is the dimension (1,2,3 = x,y,z respectively).
%   maskM is an optional mask to limit the interpolation region.  This
%   allows for more rapid fits in cases where only the dose inside one
%   structure is required.  maskM must be the size of a CT slice or it will
%   not be applied.
%
% Example: fitDoseM = fitDoseToCT(doseM, planC{indexS.dose}(1), planC{indexS.scan}(1), 2)
%          Fits doseM from dose set 1 to scan set 1 in y.
%
%   JRA 11/11/03
%
% fitDoseM = fitDoseToCT(doseM, doseStruct, scanStruct, dim, maskM)
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


if ~exist('offset') 
    offset = 0;
end

%Check for null scans or doses.
if ~isempty(doseStruct)
	%perform a check on the verticalGridInterval, must be negative by spec.
	if doseStruct.verticalGridInterval >= 0
        warning('Vertical grid interval is positive in violation of RTOG spec. Using negative.')
        doseStruct.verticalGridInterval = -doseStruct.verticalGridInterval;
	end
	
	%Get the x,y,z values of the 3D dose.
	%generated by firstPoint:interval:lastPoint
    [doseXVals, doseYVals, doseZVals] = getDoseXYZVals(doseStruct);
else
    %doseStruct is empty.    
end

if ~isempty(scanStruct)    
    scanInfo = scanStruct.scanInfo(1);
    try
        uniformScanInfo = scanStruct.uniformScanInfo;
    catch
        uniformScanInfo = [];    
    end
    
    if isempty(uniformScanInfo) & (dim ~= 3)
        error('No uniformscan info exists.') % maybe create it?
    elseif ~isempty(uniformScanInfo)
     	%Get the z values of the scan set, slightly more complicated
		nCTSlices = abs(uniformScanInfo.sliceNumSup - uniformScanInfo.sliceNumInf) + 1;
		[nSupSlices] = size(getScanArraySuperior(scanStruct), 3);
		if isempty(getScanArraySuperior(scanStruct)), nSupSlices = 0;, end
		
		[nInfSlices] = size(getScanArrayInferior(scanStruct), 3);
		if isempty(getScanArrayInferior(scanStruct)), nInfSlices = 0;, end
		
		nZSlices = nCTSlices + nSupSlices + nInfSlices;
		ctZVals = uniformScanInfo.firstZValue : uniformScanInfo.sliceThickness : uniformScanInfo.sliceThickness * (nZSlices-1) + uniformScanInfo.firstZValue;       
    end

%     sizeDim1 = scanInfo.sizeOfDimension1-1;
%     sizeDim2 = scanInfo.sizeOfDimension2-1;

    [ctXVals, ctYVals, jnk] = getScanXYZVals(scanStruct);
%     
%     %Get the x,y values of the scan set.
% 	ctXVals = scanInfo.xOffset - (sizeDim2*scanInfo.grid2Units)/2 : scanInfo.grid2Units : scanInfo.xOffset + (sizeDim2*scanInfo.grid2Units)/2;
% 	
% 	%flip y vals 
% 	ctYVals = fliplr(scanInfo.yOffset - (sizeDim1*scanInfo.grid1Units)/2 : scanInfo.grid1Units : scanInfo.yOffset + (sizeDim1*scanInfo.grid1Units)/2);
	
else
    ctXVals = doseXVals;
    ctYVals = doseYVals;
    ctZVals = doseZVals;    
end

switch dim
    case 1
        doseColCoords = doseYVals;
        doseRowCoords = doseZVals;
        CTColCoords = ctYVals;
        CTRowCoords = ctZVals;
    case 2
        doseColCoords = doseXVals;
        doseRowCoords = doseZVals;
        CTColCoords = ctXVals;
        CTRowCoords = ctZVals;
    case 3
        doseColCoords = doseXVals;
        doseRowCoords = doseYVals; 
        CTColCoords = ctXVals;
        CTRowCoords = ctYVals;
end

%Sort coordinates/dose to ensure increasing vectors.
[doseColCoords, ind] = sort(doseColCoords);
doseM = doseM(:,ind);
[doseRowCoords, ind] = sort(doseRowCoords);
doseM = doseM(ind,:);

%Find region in CT where dose will exist.  Interpolate over this region.
fitDoseM = repmat(offset, [length(CTRowCoords), length(CTColCoords)]);
%fitDoseM = ones(length(CTRowCoords), length(CTColCoords)) * offset;
indL = logical(uint8(zeros(length(CTRowCoords),length(CTColCoords))));
rowIndices = find( (CTRowCoords < max(doseRowCoords)) & (CTRowCoords > min(doseRowCoords)) );
colIndices = find( (CTColCoords < max(doseColCoords)) & (CTColCoords > min(doseColCoords)) );

indL(min(rowIndices):max(rowIndices),min(colIndices):max(colIndices)) = 1;

%if a mask exists, interpolate only over the mask.
if nargin == 6 & size(maskM) == size(indL)
    indL = indL & maskM;
end

[x,y] = meshgrid(doseColCoords, doseRowCoords);
[ctx, cty] = meshgrid(CTColCoords, CTRowCoords);
interpDose = interp2(x, y, doseM, ctx(indL), cty(indL), 'linear');
fitDoseM(indL) = interpDose;