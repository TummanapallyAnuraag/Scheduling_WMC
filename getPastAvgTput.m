function [Rbar] = getPastAvgTput(PF_allocation, MS, Rbar, TTI)
	% Referred from the Capozzi's Research Paper

	% Weighted Average to estimate average user experienced Data Rate(Rbar)
	bta = 0.8;
	UserCount = length(MS);

	if(TTI == 1)
		Rbar = 0;
	end
	for i = 1 : UserCount
    	allocated_rbs = (PF_allocation == i);	% Check the Allocation Matrix for current User,
    	UserTput(i) = sum(MS(i).datarate_array(allocated_rbs) );	
    	% Sum of all the Alloted PRB's data rate is the UE's Data Rate 
    end
	Rbar = bta * Rbar + (1-bta)*UserTput;
	Rbar = Rbar + (Rbar ==0)*10^(-6);
	% This is done becuase we were having Rbar sometimes as 0 
	% => Metric for PF would be NaN which is not handled properly.
	% So doing this will give the Metric a Large value, which is intended actually.

endfunction