function varargout = peaklocator_autoandcombos_final2(varargin)
% PEAKLOCATOR_AUTOANDCOMBOS_FINAL2 MATLAB code for peaklocator_autoandcombos_final2.fig
%      PEAKLOCATOR_AUTOANDCOMBOS_FINAL2, by itself, creates a new PEAKLOCATOR_AUTOANDCOMBOS_FINAL2 or raises the existing
%      singleton*.
%
%      H = PEAKLOCATOR_AUTOANDCOMBOS_FINAL2 returns the handle to a new PEAKLOCATOR_AUTOANDCOMBOS_FINAL2 or the handle to
%      the existing singleton*.
%
%      PEAKLOCATOR_AUTOANDCOMBOS_FINAL2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEAKLOCATOR_AUTOANDCOMBOS_FINAL2.M with the given input arguments.
%
%      PEAKLOCATOR_AUTOANDCOMBOS_FINAL2('Property','Value',...) creates a new PEAKLOCATOR_AUTOANDCOMBOS_FINAL2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before peaklocator_autoandcombos_final2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to peaklocator_autoandcombos_final2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
%This is a project initially intended to simplify the process for charge
%identification scans using the Prague magnet at TRIUMF. It is also my
%first time using Matlab, so the code may not be...elegant. 
%-JLewis

% Edit the above text to modify the response to help peaklocator_autoandcombos_final2

% Last Modified by GUIDE v2.5 01-Apr-2016 11:12:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @peaklocator_autoandcombos_final2_OpeningFcn, ...
                   'gui_OutputFcn',  @peaklocator_autoandcombos_final2_OutputFcn, ...
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


% --- Executes just before peaklocator_autoandcombos_final2 is made visible.
function peaklocator_autoandcombos_final2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to peaklocator_autoandcombos_final2 (see VARARGIN)

