function CreateBSplineMethodPanel(handles)
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


    %BSplineMI Panel
    handles.BSplineMIPanel = uipanel('Parent',handles.toolPanel,'Units','normalize','FontSize',10,'Title','BSplineMI Optimizer Setup',...
                                    'Tag','BSplineMIPanel','Clipping','off',...
                                    'Position',[0 0 1 1],...
                                    'Visible','on');
    dx = 0; dy = 160;                                
    h305 = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','right',...
    'Position',[10.1923076923077+dx 114.208333333333+dy 120.649038461538 21.8472222222222],...
    'String','MMI Histogram Bins:',...
    'Style','text',...
    'Tag','text58');

    h306 = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','right',...
    'Position',[32.0240384615385+dx 85.4097222222222+dy 98.8173076923077 15.8888888888889],...
    'String','Sample Number :',...
    'Style','text',...
    'Tag','text59');

    handles.BSplineMI_HistBins = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'Position',[138.884615384615+dx 113.215277777778+dy 91.9230769230769 23.8333333333333],...
    'String','50',...
    'Style','edit',...
    'Tag','BSplineMI_HistBins')';

    handles.BSplineMI_SampleNum = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'Position',[138.884615384615+dx 79.4513888888889+dy 91.9230769230769 25.8194444444444],...
    'String','0.1',...
    'Style','edit',...
    'Tag','BSplineMI_SampleNum');

    h309 = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','right',...
    'Position',[9.04326923076922+dx 52.6388888888889+dy 121.798076923077 17.875],...
    'String','Iteration Nums:',...
    'Style','text',...
    'Tag','text60');

    handles.BSplineMI_iternum = uicontrol(...
    'Parent',handles.BSplineMIPanel,...
    'FontSize',10,...
    'HorizontalAlignment','left',...
    'Position',[138.884615384615+dx 48.6666666666667+dy 91.9230769230769 23.8333333333333],...
    'String','500',...
    'Style','edit',...
    'Tag','BSplineMI_iternum');

%     h311 = uicontrol(...
%     'Parent',handles.BSplineMIPanel,...
%     'FontSize',10,...
%     'HorizontalAlignment','right',...
%     'Position',[5.59615384615385+dx 16.8888888888889+dy 125.245192307692 23.8333333333333],...
%     'String','Standard Deviation:',...
%     'Style','text',...
%     'Tag','text61');
% 
%     handles.BSplineMI_sd = uicontrol(...
%     'Parent',handles.BSplineMIPanel,...
%     'FontSize',10,...
%     'HorizontalAlignment','left',...
%     'Position',[138.884615384615+dx 14.9027777777778+dy 91.9230769230769 23.8333333333333],...
%     'String','1.0',...
%     'Style','edit',...
%     'Tag','BSplineMI_sd');


    guidata(handles.mainframe, handles);
    
end

    