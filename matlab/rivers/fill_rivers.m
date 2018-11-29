function [ field ] = fill_rivers( field, coordinate_list, value1, value2, fill_value)

% value1 = 0.001;
% value2 = 0.0005;

% i=107;j=240:243;
% i =357:360 ; j = 230;

% Arachtos


%% Louros
  for k = 1:size(field,3)
    field(:,:,k) = fill_value;
    field(coordinate_list(1):coordinate_list(2),coordinate_list(3):coordinate_list(4),k) = value2 + value2*abs(sin(k))/3  ; % Arachtos
    field(coordinate_list(5):coordinate_list(6),coordinate_list(7):coordinate_list(8),k) = value1 +  value1*abs(cos(k))/3 ; % Louros
  end


end

