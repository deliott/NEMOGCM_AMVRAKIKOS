
% % % % % 
%% Create the netcdf recipient file
% % % % % 
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
netcdf.putAtt(ncid,varid_lon,'long_name','longitude');
netcdf.putAtt(ncid,varid_lon,'_CoordinateAxisType','Lon');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_lat = netcdf.defVar(ncid,'latitude','NC_FLOAT',dimidlat); %NC_DOUBLE ou NC_FLOAT ?
% % % % % % % % % % % % % Create attributes associated with the variable latitude
netcdf.putAtt(ncid,varid_lat,'units','degrees_north');
netcdf.putAtt(ncid,varid_lat,'long_name','latitude');
netcdf.putAtt(ncid,varid_lat,'_CoordinateAxisType','Lat');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_time = netcdf.defVar(ncid,'time','NC_INT',dimidtime); %NC_DOUBLE ou NC_FLOAT ?
netcdf.putAtt(ncid,varid_time,'units','hours since 1900-01-01 00:00:0.0');
netcdf.putAtt(ncid,varid_time,'long_name','time');
netcdf.putAtt(ncid,varid_time,'calendar','gregorian');
netcdf.putAtt(ncid,varid_time,'_CoordinateAxisType','Time');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_d2m = netcdf.defVar(ncid,'d2m','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]); 
netcdf.putAtt(ncid,varid_d2m,'scale_factor',d2m_scale_factor);
netcdf.putAtt(ncid,varid_d2m,'add_offset',d2m_offset_value);
netcdf.putAtt(ncid,varid_d2m,'missing_value','-32767');
netcdf.putAtt(ncid,varid_d2m,'units','K');
netcdf.putAtt(ncid,varid_d2m,'long_name','2 metre dewpoint temperature');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_msl = netcdf.defVar(ncid,'msl','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]); 
netcdf.putAtt(ncid,varid_msl,'scale_factor',msl_scale_factor);
netcdf.putAtt(ncid,varid_msl,'add_offset',msl_offset_value);
netcdf.putAtt(ncid,varid_msl,'missing_value','-32767');
netcdf.putAtt(ncid,varid_msl,'units','Pa');
netcdf.putAtt(ncid,varid_msl,'long_name','Mean sea level pressure');
netcdf.putAtt(ncid,varid_msl,'standard_name','air_pressure_at_sea_level');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_t2m = netcdf.defVar(ncid,'t2m','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]); %NC_DOUBLE ou NC_FLOAT ?
netcdf.putAtt(ncid,varid_t2m,'scale_factor',t2m_scale_factor);
netcdf.putAtt(ncid,varid_t2m,'add_offset',t2m_offset_value);
netcdf.putAtt(ncid,varid_t2m,'missing_value','-32767');
netcdf.putAtt(ncid,varid_t2m,'units','K');
netcdf.putAtt(ncid,varid_t2m,'long_name','2 metre temperature');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_tcc = netcdf.defVar(ncid,'tcc','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]);
netcdf.putAtt(ncid,varid_tcc,'scale_factor',tcc_scale_factor);
netcdf.putAtt(ncid,varid_tcc,'add_offset',tcc_offset_value);
netcdf.putAtt(ncid,varid_tcc,'missing_value','-32767');
netcdf.putAtt(ncid,varid_tcc,'units','%');
netcdf.putAtt(ncid,varid_tcc,'long_name','Total cloud cover');
netcdf.putAtt(ncid,varid_tcc,'standard_name','cloud_area_percentage');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_tp = netcdf.defVar(ncid,'tp','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]);
netcdf.putAtt(ncid,varid_tp,'scale_factor',tp_scale_factor);
netcdf.putAtt(ncid,varid_tp,'add_offset',tp_offset_value);
netcdf.putAtt(ncid,varid_tp,'missing_value','-32767');
netcdf.putAtt(ncid,varid_tp,'units','m');
netcdf.putAtt(ncid,varid_tp,'long_name','Total precipitation');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_u10 = netcdf.defVar(ncid,'u10','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]);
netcdf.putAtt(ncid,varid_u10,'scale_factor',u10_scale_factor);
netcdf.putAtt(ncid,varid_u10,'add_offset',u10_offset_value);
netcdf.putAtt(ncid,varid_u10,'missing_value','-32767');
netcdf.putAtt(ncid,varid_u10,'units','m s**-1');
netcdf.putAtt(ncid,varid_u10,'long_name','10 metre U wind component');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
varid_v10 = netcdf.defVar(ncid,'v10','NC_DOUBLE', [dimidlon,dimidlat,dimidtime]);
netcdf.putAtt(ncid,varid_v10,'scale_factor',v10_scale_factor);
netcdf.putAtt(ncid,varid_v10,'add_offset',v10_offset_value);
netcdf.putAtt(ncid,varid_v10,'missing_value','-32767');
netcdf.putAtt(ncid,varid_v10,'units','m s**-1)');
netcdf.putAtt(ncid,varid_v10,'long_name','10 metre V wind component');
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Leave define mode and enter data mode to write data.
netcdf.endDef(ncid);
%% Write data to variables.
netcdf.putVar(ncid,varid_lon,Xq(1,:));
netcdf.putVar(ncid,varid_lat,Yq(:,1));
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
netcdf.putVar(ncid,varid_time,time);
netcdf.putVar(ncid,varid_d2m,interp_d2m);
netcdf.putVar(ncid,varid_msl,interp_msl);
netcdf.putVar(ncid,varid_t2m,interp_t2m);
netcdf.putVar(ncid,varid_tcc,interp_tcc);
netcdf.putVar(ncid,varid_tp,interp_tp);
netcdf.putVar(ncid,varid_u10,interp_u10);
netcdf.putVar(ncid,varid_v10,interp_v10);
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % % % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % %% Close file and display its parameters
netcdf.close(ncid)
ncdisp(filename_output);
% % % % % % % % % % % % 