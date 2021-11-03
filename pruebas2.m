%%

fs = 100;
nPSK_k=1;

T_k = 1024;

SNR= -6;                  
vs_k=5;

ns_k=fs/vs_k;                   
numSimbolos_k=ceil(T_k/ns_k);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,1,[],nPSK_k,T_k,1,[],2);

%%

SNR= -6;    
[x,t,error]=lfm(1,0.25,1,1024,1,0.2/1024);
%%

fs = 100;
nFSK_k=1;
T_k = 1024;
 
SNR= 20;    
vs_k=5;

ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
Df_k=1/ns_k;
numSimbolos_k=ceil(T_k/ns_k);

[x,t,codigo,error]=m_fsk(1,0.25,Df_k,ns_k,numSimbolos_k,1,1,[],nFSK_k,T_k,1,1,[],1);

%%

figure(2);
%sgtitle('BPSK with v_s = 5 Msymb/s  and SNR = -6 dB');
%sgtitle('LFM with BW = 20 MHz  and SNR = -6 dB');
sgtitle('2FSK with v_s = 5 Msymb/s  and SNR = 20 dB');

snr_i = 10^(SNR/10);

ampR = 1; % Amplitud fija de ruido
ampS=sqrt(2*snr_i*ampR^2); % Amplitud de señal depende del ruido fijado y de la SNR  
                  
r = ampR*(randn(1,length(x)) + 1j*randn(1,length(x))); %Ruido aleatorio gaussiano 
            
s = ampS*x+r;
x = s / max(abs(s)) ;


figure(2)
subplot(3,2,3);
[S1,t,f] = tfrstft(x.',1:length(x), 256, hamming(32+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 32 ')

figure(2)
subplot(3,2,4);
[Sx,t,f] = tfrstft(x.',1:8:length(x), 256, hamming(32+1));
Sx = Sx(1:128,:);
surf(t,f(1:128),abs(Sx),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 32 decimated')

figure(2)
subplot(3,2,1);
[S1,t,f] = tfrcw(x.',1:length(x), 128, hamming(17),hamming(16+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('CWD Hamming 16 (Time / Freq.)')


figure(2)
subplot(3,2,2);
[S1,t,f] = tfrcw(x.',1:8:length(x), 128, hamming(17),hamming(16+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('CWD Hamming 16 (Time / Freq.) decimated')

figure(2)
subplot(3,2,5);
[S1,t,f] = tfrwv(x.',1:length(x), 128);
surf(t,f,abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('WVD')

figure(2)
subplot(3,2,6);
[S1,t,f] = tfrwv(x.',1:8:length(x), 128);
surf(t,f,abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('WVD decimated')




