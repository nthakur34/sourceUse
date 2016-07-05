function dcmobj = createEmptyFields(dcmobj, tagS)
%"createEmptyFields"
%   Fill a Java dicom object with the empty fields indicated by the passed
%   tagS structure.  See any file ending in "_module_tags" for details on
%   this structure.
%
%   Sequences always contain a single member, itself populated with empty 
%   fields.
%
%JRA 06/23/06
%
%Usage:
%   dcmobj = createEmptyFields(dcmobj, tagS)
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

%Get the decimal tags.
tags = hex2dec({tagS.tag});
%%
%TOOK OFF HEX2DEC
%%

%Create and set passed tag fields to null.
for i=1:length(tags)
    vr = org.dcm4che3.data.ElementDictionary.vrOf(tags(i), dcmobj.getPrivateCreator(tags(i)));
    %Handle the case of a tag with no children.
    if isempty(tagS(i).children)
       %vr = org.dcm4che3.data.ElementDictionary.vrOf(tags(i), dcmobj.getPrivateCreator(tags(i)));

       if (isempty(vr))
           vr = org.dcm4che3.data.VR.UN;
           disp(['Cant find VR, so exiting....If VR not needed here,' ...
           'remove error in file createEmptyFields.m']);
           exit(1);
       end
       dcmobj.setNull(tags(i), vr);
       %dcmobj.addDicomObject(child_obj);
       %child_obj.add(i, dcmobj);
       %child_obj.setParent(dcmobj, child_obj.getParentSequencePrivateCreator(), child_obj.getParentSequenceTag);
       
       
    %Handle the case of a tag with children, a sequence.
    %CHANGED to ELEMENT DICTIONARY
    elseif  strcmpi(toString(vr), 'SQ')
       child_obj = org.dcm4che3.data.Attributes;
       disp('good - AT createEmptyFields');
       % el = dcmobj.setNull(tags(i), vr); NOT WORKING
       dcmobj.setNull(tags(i), vr);
       el = dcmobj;
       
       kids = tagS(i).children;
       child_obj = createEmptyFields(child_obj, kids); 
       %FIX by removing
        % el.addDicomObject(child_obj);
       % probably use this
   
       el.addAll(child_obj);
       
    %Handle the case of a tag that appears to have children but is not 
    %recognized as a sequence by the data dictionary.    
    else    
        CERRStatusString('Warning !!! A field with child elements is not of type SQ in the DICOM dictionary.\n\t\t Dictionary is out-of-date or module''s tag is incorrect.', 1);
        disp('bad -- AT createEmptyFields');
        dcmobj.setNull(tags(i), vr);    
    end
    
end