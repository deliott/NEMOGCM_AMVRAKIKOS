function [ field ] = suppress_ionian( field )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


ionian_limits_of_buffer_zone = [65, 93, 128]; %west, south, north

for lon = 1:ionian_limits_of_buffer_zone(1)
    
    field(:, lon)= 0;
    
end

lonon2 = size(field,2)/2;

for lat =  1:82 %ionian_limits_of_buffer_zone(2)
    
    field(lat, 1:lonon2)= 0;
end   

for lat =  83:ionian_limits_of_buffer_zone(2)
    
    field(lat, 1:105)= 0;
end   

end 
