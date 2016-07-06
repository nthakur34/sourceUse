function data = getTagValue(attr, tag)
%"dcm2ml_element"
%   Convert a Java SimpleDicomElement object into a Matlab datatype.
%
%   TO DO: Define VRs labeled "Needs implementation."  All elements require
%   testing on various plans.
% 
%   Discription for all the VR types
%     FD => 'double',
%     FL => 'float',
%     OB => 'int8u',
%     OF => 'float',
%     OW => 'int16u',
%     SL => 'int32s',
%     SS => 'int16s',
%     UL => 'int32u',
%     US => 'int16u',
%
%JRA 6/1/06
%   DK 
%       Added support for multiple VR types.
%
%Usage:
%   data = dcm2ml_element(Java SimpleDicomElement)
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

%Set cache buffer to true.
%{
buf = 1;

%Set character set to [], default.
cs = [];

%Get the tag value as a char array.
try
    tag = char(org.dcm4che2.util.TagUtils.toString(attr.tag)); %removed attr.tag
catch
    data = '';
    return;
end

%Get the VR, cast to ML char array.
vr = char(attr.vr.toString);
%}
%modalityTag = '00080060';
vr = char (attr.getVR(hex2dec(tag)));
buf = 1;
cs = [];

switch upper(vr)
    case 'AE'
        %Needs implementation
        data = '';
    case 'AS'
        %Needs implementation
        data = '';
    case 'AT'
        data = dec2hex(attr.getInts(hex2dec(tag)));
    case {'CS', 'LO', 'SH', 'ST'}
        data = attr.getStrings(hex2dec(tag));
        %If more than one string, put in cell array.
        if numel(data) > 1
            data = cell(data);
        else
            data = char(data);
        end
    case 'DA'
        %Date string format: YYYYMMDD
        data = char(attr.getString(hex2dec(tag)));
    case 'DS'
        data = attr.getDoubles(hex2dec(tag));
    case 'DT'
        data = attr.getDate(hex2dec(tag));
        
    case 'FL'
        %Needs implementation
        %wy
        %data =  float(attr.getFloat(buf));
        data =  attr.getFloats(hex2dec(tag));
        
    case 'FD'
        data = attr.getDoubles(hex2dec(tag));
    case 'IS'
        data = attr.getInts(hex2dec(tag));
    case 'LT'
        data = char(attr.getString(cs, buf));
    case 'OB'
        data = attr.getBytes;
    case 'OF'
        data = attr.getFloats(hex2dec(tag));        
    case 'OW'
        %OW contains 16 bit words.  Conversion of this data into meaningful
        %values is the responsibility of the calling function.
        
        %wy it should be uint16 or int16, which depends on the value in data
        %representation fields, but the data conversion b/w matlab and java is int32.
        
        %data = uint16(attr.getInts(buf));
        data = attr.getInts(hex2dec(tag));
    case 'PN'
        nameObj = org.dcm4che3.data.PersonName(attr.getString(hex2dec(tag)));

        %The # in get(#) as defined by dcm4che2, PersonName class.
        data.FamilyName = char(nameObj.get(0));
        data.GivenName  = char(nameObj.get(1));
        data.MiddleName = char(nameObj.get(2));
        data.NamePrefix = char(nameObj.get(3));
        data.NameSuffix = char(nameObj.get(4));
    case 'SL'
        % 
         data = attr.getInt(hex2dec(tag), 0);
    case 'SQ'
        nElements = attr.countItems;
        data = [];
        for i=0:nElements-1
            data.(['Item_' num2str(i+1)]) = dcm2ml_Object(attr.getDicomObject(i)); %CHANGE THIS TOO IMPORTANT
        end
    case 'SS'
        %Needs implementation
        data = '';
    case 'TM'
        %Time string format: HHMMSS.ss where "ss" is fraction of a second.
        data = char(attr.getString(hex2dec(tag)));
    case 'UI'
        data = char(attr.getString(hex2dec(tag)));
    case 'UL'
        data = attr.getInts(hex2dec(tag));
    case 'UN'
        data = attr.getBytes;
    case 'US'
        data = attr.getInt(hex2dec(tag), 0);
    case 'UT'
        %Needs implementation
        data = '';                 
    otherwise
        error('Unrecognized VR type.'); %%Consider more gracious exit.
end

%DEBUGGING: remove this once all DICOM VRs are implemented and fully
%tested.  Until then, reaching this point in the code indicates that a VR
%MUST be defined for proper functioning of a called module.
if ~exist('data', 'var');    
    disp(['DEBUGGING: ' vr ' is not defined.  Implement it in dcm2ml_Element.m']);
    data = '';
else
    %Handle empty data situations -- this needs to be tailored to individual
    %VR values if matching MATLAB's dicominfo function output is desired.
    if isempty(data);
        disp('ERROR IN GETTAGVAL');
        data = '';
    end
end
