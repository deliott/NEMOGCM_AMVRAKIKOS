function [ output_field ] = write_resto_ssh( mask_field, input_field )


% This function is used by the make_resto_ssh.m script 
% It modifies the resto_field to put the buffer zone in it 
% with a tanh transition

% It also plot the tanh function used.

i_min = 93;
i_max = 128;
j_min = 65 ; 
j_max = 85;
  
test_x = j_min:j_max;
output_field = input_field;


for j=j_min:j_max
    output_field(j,i_min:i_max) =  mask_field(j,i_min:i_max,1) ;%* (1-tanh((j- (j_max+j_min)/2)/5))/2;
end


end


