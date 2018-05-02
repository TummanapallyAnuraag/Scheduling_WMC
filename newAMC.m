function [datarate] = newAMC(SINR)
	SINR = SINR;
	if (SINR <= 1.7)
		datarate = 138*10^3;
		mod_schme = 'QPSK (1/2)'; 
	elseif (SINR >= 3.7 && SINR < 4.5)
		datarate = 184*10^3;
		mod_schme = 'QPSK (2/3)';
	elseif (SINR >= 4.5 && SINR < 7.2)
		datarate = 207*10^3;
		mod_schme = 'QPSK (3/4)';
	elseif (SINR >= 7.2 && SINR < 9.5)
		datarate = 276*10^3;
		mod_schme = '16QAM (1/2)';
	elseif (SINR >= 9.5 && SINR < 10.7)
		datarate = 368*10^3;
		mod_schme = '16QAM (2/3)';
	elseif (SINR >= 10.7 && SINR < 14.8)
		datarate = 414*10^3;
		mod_schme = '16QAM (3/4)';
	elseif (SINR >= 14.8 && SINR < 16.1)
		datarate = 552*10^3;
		mod_schme = '64QAM (2/3)';
	elseif (SINR >= 16.1 )
		datarate = 621*10^3;
		mod_schme = '64QAM (3/4)';
	end

end
