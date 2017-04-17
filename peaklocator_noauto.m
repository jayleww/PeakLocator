function varargout = peaklocator_noauto(varargin)
% PEAKLOCATOR_NOAUTO MATLAB code for peaklocator_noauto.fig
%      PEAKLOCATOR_NOAUTO, by itself, creates a new PEAKLOCATOR_NOAUTO or raises the existing
%      singleton*.
%
%      H = PEAKLOCATOR_NOAUTO returns the handle to a new PEAKLOCATOR_NOAUTO or the handle to
%      the existing singleton*.
%
%      PEAKLOCATOR_NOAUTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEAKLOCATOR_NOAUTO.M with the given input arguments.
%
%      PEAKLOCATOR_NOAUTO('Property','Value',...) creates a new PEAKLOCATOR_NOAUTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before peaklocator_noauto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to peaklocator_noauto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help peaklocator_noauto

% Last Modified by GUIDE v2.5 05-Feb-2016 09:40:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @peaklocator_noauto_OpeningFcn, ...
                   'gui_OutputFcn',  @peaklocator_noauto_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before peaklocator_noauto is made visible.
function peaklocator_noauto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to peaklocator_noauto (see VARARGIN)

% Choose default command line output for peaklocator_noauto
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes peaklocator_noauto wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.zoom_off, 'BackgroundColor', [0.5, 0.5, 0.5]);
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
table7dataclr = [0 0 0 0];
set(handles.uitable7, 'Data', table7dataclr, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on')
mebtcolumnname = {'Most Likely Mass', 'Charge', 'Error'};
massclr1 = [0 0 0 0 0];
massclr2 = [0 0 0 0 0];
masstableclrdata = [massclr1.' massclr2.' massclr2.'];
set(handles.masstable, 'Data', masstableclrdata, 'ColumnName', mebtcolumnname, 'ColumnWidth', {126}, 'Rowstriping', 'on');



% --- Outputs from this function are returned to the command line.
function varargout = peaklocator_noauto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global gobutton;
global sig1name;
global sig2name;
global list1;
global list2;
global x;
global y;
global bigx;
global bigy;
gobutton = 1;
signal1 = mcaopen(sig1name);
signal2 = mcaopen(sig2name);


list1 = [];
list2 = [];

%retrieves and plots data until user changes gobutton status
while gobutton == 1
    
    drawnow();
    s1 = mcaget(signal1);
    s2 = mcaget(signal2);
    list1(end+1) = s1;
    list2(end+1) = s2;
    %pause(0.05);
    fileid = fopen('94Sr_Dec_2015_PragueScan');
    %fileid = fopen('20150909_ZrC#7_15uA_Large_Mass_Scan')
    x = cell2mat(textscan(fileid, '%*s %*s %*s %f %*[^\n]', 'Headerlines', 1));
    %x = list1;
    fileid = fopen('94Sr_Dec_2015_PragueScan');
    %fileid = fopen('20150909_ZrC#7_15uA_Large_Mass_Scan')
    %y = list2;
    y = cell2mat(textscan(fileid, '%*s %*s %f %*[^\n]', 'Headerlines', 1));
    bigx = max(x);
    bigy = 1.1*max(y);
    plot(x,y)
    brush on;
    grid on;
    axis([0 bigx (-5) bigy]);
    xlabel('Magnetic Field (G)');
    ylabel('Current Reading');
    
end

%Redefines final axes for monitored signals
sig1ax = max(x);
sig2ax = 1.2*max(y);
axis([0 sig1ax (-5) sig2ax]);

%Closes signal connection (in theory)
mcaclose(signal1);
mcaclose(signal2);



% --- Executes on button press in stopbutton.
function stopbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gobutton;
global gaussfitcount;
global peaklocationlist;
gobutton = 0;
gaussfitcount = 1;
peaklocationlist = [];





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global sig1name;
sig1name = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global sig2name;
sig2name = get(hObject, 'String');


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Gaussianfit.
function Gaussianfit_Callback(hObject, eventdata, handles)
% hObject    handle to Gaussianfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global list1;
global list2;
global pulleddata; 
global gaussfitcount;
global peaklabelled;
global peaklocationlist;
global peakheightlist;
global energy;

%finds the brushed data to fit
brusheddata = findobj('-property', 'BrushData');
pulleddata = get(brusheddata, 'BrushData');

%performs data type check to deal with potential issues
if iscell(pulleddata) == 0
    brushed = (find(pulleddata));
    amountofbrushed = length(brushed);
end
if iscell(pulleddata) == 1
    newdata = str2mat(pulleddata{gaussfitcount});
    brushed = (find(newdata));
    amountofbrushed = length(brushed);
end

%looks for the max within the brushed data and stores the location in maxloc
ymax = 0;
for i = 1:amountofbrushed
    if (y(brushed(i)) > ymax)
        ymax = y(brushed(i));
        maxloc = brushed(i);
    end
end

%look on either side of the max to find point where signal drops to ~20%
%for cut off. 20% was an arbitrary choice. 
ygausslist = [];
xgausslist = [];
cutoffpoint = ymax*0.2;
j = maxloc;
gaussfitcount = gaussfitcount + 1;
while y(j) > cutoffpoint
    ygausslist(end+1) = y(j);
    xgausslist(end+1) = x(j);
    j = j+1;
end
j = maxloc;
while y(j) > cutoffpoint
    j = j-1;
    ygausslist(end+1) = y(j);
    xgausslist(end+1) = x(j);
end

hold on 
peaklabelled = (gaussfitcount - 1);
gaussfit = fit(xgausslist.',ygausslist.','gauss8');
%plot(gaussfit)
format long
peaklocation = (gaussfit.b1 + gaussfit.b2 + gaussfit.b3 + gaussfit.b4 + gaussfit.b5 + gaussfit.b6 + gaussfit.b7 + gaussfit.b8)/8;

%Build a list of peak x and y values
peaklocationlist(peaklabelled) = peaklocation;
peakheightlist(peaklabelled) = ymax;

%Change label depending on location of peak
yref = find(y==max(y));
if (peaklocation < x(yref(1)))
    %textlabel = [' Peak at ', num2str(peaklocation), 'G \rightarrow '];
    textlabel = [num2str(peaklocation), 'G \rightarrow '];
    text(peaklocation, ymax, textlabel, 'FontWeight','bold', 'HorizontalAlignment', 'right', 'Rotation', 0)
end
if (peaklocation >= x(yref(1)))
    textlabel = [' \leftarrow ', num2str(peaklocation), 'G'];
    text(peaklocation, ymax, textlabel, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'Rotation', 0)
end


xlabel('Magnetic Field (G)');
ylabel('Current Readback');
legend('off'); %Does not contribute useful info
hold off



function energy_entry_Callback(hObject, eventdata, handles)
% hObject    handle to energy_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of energy_entry as text
%        str2double(get(hObject,'String')) returns contents of energy_entry as a double
global energy;
energy = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function energy_entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to energy_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in zoom_on.
function zoom_on_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global peaklocationlist;
global gaussfitcount;
global x;
global y;
brush off;
zoom on;
set(handles.zoom_on, 'BackgroundColor', [0.5, 0.5, 0.5]); 
set(handles.zoom_off, 'BackgroundColor', [0.83, 0.82, 0.78]);

% --- Executes on button press in zoom_off.
function zoom_off_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global peaklocationlist;
global gaussfitcount;
global x;
global y;
brush on;
zoom off;
set(handles.zoom_on, 'BackgroundColor', [0.83, 0.82, 0.78]);
set(handles.zoom_off, 'BackgroundColor', [0.5, 0.5, 0.5]);



function avalueentered_Callback(hObject, eventdata, handles)
% hObject    handle to avalueentered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avalueentered as text
%        str2double(get(hObject,'String')) returns contents of avalueentered as a double
global aval;
aval = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function avalueentered_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avalueentered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatetable.
function updatetable_Callback(hObject, eventdata, handles)
% hObject    handle to updatetable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global peaklocationlist;
global peaklabelled;
global energy;
global aval;
global aqlist;
global qlist;
global dqlist;
global tabledata;

%Create data table and update with peak values
hallref = 2607.39; %these are reference values from Marco
aqref = 3.5; %
eref = 0.78; %
peaklocationlist = sort(peaklocationlist);
aqlist = zeros(1,length(peaklocationlist));
qlist = zeros(1,length(peaklocationlist));

%Calculate and update table data for each fit
for n = 1:peaklabelled
    aqlist = (peaklocationlist./hallref)*sqrt(eref/energy)*aqref;
    qlist = aval.*(1./aqlist);
end

%Calculate charge change, difference from start
dqlist = [];
dqlist(end+1) = 0;
dqfromstart = [];
dqfromstart(end+1) = 0;
for m = 2:peaklabelled
    dqlist(end+1) = qlist(m-1) - qlist(m);
    dqfromstart(end+1) = abs(qlist(1) - qlist(m));
end

%Generate table
tabledata = num2cell([peaklocationlist.' aqlist.' qlist.' dqlist.']);
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
set(handles.uitable7, 'Data', tabledata, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on');



function mebtaq_Callback(hObject, eventdata, handles)
% hObject    handle to mebtaq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mebtaq as text
%        str2double(get(hObject,'String')) returns contents of mebtaq as a double
global mebtaq;
mebtaq = str2num(get(hObject, 'String'));


% --- Executes during object creation, after setting all properties.
function mebtaq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mebtaq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in masscalc.
function masscalc_Callback(hObject, eventdata, handles)
% hObject    handle to masscalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mebtaq;
global peaklocationlist;
global energy;
global aqlist;
global peaklabelled;
global bestmass;


%This section generates all possible masses based on MEBT A/q (which are
%under 250) and finds the most likely 5 masses and the associated error
bestmass = [0 0 0 0 0];
upperlim = 1;
sortedaq = sort(aqlist);

while mebtaq*upperlim < 250
    upperlim = upperlim + 1;
end
charges = (1:upperlim);
trymasses = mebtaq.*(charges); %list of masses to try

%Create and compare the error for each mass based on dq and overall dq for
%each peak.
for i = 1:length(trymasses)
    testcharges = [];
    testcharges = trymasses(i)*(1./sortedaq);
    testdqlist = [];
    testdqlist(1) = 0;
    testdqfromstart = [];
    testdqfromstart(1) = 0;
    for j = 2:peaklabelled    
        testdqlist(j) = testcharges(j-1) - testcharges(j);
        testdqfromstart(j) = abs(testcharges(1) - testcharges(j));
    end
    testexpectedval = (0:peaklabelled);
    testexpectedval(1) = 1;
    terrorcalcs = [];
    for e = 1:peaklabelled
    terrorcalcs(e) = (abs(testexpectedval(e) - testdqfromstart(e))/testexpectedval(e));
    end
    testtoterror(i) = sum(terrorcalcs) - 1;
end

%Find the minimum error location of the list, store it, then reassign
%arbitrarily high values to it so min will find the next lowest location. 
for i = 1:5
    minerrloc = find(testtoterror == min(testtoterror));
    minerror(i) = testtoterror(minerrloc);
    bestmass(i) = trymasses(minerrloc);
    bestmasscharge(i) = minerrloc;
    testtoterror(minerrloc) = 100;
    trymasses(minerrloc) = 0;
end

%Update the MEBT table with the found values.
mebtcolumnname = {'Most Likely Mass', 'Charge', 'Error'};
mebttabledata = [bestmass.' bestmasscharge.' minerror.'];
set(handles.masstable, 'Data', mebttabledata, 'ColumnName', mebtcolumnname, 'ColumnWidth', {126}, 'Rowstriping', 'on');
    
    
    
    

% --- Executes on button press in replot.
function replot_Callback(hObject, eventdata, handles)
% hObject    handle to replot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global list1;
global list2;
global gaussfitcount;
global peaklocationlist;
global aqlist;
global qlist;
global dqlist;
global tabledata;
global bigx;
global bigy;

gaussfitcount = 1;
peaklocationlist = [];
clearvars -except x y list1 list2 handles bigx bigy;
plot(x ,y)
axis([0 (max(x)) (-5) (1.2*max(y))]);
grid on;
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
table7dataclr = [0 0 0 0];
set(handles.uitable7, 'Data', table7dataclr)
mebtcolumnname = {'Mass', 'Charge', 'Error'};
massclr1 = [0 0 0 0 0];
massclr2 = [0 0 0 0 0];
massclr3 = [0 0 0 0 0];
masstableclrdata = [massclr1.' massclr2.' massclr3.'];
set(handles.masstable, 'Data', masstableclrdata, 'ColumnName', mebtcolumnname, 'ColumnWidth', {126}, 'Rowstriping', 'on');


% --- Executes on button press in helpcheckbox.
function helpcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to helpcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of helpcheckbox
if get(hObject, 'Value') == 1
    set(handles.helptext, 'Visible', 'on');
end
if get(hObject, 'Value') == 0
    set(handles.helptext, 'Visible', 'off');
end



function scannotes_Callback(hObject, eventdata, handles)
% hObject    handle to scannotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scannotes as text
%        str2double(get(hObject,'String')) returns contents of scannotes as a double


% --- Executes during object creation, after setting all properties.
function scannotes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scannotes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chargestates.
function chargestates_Callback(hObject, eventdata, handles)
% hObject    handle to chargestates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bestmass;
global peaklocationlist;
global peakheightlist;
global aqlist;
global qlist;
global dqlist;
global peaklabelled;
global x;
global y;
global bigx;
global bigy;

chosenmass = bestmass(1);
set(handles.avalueentered, 'String', num2str(chosenmass));


%Create new data table and update with best charge values (code repeated
%from earlier)
hallref = 2607.39; %these are reference values from Marco
aqref = 3.5; %
eref = 0.78; %
peaklocationlist = sort(peaklocationlist);
qlist = zeros(1,length(peaklocationlist));

%Calculate and update table data for each fit
for n = 1:peaklabelled
    qlist = chosenmass.*(1./aqlist);
end

%Calculate charge change, difference from start
dqlist = [];
dqlist(end+1) = 0;
dqfromstart = [];
dqfromstart(end+1) = 0;
for m = 2:peaklabelled
    dqlist(end+1) = qlist(m-1) - qlist(m);
    dqfromstart(end+1) = abs(qlist(1) - qlist(m));
end
%Update table with new values based on previously calculated mass. 
tabledata = num2cell([peaklocationlist.' aqlist.' qlist.' dqlist.']);
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
set(handles.uitable7, 'Data', tabledata, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on');

qlist = sort(qlist, 'descend');
qints = round(qlist); %get charge values rounded to integers


%Find x and y coords for peaks, want to put q labels there
yref2 = find(y==max(y));
yloc = 1.05*y(yref2(1));
for i = 1:length(peaklocationlist)
    peakxloc = peaklocationlist(i);
    %peakyloc = 0.95*peakheightlist(i);
    textlabel = ['Q = ', num2str(qints(i))];
    if (peakxloc <= x(yref2(1)))
        text(peakxloc, -1, textlabel, 'FontWeight','bold', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center')
    end
    if (peakxloc > x(yref2(1)))
        text(peakxloc, -1, textlabel, 'FontWeight','bold', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center')
    end
end


% --- Executes on button press in peakfinder.
function peakfinder_Callback(hObject, eventdata, handles)
% hObject    handle to peakfinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global energy;
global aval;


testx = x;
testy = y;
peakstofind = 7;
magfields = [];
peakheights = [];

%finds the brushed data to fit
dataselected = findobj('-property', 'BrushData');
useabledata = get(dataselected, 'BrushData');
chosen = (find(useabledata));
amountofchosen = length(chosen);

%finding the max, create a gaussian fit to find the top, then redefining the gaussian as
%zeros and looping. 
for i = 1:peakstofind
    maxspot = find(testy == max(testy),1);
    maxspots(i) = maxspot;
    peakheights(i) = testy(maxspots(i));
    cutoff = testy(maxspot)*0.2;
    j = maxspot;
    maxj = 0;
    minj = 0;
    xgausslist = [];
    ygausslist = [];
    while testy(j) > cutoff
        ygausslist(end+1) = testy(j);
        xgausslist(end+1) = testx(j);
        j = j+1;
        maxj = j;
    end
    j = maxspot;
    while testy(j) > cutoff
        j = j-1;
        ygausslist(end+1) = testy(j);
        xgausslist(end+1) = testx(j);
        minj = j;
    end
    gaussfit = fit(xgausslist.',ygausslist.','gauss6');
    magfields(i) = (gaussfit.b1 + gaussfit.b2 + gaussfit.b3 + gaussfit.b4 + gaussfit.b5 + gaussfit.b6)/6; %+ gaussfit.b7 + gaussfit.b8)/8;
    for m = minj:maxj
        testy(m) = 0;
    end
end
hold on;
for i = 1:peakstofind
    textlabel = [num2str(magfields(i)), 'G \rightarrow '];
    text(magfields(i), peakheights(i), textlabel, 'FontWeight','bold', 'HorizontalAlignment', 'right', 'Rotation', 270);
end
hold off;

%Create data table and update with peak values
hallref = 2607.39; %these are reference values from Marco
aqref = 3.5; %
eref = 0.78; %
magfields = sort(magfields);
autoaqlist = zeros(1,length(magfields));
autoqlist = zeros(1,length(magfields));

%Calculate and update table data for each fit
for n = 1:peakstofind
    autoaqlist = (magfields./hallref)*sqrt(eref/energy)*aqref;
    autoqlist = aval.*(1./autoaqlist);
end

%Calculate charge change, difference from start
dqlist = [];
dqlist(end+1) = 0;
dqfromstart = [];
dqfromstart(end+1) = 0;
for m = 2:peakstofind
    dqlist(end+1) = autoqlist(m-1) - autoqlist(m);
    dqfromstart(end+1) = abs(autoqlist(1) - autoqlist(m));
end

%Generate table
tabledata = num2cell([magfields.' autoaqlist.' autoqlist.' dqlist.']);
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
set(handles.uitable7, 'Data', tabledata, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on');
