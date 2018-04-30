% Using GNU Octave version 4.2.1
clc; clear; close;
tic;

if( exist('pictures','dir') == 0)
	mkdir 'pictures';
endif

% Generate 10 User Equipments (MSs) in Center Cell.
for uc = 20:20:100
	cell_tputmt = avg_user_tputmt = jain_fair_indexmt = cell_tputtta = avg_user_tputtta = jain_fair_indextta = cell_tputpf = avg_user_tputpf = jain_fair_indexpf = [];
	UserCount = uc;
	MS = getRandMS(UserCount, 0, 0, 500);
	for TTI = 1:10
		MS = getSINRs(MS);
		for index = 1 : UserCount
			METRIC_MT(index,:) = MS(index).drate_rb_array;
			METRIC_TTA(index,:) = MS(index).drate_rb_array / MS(index).drate_wb;
			if (TTI == 1)
				Rbar = ones(1,UserCount);
			end
			METRIC_PF(index,:) = METRIC_MT(index,:)./(Rbar(index));
		end
		% "max" function - gives maximum value, and index.. along the column of the input matrix
		[~,MT_allocation] = max(METRIC_MT);
		[~,TTA_allocation] = max(METRIC_TTA);
		[~,PF_allocation] = max(METRIC_PF);
		[cell_tputmt(TTI), avg_user_tputmt(TTI), jain_fair_indexmt(TTI)] = getMETRICS(MT_allocation, MS);
		[cell_tputtta(TTI), avg_user_tputtta(TTI), jain_fair_indextta(TTI)] = getMETRICS(TTA_allocation, MS);
		[cell_tputpf(TTI), avg_user_tputpf(TTI), jain_fair_indexpf(TTI)] = getMETRICS(PF_allocation, MS);
		Rbar = getPastAvgTput(PF_allocation, MS, Rbar, TTI);
	end
	final_cell_tp((uc/20),:) =[mean(cell_tputmt),mean(cell_tputtta),mean(cell_tputpf)];
	final_avg_usr_tp((uc/20),:) = [mean(avg_user_tputmt),mean(avg_user_tputtta),mean(avg_user_tputpf)];
	final_jn_fnss_ndx((uc/20),:) = [mean(jain_fair_indexmt),mean(jain_fair_indextta),mean(jain_fair_indexpf)]; 

disp('--');fflush(stdout);
end