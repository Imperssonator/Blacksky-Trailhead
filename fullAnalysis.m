function SP = fullAnalysis(expName,parentDir,varargin)

%Full Analysis
% This function takes an experiment name, and runs the full set of OFET
% data analysis on all devices in its Dropbox folder

if nargin == 1
    parentDir = '~/Dropbox/Experiments/';
end
addpath('Functions')
addpath('Data')

SP = [expName, '.mat'];
exp = struct();
exp.name = expName;

% Initialize Devices by identifying folders
exp = findDevices(exp,parentDir);

% Process variables
exp = addProcVars(exp,parentDir);

% AFM


% UV-Vis


% Electrical

save(SP,'exp')
end

function exp = addProcVars(exp,parentDir)

xlsFile = [parentDir, exp.name, '/Process.xlsx'];
[~, ~, procTable] = xlsread(xlsFile);
procTable = CleanXLSCell(procTable);
%     disp(alldata)
[numProcVars,numDevs] = size(procTable); % Number of process variables, number of devices (columns in spreadsheet)

for dd = 1:length(exp)  % iterate over devices in exp struct
    
    % Find which column has device dd
    ddName = exp(dd).devName;
    ddCol = findDevCol(ddName,procTable);
    if ddCol == 0
        continue
    end
    
    for i = 1:numProcVars
        procVari = procTable{i,1}; % category = name of process variable in row i
        cellidd = procTable{i,ddCol}; % store value of that process variable in cellidd
        exp(dd).process.(procVari)=cellidd; %store the value of cellji in the exp structure process section
    end

    exp(dd).process = ClearEmpty(exp(dd).process);
    exp(dd).process = AddSolventProps(exp(dd).process);
end

end

function exp = findDevices(exp,parentDir)

% Open the experiment folder and find all the device folders
ad = pwd;
cd([parentDir, exp.name, '/', 'DEV/']);
devList = findAllSubdirs();
numDevs = length(devList);

for d = 1:numDevs
    exp(d).devName = devList{d};
    exp(d).devDir = [parentDir, exp.name, '/', 'DEV/', exp(d).devName, '/'];
end

cd(ad)

end

function col = findDevCol(ddName,procTable)

% ddName = string of dev name
% procTable = cell array where one column will correspond to ddName

[numProcVars,numDevs] = size(procTable); % Number of process variables, number of devices (columns in spreadsheet)

for i = 1:numProcVars
    if strcmp(procTable{i,1},'DevName')
        nameRow = i;
    end
end

col = 0;

for j = 2:numDevs
    if strcmp(procTable{nameRow,j},ddName)
        col = j;
    end
end

if col==0
    disp(['Device ', ddName, ' not found'])
end

end

function out = findAllSubdirs()

% Generate a cell array of the names of all subdirectories in the current
% directory

D = dir;

Names = {D(:).name};

out = {};

for i = 1:length(Names)
    if D(i).isdir
        Name = Names{i};
        if Name(1) ~= '.'
            out = [out; Name];
        end
    end
end

end

function Updated = CleanXLSCell(Old)

% Takes a cell array "old" and removes any rows or columns that are
% entirely full of NaN's

[m, n] = size(Old);

GoodRows = [];
GoodCols = [];

for i = 1:m
    if all(isnan([Old{i,:}]))
    else
        GoodRows = [GoodRows i];
    end
end

for j = 1:n
    if all(isnan([Old{:,j}]))
    else
        GoodCols = [GoodCols j];
    end
end

Updated = Old(GoodRows,GoodCols);

end

function Updated = ClearEmpty(Old)

%% Find empty matrices and replace with NaN

FN = fieldnames(Old);
Updated = Old;

for d = 1:length(Old)
    for i = 1:numel(FN)
%         disp(Old(d).(FN{i}))
%         disp(isequal(Old(d).(FN{i}),[]))
        if isequal(Old(d).(FN{i}),[])
            Updated(d).(FN{i})=NaN;
        end
    end
end

end