function [] = AMC(fc,d,ber=0.1,ttl_symbl=1)

pkg load signal;
pkg load nan;
pkg load statistics;

sigma = 1;    % rayleigh parameter
R = d;              % Distance from transmitter to receiver
Pl = 128.1+(37.6*log10(R/1000));   % path loss
fc = fc;   % carrier frequency
A  = 10^(-3);     % symbol amplitude
No = -174; % Noise power 

fs = 3*fc;  % sampling frequency 
slot_time = 10^(-3);

T = 10^(-3)/14; % symbol time
bt_errr = 0 ; % to count the error symbols 
ttl_symbl = ttl_symbl; % total symbols to be sent 

% generate QPSK symbols and modulate them with carrier 

t = 0:1/fs:T; 
qpsk1 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
qpsk2 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
qpsk3 = (A)*cos(2*pi*fc*t)-(-A)*sin(2*pi*fc*t);
qpsk4 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
% carrier signals

carrier = cos(2*pi*fc*t);
crrr_phs_shftd = -sin(2*pi*fc*t);
symbols = {qpsk1,qpsk2,qpsk3,qpsk4};
symbl_cmprsn = [-A,-A;-A,A;A,-A;A,A];

 % channel behaviour

hx = normrnd (0,sigma,1,ttl_symbl);  
hy = normrnd (0,sigma,1,ttl_symbl); 
N = normrnd(0,sqrt(10^(No/10)/2),1,ttl_symbl);
pathloss = 10^(-Pl/10); %path loss in Db converted to volts

for k = 1:ttl_symbl

    tx_bt = randi([1 4],1,1); %save the symbol choosed to compare at the receiver
    tx_sym = cell2mat(symbols(tx_bt)); % transmitted symbol
    h = hx(k)+j*hy(k);  %channel distribution

    %received symbol

    rx_sym = h*pathloss*tx_sym+N(k);

    % demodulation
    
    rx_sym_h = rx_sym*conj(h);
    rx_sym1 = real(rx_sym_h).*carrier;
    rx_sym2 = real(rx_sym_h).*crrr_phs_shftd;

    %integration

    rx_sym1_int = (sum(rx_sym1)/fs)*2/T;
    rx_sym2_int = (sum(rx_sym2)/fs)*2/T;

    % detection

    if (rx_sym1_int > 0 )
      fin_sym1 = A;
    elseif (rx_sym1_int < 0)
      fin_sym1 = -A;
    endif

    if (rx_sym2_int > 0)
      fin_sym2 = A;
    elseif (rx_sym2_int < 0)
      fin_sym2 = -A;
    endif


    if(fin_sym1 != symbl_cmprsn(tx_bt,1))
      bt_errr = bt_errr+1;
    endif

    if (fin_sym2 != symbl_cmprsn(tx_bt,2))
      bt_errr = bt_errr+1;
    endif
    
endfor

bt_errr_rt_qpsk = bt_errr/(2*ttl_symbl)
% bit error rate for 16QAM
for k = 1:ttl_symbl

    tx_bt = randi([1 4],1,1); %save the symbol choosed to compare at the receiver
    tx_sym = cell2mat(symbols(tx_bt)); % transmitted symbol
    h = hx(k)+j*hy(k);  %channel distribution

    %received symbol

    rx_sym = h*pathloss*tx_sym+N(k);

    % demodulation
    
    rx_sym_h = rx_sym*conj(h);
    rx_sym1 = real(rx_sym_h).*carrier;
    rx_sym2 = real(rx_sym_h).*crrr_phs_shftd;

    %integration

    rx_sym1_int = (sum(rx_sym1)/fs)*2/T;
    rx_sym2_int = (sum(rx_sym2)/fs)*2/T;

    % detection

    if (rx_sym1_int > 0 )
      fin_sym1 = A;
    elseif (rx_sym1_int < 0)
      fin_sym1 = -A;
    endif

    if (rx_sym2_int > 0)
      fin_sym2 = A;
    elseif (rx_sym2_int < 0)
      fin_sym2 = -A;
    endif


    if(fin_sym1 != symbl_cmprsn(tx_bt,1))
      bt_errr = bt_errr+1;
    endif

    if (fin_sym2 != symbl_cmprsn(tx_bt,2))
      bt_errr = bt_errr+1;
    endif
    
endfor

bt_errr_rt_qpsk = bt_errr/(2*ttl_symbl)