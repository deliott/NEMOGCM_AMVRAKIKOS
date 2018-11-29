% This script is creating the river runoff files file for AMVRAKIKOS 
% 
% The output file is amvra_rivers.nc
% 
% It uses the function fill_rivers2.m and fill_rivers.m

% !!!!! fill_rivers2 too simple and should be improved !!!!
% 
% coordinates_list = loist of coordinates for the two river mouths. 4 for
% each river, l(1):l(2), l(3):l(4) define the first mouth
% 
% Written by Eliott the -- (end) of June 2018
% Modified with new data on the 31st of July
%
% You will have to run the next command on the output file : 
% ncks --mk_rec_dmn time amvra_rivers.nc -o amvra_rivers_unlimited.nc ; mv amvra_rivers_unlimited.nc amvra_rivers.nc

% To deal with the unlimited time variable



% clear former workspace 
clear;
close all;

write_file = false; % true = write the output file.

%% load data fron coarse ncdf
% Read input_file
filename_input = '/home/lifewatch-user/working_directory/rivers/amm12_rivers.nc';
% filename_output = '/home/lifewatch-user/NEMOGCM/CONFIG/AMVRA_rivers/EXP00/input/amvra_rivers.nc';
filename_output = '/home/lifewatch-user/working_directory/rivers/amvra_rivers.nc' ;

% ncdisp(filename_input);

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


% % ncdisp(filename_input);
lon12   = ncread(filename_input, 'x');
lat12   = ncread(filename_input, 'y');
time12  = ncread(filename_input, 'time_counter');
rorunoff12  = ncread(filename_input, 'rorunoff');
rotemper12  = ncread(filename_input, 'rotemper');
rosaline12  = ncread(filename_input, 'rosaline');
rodepth12 = ncread(filename_input, 'rodepth');
% 
% %% Resort data into a monotonous time :
% time = resort_time(time) ; 
% d2m = resort_data(d2m) ;
% msl = resort_data(msl) ;
% t2m = resort_data(t2m) ;
% tcc = resort_data(tcc) ;
% tp = resort_data(tp) ;
% u10 = resort_data(u10) ;
% v10 = resort_data(v10) ;
% 
% 
% %% Fill missing values
% lon(isnan(lon)) = 1.000000020040877e+20 ;
% lat(isnan(lat)) = 1.000000020040877e+20 ;
% time(isnan(time)) = max(time) ;
% d2m = fill_nan(d2m);
% % e = fill_nan(e);
% msl =  fill_nan(msl);
% t2m = fill_nan(t2m);
% tcc = fill_nan(tcc);
% tp = fill_nan(tp);
% u10 = fill_nan(u10);
% v10 = fill_nan(v10);

%%Arachthos River
time = time12; %1:86400: 2678400; %1:31 ; % = 31 days 

% input_fill_rivers2 = zeros(size(Xq,2),size(Xq,1));
% 
% rodepth  = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), 3, 4);
% rotemper  = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), NaN, NaN);
% rosaline = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), NaN, NaN);
% rorunoff = zeros(size(Xq,2),size(Xq,1),size(time,1));
% rorunoff = fill_rivers2(rorunoff, 0.05614285715, 0.24);


% rodepth  = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), 3,4);
% rotemper = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,2)), NaN, NaN);
% rosaline = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,2)), NaN, NaN);
% % rorunoff = zeros(size(Xq,2),size(Xq,1),size(time,1));
% rorunoff = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,2)), 0.05614285715, 0.24);


coordinate_list = [286,288,169,169,85,85,213,213];
% coordinate_list = [355,357,233,233,113,113,244,246];  %+2 for y and +1 for xin east river after looking at results
rodepth  = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), 2,2);
    rodepth(:,:) = -1; % according to AMM12 file %-999;