% Choose default command line output for peaklocator_autoandcombos_final2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes peaklocator_autoandcombos_final2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%Set tables to be empty
global table7dataclr;
massclr1 = [0 0 0 0 0];
massclr2 = [0 0 0 0];
table7dataclr = [massclr1.' massclr1.' massclr1.' massclr1.'];
masstableclrdata = [massclr1.' massclr1.' massclr1.'];
manymassclrdata = [massclr2.' massclr2.' massclr2.'];
set(handles.zoom_off, 'BackgroundColor', [0.5, 0.5, 0.5]);
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
set(handles.uitable7, 'Data', table7dataclr, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on')
mebtcolumnname = {'Most Likely Mass', 'Charge', 'Error'};
set(handles.masstable, 'Data', masstableclrdata, 'ColumnName', mebtcolumnname, 'ColumnWidth', {126}, 'Rowstriping', 'on');
manymasstablenames = {'Mass 1', 'Mass 2', 'Mass 3'};
manymassrowname = {'Peak 1', 'Peak 2', 'Peak 3', 'ID Error'};
set(handles.manymasstable, 'Data', manymassclrdata, 'ColumnName', manymasstablenames, 'RowName', manymassrowname, 'ColumnWidth', {107}, 'Rowstriping', 'on');


%Help text
%Read text file lines as cell array of strings
fid = fopen(fullfile('magnetscanhelp') );
str = textscan(fid, '%s', 'Delimiter','\n'); str = str{1};
fclose(fid);

%GUI with help file
global hFig;
hFig = figure('Name', 'Help', 'NumberTitle', 'off', 'Menubar','none', 'Toolbar','none', 'Visible', 'off', 'CloseRequestFcn', '');
hPan = uipanel(hFig, 'Units','normalized', 'Position',[0 0 1 1]);
hEdit = uicontrol(hPan, 'Style','edit', 'Enable', 'inactive', 'BackgroundColor', 'white', 'FontSize', 10, 'Min', 0, 'Max', 2, 'HorizontalAlignment','left', 'Units','normalized', 'Position',[0 0 1 1], 'String', str);

%Prevent export screenshot from changing color and ensure the grab gets the
%entire figure. 
set(hObject, 'PaperPositionMode', 'auto', 'InvertHardcopy', 'off');





% --- Outputs from this function are returned to the command line.
function varargout = peaklocator_autoandcombos_final2_OutputFcn(hObject, eventdata, handles) 
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
gobutton = 1;
signal1 = mcaopen(sig1name);
signal2 = mcaopen(sig2name);


x = [];
y = [];
list1 = zeros(1,30000);
list2 = zeros(1,30000);
set(handles.helpcheckbox, 'Visible', 'off');

cla;
hold on
axis auto
disp(datestr(now))

%retrieves and plots data until user changes gobutton status
%tic/toc check prevents plotting every point which prevents the loop from
%slowing down significantly once plotting thousands of points
ele = 1;
tic
while gobutton == 1
    
    s1 = mcaget(signal1);
    s2 = mcaget(signal2);
    list1(ele) = s1;
    list2(ele) = s2;
    ele = ele + 1;
    pause(0.02);
    if toc >= 0.75
        plot(s1, s2, 'o')
        tic
    end
    
end
disp(ele)
hold off;

x = list1(1:ele-1); %use ele-1 to avoid taking 0,0 point as loop is terminated (purely aesthetic reason)
y = list2(1:ele-1);

%Redefines final axes for monitored signals
sig1ax = max(x);
sig1axmin = min(x);
sig2ax = 1.2*max(y);
sig2axmin = min(y) - .1*min(y);
% plot(x, y, 'bo')
plot(x,y)
xlabel('Magnetic Field (G)');
ylabel('Beam Signal');
axis([sig1axmin sig1ax sig2axmin sig2ax]);
hold on;

% %Smoothing attempt code; not to be used yet
% xsmooth = smooth(x, 0.001, 'loess');
% ysmooth = smooth(y, 0.001, 'loess');
% plot(xsmooth, ysmooth, 'r-')
% axis([sig1axmin sig1ax sig2axmin sig2ax]);
% %End of smoothing code

brush on;
grid on;

%axis auto;

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
set(handles.helpcheckbox, 'Visible', 'on');
disp(datestr(now))


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
global magfields;

%finds the brushed data to fit
brusheddata = findobj('-property', 'BrushData');
pulleddata = get(brusheddata, 'BrushData');

%performs data type check to deal with potential issues
if iscell(pulleddata) == 0
    brushed = (find(pulleddata));
    amountofbrushed = length(brushed);
end
if iscell(pulleddata) == 1
    newdata = char(pulleddata{gaussfitcount});
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
%for cut off. 20% was an arbitrary choice, as was 1.2 of the previous min
%check. Trial and error.
ygausslist = [];
xgausslist = [];
cutoffpoint = ymax*0.2;
j = maxloc;
prevmin = y(j);
gaussfitcount = gaussfitcount + 1;
while y(j) > cutoffpoint && y(j) <= 1.2*prevmin
    ygausslist(end+1) = y(j);
    xgausslist(end+1) = x(j);
    j = j + 1;
    prevmin = y(j);
end
j = maxloc;
prevmin = y(j);
while y(j) > cutoffpoint && y(j) <= 1.2*prevmin
    j = j - 1;
    ygausslist(end+1) = y(j);
    xgausslist(end+1) = x(j);
    prevmin = y(j);
end

hold on

peaklabelled = (gaussfitcount - 1);
gaussfit = fit(xgausslist.',ygausslist.','gauss6');
%plot(gaussfit)
format long
peaklocation = (gaussfit.b1 + gaussfit.b2 + gaussfit.b3 + gaussfit.b4 + gaussfit.b5 + gaussfit.b6)/6;  %+ gaussfit.b7 + gaussfit.b8)/8;

%Build a list of peak x and y values
peaklocationlist(peaklabelled) = peaklocation;
peakheightlist(peaklabelled) = ymax;

%Change label depending on location of peak
yref = find(y==max(y));
textlabel = [num2str(peaklocation), 'G \rightarrow '];
text(peaklocation, ymax, textlabel, 'FontWeight','bold', 'HorizontalAlignment', 'right', 'Rotation', 270);


%%%CHANGED TO NEW DEFAULT SO AUTO/USER LABELS ARE UNIFORM%%%
% if (peaklocation < x(yref(1)))
%     %textlabel = [' Peak at ', num2str(peaklocation), 'G \rightarrow '];
%     textlabel = [num2str(peaklocation), 'G \rightarrow '];
%     text(peaklocation, ymax, textlabel, 'FontWeight','bold', 'HorizontalAlignment', 'right', 'Rotation', 0)
% end
% if (peaklocation >= x(yref(1)))
%     textlabel = [' \leftarrow ', num2str(peaklocation), 'G'];
%     text(peaklocation, ymax, textlabel, 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'Rotation', 0)
% end


xlabel('Magnetic Field (G)');
ylabel('Beam Signal');
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
global magfields;

%Create data table and update with peak values
hallref = 2607.39; %these are reference values from Marco
aqref = 3.5; %
eref = 0.78; %

peaklocationlist = union(peaklocationlist,magfields);
peaklocationlist = sort(peaklocationlist);
aqlist = zeros(1,length(peaklocationlist));
qlist = zeros(1,length(peaklocationlist));

%Calculate and update table data for each fit
for n = 1:length(peaklocationlist)
    aqlist = (peaklocationlist./hallref)*sqrt(eref/energy)*aqref;
    qlist = aval.*(1./aqlist);
end

%Calculate charge change, difference from start
dqlist = [];
dqlist(end+1) = 0;
dqfromstart = [];
dqfromstart(end+1) = 0;
for m = 2:length(peaklocationlist)
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
    for j = 2:length(peaklocationlist)   
        testdqlist(j) = testcharges(j-1) - testcharges(j);
        testdqfromstart(j) = abs(testcharges(1) - testcharges(j));
    end
    testexpectedval = (0:length(peaklocationlist));
    testexpectedval(1) = 1;
    terrorcalcs = [];
    for e = 1:length(peaklocationlist)
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
global magfields;
global table7dataclr;

gaussfitcount = 1;
peaklocationlist = [];
magfields = [];
clearvars -except x y list1 list2 handles bigx bigy table7dataclr;
plot(x,y)
sig1ax = max(x);
sig1axmin = min(x);
sig2ax = 1.2*max(y);
sig2axmin = min(y) - 10*min(y);
axis([sig1axmin sig1ax sig2axmin sig2ax]);
xlabel('Magnetic Field (G)');
ylabel('Beam Signal');
grid on;
columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
set(handles.uitable7, 'Data', table7dataclr)
mebtcolumnname = {'Mass', 'Charge', 'Error'};
massclr1 = [0 0 0 0 0];
massclr2 = [0 0 0 0 0];
massclr3 = [0 0 0 0 0];
masstableclrdata = [massclr1.' massclr2.' massclr3.'];
set(handles.masstable, 'Data', masstableclrdata, 'ColumnName', mebtcolumnname, 'ColumnWidth', {126}, 'Rowstriping', 'on');
manymasstablenames = {'Mass 1', 'Mass 2', 'Mass 3'};
manymassrowname = {'Peak 1', 'Peak 2', 'Peak 3', 'ID Error'};
set(handles.manymasstable, 'Data', masstableclrdata, 'ColumnName', manymasstablenames, 'RowName', manymassrowname, 'ColumnWidth', {110}, 'Rowstriping', 'on');


% --- Executes on button press in helpcheckbox.
function helpcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to helpcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of helpcheckbox
global hFig;

if get(hObject, 'Value') == 1
    set(hFig, 'Visible', 'on');
end

if get(hObject, 'Value') == 0
    set(hFig, 'Visible', 'off');
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
global aqlist;
global qlist;
global dqlist;
global x;
global y;

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
for n = 1:length(peaklocationlist)
    qlist = chosenmass.*(1./aqlist);
end

%Calculate charge change, difference from start
dqlist = [];
dqlist(end+1) = 0;
dqfromstart = [];
dqfromstart(end+1) = 0;
for m = 2:length(peaklocationlist)
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
qyloc = (-10)*min(y);
for i = 1:length(peaklocationlist)
    peakxloc = peaklocationlist(i);
    %peakyloc = 0.95*peakheightlist(i); %Easier to put them below each peak
    textlabel = ['Q = ', num2str(qints(i))];
    text(peakxloc, qyloc, textlabel, 'FontWeight','bold', 'VerticalAlignment', 'top', 'HorizontalAlignment', 'center')
end


% --- Executes on button press in autopeakfinder.
function autopeakfinder_Callback(hObject, eventdata, handles)
% hObject    handle to autopeakfinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global magfields;


testx = x;
testy = y;
magfields = [];
peakheights = [];

%finds the brushed data to fit (if there is any)
dataselected = findobj('-property', 'BrushData');
useabledata = get(dataselected, 'BrushData');
chosen = (find(useabledata));
amountofchosen = length(chosen);

%finding the max, create a gaussian fit to find the top, then redefining the gaussian as
%zeros and looping.
i = 1;
maxspot = find(testy == max(testy),1);
maxspots(i) = maxspot;
peakheights(i) = testy(maxspots(i));
cutoff = testy(maxspot)*0.20;
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

gaussfit = fit(xgausslist.',ygausslist.','gauss8');
magfields(i) = (gaussfit.b1 + gaussfit.b2 + gaussfit.b3 + gaussfit.b4 + gaussfit.b5 + gaussfit.b6)/6; %+ gaussfit.b7 + gaussfit.b8)/8;
for m = minj:maxj
    testy(m) = 0;
end

while peakheights(i) > cutoff
    
    i = i + 1;
    maxspot = find(testy == max(testy),1);
    maxspots(i) = maxspot;
    peakheights(i) = testy(maxspots(i));
    j = maxspot;
    maxj = 0;
    minj = 0;
    xgausslist = [];
    ygausslist = [];
    lowerlim = peakheights(i)*0.2;
    while testy(j) > lowerlim
        ygausslist(end+1) = testy(j);
        xgausslist(end+1) = testx(j);
        j = j + 1;
        maxj = j;
    end
    j = maxspot;
    while testy(j) > lowerlim
        j = j - 1;
        ygausslist(end+1) = testy(j);
        xgausslist(end+1) = testx(j);
        minj = j;
    end
    gaussfit = fit(xgausslist.',ygausslist.','gauss8');
    magfields(i) = (gaussfit.b1 + gaussfit.b2 + gaussfit.b3 + gaussfit.b4 + gaussfit.b5 + gaussfit.b6)/6; %+ gaussfit.b7 + gaussfit.b8)/8;
    for m = minj:maxj
        testy(m) = 0;
    end
    
end


hold on;
for i = 1:length(magfields)
    textlabel = [num2str(magfields(i)), 'G \rightarrow '];
    text(magfields(i), peakheights(i), textlabel, 'FontWeight','bold', 'HorizontalAlignment', 'right', 'Rotation', 270);
end
hold off;


%%%MADE THIS SECTION OBSOLETE WITH UPDATES TO 'UPDATE TABLE'%%%
% %Create data table and update with peak values
% hallref = 2607.39; %these are reference values from Marco
% aqref = 3.5; %
% eref = 0.78; %
% magfields = sort(magfields);
% autoaqlist = zeros(1,length(magfields));
% autoqlist = zeros(1,length(magfields));
% 
% %Calculate and update table data for each fit
% for n = 1:peakstofind
%     autoaqlist = (magfields./hallref)*sqrt(eref/energy)*aqref;
%     autoqlist = aval.*(1./autoaqlist);
% end
% 
% %Calculate charge change, difference from start
% dqlist = [];
% dqlist(end+1) = 0;
% dqfromstart = [];
% dqfromstart(end+1) = 0;
% for m = 2:peakstofind
%     dqlist(end+1) = autoqlist(m-1) - autoqlist(m);
%     dqfromstart(end+1) = abs(autoqlist(1) - autoqlist(m));
% end
% 
% %Generate table
% tabledata = num2cell([magfields.' autoaqlist.' autoqlist.' dqlist.']);
% columnname = {'Magnetic Fields', 'A/q', 'q', 'dq'};
% set(handles.uitable7, 'Data', tabledata, 'ColumnName', columnname, 'ColumnWidth', {95}, 'Rowstriping', 'on');


% --- Executes on button press in allmasses.
function allmasses_Callback(hObject, eventdata, handles)
% hObject    handle to allmasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global peaklocationlist;
global magfields;
global mebtaq;
global energy;
global peaksreq;

hallref = 2607.39; %these are reference values from Marco
aqref = 3.5; %
eref = 0.78; %

upperlim = 1;

allpeaks = union(peaklocationlist, magfields);
combinationmatrix = combntns(allpeaks, peaksreq);
%location goes row,column
columns = peaksreq;
rows = length(combinationmatrix);
%Generate mass list
while mebtaq*upperlim < 250
    upperlim = upperlim + 1;
end

charges = (1:upperlim);
possiblemasses = mebtaq.*(charges);
massidlist = [];
peakcomborow = [];
errorlist = [];
newmat = [];

%Checks all possible combinations of the selected peaks, to determine
%potential masses within the beam, based on the provided A/q
for m = 1:length(possiblemasses)
    
    for r = 1:rows

        for c = 1:columns
            peakcombo(c) = (combinationmatrix(r, c));
        end
        
        peakcombo = sort(peakcombo);
        comboaqlist = zeros(1,length(peakcombo));
        comboqlist = zeros(1,length(peakcombo));
        %Calculate aq and q values for each combination
        for n = 1:length(peakcombo)
            comboaqlist = (peakcombo./hallref)*sqrt(eref/energy)*aqref;
            comboqlist = possiblemasses(m).*(1./comboaqlist);
        end
        %Calculate charge change, difference from first
        dqlist = [];
        dqlist(1) = 0;
        dqfromstart = [];
        dqfromstart(1) = 0;
        for q = 2:length(peakcombo)
            dqlist(end+1) = comboqlist(q-1) - comboqlist(q);
            dqfromstart(end+1) = abs(comboqlist(1) - comboqlist(q));
        end
        %Start finding error of this combination fitting the mass
        comboexpectedval = (0:length(peakcombo));
        comboexpectedval(1) = 1;
        terrorcalcs = [];
        for e = 1:length(peakcombo)
        terrorcalcs(e) = (abs(comboexpectedval(e) - dqfromstart(e))/comboexpectedval(e));
        end
        combototerror(r) = sum(terrorcalcs) - 1;
        
    end
    %Find the minimum error location of the list of errors for this mass
    minerrloc = find(combototerror == min(combototerror));
    if combototerror(minerrloc) <= 0.025
        massidlist(end+1) = possiblemasses(m);
        peakcomborow(end+1) = minerrloc;
        errorlist(end+1) = combototerror(minerrloc);
    end
end

%Put them into a matrix, sort them, then pull them back out in order of
%lowest error
massanderrormatrix = [massidlist(:), errorlist(:), peakcomborow(:)];
sortedmatrix = sortrows(massanderrormatrix, 2);

%Find the peaks used in the identification
for i = 1:length(massidlist)
    usedpeaks(:,i) = combinationmatrix(sortedmatrix(i,3),:);
end

rowsofnewmat = peaksreq + 1;
for i = 1:length(massidlist)
    newmat(rowsofnewmat,i) = sortedmatrix(i,2);
    for j = 1:peaksreq
    newmat(j,i) = usedpeaks(j,i);
    end
end
    
%Build the table
%Table total width = 330
numofmasses = length(massidlist);
manymasstablenames = cell(numofmasses,1);
manymassrownames = cell(rowsofnewmat,1);
for i = 1:numofmasses
    manymasstablenames{i} = ['Mass: ',  num2str(sortedmatrix(i,1))];
end
manymassrownames{rowsofnewmat} = ['ID Error '];
for i = 1:peaksreq
    manymassrownames{i} = ['Peak ' num2str(i)];
end
width = 312/numofmasses;
set(handles.manymasstable, 'Data', newmat, 'ColumnName', manymasstablenames, 'RowName', manymassrownames, 'ColumnWidth', {width}, 'Rowstriping', 'on');
    



function peaksrequired_Callback(hObject, eventdata, handles)
% hObject    handle to peaksrequired (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peaksrequired as text
%        str2double(get(hObject,'String')) returns contents of peaksrequired as a double
global peaksreq;

peaksreq = str2num(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function peaksrequired_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peaksrequired (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exportbutton.
function exportbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exportbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;
global aval;

%Create backup data in case crash occurs during export
backupfile = fopen('Saved_Scans/lastscanbackup.txt','w');
fprintf(backupfile, '%3.4e %3.4e\n', [x(:) y(:)]');
fclose(backupfile);

%Create default naming convention based on date and entered mass
defaultname = [datestr(now, 'yyyy-mm-dd-HH:MM'), '_mass_', num2str(aval), '_scan'];
[filename, filepath] = uiputfile('*.txt','Save as', defaultname);

%Create the file in the 'Saved Scans' folder
savefile = ['Saved_Scans/', defaultname, '.txt'];
picfile = ['Saved_Scans/', defaultname];

print(gcf, picfile, '-dpng')
fid = fopen(savefile,'w');

%Write x and y as two columns of floating point numbers
fprintf(fid, '%3.4e %3.4e\n', [x(:) y(:)]');
fclose(fid);

%Remove backup file once named save file is created
delete('Saved_Scans/lastscanbackup.txt');


% --- Executes on button press in importbutton.
function importbutton_Callback(hObject, eventdata, handles)
% hObject    handle to importbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;
global y;

[FileName, PathName] = uigetfile('*.txt', 'Select the data file');
rawdata = load([PathName FileName]);
%Assigns the first column in 'rawdata' to x, the second to y
x = rawdata(:,1);
y = rawdata(:,2);
xsmoothed = smooth(x, 0.01, 'loess');
ysmoothed = smooth(y, 0.01, 'loess');

keepplot = questdlg('Do you want to keep the current plot?');
switch lower(keepplot)
    case 'yes'
        hold on;
        axis auto
    case 'no'
        hold off;
        sig1ax = max(x);
        sig1axmin = min(x);
        sig2ax = 1.2*max(y);
        sig2axmin = min(y) - 10*min(y);
        axis([sig1axmin sig1ax sig2axmin sig2ax]);
        cla;
end
        
plot(x,y)
hold on
%plot(xsmoothed, ysmoothed, 'k-')
hold off
grid on;
brush on;
xlabel('Magnetic Field (G)');
ylabel('Signal Strength');
% sig1ax = max(x);
% sig1axmin = min(x);
% sig2ax = 1.2*max(y);
% sig2axmin = min(y) - 10*min(y);
% axis([sig1axmin sig1ax sig2axmin sig2ax]);
