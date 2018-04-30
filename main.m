% Using GNU Octave version 4.2.1
clc; clear; close;
tic;

if( exist('pictures','dir') == 0)
	mkdir 'pictures';
endif

% Generate 10 User Equipments (MSs) in Center Cell.
UserCount = 10;
MS = getRandMS(UserCount, 0, 0, 500);
for TTI = 1:10
	MS = getSINRs(MS);
	for index = 1 : UserCount
		METRIC_MT(index,:) = MS(index).drate_rb_array;
		METRIC_TTA(index,:) = MS(index).drate_rb_array / MS(index).drate_wb;
		% METRIC_PF(index,:) = MS(index).drate_rb_array;
	end
	% "max" function - gives maximum value, and index.. along the column of the input matrix
	[~,MT_allocation] = max(METRIC_MT);
	[~,TTA_allocation] = max(METRIC_TTA);
end
