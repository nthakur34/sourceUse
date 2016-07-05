function [tags study]=dicomrt_d2c_SPECTcoordsystem(study)

info = study{1};
study_array = study{2};
xmesh = study{3};
ymesh = study{4};
zmesh = study{5};

if strcmpi(info.PatientPosition,'HFS')
    tags.hio                    = 'IN';
    tags.pos                    = 'NOSE UP';
    tags.originalCTxmesh        = xmesh/10;
    tags.originalCTymesh        = ymesh/10;
    tags.originalCTzmesh        = zmesh/10;
    xmesh                       = xmesh/10;
    ymesh                       = -ymesh/10;
    zmesh                       = -zmesh/10;
    zmesh                       = flipdim(zmesh,1);
    tags.xOffset                = 0;
    tags.yOffset                = 0;
    temp_diff_x                 = diff(xmesh);
    temp_diff_y                 = diff(ymesh);
    tags.grid1Units             = abs(temp_diff_x(1));
    tags.grid2Units             = abs(temp_diff_y(1));
    tags.xcoordOfNormaliznPoint = '';
    tags.ycoordOfNormaliznPoint = '';
    tags.zcoordOfNormaliznPoint = '';

elseif strcmpi(info.PatientPosition,'FFS')
    study_array                 = flipdim(study_array,3);
    tags.hio                    = 'OUT';
    tags.pos                    = 'NOSE UP';
        
    tags.originalCTxmesh        = xmesh/10;
    tags.originalCTymesh        = ymesh/10;
    tags.originalCTzmesh        = zmesh/10;
    xmesh                       = xmesh/10;
    ymesh                       = -ymesh/10;
    zmesh                       = -zmesh/10;
    zmesh                       = flipdim(zmesh,1);
    tags.xOffset                = 0;
    tags.yOffset                = 0;
    temp_diff_x                 = diff(xmesh);
    temp_diff_y                 = diff(ymesh);
    tags.grid1Units             = abs(temp_diff_x(1));
    tags.grid2Units             = abs(temp_diff_y(1));
    tags.xcoordOfNormaliznPoint = '';
    tags.ycoordOfNormaliznPoint = '';
    tags.zcoordOfNormaliznPoint = '';

elseif strcmpi(info.PatientPosition,'HFP')% HFP
    study_array                 = flipdim(study_array,3);
    tags.hio                    = 'IN';
    tags.pos                    = 'NOSE DOWN';
    tags.originalCTxmesh        = xmesh/10;
    tags.originalCTymesh        = ymesh/10;
    tags.originalCTzmesh        = zmesh/10;
    xmesh                       = -xmesh/10;
    ymesh                       = ymesh/10;
    zmesh                       = -zmesh/10;
    zmesh                       = flipdim(zmesh,1);
    tags.xOffset                = 0;
    tags.yOffset                = 0;
    temp_diff_x                 = diff(xmesh);
    temp_diff_y                 = diff(ymesh);
    tags.grid1Units             = abs(temp_diff_x(1));
    tags.grid2Units             = abs(temp_diff_y(1));

    tags.xcoordOfNormaliznPoint = '';
    tags.ycoordOfNormaliznPoint = '';
    tags.zcoordOfNormaliznPoint = '';

elseif strcmpi(info.PatientPosition,'FFP')% FFP
    study_array                 = flipdim(study_array,3);
    tags.hio                    = 'OUT';
    tags.pos                    = 'NOSE DOWN';
    tags.originalCTxmesh        = xmesh/10;
    tags.originalCTymesh        = ymesh/10;
    tags.originalCTzmesh        = zmesh/10;
    xmesh                       = -xmesh/10;
    ymesh                       = ymesh/10;
    zmesh                       = -zmesh/10;
    zmesh                       = flipdim(zmesh,1);
    tags.xOffset                = 0;
    tags.yOffset                = 0;
    temp_diff_x                 = diff(xmesh);
    temp_diff_y                 = diff(ymesh);
    tags.grid1Units             = abs(temp_diff_x(1));
    tags.grid2Units             = abs(temp_diff_y(1));
    tags.xcoordOfNormaliznPoint = '';
    tags.ycoordOfNormaliznPoint = '';
    tags.zcoordOfNormaliznPoint = '';
end
study{3} = xmesh;
study{4} = ymesh;
study{5} = zmesh;
study{2} = study_array;