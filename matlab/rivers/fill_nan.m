function [field ] = fill_nan( field )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


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

