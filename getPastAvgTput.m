function [Rbar] = getPastAvgTput(PF_allocation, MS, Rbar, TTI)
	beta = 0.8;
	UserCount = length(MS);
	if(TTI == 1)
		Rbar = 0;
	end
	for i = 1 : UserCount
    	allocated_rbs = (PF_allocation == i);
    	UserTput(i) = sum(MS(i).datarate_array(allocated_rbs) );
    end
	Rbar = beta * Rbar + (1-beta)*UserTput;
	Rbar = Rbar + (Rbar ==0)*10^(-6);

endfunction