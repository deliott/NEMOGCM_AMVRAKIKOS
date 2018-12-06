% This script is creating the 100m bathymetry file for AMVRAKIKOS from the
% binary files provided by Mamoutos.
%
% The Ionian sea is included in this bathymetry.
% 
% The output file is bathy_meter.nc
% 
% It uses the function loadBin.m write_bathy.m
% 
% Written by Eliott the 29th of May 2018
% 



%% clear former workspace 
clear;
close all;

write_file = true; % true = write the output file.
display_image = true; % true = display the matlab 3d view of the bathymetry

%% load and put data in shape
%fileName = '<path>/0524_new_test_bath/matlab_0529/bathy_meter.nc';
%filename100m = '<path>/mamoutos/test/amvrakikos_100m.bin';
fileName = '/home/eliott/PFE/working_directory/0524_new_test_bath/bathymetry_matlab_0529/test_decembre.nc'
filename100m = '/home/eliott/PFE/working_directory/mamoutos/test/amvrakikos_100m.bin';
[lon100m, lat100m, depth100m]= loadBin(filename100m, 514, 270);

lon100m = cast(lon100m(1,:) ,'single');
lat100m = cast(lat100m(:,1) ,'single');
depth100m = cast(depth100m' ,'single');
lon100m(isnan(lon100m)) = 1.000000020040877e+20 ;
lat100m(isnan(lat100m)) = 1.000000020040877e+20 ;
depth100m(isnan(depth100m)) = 0 ;

[X,Y] = meshgrid(lon100m(1,:), lat100m(:,1));
%[X,Y] = meshgrid(-50:1:50, -10:1:10);
% R = sqrt(X.^2 + Y.^2)+ eps;
V = depth100m';
% % % 
% figure
% % % % subplot(1,2,1) 
% s1 = surf(X,Y,V);
% title('Original 100m bathymetry data')
% s1.EdgeColor = 'none';
%[Xq,Yq] = meshgrid(20.6497:0.00363548:21.1841,38.8407:0.00089983083:39.1210);
lat_min = 38.8407;
lat_max = 39.1210;
Dlat = lat_max - lat_min;
dy = Dlat/ 318 ;
lon_min = 20.6497;
lon_max = 21.1841;
Dlon = lon_max - lon_min;
dx= Dlon/445;
[Xq,Yq] = meshgrid(lon_min:dx:lon_max,lat_min:dy:lat_max);

Vq = interp2(X,Y,V,Xq,Yq,'linear',0);

if display_image
    figure
    s2 = surf(Xq,Yq,Vq);
    title('Linear Interpolation of bathymetry on 446*319 grid');
    s2.EdgeColor = 'none';
end

if write_file  
	write_bathy
end
