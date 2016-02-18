% Copyright (c) 2014, ETH Zurich (Switzerland)
% All rights reserved.
function About(hObject, eventdata)

aboutFig = figure('NumberTitle', 'off', 'MenuBar', 'none', 'Resize', 'off', ...
    'DockControls', 'off', 'Color', [0.94 0.94 0.94], 'WindowStyle', 'modal', ...
    'Name', 'About FiberApp', 'Position', [500, 500, 230, 150]);
uicontrol(aboutFig, 'Style', 'text', 'Position', [10 20 210 100], ...
    'String', {'FiberApp v2.0'; ...
               '2011-2014'; ...
               ' '; ...
               'Ivan Usov'; ...
               'ivan.usov@hest.ethz.ch'; ...
               'ETH Zurich'});

           