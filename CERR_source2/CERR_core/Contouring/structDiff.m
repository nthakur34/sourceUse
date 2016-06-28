function rasterSegs = structDiff(rasterSegs1, rasterSegs2, scanNum, planC)
%"structDiff"
%   Returns rasterSegments that represent all points in the first structure
%   that are NOT contained in the second structure.  Logically this is the 
%   same as the Matlab setDiff command.  This intersect is performed one 
%   slice at a time to save memory.
%
%   By JRA 10/1/03
%
%   rasterSegs1    : rasterSegments of first structure
%   rasterSegs2    : rasterSegments of second structure
%   scanNum        : scan number that rasterSegments are defined on.
%   planC          : CERR planC
%
%   rasterSegs     : rasterSegments of (structure 1) - (structure 2).
%
%Usage:
%   rasterSegs = structDiff(rasterSegs1, rasterSegs2, scanNum, planC)
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


indexS = planC{end};
rasterSegs = [];

%sort input rasterSegments by CTSliceValue
rasterSegs1 = sortrows(rasterSegs1, 6);
rasterSegs2 = sortrows(rasterSegs2, 6);

%get list of CTSlices to iterate over.
slices1 = unique(rasterSegs1(:,6));
slices2 = unique(rasterSegs2(:,6));

%for difference, need to worry about slices where struct1 has segments.
%(struct1 WITHOUT struct2 is meaningless if there is no struct1).
slicesToCalculate = slices1;

%for each slice we are calculating on, create a mask for each structure and
%intersect them. Then convert from that mask to raster segments.
for i=1:length(slicesToCalculate)
    sliceNum = slicesToCalculate(i);
    rasterIndices = find(rasterSegs1(:,6) == sliceNum);
    mask1 = rasterToMask(rasterSegs1(rasterIndices,:), scanNum, planC);
    rasterIndices = find(rasterSegs2(:,6) == sliceNum);
    mask2 = rasterToMask(rasterSegs2(rasterIndices,:), scanNum, planC);
    diffMask = mask1 & ~mask2;
    rasterSegs = [rasterSegs;maskToRaster(diffMask, sliceNum, scanNum, planC)];
end