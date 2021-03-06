%% Flow Cytometry Script
%
% written by Bo Hua, Springer Lab in HMS

%% Clean Workspace
clc
clear
close all

%% Load Data Parameter

% define Machine type
% machineType = 'LSRII';
machineType = 'Stratedigm';

% define Channels of interests
% LSRII
% channel = struct('fsc', 1, 'ssc', 3, 'yfp', 5, 'cfp', 7, 'mcherry', 9, 'bfp', 11);
% Stratedigm
channel = struct('fsc', 2, 'ssc', 4, 'yfp', 6, 'cfp', 8, 'mcherry', 10, 'bfp', 12);

% now the script still does not support inputs as following,
% channel = {'fsc', 'ssc', 'yfp', 'cfp', 'bfp', 'rfp'};

% define acquisition mode
acquisitionMode = 'plate';
% acquisitionMode = 'tube';

% define Data folder
% folder_name = '../data';
% folder_name = 'data/sample_plate_LSRII';
folder_name = 'data/sample_plate_stratedigm/';

%% Load data

% Read data
[all_data, Plates_info, para_name] = fc_readfolder(folder_name, channel, machineType, acquisitionMode);

% Report
disp(' ')
disp('Plate index:')
fprintf([strjoin(Plates_info.name, '\n', 'index', 'on'),'\n']);

disp(' ')
disp('Parameter index:')
fprintf([strjoin(para_name, '\n','index', 'on'),'\n']);

disp(' ')
disp('Parameter used:')
disp(channel)

%% Filter

% to be finished
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