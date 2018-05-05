function [datarate] = newAMC(SINR)

	datarate = zeros(1,length(SINR));
	
	indices = SINR <= 3.7;
	datarate(indices) = 138*10^3;
	% mod_schme = 'QPSK (1/2)'; 


	indices = (SINR >= 3.7 && SINR < 4.5);
	datarate(indices) = 184*10^3;
	% mod_schme = 'QPSK (1/2)';
	datarate = 184*10^3;
	mod_schme = 'QPSK (2/3)';

	indices = (SINR >= 4.5 && SINR < 7.2);
	datarate(indices) = 207*10^3;
	% mod_schme = 'QPSK (3/4)';

	indices = (SINR >= 7.2 && SINR < 9.5);
	datarate(indices) = 276*10^3;
	% mod_schme = '16QAM (1/2)';

	indices = (SINR >= 9.5 && SINR < 10.7);
	datarate(indices) = 368*10^3;
	% mod_schme = '16QAM (2/3)';

	indices = (SINR >= 10.7 && SINR < 14.8);
	datarate(indices) = 414*10^3;
	% mod_schme = '16QAM (3/4)';

	indices = (SINR >= 14.8 && SINR < 16.1);
	datarate(indices) = 552*10^3;
	% mod_schme = '64QAM (2/3)';

	indices = (SINR >= 16.1 );
	datarate(indices) = 621*10^3;
	% mod_schme = '64QAM (3/4)';
end
