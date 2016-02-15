load('SnA40k')

F = getFibLenHist(expt,15);

% Plot data
hfig = figure;
hax = gca;
hold(hax,'on')
hdata = histogram(hax,F);

% Adjust axis settings
hax.YLabel.String = 'Number of Fibers';
hax.XLabel.String = 'Contour Length, L (nm)';
hax.FontSize=20;
hax.Box = 'on';
hax.LineWidth = 0.75;
hax.PlotBoxAspectRatio = [1 1 1];

% Scale figure and write text
hfig.Position = [440 174 661 624];
htex = text('Units', 'normalized', 'Position', [0.7 0.92], ...
        'BackgroundColor', [1 1 1], ...
        'String', {['\langleL\rangle = ' num2str(mean(F), '%.2f') ' nm']; ...
        ['\sigma_L = ' num2str(std(F), '%.2f') ' nm']}, ...
        'FontSize', 20, ...
        'EdgeColor', 0.6*[1 1 1]);

hgexport(hfig, ['~/Documents/GA Tech/Research/Papers/Quantification of P3HT Microstructure/Workflow/LHist.tif'],  ...
     hgexport('factorystyle'), 'Format', 'tiff'); 
