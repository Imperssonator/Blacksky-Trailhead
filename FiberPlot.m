function [] = FiberPlot(IDPath)

% Given imageData filepath, plot the fibers.
load(IDPath)
figure
hold on
XY = imageData.xy;
for i = 1:length(XY)
XYi = XY{i};
plot(XYi(1,:),XYi(2,:),'-b','LineWidth',1)
end
axis equal
set(gca,'Ydir','reverse')
ax = gca;

end
