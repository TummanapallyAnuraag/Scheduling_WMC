function [datarate] = AMC(fc=7500,d,berp=0.45,repetitions=1)

sigma = 1;    % rayleigh parameter
R = d;              % Distance from transmitter to receiver
Pl = 128.1+(37.6*log10(R/1000));   % path loss
fc = fc;   % carrier frequency
Pt = 13; % power transmitted in Db
A  = sqrt(10^(13/10)) ;     % symbol amplitude
No = -174; % Noise power 
permis_ber = berp;
fs = 3*fc;  % sampling frequency 
slot_time = 10^(-3);

T = 10^(-3)/14; % symbol time
bt_errr = 0 ; % to count the error symbols 
repetitions = repetitions; % total number of times process to repeated for average ber
t = 0:1/fs:T; 

% carrier signals

carrier = cos(2*pi*fc*t);
crrr_phs_shftd = -sin(2*pi*fc*t);


 % channel behaviour

hx = normrnd (0,sigma,1,repetitions);  
hy = normrnd (0,sigma,1,repetitions); 
N = normrnd(0,sqrt(10^(No/10)/2),1,repetitions);
pathloss = 10^(-Pl/10); %path loss in Db converted to volts
% bit error rate for 64QAM

ee = 0;
for k = 1:repetitions
    if(k == 1)
      tx_bt = dec2bin(randi([0 63],1,1),6) ;%save the symbol choosed to compare at the receiver
    endif
    if (tx_bt(1:3) == '000')
      tx_sym_re = A;
    elseif (tx_bt(1:3) == '001')
      tx_sym_re = 2*A;
    elseif (tx_bt(1:3) == '010') 
      tx_sym_re = 3*A;
    elseif (tx_bt(1:3) == '011') 
      tx_sym_re = 4*A;
    elseif (tx_bt(1:3) == '100') 
      tx_sym_re = -A;
    elseif (tx_bt(1:3) == '101')
      tx_sym_re = -2*A;
    elseif (tx_bt(1:3) == '110') 
      tx_sym_re = -3*A;
    elseif (tx_bt(1:3) == '111')
      tx_sym_re = -4*A; 
    end

    if (tx_bt(4:6) == '000')
      tx_sym_im = A;
    elseif (tx_bt(4:6) == '001')
      tx_sym_im = 2*A;
    elseif (tx_bt(4:6) == '010') 
      tx_sym_im = 3*A;
    elseif (tx_bt(4:6) == '011') 
      tx_sym_im = 4*A;
    elseif (tx_bt(4:6) == '100') 
      tx_sym_im = -A;
    elseif (tx_bt(4:6) == '101')
      tx_sym_im = -2*A;
    elseif (tx_bt(4:6) == '110') 
      tx_sym_im = -3*A;
    elseif (tx_bt(4:6) == '111')
      tx_sym_im = -4*A;
    end

    tx_sym = tx_sym_re*cos(2*pi*fc*t)-tx_sym_im*sin(2*pi*fc*t); % transmitted symbol
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

    sym = [A,2*A,3*A,4*A,-A,-2*A,-3*A,-4*A];
    bits_rx = ['000','001','010','011','100','101','110','111'];
    for l=1:length(sym)
      err(l) = (sym(l)-rx_sym1_int)^2;
      [~,minerr] = min(err);
      fin_sym1 = bits_rx(minerr);

      err1(l) = (sym(l)-rx_sym1_int)^2;
      [~,minerr] = min(err1);
      fin_sym2 = bits_rx(minerr);
    endfor
    rerr = tx_bt(1:2) == fin_sym1;
    imerr = tx_bt(3:4) == fin_sym2;
    ee = ee + (3-sum(rerr(:)))+(3-sum(imerr(:)));
    
endfor

bt_errr_rt_sixtyfourqam = ee/(6*repetitions);
if (bt_errr_rt_sixtyfourqam <= permis_ber)
  bt_errr_rt_qpsk = 'NA';
  bt_errr_rt_sixteenqam = 'NA';
  data = tx_bt;
else
  % bit error rate for 16QAM
  e = 0;
  for k = 1:repetitions
      if (k == 1)
        tx_bt = dec2bin(randi([0 15],1,1),4); %save the symbol choosed to compare at the receiver
      endif
      if (tx_bt(1:2) == '00')
        tx_sym_re = A;
      elseif (tx_bt(1:2) == '01') 
        tx_sym_re = -A;
      elseif (tx_bt(1:2) == '10') 
        tx_sym_re = 2*A;
      elseif (tx_bt(1:2) == '11') 
        tx_sym_re = -2*A;
      end

      if (tx_bt(3:4) == '00')
        tx_sym_im = A;
      elseif (tx_bt(3:4) == '01') 
        tx_sym_im = -A;
      elseif (tx_bt(3:4) == '10') 
        tx_sym_im = 2*A;
      elseif (tx_bt(3:4) == '11') 
        tx_sym_im = -2*A;
      end

      tx_sym = tx_sym_re*cos(2*pi*fc*t)-tx_sym_im*sin(2*pi*fc*t); % transmitted symbol
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

      sym = [A,-A,2*A,-2*A];
      bits_rx = ['00','01','10','11'];
      for l=1:length(sym)
        err(l) = (sym(l)-rx_sym1_int)^2;
        [~,minerr] = min(err);
        fin_sym1 = bits_rx(minerr);

        err1(l) = (sym(l)-rx_sym1_int)^2;
        [~,minerr] = min(err1);
        fin_sym2 = bits_rx(minerr);
      endfor
      rerr = tx_bt(1:2) == fin_sym1;
      imerr = tx_bt(3:4) == fin_sym2;
      e = e+(2-sum(rerr(:)))+(2-sum(imerr(:)));
      
  endfor

  bt_errr_rt_sixteenqam = e/(4*repetitions);
  if (bt_errr_rt_sixteenqam <= permis_ber)
    bt_errr_rt_qpsk = 'NA';
    data = tx_bt;
  else
    %ber for qpsk
    % generate QPSK symbols and modulate them with carrier 
    qpsk1 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
    qpsk2 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
    qpsk3 = (A)*cos(2*pi*fc*t)-(-A)*sin(2*pi*fc*t);
    qpsk4 = (A)*cos(2*pi*fc*t)-(A)*sin(2*pi*fc*t);
    symbols = {qpsk1,qpsk2,qpsk3,qpsk4};
    symbl_cmprsn = [-A,-A;-A,A;A,-A;A,A];
    bits = ['01';'10';'11';'00'];
    for k = 1:repetitions
        if (k == 1)
          tx_bt = randi([0 3],1,1); %save the symbol choosed to compare at the receiver
        endif
        tx_sym = cell2mat(symbols(tx_bt+1)); % transmitted symbol
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

        if (rx_sym1_int >= 0 )
          fin_sym1 = A;
        elseif (rx_sym1_int < 0)
          fin_sym1 = -A;
        endif

        if (rx_sym2_int >= 0)
          fin_sym2 = A;
        elseif (rx_sym2_int < 0)
          fin_sym2 = -A;
        endif


        if(fin_sym1 != symbl_cmprsn(tx_bt+1,1))
          bt_errr = bt_errr+1;
        endif

        if (fin_sym2 != symbl_cmprsn(tx_bt+1,2))
          bt_errr = bt_errr+1;
        endif
        
    endfor

    bt_errr_rt_qpsk = bt_errr/(2*repetitions);
    data =  bits(tx_bt+1,:);
  endif
endif
%  Datarate based on modulation technique used.

datarate   = (length(data)/T)*15;