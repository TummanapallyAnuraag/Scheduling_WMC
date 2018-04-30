function [cell_tput, avg_user_tput, jain_fair_index] = getMETRICS(ALLOCATION_ARRAY, MS)
    UserCount = length(MS);

    for i = 1 : UserCount
    	allocated_rbs = (ALLOCATION_ARRAY == i);
    	UserTput(i) = sum(MS(i).datarate_array(allocated_rbs) );
    end
    cell_tput = sum(UserTput);
    avg_user_tput = mean(UserTput);
    jain_fair_index = cell_tput.^2 / ( UserCount * sum(UserTput.^2) );
endfunction
