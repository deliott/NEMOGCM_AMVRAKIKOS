% This matlab script intend to shape the ecmwf raw data to feed NEMO
% 
% The output file are ecmwf_y1987m**.nc'
% 

% 
% It uses the functions  fill_nan.m   convert_accu.m   and interpol.m  
% 
% Modified by Eliott the 9th of July 2018
%

% clear former workspace 
clear;
close all;

%% load data fron coarse ncdf
% Read input_file
% filename_input = '/home/lifewatch-user/working_directory/ecmwf_shape_input_0607/withMATLAB/test.nc';
% filename_output = '/home/lifewatch-user/working_directory/ecmwf_shape_input_0607/withMATLAB/test_y2016m12.nc' 

% file_list = '/home/lifewatch-user/Downloads/PFE/ecmwf_1987_input/input/1987_*.nc' 

input_dirName = '/home/lifewatch-user/Downloads/PFE/ecmwf_1987_input/input/';  
output_dirName = '/home/lifewatch-user/Downloads/PFE/ecmwf_1987_input/output/';  

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


U10 =[];
V10 =[];
T2M =[];

for i=1:numel(files)
    filename_input = fullfile(input_dirName,files{i});     %# full path to file
    files{i} = strcat('ecmwf_',  files{i});
    filename_output = fullfile(output_dirName, files{i}); 
    
        %% reading the input data
    lon   = ncread(filename_input, 'longitude');
    lat   = ncread(filename_input, 'latitude');
    time  = ncread(filename_input, 'time');
    d2m = ncread(filename_input, 'd2m');
    msl = ncread(filename_input, 'msl');
    t2m = ncread(filename_input, 't2m');
    tcc = ncread(filename_input, 'tcc');
    tp = ncread(filename_input, 'tp');
    u10 = ncread(filename_input, 'u10');
    v10 = ncread(filename_input, 'v10'); 
        %% Fill missing values
    lon(isnan(lon)) = 1.000000020040877e+20 ;
    lat(isnan(lat)) = 1.000000020040877e+20 ;
    time(isnan(time)) = max(time) ;
    d2m = fill_nan(d2m);
    % e = fill_nan(e);
    msl = fill_nan(msl);
    t2m = fill_nan(t2m);
    tcc = fill_nan(tcc);
    tp = fill_nan(tp);
    u10 = fill_nan(u10);
    v10 = fill_nan(v10);
        %% Convert accumulated data over several time step to accumulation over a single timestep
    tp_notConverted = tp;
    tp = convert_accu(tp);
 
    

        %% read the offset and scale factors from source netcdf file
    d2m_scale_factor = ncreadatt(filename_input,'d2m','scale_factor');
    msl_scale_factor = ncreadatt(filename_input,'msl','scale_factor');
    t2m_scale_factor = ncreadatt(filename_input,'t2m','scale_factor');
    tcc_scale_factor = ncreadatt(filename_input,'tcc','scale_factor');
    u10_scale_factor = ncreadatt(filename_input,'u10','scale_factor');
    v10_scale_factor = ncreadatt(filename_input,'v10','scale_factor');
    tp_scale_factor = ncreadatt(filename_input,'tp','scale_factor');
  
    d2m_offset_value = ncreadatt(filename_input,'d2m','add_offset');
    msl_offset_value = ncreadatt(filename_input,'msl','add_offset');
    t2m_offset_value = ncreadatt(filename_input,'t2m','add_offset');
    tcc_offset_value = ncreadatt(filename_input,'tcc','add_offset');
    u10_offset_value = ncreadatt(filename_input,'u10','add_offset');
    v10_offset_value = ncreadatt(filename_input,'v10','add_offset');
    tp_offset_value = ncreadatt(filename_input,'tp','add_offset');    
    
%     figure
%     surf(u10(:,:,1));
    

%% Daily average
U10_m = [];
V10_m = [];
t2m_m = [];
    for i=1:((size(u10,3)-1)/8)
        U10_m = [U10_m,mean2(u10(:,:,(8*i-7):(i*8)))];
        V10_m = [V10_m,mean2(v10(:,:,(8*i-7):(i*8)))];
        t2m_m = [t2m_m,mean2(t2m(:,:,(8*i-7):(i*8)))];
        
        
        
    end
    
    U10 = [U10 , U10_m ];
    V10 = [V10 , V10_m ];
    T2M = [T2M , t2m_m ];

    
end
t1 = datetime(1987,01,1,0,0,0);
t2 = datetime(1988,01,31,23,59,59);
t = t1:t2;

subplot(3,1,1);

plot( t, T2M-273.15)
title('Air Temperature (C)')
xlim([t1 t2])
ylim([-5 35])
    hline = ones(1,size(t,2))*0;%mean(T2M-273.15);
hold on
plot( t , hline)
hold off

subplot(3,1,2);

plot( t, U10)
title('Wind velocity, x-component (m/s)')
xlim([t1 t2])
ylim([-6 6])
    hline = ones(1,size(t,2))*mean(U10);
hold on
plot( t , hline)
hold off

subplot(3,1,3);


plot( t, V10)
title('Wind velocity, y-component (m/s)')
xlim([t1 t2])
ylim([-6 6])
    hline = ones(1,size(t,2))*mean(V10);
hold on
plot( t , hline)
hold off

% sgtitle('My Subplot Grid Title')


