clear ;
close all;

% value1 = 0.001;
% value2 = 0.0005;

% i=107;j=240:243;
% i =357:360 ; j = 230;

% Arachtos

arachtos = '/home/eliott/backup_DELL/working_directory/rivers/arachthos_1987.csv';
louros = '/home/eliott/backup_DELL/working_directory/rivers/louros_1987.csv';
Flow_Arachtos = readtable(arachtos);
Flow_Louros = readtable(louros);


% formatIn = 'yyyy-mm-dd';        
% datenum(datestr(Flow_Arachtos.x_Date_),formatIn)

day1 = Flow_Arachtos.x_Date_(1);
i = 1;
j = 1;

conv_coeff_Arachtos = 1000/(300*2);
conv_coeff_Louros= 1000/(100*2);

moyenneA = mean(Flow_Arachtos.x_mcubeParS_)
moyenneL = mean(Flow_Louros.x_mcubeParS_)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


input_dirName = '/media/eliott/Elements/grece/PFE_CLUSTER/ecmwf_1987_input/input/';  
% 
output_dirName =  '/home/eliott/backup_DELL/working_directory/FOR_REPORT/ecmwf/';
% %'/home/lifewatch-user/Downloads/PFE/ecmwf_1987_input/output/';  

files = dir( fullfile(input_dirName,'*.nc') );   %# list all *.xyz files
files = {files.name}';                      %'# file names


%% Work to be done outside the for loop 
    %% Target dimension
target_nlon = 446;
target_nlat = 319;

lat_min = 38.8407;

lat_max = 39.1210;  
Dlat = lat_max - lat_min;
dy = Dlat/ (target_nlat -1) ;
lon_min = 20.6497;
lon_max = 21.1841;
Dlon = lon_max - lon_min;
dx= Dlon/(target_nlon -1);
[Xq,Yq] = meshgrid(lon_min:dx:lon_max,lat_min:dy:lat_max);


TP = [];
for i=1:numel(files)
    filename_input = fullfile(input_dirName,files{i});     %# full path to file
    files{i} = strcat('ecmwf_',  files{i});
    filename_output = fullfile(output_dirName, files{i}); 
    
        %% reading the input data
    lon   = ncread(filename_input, 'longitude');
    lat   = ncread(filename_input, 'latitude');
    time  = ncread(filename_input, 'time');
    tp = ncread(filename_input, 'tp');
        %% Fill missing values
    tp = fill_nan(tp);
        %% Convert accumulated data over several time step to accumulation over a single timestep
%     tp_notConverted = tp;
%     tp = convert_accu(tp);
 
        %% read the offset and scale factors from source netcdf file
    tp_scale_factor = ncreadatt(filename_input,'tp','scale_factor');
    tp_offset_value = ncreadatt(filename_input,'tp','add_offset');    
    
%     figure
%     surf(u10(:,:,1));
    




%% Daily average
tp_m = [];
    for i=1:((size(tp,3)-1)/8)
        tp_m = [tp_m,mean2(tp(:,:,(8*i-7):(i*8)))];
       
        
        
    end
    TP = [TP , tp_m ];
    
end
t1 = datetime(1987,01,1,0,0,0);
t2 = datetime(1988,01,31,23,59,59);
t = t1:t2;



tstart = datetime(1987,01,01);
tend = datetime(1987,12,31);

figure
subplot(2,1,1)
riv = plot(Flow_Arachtos.x_Date_, Flow_Arachtos.x_mcubeParS_, ...
    Flow_Louros.x_Date_, Flow_Louros.x_mcubeParS_)%, ...
%     Flow_Arachtos.x_Date_,  Flow_Arachtos.x_mcubeParS_+Flow_Louros.x_mcubeParS_  )
xlim([tstart tend])
% ylim([-10 250])
title('Time serie of the rivers outflow in m3/s');
ylabel('River outflow in m3/s')
legend('Arachtos','Louros')



subplot(2,1,2)
plot( t, TP)
title('Time serie of the precipitations in m')
xlim([t1 t2])
ylim([0 6E-3])
    hline = ones(1,size(t,2))*mean(TP);
hold on
plot( t , hline)
hold off
ylabel('Mean precipitation in m')
legend('Daily mean precipitation','Annual average = 0.7309 mm')