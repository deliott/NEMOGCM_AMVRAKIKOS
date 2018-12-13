function [ interpolated_field] = interpol( field, Xq, Yq, lon, lat )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%Layer by layer interpolation
interpolated_field = zeros(size(Xq,2),size(Xq,1),size(field,3)); % here 319 and 446 and 69 (69=time)
[X,Y] = meshgrid(lon, lat');
for k = 1:size(field,3)
    V = field(:,:,k)';
    interpolated_field(:,:,k) = interp2(X,Y,V,Xq,Yq,'linear',0)';
end



end

