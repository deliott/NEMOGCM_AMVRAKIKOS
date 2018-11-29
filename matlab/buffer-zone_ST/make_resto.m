% This scrit is creating the resto.nc file 
%
% 
% First we put arbitrary values on each side of the box>
% when data is available, we will use profiles. (maybe)
% 
% written by Eliott on  Monday 02/07/2018
% 
% Uses write_resto.m


% clear former workspace 
clear;
close all;


write_bool = true; 

%% load and put data in shape

% fileName = '/home/lifewatch-user/NEMOGCM/CONFIG/AMVRA_000/EXP00/input/resto.nc';
filename_output = '/home/lifewatch-user/working_directory/25_Layers_input/buffer_zone_2018_07_28/resto.nc';
filename_mask  = '/home/lifewatch-user/working_directory/25_Layers_input/buffer_zone_2018_07_28/mesh_mask.nc';


% ncdisp(fileName);

%% Time scale of the damping
time_scale =  (1*24*3600) ; %5heures


% ncdisp(fileName);


%% Target dimension
target_nlon = 446;
target_nlat = 319;
target_ndepth = 25;



%% creation of the grid

% https://www.nhc.noaa.gov/gccalc.shtml to convert in meter

lat_min = 38.8407;  % 38:50:26.52
lat_max = 39.1210;  % 39:7:15.60
Dlat = lat_max - lat_min; % 16' 49'' 
dy = Dlat/ (target_nlat -1) ;

lon_min = 20.6497;  % 20:38:58.92
lon_max = 21.1841;  % 21:11:03.76
Dlon = lon_max - lon_min; % 32' 3''
dx= Dlon/(target_nlon -1);

% [Xq,Yq] = meshgrid(lon_min:dx:lon_max,lat_min:dy:lat_max);

[Xq,Yq] = meshgrid(lat_min:dy:lat_max,lon_min:dx:lon_max);


%% creation of the resto_field

% resto_field = zeros(target_nlon, target_nlat, target_ndepth); 

% resto = ncread(fileName, 'resto');

mask_field =  cast(ncread(filename_mask, 'fmask'),'double');

resto_field = mask_field * 0;

resto_field =  write_resto(mask_field, resto_field)/time_scale ;



figure
subplot(1,2,1)
s1 = surf(resto_field(:, :, 2)');
s1.EdgeColor = 'none';
title('Plot of the buffer zone');
subplot(1,2,2)
s2 = surf(mask_field(:, :, 2));
s2.EdgeColor = 'none';
title('Plot of the fmask');








if write_bool 
    %% Creation of file with format
    ncid = netcdf.create(filename_output,'64BIT_OFFSET');
    %% Define a dimension in the file.
    dimidX = netcdf.defDim(ncid,'X',446);
    dimidY = netcdf.defDim(ncid,'Y',319);
    dimidZ = netcdf.defDim(ncid,'Z',25);
    %% Creation of the Variables and their Attributes
    % Define a new variable in the file.
    varidX = netcdf.defVar(ncid,'X','NC_INT',dimidX);
%     Create attributes associated with the variable X.
    netcdf.putAtt(ncid,varidX,'standard_name','projection_x_coordinate');
    netcdf.putAtt(ncid,varidX,'units','unitless');
    netcdf.putAtt(ncid,varidX,'axis','X');
    netcdf.putAtt(ncid,varidX,'grid_point','T');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varidY = netcdf.defVar(ncid,'Y','NC_INT',dimidY);
%     Create attributes associated with the variable Y
    netcdf.putAtt(ncid,varidY,'standard_name','projection_y_coordinate');
    netcdf.putAtt(ncid,varidY,'units','unitless');
    netcdf.putAtt(ncid,varidY,'axis','Y');
    netcdf.putAtt(ncid,varidY,'grid_point','T');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varidZ = netcdf.defVar(ncid,'Z','NC_INT',dimidZ);
%     Create attributes associated with the variable Z
    netcdf.putAtt(ncid,varidZ,'standard_name','projection_z_coordinate');
    netcdf.putAtt(ncid,varidZ,'units','unitless');
    netcdf.putAtt(ncid,varidZ,'axis','Z');
    netcdf.putAtt(ncid,varidZ,'grid_point','T');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_resto = netcdf.defVar(ncid,'resto','NC_FLOAT',[dimidX, dimidY, dimidZ]);
    %% Leave define mode and enter data mode to write data.
    netcdf.endDef(ncid);
    % % % Write data to variables.
%     netcdf.putVar(ncid,varidX,Xq(1,:));
%     netcdf.putVar(ncid,varidY,Yq(:,1));
    netcdf.putVar(ncid,varidX,Xq(:,1));
    netcdf.putVar(ncid,varidY,Yq(1,:));
    netcdf.putVar(ncid,varidZ,1:target_ndepth);
    netcdf.putVar(ncid,varid_resto,resto_field);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Close file and display its parameters
    netcdf.close(ncid);
end
