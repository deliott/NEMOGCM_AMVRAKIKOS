	% This matlab script shapes the ecmwf raw data to feed NEMO
% 
% The output file are ecmwf_y1987m**.nc'
% 
% 
% It uses the functions  fill_nan.m   convert_accu.m   and interpol.m  
% 
% It can call plot_data.m and write_ecmwf.m
%
% Modified by Eliott the 9th of July 2018
%

% clear former workspace 
clear;
close all;

plot_of_data = false; 
write_bool = ; 
deal_with_all_files = false ; %false -> for test with only one file

%% load data fron coarse ncdf
% Read input_file

% file_list = '/home/lifewatch-user/Downloads/PFE/ecmwf_1987_input/input/1987_*.nc' 
%path = '/media/eliott/Elements/grece/PFE_CLUSTER/ecmwf_1987_input/output/ecmwf_y1987m02.nc';
%ncdisp(path);

input_dirName  = '/home/eliott/PFE/GITHUB/NEMOGCM_AMVRAKIKOS/matlab/ecmwf/input/';  
output_dirName = '/home/eliott/PFE/GITHUB/NEMOGCM_AMVRAKIKOS/matlab/ecmwf/output/';  

if deal_with_all_files
    files = dir( fullfile(input_dirName,'*.nc') );   % list all *.xyz files
else 
    files = dir( fullfile(input_dirName,'y1987m02.nc') ); % uses only one file as input
end
    files = {files.name}';                      % file names


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


% U10 =[];
% V10 =[];
% T2M =[];

for i=1:numel(files)
    filename_input = fullfile(input_dirName,files{i});     %# full path to file
    files{i} = strcat('ecmwf_',  files{i});
    filename_output = fullfile(output_dirName, files{i}); 
    
        %% reading the input data
    lon  = ncread(filename_input, 'longitude');
    lat  = ncread(filename_input, 'latitude');
    time = ncread(filename_input, 'time');
    d2m  = ncread(filename_input, 'd2m');
    msl  = ncread(filename_input, 'msl');
    t2m  = ncread(filename_input, 't2m');
    tcc  = ncread(filename_input, 'tcc');
    tp   = ncread(filename_input, 'tp');
    u10  = ncread(filename_input, 'u10');
    v10  = ncread(filename_input, 'v10'); 
        %% Fill missing values
    lon(isnan(lon)) = 1.000000020040877e+20 ;
    lat(isnan(lat)) = 1.000000020040877e+20 ;
    time(isnan(time)) = max(time) ;
    d2m = fill_nan(d2m);
    msl = fill_nan(msl);
    t2m = fill_nan(t2m);
    tcc = fill_nan(tcc);
    tp  = fill_nan(tp);
    u10 = fill_nan(u10);
    v10 = fill_nan(v10);
        %% Convert accumulated data over several time step to accumulation over a single timestep
    %tp_notConverted = tp;
    %tp  = convert_accu(tp);
    tp = convert_accummulations_instantaneous(tp);
%
 
    

        %% read the offset and scale factors from source netcdf file
    d2m_scale_factor = ncreadatt(filename_input,'d2m','scale_factor');
    msl_scale_factor = ncreadatt(filename_input,'msl','scale_factor');
    t2m_scale_factor = ncreadatt(filename_input,'t2m','scale_factor');
    tcc_scale_factor = ncreadatt(filename_input,'tcc','scale_factor');
    u10_scale_factor = ncreadatt(filename_input,'u10','scale_factor');
    v10_scale_factor = ncreadatt(filename_input,'v10','scale_factor');
    tp_scale_factor  = ncreadatt(filename_input,'tp','scale_factor');
  
    d2m_offset_value = ncreadatt(filename_input,'d2m','add_offset');
    msl_offset_value = ncreadatt(filename_input,'msl','add_offset');
    t2m_offset_value = ncreadatt(filename_input,'t2m','add_offset');
    tcc_offset_value = ncreadatt(filename_input,'tcc','add_offset');
    u10_offset_value = ncreadatt(filename_input,'u10','add_offset');
    v10_offset_value = ncreadatt(filename_input,'v10','add_offset');
    tp_offset_value  = ncreadatt(filename_input,'tp','add_offset');    
    
    
        %% Do the interpolation
    interp_d2m = interpol(d2m, Xq, Yq, lon, lat);
    interp_msl = 0.01* interpol(msl, Xq, Yq, lon, lat); % to convert Pa into hPa
    interp_t2m = interpol(t2m, Xq, Yq, lon, lat);
    interp_tcc = 100 * interpol(tcc, Xq, Yq, lon, lat); %to convert [0-1] coefficient into percentage. 
    interp_tp = (1000 / (3 * 3600))*interpol(tp, Xq, Yq, lon, lat);
    interp_u10 = interpol(u10, Xq, Yq, lon, lat);
    interp_v10 = interpol(v10, Xq, Yq, lon, lat);

%     figure
%     surf(u10(:,:,1));
    

%% Daily average
% U10_m = [];
% V10_m = [];
% t2m_m = [];
%     for i=1:((size(u10,3)-1)/8)
%         U10_m = [U10_m,mean2(u10(:,:,(8*i-7):(i*8)))];
%         V10_m = [V10_m,mean2(v10(:,:,(8*i-7):(i*8)))];
%         t2m_m = [t2m_m,mean2(t2m(:,:,(8*i-7):(i*8)))];
%     end
%     
%     U10 = [U10 , U10_m ];
%     V10 = [V10 , V10_m ];
%     T2M = [T2M , t2m_m ];

%% write the data into the output monthly files.    
    if write_bool 
        write_ecmwf;
    end
end

if plot_of_data 
    plot_data;
end


