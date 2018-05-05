function [MS] = getSINRs(MS)
    % Each MS (or) UE has two SINRs , SINR and SINRk
    % SINR : For all the BW
    %   The Interference is caused due to Rayleigh channel and Neighbouring BS(eNB)s
    % SINRk : For kth(single) Resource Block (RB)

    % CONSTANTS:
    gamma = 4.5;
    N0 = 10^(-174/10);
    BW = 10*10^6;
    RB_BW = 180*10^3;
    RB_Count = floor( BW / RB_BW );
    Pt = 10^4.6; % signal power
    % -174 dB Noise PSD


    UserCount = length(MS);

    % Repeat the following for each User Equipment (MS)
    for i = 1 : UserCount
        % SINRk calculation => for 1 RB Only
        % For 1 TTI
        % It is sure that for 1 TTI the sub channel is flat fading.
        % so the channel gain is same as h throughout the TTI duration.

        hx = normrnd(0,1,7,RB_Count);
        hy = normrnd(0,1,7,RB_Count);
        h = hx + i*hy;
        % Each row corresponds to each cell (total 7)
        gain = abs(h).^2;
        % gain(1, :) => array of gain of all RBs in 1st cell(eUTRAN)
        numerator = ( gain(1,:)*Pt )./( ( MS(i).d_refcell )^gamma );
        denominator = N0*RB_BW;
        for bs_index = 1:6
            denominator = denominator + ( gain(1+bs_index,:)*Pt )./( ( MS(i).distance(bs_index) )^gamma );
        end
        MS(i).SINRk = numerator./denominator;

        for j = 1:RB_Count
            MS(i).datarate_array(j) = newAMC(fc=7500,MS(i).d_refcell,0.45,10);  
        end

        % SINR calculation => for all RBs taken together
        % for 1 TTI
        % Each RB has its own h, because the coherence Bandwidth is around 180kHz.
        % So we have to take RB_Count number of samples of h to estimate complete channel(entire Bandwidth)
        hx = normrnd(0,1,7,RB_Count);
        hy = normrnd(0,1,7,RB_Count);
        h = hx + i*hy;
        % Each row corresponds to each cell (total 7)
        gain = sum(abs(h).^2, 2);
        % Sum along the row => gain is added within same cell(eUTRAN)

        % To change the dimension and reset the values...
        numerator = denominator = 0;
        denominator = N0*BW;
        numerator = ( gain(1)*Pt )/( ( MS(i).d_refcell )^gamma );
        for bs_index = 1:6
            denominator = denominator + ( gain(1+bs_index)*Pt )/( ( MS(i).distance(bs_index) )^gamma );
        end
        MS(i).SINR = numerator/denominator;

        % Wide-Band Expected Data-Rate for ith user at time t => di(t)
        MS(i).drate_wb = log2(1 + MS(i).SINR)*10*10^6;
        % Expected Data-Rate for ith user at time t on "k-th" Resource Block(RB)
        MS(i).drate_rb_array = log2(1 + MS(i).SINRk)*180*10^3;
    end
endfunction
