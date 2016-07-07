function dataS = populate_planC_gsps_field(fieldname, dcmdir_PATIENT_STUDY_SERIES_GSPS, gspsNum, dcmobj)
%"populate_planC_gsps_field"
%   Given the name of a child field to planC{indexS.GSPS}, populates that
%   field based on the data contained in dcmdir.PATIENT.STUDY.SERIES.PR
%   gsps object passed in, for GSPS object number gspsNum.
%
%APA, 01/25/2013
%
%Usage:
%   dataS = populate_planC_gsps_field(fieldname, dcmdir_PATIENT_STUDY_SERIES_GSPS, gspsNum, dcmobj)
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

GSPS = dcmdir_PATIENT_STUDY_SERIES_GSPS;

%Default value for undefined fields.
dataS = '';

if ~exist('dcmobj', 'var')
    %Grab the dicom object representing the structures.
    dcmobj = scanfile_mldcm(GSPS.file);
end

% Graphical Annotation Sequence
GSPSseq = dcmobj.getValue(hex2dec('00700001'));

%Count em up.
if ~isempty(GSPSseq)
    nGsps = GSPSseq.size();
else
    nGsps = 0;
end

%Structure Set item for this structure.
annotObj = GSPSseq.get(gspsNum - 1);

switch fieldname

    case 'SOPInstanceUID'
        %Referenced Image Sequence
        refImageSeq = annotObj.getValue(hex2dec('00081140'));
        refImageObj = refImageSeq.get(0); % Assuming only one image reference.
        dataS = getTagValue(refImageObj, '00081155');
        
        
    case 'graphicAnnotationS'
        %Graphic Object Sequence
        graphicObjSeq = annotObj.getValue(hex2dec('00700009'));

        if isempty(graphicObjSeq)
            return;
        end
        
        if ~isempty(graphicObjSeq)
            numGraphicAnnot = graphicObjSeq.size();
        else
            numGraphicAnnot = 0;
        end
        
        graphicAnnotationS(1:numGraphicAnnot) = struct();
        for i = 1:numGraphicAnnot
            aGraphicAnnot = graphicObjSeq.get(i-1);
            graphicAnnotationS(i).graphicAnnotationUnits   = getTagValue(aGraphicAnnot, '00700005');
            graphicAnnotationS(i).graphicAnnotationDims    = getTagValue(aGraphicAnnot, '00700020');
            graphicAnnotationS(i).graphicAnnotationNumPts  = getTagValue(aGraphicAnnot, '00700021');
            graphicAnnotationS(i).graphicAnnotationData    = getTagValue(aGraphicAnnot, '00700022');
            graphicAnnotationS(i).graphicAnnotationType    = getTagValue(aGraphicAnnot, '00700023');
            graphicAnnotationS(i).graphicAnnotationFilled  = getTagValue(aGraphicAnnot, '00700024');            
        end
        
        dataS = graphicAnnotationS;
        

    case 'textAnnotationS'
        %Text Object Sequence
        textObjSeq = annotObj.getValue(hex2dec('00700008'));

        if isempty(textObjSeq)
            return;
        end

        if ~isempty(textObjSeq)
            numTextAnnot = textObjSeq.size();
        else
            numTextAnnot = 0;
        end
        
        textAnnotationS(1:numTextAnnot) = struct();
        
        for i = 1:numTextAnnot
            aTextAnnot = textObjSeq.getDicomObject(i-1);
            textAnnotationS(i).boundingBoxAnnotationUnits                = getTagValue(aTextAnnot, '00700003');
            textAnnotationS(i).anchorPtAnnotationUnits                   = getTagValue(aTextAnnot, '00700004');
            textAnnotationS(i).unformattedTextValue                      = getTagValue(aTextAnnot, '00700006');            
            textAnnotationS(i).boundingBoxTopLeftHandCornerPt            = getTagValue(aTextAnnot, '00700010');            
            textAnnotationS(i).boundingBoxBottomRightHandCornerPt        = getTagValue(aTextAnnot, '00700011');            
            textAnnotationS(i).boundingBoxTextHorizontalJustification    = getTagValue(aTextAnnot, '00700012');            
            textAnnotationS(i).anchorPoint                               = getTagValue(aTextAnnot, '00700014');            
            textAnnotationS(i).anchorPointVisibility                     = getTagValue(aTextAnnot, '00700015');                        
        end
        
        dataS = textAnnotationS;
        
    case 'annotUID'
        
        dataS = createUID('annotation');

end
