%anonymize_script.m
%Script to anonymize a CERR plan.
%This script loops over all cells with potential protected health
%information and replaces suspicious fields with a user-input string.
%The following fields should always be viewed suspiciously:
%{'studyNumberOfOrigin','PatientName','caseNumber','archive'}, and are
%automatically searched for and replaced with found by the entered
%replacment string.
%
%LM: JOD, 31 Aug 06 - input dialog.
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

global planC
indexS = planC{end};

PHI = {'studyNumberOfOrigin','PatientName','caseNumber','archive','PatientID'};

newName = inputdlg({'Enter replacement string'});

if ~isempty(newName)

  for i = 1 : length(PHI)
    str = PHI{i};
    planC = anonymize(planC,str,newName);
  end
  
end

cerrUID = createUID('CERR');
for iHeader = 1:length(planC{indexS.header})
    planC{indexS.header}.anonymizedID = cerrUID;
end
