function expt = getFibLen(expt,devNum)
% Given "path", the path to the folder of fiber data files with a /, and
% "devStr", a string of the title of the device (0-3 or whatever), and
% "angleStep", the level of discretization of the angular distribution,
% produce:
% N, the total count of fiber segments of a given angle, specified by
% Centers, and S_Avg, the average 2-D O.P. Also display ODists for each
% inidividual image so variance can be analyzed.

numBins = 50; % default for now

FS = CompileFib(expt.AFMFolder,expt.DEV(devNum).devName);
if isempty(fieldnames(FS))
    expt.DEV(devNum).avgFibLen = [];
    expt.DEV(devNum).stdFibLen = [];
    return
end
fibLen = [];

for i = 1:length(FS)
    fibLeni = GetFibLen(FS(i).FilePath);
    fibLen = [fibLen, fibLeni];
end

expt.DEV(devNum).avgFibLen = mean(fibLen);
expt.DEV(devNum).stdFibLen = std(fibLen);

end

function out = CompileFib(FolderPath,devStr)

ad = pwd;

% First compile any images from the folderpath
cd(FolderPath)

FIB = dir('*.fib.mat');
cd(ad)
out = struct();

count = 0;
for p = 1:length(FIB)
    FirstDot = findFirstDot(FIB(p).name);
    if strcmp(devStr,FIB(p).name(1:FirstDot-1))
        count = count+1;
        out(count).File = FIB(p).name;
        out(count).FilePath = [FolderPath, FIB(p).name];
    end
end

end

function FL = GetFibLen(FilePath)

load(FilePath)

FibCell = imageData.xy;
Lnm = imageData.length_nm;
FL = [];
sizeX = imageData.sizeX;
sizeY = imageData.sizeY;

for i = 1:length(FibCell)
    XYi = FibCell{i};
    if any(XYi(1,:)<10) || any(XYi(1,:)>(sizeX-10)) ||...    % if any part of this fiber goes off the edge
            any(XYi(2,:)<10) || any(XYi(2,:)>(sizeY-10))
        continue
    else
        FL = [FL, Lnm(i)];
    end
end



end