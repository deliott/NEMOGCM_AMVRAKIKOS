function [ field ] = fill_rivers_runoff( field, coordinate_list, value1, value2, fill_value)

% Used in main_rivers : 
% rorunoff = fill_rivers_runoff(zeros(size(Xq,2),size(Xq,1),size(time,1)), coordinate_list, 0.0005, 0.001, 0);% 0 = fill_value for runoff


% value1 = 0.001;
% value2 = 0.0005;

% i=107;j=240:243;
% i =357:360 ; j = 230;

% Arachtos

arachtos = '/home/eliott/PFE/working_directory/rivers/arachthos_1987.csv';
louros = '/home/eliott/PFE/working_directory/rivers/louros_1987.csv';
Flow_Arachtos = readtable(arachtos);
Flow_Louros = readtable(louros);


% formatIn = 'yyyy-mm-dd';        
% datenum(datestr(Flow_Arachtos.x_Date_),formatIn)

m_lon = 103.14 ;
m_lat = 97.18 ; 
surf_unitaire = m_lon * m_lat ;
nb_pixel_Louros = 1 ; %change to use coordinates lists
nb_pixel_Arachtos = 3 ; %change to use coordinates lists

day1 = Flow_Arachtos.x_Date_(1);
i = 1;
j = 1;

conv_coeff_Arachtos = 1000/(surf_unitaire*nb_pixel_Arachtos);    % x m3/S = 1000*x/(SUM(SURF(pixel))), SUM on the number of pixel considerated for the river.
conv_coeff_Louros= 1000/(surf_unitaire*nb_pixel_Louros);
% conv_coeff_Arachtos = 1000/(300*2);
% conv_coeff_Louros= 1000/(100*2);

for k = 1:size(field,3)
      % k = k^th day of the year (since January 1st 1987)
    field(:,:,k) = fill_value;
    
    %% Arachtos
    if (Flow_Arachtos.x_Date_(i)+1 - day1)==k %does the ith date is the kth day of the year ? 
        field(coordinate_list(1):coordinate_list(2),coordinate_list(3):coordinate_list(4),k) = Flow_Arachtos.x_mcubeParS_(i) * conv_coeff_Arachtos;
        i = i+1;
    else %we put the value of the day before  ===> pas vraiment necessaire en fait.
        field(coordinate_list(1):coordinate_list(2),coordinate_list(3):coordinate_list(4),k) = Flow_Arachtos.x_mcubeParS_(i-1) * conv_coeff_Arachtos;
        
    end
    
    %% Louros
    if (Flow_Louros.x_Date_(j)+1 - day1)==k %does the ith date is the kth day of the year ? 
        field(coordinate_list(5):coordinate_list(6),coordinate_list(7):coordinate_list(8),k) = Flow_Louros.x_mcubeParS_(j) * conv_coeff_Louros;
        j = j+1;
    else %we put the value of the day before ===> pas vraiment necessaire en fait.
        field(coordinate_list(5):coordinate_list(6),coordinate_list(7):coordinate_list(8),k) = Flow_Louros.x_mcubeParS_(j-1) * conv_coeff_Louros;
        display (j)
    end
end




end
