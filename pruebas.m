%%
fs = 100;
nFSK_k=1;
T_k = 1024;
                    
vs_k=4;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
Df_k=1/ns_k;

[codFSK,errorC]= codigoCostas(6);
codFSK = codFSK(1,:);
numSimbolos_k=length(codFSK);
T_k = round(numSimbolos_k * ns_k);

[x,t,codigo,error]=m_fsk(1,0.01,Df_k,ns_k,numSimbolos_k,1,0,codFSK,nFSK_k,T_k,1,1,[],1);

figure(1)
sgtitle('Original')
subplot(3,1,1);
[S1,t,f] = tfrstft(x.',1:length(x), 128);
surf(t,f(1:64),abs(S1(1:64,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('STFT')

figure(1)
subplot(3,1,2);
[S2,t,f] = tfrwv(x.',1:length(x), 128);
surf(t,f,S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('WVD')

figure(1)
subplot(3,1,3);
[S3,t,f] = tfrcw(x.',1:length(x), 128);
surf(t,f,S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('CWD')

S1 = S1(1:64,:);
ss = size(S1);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),64), linspace(1,ss(1),64));

S1 = interp2(X,Y,abs(S1),Xq,Yq,'cubic');

ss = size(S2);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),128), linspace(1,ss(1),128));

S2 = interp2(X,Y,S2,Xq,Yq,'cubic');
S3 = interp2(X,Y,S3,Xq,Yq,'cubic');


figure(3)
sgtitle('Cubid interpolation over image')
subplot(3,1,1);
surf(1:64, linspace(0,0.5,64),abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 64 0 0.5])
title('STFT')

figure(3)
subplot(3,1,2);
surf(1:128, linspace(0,0.5,128),S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('WVD')

figure(3)
subplot(3,1,3);
surf(1:128, linspace(0,0.5,128),S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('CWD')

%%

fs = 100;
nPSK_k=1;
T_k = 1024;
                    
vs_k=20;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
numSimbolos_k=ceil(T_k/ns_k);

%[codPSK,errorC]=codigoBarker(13);
%[codPSK,errorC]=codigoFrank(len);
%[codPSK,errorC]=codigoP1(len);

%T_k=round(ns_k*length(codPSK));
%numSimbolos_k=length(codPSK);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,1,codPSK,nPSK_k,T_k,1,[],2);

figure(1)
subplot(4,1,1);
[S1,t,f] = tfrstft(x.',1:length(x), 256);
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT toolbox')

figure(1)
subplot(4,1,2);
[Sx,t,f] = tfrstft(x.',1:8:length(x), 256);
Sx = Sx(1:128,:);
surf(t,f(1:128),abs(Sx),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT toolbox')

figure(1)
subplot(4,1,3);
[S1, Pq] = acondicionamientoSTFT(x, fs, 256, 63, 64, 1);
surf(S1, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
%axis([1 1024 0 0.5])
title('STFT MatLab')


figure(1)
subplot(4,1,4);
[S1, Pq] = acondicionamientoSTFT(x, fs, 256, 56, 64, 1);
surf(S1, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
%axis([1 1024 0 0.5])
title('STFT MatLab')

%%

fs = 100;
nPSK_k=1;
T_k = 1024;
                    
vs_k=1;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
numSimbolos_k=ceil(T_k/ns_k);

%[codPSK,errorC]=codigoBarker(13);
%[codPSK,errorC]=codigoFrank(len);
%[codPSK,errorC]=codigoP1(len);

%T_k=round(ns_k*length(codPSK));
%numSimbolos_k=length(codPSK);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,1,[],nPSK_k,T_k,1,[],2);

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
[S1,t,f] = tfrstft(x.',1:length(x), 256, hamming(16+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 16 ')


figure(2)
subplot(3,2,2);
[S1,t,f] = tfrstft(x.',1:8:length(x), 256, hamming(16+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 16 decimated')

figure(2)
subplot(3,2,5);
[S1,t,f] = tfrstft(x.',1:length(x), 256, hamming(64+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 64')

figure(2)
subplot(3,2,6);
[S1,t,f] = tfrstft(x.',1:8:length(x), 256, hamming(64+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 64 decimated')

%%

fs = 100;
nFSK_k=1;
T_k = 1024;
                    
vs_k=4;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
Df_k=1/ns_k;
numSimbolos_k=ceil(T_k/ns_k);

[x,t,codigo,error]=m_fsk(1,0.25,Df_k,ns_k,numSimbolos_k,1,1,[],nFSK_k,T_k,1,1,[],1);

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
[S1,t,f] = tfrstft(x.',1:length(x), 256, hamming(16+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 16 ')


figure(2)
subplot(3,2,2);
[S1,t,f] = tfrstft(x.',1:8:length(x), 256, hamming(16+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 16 decimated')

figure(2)
subplot(3,2,5);
[S1,t,f] = tfrstft(x.',1:length(x), 256, hamming(64+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 64')

figure(2)
subplot(3,2,6);
[S1,t,f] = tfrstft(x.',1:8:length(x), 256, hamming(64+1));
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Hamming 64 decimated')

%%

fs = 100;
nPSK_k=1;
T_k = 1024;
                    
vs_k=20;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
numSimbolos_k=ceil(T_k/ns_k);

%[codPSK,errorC]=codigoBarker(13);
%[codPSK,errorC]=codigoFrank(len);
%[codPSK,errorC]=codigoP1(len);

%T_k=round(ns_k*length(codPSK));
%numSimbolos_k=length(codPSK);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,1,[],nPSK_k,T_k,1,[],2);

figure(2)
subplot(3,2,3);
[S1,t,f] = tfrcw(x.',1:length(x), 128, hamming(17),hamming(16+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16 Hamming 16 ')

figure(2)
subplot(3,2,4);
[Sx,t,f] = tfrcw(x.',1:8:length(x), 128, hamming(17),hamming(16+1));
surf(t,f,Sx,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16 Hamming 16 decimated')

figure(2)
subplot(3,2,1);
[S1,t,f] = tfrcw(x.',1:length(x), 128, hamming(17),hamming(8+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16 Hamming 8 ')


figure(2)
subplot(3,2,2);
[S1,t,f] = tfrcw(x.',1:8:length(x), 128, hamming(17),hamming(8+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16  Hamming 8 decimated')

figure(2)
subplot(3,2,5);
[S1,t,f] = tfrcw(x.',1:length(x), 128, hamming(17),hamming(32+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16 Hamming 32')

figure(2)
subplot(3,2,6);
[S1,t,f] = tfrcw(x.',1:8:length(x), 128, hamming(17),hamming(32+1));
surf(t,f,S1,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT Smoothing 16 Hamming 32 decimated')
%%
fs = 100;
nPSK_k=1;
T_k = 1024;
                    
vs_k=20;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
numSimbolos_k=ceil(T_k/ns_k);

%[codPSK,errorC]=codigoBarker(13);
%[codPSK,errorC]=codigoFrank(len);
%[codPSK,errorC]=codigoP1(len);

%T_k=round(ns_k*length(codPSK));
%numSimbolos_k=length(codPSK);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,1,codPSK,nPSK_k,T_k,1,[],2);

figure(1)
sgtitle('Without Time Decimation')
subplot(3,1,1);
[S1,t,f] = tfrstft(x.',1:length(x), 256);
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT')

figure(1)
subplot(3,1,2);
[S2,t,f] = tfrwv(x.',1:length(x), 128);
surf(t,f,S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('WVD')

figure(1)
subplot(3,1,3);
[S3,t,f] = tfrcw(x.',1:length(x), 128);
surf(t,f,S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('CWD')

figure(2)
sgtitle('First samples')
subplot(3,1,1);
surf(t(1:128), f(1:128)*2,abs(S1(1:128,1:128)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 64 0 0.5])
title('STFT')

figure(2)
subplot(3,1,2);
surf(t(1:128),f,S2(:,1:128), 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('WVD')

figure(2)
subplot(3,1,3);
surf(t(1:128),f,S3(:,1:128), 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('CWD')

S1 = S1(1:128,:);
ss = size(S1);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),128), linspace(1,ss(1),128));

S1 = interp2(X,Y,abs(S1),Xq,Yq,'cubic');

ss = size(S2);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),128), linspace(1,ss(1),128));

S2 = interp2(X,Y,S2,Xq,Yq,'cubic');
S3 = interp2(X,Y,S3,Xq,Yq,'cubic');


figure(3)
sgtitle('Cubid decimation over image')
subplot(3,1,1);
surf(1:128, linspace(0,0.5,128),abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('STFT')

figure(3)
subplot(3,1,2);
surf(1:128, linspace(0,0.5,128),S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('WVD')

figure(3)
subplot(3,1,3);
surf(1:128, linspace(0,0.5,128),S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('CWD')


figure(4)
sgtitle('Decimation in time-frequency distribution')
subplot(3,1,1);
%tfrstft(x');
[S1,t,f] = tfrstft(x.',1:8:length(x), 256);
surf(t,f(1:128),abs(S1(1:128,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('STFT')

figure(4)
subplot(3,1,2);
[S2,t,f] = tfrwv(x.',1:8:length(x), 128);
surf(t,f,S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('WVD')

figure(4)
subplot(3,1,3);
[S3,t,f] = tfrcw(x.',1:8:length(x), 128);
surf(t,f,S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 1024 0 0.5])
title('CWD')






%%
fs = 100;
nPSK_k=1;
T_k = 1024;
                    
vs_k=1;
ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo                   
numSimbolos_k=ceil(T_k/ns_k);

[codPSK,errorC]=codigoBarker(13);
%[codPSK,errorC]=codigoFrank(len);
%[codPSK,errorC]=codigoP1(len);

T_k=round(ns_k*length(codPSK));
numSimbolos_k=length(codPSK);


[x,t,codigo,error]=m_psk(1,0.25,ns_k,numSimbolos_k,1,0,codPSK,nPSK_k,T_k,1,[],2);

figure(1)
sgtitle('Original')
subplot(3,1,1);
[S1,t,f] = tfrstft(x.',1:length(x), 128);
surf(t,f(1:64),abs(S1(1:64,:)),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('STFT')

figure(1)
subplot(3,1,2);
[S2,t,f] = tfrwv(x.',1:length(x), 128);
surf(t,f,S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('WVD')

figure(1)
subplot(3,1,3);
[S3,t,f] = tfrcw(x.',1:length(x), 128);
surf(t,f,S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('CWD')

S1 = S1(1:64,:);
ss = size(S1);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),64), linspace(1,ss(1),64));

S1 = interp2(X,Y,abs(S1),Xq,Yq,'cubic');

ss = size(S2);

[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

[Xq,Yq] = meshgrid(linspace(1,ss(2),128), linspace(1,ss(1),128));

S2 = interp2(X,Y,S2,Xq,Yq,'cubic');
S3 = interp2(X,Y,S3,Xq,Yq,'cubic');


figure(3)
sgtitle('Cubid interpolation over image')
subplot(3,1,1);
surf(1:64, linspace(0,0.5,64),abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 64 0 0.5])
title('STFT')

figure(3)
subplot(3,1,2);
surf(1:128, linspace(0,0.5,128),S2, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('WVD')

figure(3)
subplot(3,1,3);
surf(1:128, linspace(0,0.5,128),S3, 'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 128 0 0.5])
title('CWD')


%%
% x = exp(1j*2*pi*(0.4*(0:1024-1)));
[s,t,error]=lfm(1,0.25,1,1024,1,0.2/1024);
%  [x,t,codigo,error]=m_psk(1,0.25,20,52,0,1,[],1,1024,1,[],2);
%  [x,t,codigo,error]=m_psk(1,0.25,20,52,0,1,[],1,1024,1,[],2);


ttt = 1:length(s);
[S1,t,f] = tfrstft(s.',ttt, 256, hamming(32+1));
[S2,t2,f2] = tfrwv(s.',ttt, 128);
[S3,t3,f3] = tfrcw(s.',ttt, 128, hamming(16+1),hamming(32+1));

subplot(3,1,1);
surf(t,f,abs(S1),'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) -0.5 0.5])
title('STFT')

subplot(3,1,2);
surf(t2,f2,S2,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('WV')

subplot(3,1,3);
surf(t3,f3,S3,'edgecolor', 'none')
view(2)
ylabel('Normalized frequency')
xlabel('Time (samples)')
axis([1 length(t) 0 0.5])
title('CW')
