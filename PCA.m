function PCA(data, Colors, Odorants, smooth, ptitle, time, stim_on, bps, line_mult)

[~,scores,~,~,var_exp] = pca(data);
my_filter = designfilt('lowpassiir','FilterOrder',smooth,'HalfPowerFrequency',0.15,'DesignMethod','butter'); % design custom filter
scores = filtfilt(my_filter,scores);
scores = permute(reshape(scores,size(scores,1)/numel(Odorants),numel(Odorants),size(scores,2)),[1 3 2]);
scores_norm = scores-scores(1,:,:);

static_fig = figure('Units','normalized','Position',[0 0.5 0.5 0.39]);  % generate single figure for all Odorant PCA trajectories
static_axes = axes(static_fig);
hold on; grid on; box off; view(3);

plot3(0,0,0,'.','Color',[.5,.5,.5,.5],'MarkerSize',40);
for cycle_odors = 1:numel(Odorants)
    for cycle_points = 0:line_mult:size(scores_norm,1)
        if cycle_points ~= 0
            plot3([0,scores_norm(cycle_points,1,cycle_odors)], [0,scores_norm(cycle_points,2,cycle_odors)],[0,scores_norm(cycle_points,3,cycle_odors)],'Color',[Colors(cycle_odors,:),0.2],'Linewidth', .5);
            switch cycle_points
                case bps*.5, text(scores_norm(cycle_points,1,cycle_odors), scores_norm(cycle_points,2,cycle_odors), scores_norm(cycle_points,3,cycle_odors), [num2str(time(1)-stim_on + .5)],'FontSize',14,'Color','k','BackgroundColor',[Colors(cycle_odors,:),0.25])
                case bps*1, text(scores_norm(cycle_points,1,cycle_odors), scores_norm(cycle_points,2,cycle_odors), scores_norm(cycle_points,3,cycle_odors), [num2str(time(1)-stim_on + 1)],'FontSize',14,'Color','k','BackgroundColor',[Colors(cycle_odors,:),0.25])
                case bps*4, text(scores_norm(cycle_points,1,cycle_odors), scores_norm(cycle_points,2,cycle_odors), scores_norm(cycle_points,3,cycle_odors), [num2str(time(1)-stim_on + 4)],'FontSize',14,'Color','k','BackgroundColor',[Colors(cycle_odors,:),0.25])
                case bps*8, text(scores_norm(cycle_points,1,cycle_odors), scores_norm(cycle_points,2,cycle_odors), scores_norm(cycle_points,3,cycle_odors), [num2str(time(1)-stim_on + 8)],'FontSize',14,'Color','k','BackgroundColor',[Colors(cycle_odors,:),0.25])
            end
        end
    end   
    PCA_handle(cycle_odors) = plot3(scores_norm(:,1,cycle_odors),scores_norm(:,2,cycle_odors),scores_norm(:,3,cycle_odors),'Color',[Colors(cycle_odors,:),0.85],'Linewidth', 2.5);
    legend(PCA_handle,Odorants','location','eastoutside','FontSize',16,'FontWeight','Bold');
end
title(static_axes,ptitle,'FontSize',20,'FontWeight','Bold');

lims = [min(scores_norm(:,1,:),[],'all') max(scores_norm(:,1,:),[],'all'); min(scores_norm(:,2,:),[],'all') max(scores_norm(:,2,:),[],'all'); min(scores_norm(:,3,:),[],'all') max(scores_norm(:,3,:),[],'all')]; 
xlim(static_axes,lims(1,:));
ylim(static_axes,lims(2,:));
zlim(static_axes,lims(3,:));
xlabel(static_axes,['PC1 (' num2str(round(var_exp(1)*100)/100) '%)'],'FontName','Arial','FontSize',18,'FontWeight','Bold');
ylabel(static_axes,['PC2 (' num2str(round(var_exp(2)*100)/100) '%)'],'FontName','Arial','FontSize',18,'FontWeight','Bold');
zlabel(static_axes,['PC3 (' num2str(round(var_exp(3)*100)/100) '%)'],'FontName','Arial','FontSize',18,'FontWeight','Bold');
num_files = annotation(static_fig,'textbox', [0.2, 0.9, 0, 0], 'String', ['n = ' num2str(size(scores,2))],'Units','normalized','Color','k','FontSize',14,'FontWeight','Bold','FitBoxToText','on','HorizontalAlignment','center');

return