%     rodepth(357:360,230) = -2  ;  % Louros
%     rodepth(240:243,107) = - 4  ;% Arachtos
    rodepth(coordinate_list(1):coordinate_list(2),coordinate_list(3):coordinate_list(4)) = 2  ;  % Arachtos
    rodepth(coordinate_list(5):coordinate_list(6),coordinate_list(7):coordinate_list(8)) =  2  ; % Louros

rotemper = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,1)),coordinate_list,  10, 10, -999); %-999 = fill_value for temperature
rosaline = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,1)),coordinate_list, 1, 5, 0); % 0 = fill_value for salinity
% rorunoff = zeros(size(Xq,2),size(Xq,1),size(time,1));
rorunoff = fill_rivers_runoff(zeros(size(Xq,2),size(Xq,1),size(time,1)), coordinate_list, 0.0005, 0.001, 0);% 0 = fill_value for runoff

% value1 = 0.001;
% value2 = 0.0005;
% rodepth(100:150,10)  = cos(3.14*(100:150));



if write_file  
    % % % % % 
    %% Create the netcdf recipient file
    % % % % % % % % 
    ncid = netcdf.create(filename_output,'64BIT_OFFSET');
    %% Define a dimension in the file.    
    dimidlon = netcdf.defDim(ncid,'longitude',size(Xq,2));
    dimidlat = netcdf.defDim(ncid,'latitude',size(Xq,1));
    dimidtime = netcdf.defDim(ncid,'time',size(time,1));

    %% Creation of the Variables and their Attributes
    %%% Define longitude variable in the file.
    varid_lon = netcdf.defVar(ncid,'longitude','NC_FLOAT',dimidlon);
    %%% Create attributes associated with the variable longitude
    netcdf.putAtt(ncid,varid_lon,'units','degrees_east');
    netcdf.putAtt(ncid,varid_lon,'long_name','Longitude East');
    netcdf.putAtt(ncid,varid_lon,'_CoordinateAxisType','Lon');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_lat = netcdf.defVar(ncid,'latitude','NC_FLOAT',dimidlat); %NC_DOUBLE ou NC_FLOAT ?
    % % % % % % % % % % % % % Create attributes associated with the variable latitude
    netcdf.putAtt(ncid,varid_lat,'units','degrees_north');
    netcdf.putAtt(ncid,varid_lat,'long_name','latitude North');
    netcdf.putAtt(ncid,varid_lat,'_CoordinateAxisType','Lat');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_time = netcdf.defVar(ncid,'time','NC_INT',dimidtime); %NC_DOUBLE ou NC_FLOAT ?
    
    netcdf.putAtt(ncid,varid_time,'units','seconds since 2001-01-01 00:00:00');
    netcdf.putAtt(ncid,varid_time,'long_name','Time - second since');
    netcdf.putAtt(ncid,varid_time,'calendar','gregorian');
    netcdf.putAtt(ncid,varid_time,'_CoordinateAxisType','Time');
    netcdf.putAtt(ncid,varid_time,'time_origin','2001-01-01 00:00:0.0');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_rorunoff = netcdf.defVar(ncid,'rorunoff','NC_FLOAT', [dimidlon,dimidlat,dimidtime]); %NC_DOUBLE ou NC_FLOAT ?
    
    netcdf.putAtt(ncid,varid_rorunoff,'_Fillvalue','0');
    netcdf.putAtt(ncid,varid_rorunoff,'missing_value','0');
    netcdf.putAtt(ncid,varid_rorunoff,'units','kg m-2 s-1');
    netcdf.putAtt(ncid,varid_rorunoff,'valid_min','-20');
    netcdf.putAtt(ncid,varid_rorunoff,'valid_max','20');
    netcdf.putAtt(ncid,varid_rorunoff,'axis','XYT');
    netcdf.putAtt(ncid,varid_rorunoff,'coordinates','lon lat t');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_rosaline = netcdf.defVar(ncid,'rosaline','NC_FLOAT', [dimidlon,dimidlat,dimidtime]); %NC_DOUBLE ou NC_FLOAT ?
    
    netcdf.putAtt(ncid,varid_rosaline,'_Fillvalue','0');
    netcdf.putAtt(ncid,varid_rosaline,'missing_value','0');
    netcdf.putAtt(ncid,varid_rosaline,'units','psu');
    netcdf.putAtt(ncid,varid_rosaline,'valid_min','0');
    netcdf.putAtt(ncid,varid_rosaline,'valid_max','40');
    netcdf.putAtt(ncid,varid_rosaline,'axis','XYT');
    netcdf.putAtt(ncid,varid_rosaline,'coordinates','lon lat t');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_rotemper = netcdf.defVar(ncid,'rotemper','NC_FLOAT', [dimidlon,dimidlat,dimidtime]); %NC_DOUBLE ou NC_FLOAT ?
    
    netcdf.putAtt(ncid,varid_rotemper,'_Fillvalue','-999');
    netcdf.putAtt(ncid,varid_rotemper,'missing_value','-999');
    netcdf.putAtt(ncid,varid_rotemper,'units','degrees C');
    netcdf.putAtt(ncid,varid_rotemper,'valid_min','-1');
    netcdf.putAtt(ncid,varid_rotemper,'valid_max','30');
    netcdf.putAtt(ncid,varid_rotemper,'axis','XYT');
    netcdf.putAtt(ncid,varid_rotemper,'coordinates','lon lat t');
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    varid_rodepth = netcdf.defVar(ncid,'rodepth','NC_FLOAT', [dimidlon,dimidlat]); %NC_DOUBLE ou NC_FLOAT ?
    netcdf.putAtt(ncid,varid_rodepth,'_Fillvalue','-999');
    netcdf.putAtt(ncid,varid_rodepth,'missing_value','-999');
    netcdf.putAtt(ncid,varid_rodepth,'units','meters');
    netcdf.putAtt(ncid,varid_rodepth,'valid_min','-999');
    netcdf.putAtt(ncid,varid_rodepth,'valid_max','500');
    netcdf.putAtt(ncid,varid_rodepth,'axis','XY');
    netcdf.putAtt(ncid,varid_rodepth,'coordinates','lon lat');
    
    
    
