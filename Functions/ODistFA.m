function [n, centers, S, MedOrient] = ODistFA(IDPath,angleStep,varargin)

if isempty(varargin)
    noFig = 0;
else
    noFig = varargin{1};
end

load(IDPath)

% Proceed with the selected data
vect = cellfun(@get_vectors, imageData(1).xy, 'UniformOutput', false);
vect = [vect{:}]; % unite data of all fibrils

% Calculate 2D order parameter (S)
A = sum(vect(1,:).^2);      
B = sum(prod(vect));
N = size(vect, 2);
S = sqrt((2*A-N)^2+4*B^2)/N;

% Calculate orientation distribution
vect(:, vect(2,:)>0) = - vect(:, vect(2,:)>0); % Turn the coordinate system from informatics into geometrical 
orientation = acos(vect(1,:));

% Calculate Median Orientation... This bit is... Tricky
JJJ = zeros(length(orientation),1,4);
JJJ(:,1,1) = cos(orientation).^2;
JJJ(:,1,2) = cos(orientation).*sin(orientation);
JJJ(:,1,3) = cos(orientation).*sin(orientation);
JJJ(:,1,4) = sin(orientation).^2;
MedJ = median(JJJ,1);
MedOrient = RecoverAnglesOD(MedJ);
disp(MedOrient)

% Check angleStep value
stepNum = round(180/angleStep);
angleStep = 180/stepNum;
% set(ui.angleStep, 'String', angleStep);

% Calculate for 0-pi range
n = histc(orientation, linspace(0, pi, stepNum+1));
n(1) = n(1) + n(end);
n(end) = []; % remove orientation = pi values


% if polarCoord % according to the selected coordinate system
% Reflect through the origin to the full 360 deg range

step = pi*angleStep/180; % angle step in rad
centers = - step/2 + linspace(0, 2*pi, 2*stepNum+1) ;
n = [n(end), n, n];

if noFig
    return
end

% Plot distribution in a new figure
figure('NumberTitle', 'off', 'Name', ['ODist ' datestr(now, 'HH:MM:SS dd/mm/yy')]);
title(imageData.name, 'Interpreter', 'none');

spider = polar(centers, n);
ax = gca;
ax.FontSize = 16;
text('Units', 'normalized', 'Position', [-0.15 0.16], ...
    'BackgroundColor', [1 1 1], ...
    'String', ['S_{2D} = ' num2str(S, 2)],...
    'FontSize', 16);
centers = 180*centers/pi; % recalculate into deg in case of saving to a text file

end

function v = get_vectors(xy)
v = diff(xy, 1, 2);
l = sqrt(sum(v.^2));
v = v./[l; l];

end

function [AngMap, Dirs] = RecoverAnglesOD(J)

% disp('Finding Angles...')
tic
[m, n] = size(J(:,:,1));
JE = zeros(m,n,2);
JV = zeros(m,n,4);
for i = 1:m
    for j = 1:n
        [V,D] = eig(reshape(J(i,j,:),[2 2]));
        JE(i,j,:) = diag(D);
        JV(i,j,:) = V(:);
    end
end
JESort = sort(JE,3,'descend');
JVSort = zeros(size(JV));
for i = 1:m
    for j = 1:n
        if JESort(i,j,1)~=JE(i,j,1)
            JVSort(i,j,:) = [JV(i,j,3) JV(i,j,4) JV(i,j,1) JV(i,j,2)];
        else
            JVSort(i,j,:) = JV(i,j,:);
        end
    end
end

% Coher = ((JESort(:,:,1)-JESort(:,:,2))./(JESort(:,:,1)+JESort(:,:,2))).^2;
Dirs = JVSort(:,:,1:2);
AngMap = atan2d(JVSort(:,:,2),JVSort(:,:,1));      % last evec is 'coherence orientation'
toc

end
