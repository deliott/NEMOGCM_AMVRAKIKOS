% This script is creating the river runoff files file for AMVRAKIKOS 
% 
% The output file is amvra_rivers.nc
% 
% It uses the function fill_rivers_runoff.m fill_rivers2.m and fill_rivers.m

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

write_file = true; % true = write the output file.
filename_output = '/home/eliott/PFE/working_directory/rivers/amvra_rivers_test.nc' ;

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

%% Time variable

dt=86400;
n_dt = 370;
time = cast(dt*(0:(n_dt-1))', 'single');



coordinate_list = [342,343,185,186,89,89,212,212]; % New coordianates for rivers 
            %[xmin_Arachtos,xMax_Arachtos,ymin_Arachtos,yMax_Arachtos,xmin_Louros,xmax_Louros,ymin_Louros,yMax_Louros];
            % Coordinates on the configuration output file will be
            % translated : i_matlab -1 = i_config ; j_matlab -2 = j_config
            %              x                        y
            %We assume that the (342;186)point is covered by earth
            %therefore not  taken into acount.
            
rodepth  = fill_rivers2(zeros(size(Xq,2),size(Xq,1)), 2,2);
rodepth(:,:) = -1; % according to AMM12 file %-999;

%%Arachthos River
rodepth(coordinate_list(1):coordinate_list(2),coordinate_list(3):coordinate_list(4)) = 2  ;  % Arachtos

%%Louros River
rodepth(coordinate_list(5):coordinate_list(6),coordinate_list(7):coordinate_list(8)) =  2  ; % Louros

rotemper = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,1)),coordinate_list,  10, 10, -999); %-999 = fill_value for temperature
rosaline = fill_rivers(zeros(size(Xq,2),size(Xq,1),size(time,1)),coordinate_list, 1, 5, 0); % 0 = fill_value for salinity
rorunoff = fill_rivers_runoff(zeros(size(Xq,2),size(Xq,1),size(time,1)), coordinate_list, 0.0005, 0.001, 0);% 0 = fill_value for runoff


%% writing the rivers in the output file.

if write_file  
    write_rivers;
end



