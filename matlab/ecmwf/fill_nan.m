function [field ] = fill_nan( field )
%
% This function fills the nan values from the raw ecmwf timeseries. 
% It replaces them by the average vlue for the given timestep if it is not a nan
% else it replaces it by the average ofer all the timesteps
%
%INPUT :
%      field  = timeserie of ecmwf raw data, thrid dimension is time.
%OUTPUT : 
%      field = result of the filling of NaN by averae values
%
%    uses the built-in function isnan


moyenne = mean(mean(mean(field(:,:,:),'omitnan'),'omitnan'),'omitnan');
for k = 1:size(field,3)
    moy_level = mean(mean(field(:,:,k),'omitnan'),'omitnan');
    if isnan(moy_level)
        moy_level = moyenne;
    end
    for j = 1:size(field,2)
        for i = 1:size(field,1)
                    if isnan(field(i,j,k))
                        field(i,j,k) = moy_level ;
                    end
        end
    end
end

end

