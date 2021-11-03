function [Aq, Pq] = acondicionamientoSTFT(s, fs, FFTLen, overlap, winlen, lenfinal)

w = hamming(winlen);

S = stft(s,fs,'Window',w,'OverlapLength',overlap,'FFTLength',FFTLen);
S = S(FFTLen/2+1:FFTLen,:);

%A = abs(S) / max(max(abs(S)));
%P = angle(S) / pi;
Aq = abs(S);
Pq = angle(S);
%ss = size(S);

%[X,Y] = meshgrid(linspace(1,ss(2),ss(2)), linspace(1,ss(1),ss(1)));

%[Xq,Yq] = meshgrid(linspace(1,ss(2),lenfinal), linspace(1,ss(1),lenfinal));


%Aq = interp2(X,Y,A,Xq,Yq,'cubic');
%Pq = interp2(X,Y,P,Xq,Yq);

end

