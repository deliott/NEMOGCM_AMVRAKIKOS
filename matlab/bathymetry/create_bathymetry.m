% This script is creating the 100m bathymetry file for AMVRAKIKOS from the
% binary files provided by Mamoutos.
%
% The Ionian sea is included in this bathymetry.
% 
% The output file is bathy_meter.nc
% 
% It uses the function loadBin.m
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
    %% Creation of file with format
    ncid = netcdf.create(fileName,'64BIT_OFFSET');
    %% Define a dimension in the file.
    % dimidX = netcdf.defDim(ncid,'X',514);
    % dimidY = netcdf.defDim(ncid,'Y',270);

    dimidlon = netcdf.defDim(ncid,'lon',446);
    dimidlat = netcdf.defDim(ncid,'lat',319);
    %% Creation of the Variables and their Attributes
    % Define a new variable in the file.
    % varidX = netcdf.defVar(ncid,'X','NC_INT',dimidX);

    % Create attributes associated with the variable X.
    % netcdf.putAtt(ncid,varidX,'standard_name','projection_x_coordinate');
    % netcdf.putAtt(ncid,varidX,'units','unitless');
    % netcdf.putAtt(ncid,varidX,'axis','X');
    % netcdf.putAtt(ncid,varidX,'grid_point','T');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % varidY = netcdf.defVar(ncid,'Y','NC_INT',dimidY);

    % Create attributes associated with the variable Y
    % netcdf.putAtt(ncid,varidY,'standard_name','projection_y_coordinate');
    % netcdf.putAtt(ncid,varidY,'units','unitless');
    % netcdf.putAtt(ncid,varidY,'axis','Y');
    % netcdf.putAtt(ncid,varidY,'grid_point','T');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_lon = netcdf.defVar(ncid,'lon','NC_FLOAT',dimidlon);

    % Create attributes associated with the variable longitude
    netcdf.putAtt(ncid,varid_lon,'units','degrees_east');
    netcdf.putAtt(ncid,varid_lon,'long_name','Longitude');
    netcdf.putAtt(ncid,varid_lon,'FillValue',1.000000020040877e+20);
    netcdf.putAtt(ncid,varid_lon,'standard_name','lon');
    % netcdf.putAtt(ncid,varid_lon,'associate','Y X');
    netcdf.putAtt(ncid,varid_lon,'grid_point','T');
    netcdf.putAtt(ncid,varid_lon,'_CoordinateAxisType','Lon');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_lat = netcdf.defVar(ncid,'lat','NC_FLOAT',dimidlat);

    % Create attributes associated with the variable latitude
    netcdf.putAtt(ncid,varid_lat,'units','degrees_north');
    netcdf.putAtt(ncid,varid_lat,'long_name','Latitude');
    netcdf.putAtt(ncid,varid_lat,'FillValue',1.000000020040877e+20);
    netcdf.putAtt(ncid,varid_lat,'standard_name','lat');
    % netcdf.putAtt(ncid,varid_lat,'associate','Y X');
    netcdf.putAtt(ncid,varid_lat,'grid_point','T');
    netcdf.putAtt(ncid,varid_lat,'_CoordinateAxisType','Lat');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    varid_bath = netcdf.defVar(ncid,'Bathymetry','NC_FLOAT',[dimidlon,dimidlat]);

    % Create attributes associated with the variable bathymetry
    netcdf.putAtt(ncid,varid_bath,'units','meters');
    netcdf.putAtt(ncid,varid_bath,'standard_name','bathymetry');
    netcdf.putAtt(ncid,varid_bath,'long_name','Bathymetry');
    netcdf.putAtt(ncid,varid_bath,'associate','lat lon');
    netcdf.putAtt(ncid,varid_bath,'grid_point','T');
    % netcdf.putAtt(ncid,varid_bath,'src_file','rentrer_le_nom_du_fichier.nc');
    % netcdf.putAtt(ncid,varid_bath,'src_i_indices',[1229  1237]);
    % netcdf.putAtt(ncid,varid_bath,'src_j_indices',[667  680]);
    netcdf.putAtt(ncid,varid_bath,'FillValue',0);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Leave define mode and enter data mode to write data.
    netcdf.endDef(ncid);
    % % % Write data to variables.
    netcdf.putVar(ncid,varid_lon,Xq(1,:));
    netcdf.putVar(ncid,varid_lat,Yq(:,1));
    netcdf.putVar(ncid,varid_bath,Vq');

    % xx = cast(1:1:514, 'int32');
    % yy = cast(1:1:270, 'int32');
    % netcdf.putVar(ncid,varidX,xx);
    % netcdf.putVar(ncid,varidY,yy);
%     x`x`
    % % Re-enter define mode.
    % netcdf.reDef(ncid);
    % % If you want to ad some attributes




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Close file and display its parameters
    netcdf.close(ncid)
    %ncdisp(fileName);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
