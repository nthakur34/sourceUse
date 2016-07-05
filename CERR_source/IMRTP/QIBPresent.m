function bool = QIBPresent
%"QIBPresent"
%   Returns true only if the matrix files necessary to run QIB are present 
%   and in the proper location for this copy of CERR.  Else returns false.
%
%   JRA 10/15/04
%
%Usage:
%   function bool = QIBPresent
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

bool = 0;
IMRTPdir = fileparts(which('IMRTP'));
if exist(fullfile(IMRTPdir, 'QIBData', 'aahn6b.dat'), 'file') == 2 & ...
   exist(fullfile(IMRTPdir, 'QIBData', 'aahn18b.dat'), 'file') == 2 & ...
   exist(fullfile(IMRTPdir, 'QIBData', 'QIB_lin_0pt125.mat'), 'file') == 2 & ...
   exist(fullfile(IMRTPdir, 'QIBData', 'QIBGauss_lin_0pt125.mat'), 'file') == 2
   bool = 1;
end