function [cell_tput, avg_user_tput, jain_fair_index] = getMETRICS(ALLOCATION_ARRAY, MS)
    UserCount = length(MS);

    for i = 1 : UserCount
    	allocated_rbs = (ALLOCATION_ARRAY == i);	% Check Allocation Matrix for this User.
    	UserTput(i) = sum(MS(i).datarate_array(allocated_rbs) );	
    	% User throughput is sum of all Datarates in all PRBs in 1 TTI
    end
    cell_tput = sum(UserTput);	% Total throughput of complete cell.	
    avg_user_tput = mean(UserTput);	% Average cell Throughput 
    jain_fair_index = cell_tput.^2 / ( UserCount * sum(UserTput.^2) );	% Jain Fairness Index as Discussed in the Paper.
endfunction
