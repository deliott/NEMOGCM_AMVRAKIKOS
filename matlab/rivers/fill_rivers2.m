function [ field ] = fill_rivers2( field , value1, value2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


% value1 = 0.001;
% value2 = 0.0005;



%Layer by layer interpolation
% interpolated_field = zeros(size(Xq,2),size(Xq,1),size(field,3)); % here 319 and 446 and 69 (69=time)
% [X,Y] = meshgrid(lon, lat');
% %% Louros
%   
%     field(:,:) = NaN;
% %     field(324:325,177) = value1 ;
%     field(240:243,107) = value1 ;
% 
% 
% %% Louros
%   
%     field(:,:) = NaN;
% %     field(212,98:100) = value2 ;
%     field(357:360,230) = value2 ;

    
%      field(:,:) = 123;
%     field(324:325,177,k) = value1 +  value1*abs(cos(k))/3 ;
%     field(240:243,107) = value1  ;

%% Louros
%286,288,169,169,85,85,213,213


    field(:,:) = NaN;
    field(286:288,196) = value1  ;% Arachtos
    field(85,213) = value2 ;% Louros



end

