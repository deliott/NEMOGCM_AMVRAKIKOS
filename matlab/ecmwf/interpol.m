function [ interpolated_field] = interpol( field, Xq, Yq, lon, lat )
%
% This function does a 2d linear interpolation at each timestep ofthe fields timeseries.
%
%INPUT :
%      field  = timeserie of ecmwf raw data after fill_nan was applied, thrid dimension is time.
%      Xq, Yq = meshgrid of longitude and latitdue used in interp2
%OUTPUT : 
%      interpolated_field = result of the linear interpolation of dimension x y (grid) and time
%                           no other coefficients are applied so far.
%
%    uses the built-in function interp2

%Layer by layer interpolation
interpolated_field = zeros(size(Xq,2),size(Xq,1),size(field,3)); % here 319 and 446 and 69 (69=time)
[X,Y] = meshgrid(lon, lat');
for k = 1:size(field,3)
    V = field(:,:,k)';
    interpolated_field(:,:,k) = interp2(X,Y,V,Xq,Yq,'linear',0)';
end



end

