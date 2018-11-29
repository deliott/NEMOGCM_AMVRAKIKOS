% This scrit is computing the volume from the 
%
% 
%First we put arbitrary values on each side of the box>
% when data is available, we will use profiles. (maybe)
% 
% written by Eliott on  Monday 02/07/2018
% 
% Uses fill_buffer.m and multiply_mask.m


% clear former workspace 
clear;
close all;

%% load and put data in shape

fileName = '/home/lifewatch-user/working_directory/volume/bathy_meter.nc';

%% Time scale of the damping
time_scale =  (1 * 24 *3600) ; %5heures


%% Target dimension
target_nlon = 446;
target_nlat = 319;
target_ndepth = 15;


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

[Xq,Yq] = meshgrid(lon_min:dx:lon_max,lat_min:dy:lat_max);

m_lon = 103.14 ;
m_lat = 97.18 ; 
surf_unitaire = m_lon * m_lat ;

% ncdisp(fileName);

depth = ncread(fileName, 'Bathymetry');

volume = 0; 
for i=1:size(depth, 1)
   for j=1:size(depth, 2)
       volume = volume + surf_unitaire*depth(i,j);
   end
end

% volume en km cubes : 9.7684 km3


