function [ output_field ] = write_resto( mask_field, input_field )


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


% xxx = [];

for k=1:25
    for j=j_min:j_max
        % xxx =[xxx (1-tanh((j- (j_max+j_min)/2)/4))/2]
        output_field(j,i_min:i_max,k) =  mask_field(j,i_min:i_max,k) * (1-tanh((j- (j_max+j_min)/2)/5))/2;
    end
end

% test_xx = (test_x - ((j_max+j_min)/2));

% plot(test_x,(1-tanh((test_x- (j_max+j_min)/2)/4))/2)
% title( 'tanh function used');

end


