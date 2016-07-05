function [attrData, isDcm] = scanfile_mldcm(filename)
%"scanfile_mldcm"
%   Scans the passed file for DICOM information, reading its contents into
%   a java DicomObject and setting isDcm to 1.  If the file is not a valid
%   DICOM file (determined by checking for existing metaInfo) isDcm returns 
%   0 and dcmObj is [].
%
%JRA 6/1/06
%
%Usage:
%   [dcmObj, isDcm] = scanfile_mldcm(filename, hWaitbar)
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

% import org.dcm4che2.io.*
% import org.dcm4che2.data.*

% testfile = [matlabroot '\toolbox\images\imdemos\CT-MONO2-16-ankle.dcm'];
% dcm = org.dcm4che2.data.BasicDicomObject;
% din = org.dcm4che2.io.DicomInputStream(...
%     java.io.BufferedInputStream(java.io.FileInputStream(testfile)));
% din.readDicomObject(dcm, -1);

%Create a java file object associated with this filename
ifile = java.io.File(filename);
%Create a new BasicDicomObject to hold DICOM data.
%dcmObj = org.dcm4che3.data.Attributes;
%Attributes dcmObj = new Attributes();

isDcm  = int8(1);

%Create a DicomInputStream to read this input file.
try
    in = org.dcm4che3.io.DicomInputStream(ifile);
catch
    disp('happeningCatch');
    isDcm = 0;
    return;
end

%Assume the file is not DICOM to start, if any failures occur along the way
%it will return with this value.

%Try to read the file
%dataWithFMI = org.dcm4che3.data.DatasetWithFMI;
try
    %dataWithFMI = in.readDatasetWithFMI();
    attrData = in.readDataset(-1, -1);
    attrFMI = in.readFileMetaInformation();
    
%     %Extract the metainfo object from the suspected DCM file.
%     metaInfo = dcmObj.fileMetaInfo;
%     metaInfoString = char(metaInfo.toString);
    
    if attrData.isempty
        disp('it is');
        isDcm = 0;
    end
catch
    disp('happening');
end
%Close input stream.
in.close


%Do we need to explicitly delete the invalid dcmObj?  Possibly.
if ~isDcm
    clear attrData;
    clear attrFMI;
    attrData = [];
    attrFMI = [];
end