%     varid_rodepth = netcdf.defVar(ncid,'rodepth','NC_FLOAT', [dimidlon,dimidlat]); %NC_DOUBLE ou NC_FLOAT ?
%     
%     netcdf.putAtt(ncid,varid_	,'_Fillvalue','-1');
%     netcdf.putAtt(ncid,varid_rodepth,'_Missing_value','-1');
%     netcdf.putAtt(ncid,varid_rodepth,'units','meters');
% % %     netcdf.putAtt(ncid,varid_rodepth,'valid_min','-999');
% % %     netcdf.putAtt(ncid,varid_rodepth,'valid_max','500');
%     netcdf.putAtt(ncid,varid_rodepth,'axis','XY');
%     netcdf.putAtt(ncid,varid_rodepth,'coordinates','lon lat');
%     
    
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % %% Leave define mode and enter data mode to write data.
    netcdf.endDef(ncid);
    % % % %% Write data to variables.

    netcdf.putVar(ncid,varid_lon,Xq(1,:));
    netcdf.putVar(ncid,varid_lat,Yq(:,1));
    % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    netcdf.putVar(ncid,varid_time,time);
    netcdf.putVar(ncid,varid_rorunoff,rorunoff);
    netcdf.putVar(ncid,varid_rotemper,rotemper);
    netcdf.putVar(ncid,varid_rosaline,rosaline);
    netcdf.putVar(ncid,varid_rodepth,rodepth);
    % % % % % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % % % % % % % %% Close file and display its parameters
    netcdf.close(ncid)
end
% ncdisp(filename_output);

% % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %% Write the data in netcdf file 
% % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % 
