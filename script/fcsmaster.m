%% Flow Cytometry Script
%
% written by Bo Hua, Springer Lab in HMS

%% Clean Workspace
clc
clear
close all

%% Load data

foldername = '../data_b050';
% Read data, either way is fine,
% pstrat_common = pstrat({'t', 'ssc', 'fsc', 'bfp', 'cfp', 'yfp', 'mch'})
pstrat_common = pstrat({}); % default, four colors, fsc, ssc, t
[all_data, expr_meta] = fcsfolderread(foldername, pstrat_common);

% Report
disp(' ')
disp('Plate index:')
fprintf([strjoin(expr_meta.plate_name, '\n', 'index', 'on'),'\n']);

disp(' ')
disp('Parameter index:')
fprintf([strjoin(expr_meta.para, '\n','index', 'on'),'\n']);

%% Visualization

%% Filter
% Data display - Single Well

close all

% specify all the parameters here
%
plate = 4;
row = 2;
col = 1;

cha1 = 'cfp';
cha2 = 'ssc';

close all

% data extraction
data_well = all_data.data{plate}{row, col};
data_well_thin = fc_thin2(data_well,1);

% define first gate
figure
subplot(1,2,1)

% Prompt user to draw a gate on a scatterplot of FSC versus SSC
gate1 = uigetgate(data_well_thin,{'fsc','ssc'}, 'log');
xlabel('FSC')
ylabel('SSC')

% gating
data_well_thin_sel = applygate(data_well, gate1);
% data_well_thin_sel_thin =  fc_thin(data_well_thin_sel, 1000);
data_well_thin_sel_thin = data_well_thin_sel;
data_plot  = [log10(data_well_thin_sel_thin .(cha1)), log10(data_well_thin_sel_thin .(cha2))];

% second plot
subplot(1,2,2)
fcsplot(data_well_thin_sel_thin, {cha1, cha2, 'ssc'}, 'log2')
xlabel(cha1)
ylabel(cha2)

%% Plate display

close all

cha1 = 'yfp';
cha2 = 'mch';
p = 5;

figure('name', ['p', num2str(p), '_', cha1, '_', cha2])


data_plate = all_data.data{p};

h = tight_subplot(8,12,[.02 .03],[.08 .03],[.05 .01]);
maximize_window

for r = 1:8
    for c = 1:12
        
        if ~isempty(data_plate{r,c})
            axes(h(12*r+c-12))
            
            data_well = fc_thin2( data_plate{r,c}, 1000);
            fcsplot(data_well, {cha1, cha2}, 'log2', 0)
        end
    end
end

unifyaxis(gcf, 'xlim', [0 15])
unifyaxis(gcf, 'ylim', [4 13])

%% valid only above

%% Data display - Single Well

close all

% specify all the parameters here
info.Plate = 1;
info.row = 2;
info.col = 1;
info.cha1 = 'bfp';
info.cha2 = 'cfp';

figure('name', [Plates_info.name{1}, '_P', num2str(info.Plate), '_r', num2str(info.row), '_c', num2str(info.col), '_', info.cha1, '_', info.cha2]);

% simple scatter plot
% plot(log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha1)), log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha2)), '.', 'Markersize', 1)
% grid on,


% density plot
[N, C] = hist3([log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha1)), log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha2))], [100, 100]);
surf(C{1}, C{2}, log10(N), 'EdgeColor', 'none'), view(2), grid off

% contour plot
% contour(C{1}, C{2}, N), view(2)

% advanced density plot
% dscatter(all_data.data{1}{1,1}.bfp, all_data.data{1}{1,1}.ssc)

%% Data display - Plates

plates_index = [1];

info.cha1 = 'fsc';
info.cha2 = 'ssc';

for plate_i = plates_index
    
    info.Plate = plate_i;

    figure('name', [Plates_info.name{1}, '_P', num2str(info.Plate), '_', info.cha1, '_', info.cha2]);
    h = tight_subplot(8,12,[.02 .03],[.03 .03],[.03 .01]);
    maximize_window
    
    for r = 1:8
        for c = 1:12
            
            axes(h(12*r-12+c));
            info.row = r;
            info.col = c;
            
            if ~isempty(all_data.data{info.Plate}{info.row, info.col})
                % [N, C] = hist3([log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha1)), log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha2))], [100, 100]);
                % surf(C{1}, C{2}, log10(N), 'EdgeColor', 'none'), view(2), grid off
                plot(log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha1)), log2(all_data.data{info.Plate}{info.row, info.col}.(info.cha2)), '.', 'Markersize', 1)
            end
            
        end
    end
    
    unifyaxis(gcf, 'xlim')
    unifyaxis(gcf, 'ylim')
end