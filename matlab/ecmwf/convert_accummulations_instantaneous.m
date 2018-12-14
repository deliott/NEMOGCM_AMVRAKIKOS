function [accu_on_time_step] = convert_accummulations_instantaneous( field )
%
% This function deals with accumulation data from ecmwf. (total precipitation)
% 
% Convert accumulated data over several time step to accumulation over a single timestep
%INPUT :
%      field  = timeserie of ecmwf raw data after fill_nan was applied, thrid dimension is time.
%OUTPUT : 
%      accu_on_time_step = time series of fields with instantaneous data instead of accumulated data.
%
%    uses the built-in function interp2
%
% The following ressources were used to understand the data structure : 
% https://software.ecmwf.int/wiki/pages/viewpage.action?pageId=56658233
% 	for how to deal with accumulated data with forecast type of interim data
%	for time conversion into meter per 3 hours  -> look at example 5 
% https://www.researchgate.net/post/How_do_I_convert_ERA_Interim_precipitation_estimates_from_kg_m2_s_to_mm_day
% 	for other units convertions :
%		86400 mm/day = 1 kg.m-2.s-1
% 		8*n/86.4 -> convert meters per 3h to kg.m-2.s-1

accu_on_time_step = field;
%time_size= size(field(1,1,:),3);
time_step = 1
%for time_step = 1:8 %time_size 
         if mod(time_step,4) == 2
	     time_step
             accu_on_time_step(:,:,time_step) = field(:,:,time_step) - field(:,:,time_step-1) 
	elseif mod(time_step,4) == 3
	      accu_on_time_step(:,:,time_step) = field(:,:,time_step) - field(:,:,time_step-1) ;
	elseif mod(time_step,4) == 0
	      accu_on_time_step(:,:,time_step) = field(:,:,time_step) - field(:,:,time_step-1) ;
	end




%* (8/86.4)  ; % from 00:00 to 03:00 and from from 12:00 to 15:00 no calculation required
    %     else
    % % %    DOESN'T LOOK NECESSARY AFTER ALL (GIVES NEGATIVE VALUES ...)    accu_on_time_step(:,:,time_step) = field(:,:,time_step)  - field(:,:,time_step -1) ;  %% We now have meters per 3 hours. 
    %         accu_on_time_step(:,:,time_step) = accu_on_time_step(:,:,time_step) * (8/86.4);  %% we now have kg.m-2.s-1
    %     end
  %  for i=1:size(field,1)
  %      for j=1:size(field,2)
  %      
  %          accu_on_time_step(i,j,time_step) = time_step/i*j;%field(i,j,time_step)* (8/86.4)  ; % from 00:00 to 03:00 and from from 12:00 to 15:00 no calculation required

%        end
%    end

%end

end

