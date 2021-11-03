%
% Ejemplo
% T=(4*1024)/700;fcM=0;tic;dibujaEstadisticos_TTD('TZ',40,1e3,fcM,5,0.1,1,32,T,[2,3,6,7],[10],700./[70,50,35,20],[0.5],700./[70,50,35,20],700./[70,50,35,20],700./[70,50,35,20],0.3);toc
%
% T=1024/700;foMax=2.7;tic;dibujaEstadisticos_Articulo('TZ',15,1e4,foMax,5,0.1,1,32,T,[1,2,3,4],[0.5,1,2,5,10,50]*T,[10,20,40,60],[0.5,1],[10,20,40,60],[10,20,40,60],[10,20,40,60],[]);toc
%


function [X,Y,lbl]=signal_generator_wan(SNR,iteraciones,T,rTipoSig,BWc,T1_rel,Tcesc,Dfesc,vsFSK,Dffsk,nFSK,vsPSK,nPSK,pAl,cAl,cod,vsASK,vsQAM,Roff)
    

    % Crea la carpeta para almacenar los vectores de seÃ±al resultantes
    %[status,msg,msgID] = mkdir(directorio);

    % Frecuencia de muestreo en MHz
%     fs = 6500;
    fs = 100;
    
%     fo=[fs/8,3*fs/8]; % Frecuencia de portadora (MHz)
    fo = [-fs/4, fs/4]; 
    
    % MASK
    nASK=[1,2];

    % MQAM
    nQAM=[2,3];
    
    % NLFM
    nNLFM=4;
    kNLFM=0.015;
    
    %Salidas:
    X = zeros(length(SNR)*iteraciones,1024,2);
    Y = zeros(length(SNR)*iteraciones, 12);
    lbl = zeros(length(SNR)*iteraciones, 6);
    
    ik = 1;
    
    for i=1:length(SNR)
        
        snr_i=10^(SNR(i)/10);

        for k=1:iteraciones,
            
            % frecuencia de portadora aleatoria entre fo(1) y fo(2) normalizada respecto de fs
            fo_k= (fo(1)+(fo(2)-fo(1))*rand(1))/fs;
            % fo_k= 200/fs;
            T_k = round((T(1) + (T(2) - T(1))*rand(1)))/fs;
            
          for l=1:length(rTipoSig)  
            
              tipoSig=rTipoSig(l); 
            
            % Tipos de seÃ±al generados
            % 1 - LFM
            % 2 - MFSK
            % 3 - MPSK
            % 4 - NM
            % 5 - LFM tri
            % 6 - LFM esc
            % 7 - MQAM
            
            switch tipoSig,
                case 1, % LFM 
                    
                    BWc_k=(BWc(1)+(BWc(2)-BWc(1))*rand(1))*fs;
                    %BWc_k=BWc(randsrc(1,1,[1:length(BWc)])); %Ancho de banda en MHz
                                       
                    datosSig(k,i,4)=BWc_k/fs; %Se almacena el ancho de banda de la seÃ±al LFM que se va a generar
                    
                    T_k=round(T_k*fs); %DuraciÃ³n del pulso en muestras
                    BWc_k=BWc_k/fs; %Ancho de banda normalizado de la fs
                    
                    pendiente_k=randsrc; %Se elije aleaotiamente pendiente ascendente(1) o descendente(-1)
%                   pendiente_k=1;

                    cr_k=(BWc_k/T_k)*pendiente_k; %chirp rate
                    
                    [x,t,error]=lfm(1,fo_k,pAl,T_k,1,cr_k);
                    datosSig(k,i,5)=pendiente_k;
                    clas_Sig = 1;
                    
                case 2, % MFSK
                    
                    nFSK_k=nFSK(randsrc(1,1,[1:length(nFSK)]));
                    T_k=round(T_k*fs);
                    
                    vs_k=vsFSK(randsrc(1,1,[1:length(vsFSK)]));
                    ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo
                    
                    
                    %Df_k=(Dffsk(1)+(Dffsk(2)-Dffsk(1))*rand(1));
                    Df_k=1/ns_k;
%                   Df_k=Dffsk(randsrc(1,1,[1:length(Dffsk)]));
                    numSimbolos_k=ceil(T_k/ns_k);
                    faseContinua=0;
                    switch nFSK_k
                        case 1
                            clas_Sig = 2;
                        case 2
                            clas_Sig = 3;
                        case 3
                            clas_Sig = 4;
                    end
                    %%% Generar código Costas en FSK
                    codFSK = [];
                    errorC = 0;
                    if (cAl == 0)
                       if (~isempty(cod)),
                        len_p = [3,4,5,6];
                        ran = randsrc(1,1,[1:length(len_p)]);
                        len = len_p(ran);
                        %vs2 = [0.29, 0.39, 0.48, 0.58];
                        %vs_k=vs2(ran);
                        %ns_k=fs/vs_k;
                                
                        [codFSK,errorC]= codigoCostas(len);
                        codFSK = codFSK(1,:);
                        numSimbolos_k=length(codFSK);
                        T_k = round(numSimbolos_k * ns_k);
                        clas_Sig = 2;
                        end
                    end
                    if errorC,
                        disp('Error al generar el código costas.')
                        return
                    end
                    
                    %%%
                   
                    [x,t,codigo,error]=m_fsk(1,fo_k,Df_k,ns_k,numSimbolos_k,pAl,cAl,codFSK,nFSK_k,T_k,1,faseContinua,Roff,1);
                    
                    datosSig(k,i,4)=vs_k;
                    datosSig(k,i,5)=nFSK_k;
                    datosSig(k,i,6)=Df_k;
                                        
                case 3, % MPSK
                    
                    nPSK_k=nPSK(randsrc(1,1,[1:length(nPSK)]));
                    
                    T_k=round(T_k*fs);
                    
                    vs_k=vsPSK(randsrc(1,1,[1:length(vsPSK)]));
                    ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo
%                     ns_k=round(ns_k);
                    numSimbolos_k=ceil(T_k/ns_k);
%                     roff=.5;
%                     roff=[];
                    switch nPSK_k
                        case 1
                            clas_Sig = 6;
                        case 2
                            clas_Sig = 7;
                        case 3
                            clas_Sig = 8;
                    end
%          %%% Generar código radar específico en PSK %%
                    errorC = 0;
                    codPSK = [];
                    if (cAl == 0)
                       if (~isempty(cod)),
                        switch cod,
                            case 1,
                                len_p = [5,7,11,13];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                vs2 = [2, 5, 10, 15, 20];
                                vs_k=vs2(randsrc(1,1,[1:length(vs2)]));
                                ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoBarker(len);
                                clas_Sig = 3;
                            case 2,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                lob_p = [-63,-60,-56];
                                lob = lob_p(randsrc(1,1,[1:length(lob_p)]));
                                [codPSK,errorC]=codigoHuffman(len,lob);
                                clas_Sig = 10;
                            case 3,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoFrank(len);
                                clas_Sig = 4;
                            case 4,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoP1(len);
                                clas_Sig = 5;
                            case 5,
                                len_p = [16, 36, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 3.51, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoP2(len);
                                clas_Sig = 6;
                            case 6,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                codPSK=codigoP3(len);
                                clas_Sig = 7;
                            case 7,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                codPSK=codigoP4(len,0);
                                clas_Sig = 8;
                            case 8,
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoPx(len);
                                clas_Sig = 16;
                            case 9,
                                rs = [11,13];
                                r_c = rs(randsrc(1,1,[1:length(rs)]));
                                len_p = [16, 25, 36, 49, 64];
                                ran = randsrc(1,1,[1:length(len_p)]);
                                len = len_p(ran);
                                %vs2 = [1.56, 2.44, 3.51, 4.78, 6.25];
                                %vs_k=vs2(ran);
                                %ns_k=fs/vs_k;
                                
                                [codPSK,errorC]=codigoZadoff_Chu(len,r_c);
                                clas_Sig = 8;
                            case 10,
                                k_p = [4,5,6];
                                kk = k_p(randsrc(1,1,[1:length(k_p)]));
                                
                                T_k = round((T(2)/4 + (T(2) - T(2)/4)*rand(1)))/fs;
                                T_k=round(T_k*fs);
                                
                                [phase, codPSK, t, errorC] = codigoT1(1,T_k/ns_k,1,2,kk);
                                clas_Sig = 9;
                            case 11,
                                k_p = [4,5,6];
                                kk = k_p(randsrc(1,1,[1:length(k_p)]));
                                
                                T_k = round((T(2)/4 + (T(2) - T(2)/4)*rand(1)))/fs;
                                T_k=round(T_k*fs);
                                
                                [phase, codPSK, t, errorC] = codigoT2(1,T_k/ns_k,1,2,kk);
                                clas_Sig = 10;
                            case 12,
                                BWc_k=(BWc(1)+(BWc(2)-BWc(1))*rand(1));
                                
                                T_k = round((T(2)/4 + (T(2) - T(2)/4)*rand(1)))/fs;
                                T_k=round(T_k*fs);
                                
                                [phase, codPSK, t, errorC] = codigoT3(1,T_k/ns_k,1,2,BWc_k);
                                clas_Sig = 11;
                            case 13,
                                BWc_k=(BWc(1)+(BWc(2)-BWc(1))*rand(1));
                                
                                T_k = round((T(2)/4 + (T(2) - T(2)/4)*rand(1)))/fs;
                                T_k=round(T_k*fs);
                                
                                [phase, codPSK, t, errorC] = codigoT4(1,fo_k,T_k/ns_k,1,2,BWc_k);
                                clas_Sig = 12;
                                
                        end
                        
                        T_k=round(ns_k*length(codPSK));
                        numSimbolos_k=length(codPSK);
                        
                        end
                    end
                    if errorC,
                        disp('Error al generar el código radar.')
                        return
                    end
%                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    

                    [x,t,codigo,error]=m_psk(1,fo_k,ns_k,numSimbolos_k,0,cAl,codPSK,nPSK_k,T_k,1,Roff,2);

                    
                    datosSig(k,i,4)=vs_k;
                    datosSig(k,i,5)=nPSK_k;
                                        
                case 4, % NM
                    
                    T_k=round(T_k*fs); % Longitud de bloque en muestras
                    
                    x=exp(j*2*pi*(fo_k*(0:T_k-1)+rand(1)));
                    clas_Sig = 22;
                
                case 5, % LFM triangular
                    
                    T1_rel_k = T1_rel(randsrc(1,1,[1:length(T1_rel)]));
                    
                    T1_k = T_k*T1_rel_k;
                    T2_k= T_k-T1_k;
                            
                    T_k = T1_k + T2_k;
                    BWc_k=BWc(randsrc(1,1,[1:length(BWc)])); %Ancho de banda en MHz                    
                                     

                    T_k=T_k*fs;
                    T1_k=T1_k*fs; %Duración del pulso en muestras
                    T2_k=T2_k*fs; %Duración del pulso en muestras
                    BWc_k=BWc_k/fs; %Ancho de banda normalizado de la fs
                    
                    pendiente_k=randsrc; %Se elije aleaotiamente pendiente ascendente(1) o descendente(-1)
                    %pendiente_k=1;
                          
                    cr_k1=pendiente_k*(BWc_k/T1_k); %chirp rate
                    cr_k2=(-pendiente_k)*(BWc_k/T2_k); %chirp rate
                          
                    if pendiente_k == 1
                       pen= 'A';
                    else
                       pen= 'V';
                    end
                             
                    [x,t,error]=lfm_tr(1,fo_k,pAl,T1_k,T2_k,1,1,cr_k1,cr_k2,BWc_k,[]);
                    
                case 6, % LFM esc
                    
                   Tc_k =Tcesc(randsrc(1,1,[1:length(Tcesc)]));
                   Dfc_k=Dfesc(randsrc(1,1,[1:length(Dfesc)]));
                    
                   T_k=T_k*fs; %Duración del pulso en muestras
                   Tc_k=Tc_k*fs; %Duración del pulso en muestras
                   Dfc_k=Dfc_k/fs; %Ancho de banda normalizado de la fs
                   BWc_k = Dfc_k * T_k/Tc_k; 
                    
                   pendiente_k=randsrc(1,1,[1,-1]); 
                    
                   [x,t,error]=lfm_esc(1,fo_k,pAl,T_k,Tc_k,T_k/Tc_k,1,1,[],BWc_k,[],pendiente_k);
                            
                
                case 7, % MQAM
                    
                    nQAM_k=nQAM(randsrc(1,1,[1:length(nQAM)]));
                    
                    T_k=round(T_k*fs);
                    
                    vs_k=vsQAM(randsrc(1,1,[1:length(vsQAM)]));
                    ns_k=fs/vs_k; % NÃºmero de muestras por sÃ­mbolo
%                     ns_k=round(ns_k);
                    numSimbolos_k=ceil(T_k/ns_k);
%                     roff=.5;
%                     Roff=[];
                    [x,t,codigo,error]=m_qam(1,fo_k,ns_k,numSimbolos_k,pAl,cAl,cod,nQAM_k,T_k,1,Roff,1);
                    
                    datosSig(k,i,4)=vs_k;
                    datosSig(k,i,5)=nQAM_k;
                    
               case 8, % Ruido
                                        
                    T_k=round(T_k*fs); % Longitud de bloque en muestras
                    
                    x = zeros(1,T_k);
                    
                    clas_Sig = 23;
                    
            end
            
            datosSig(k,i,1)=clas_Sig;
            datosSig(k,i,2)=SNR(i);
            datosSig(k,i,3)=T_k;
            datosSig(k,i,7) = fo_k;
            
            
          % Amplitud del ruido
           
           ampR = 1; % Amplitud fija de ruido
           ampS=sqrt(2*snr_i*ampR^2); % Amplitud de señal depende del ruido fijado y de la SNR  
                  
           r = ampR*(randn(1,length(x)) + 1j*randn(1,length(x))); %Ruido aleatorio gaussiano 
            
           s = ampS*x+r;
           s = s / max(abs(s)) ;
           
           m_s = min([length(s), T(2)]);
           s = s(1:m_s);
           
           I = real(s);
           Q = imag(s);
           
           %r2 = ampR*(randn(1,T(2)-length(I)) + 1j*randn(1,T(2)-length(Q)));
           
           %I = [I r2];
           %Q = [Q r2];
           
           t1 = linspace(1,length(I),length(I)); 
           t2 = linspace(1,length(I),T(2)); 
           I = interp1(t1,I,t2);
           Q = interp1(t1,Q,t2);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            signal = I + 1j*Q;
%            
%            signal = signal(:);
% 
%            signal = real(signal);
% 
%            Lfft = 256;
%            M = 64;
%            ventana = chebwin(Lfft,60);
% 
%             % Normalización ventana proyecto 2008 (normalizada respecto al ruido)
%             % ventana = ventana/sqrt(sum(abs(ventana).^2));
% 
%             % Normalización ventana proyecto 2018 (normalizada respecto a la señal)
%             ventana = ventana/sum(ventana);
%             Nfft = floor((size(signal,1)-Lfft)/M)+1;
%             If = zeros(Nfft,1);
%             Qf = zeros(Nfft,1);
%             Amp = zeros(Nfft,1);
%             K_Max = Amp;
%             Phi = Amp;
% 
%             % FFT sucesivas (STFT)
%             for outFFT = 1:Nfft
%                 fft_inst = fft(signal([1:Lfft]+(outFFT-1)*M).*ventana).';
%                 [Amp(outFFT),K_Max(outFFT)] = max(abs(fft_inst(1:(Lfft/2))));
%                 If(outFFT) = real(fft_inst(K_Max(outFFT)));
%                 Qf(outFFT) = imag(fft_inst(K_Max(outFFT)));
%                 Phi(outFFT) = angle(fft_inst(K_Max(outFFT)));
%                 K_Max(outFFT)= K_Max(outFFT)-1;
%             end
%             
%            t1 = linspace(1,length(If),length(If)); 
%            t2 = linspace(1,length(If),1024); 
%            If = interp1(t1,If,t2);
%            Qf = interp1(t1,Qf,t2);
%             
%             fi = Phi + K_Max*3.1293;
%             fi = fi - [0; fi(1:end-1)];
%             fi = mod(fi + pi,2*pi);
%             fi = fi - mod(2*pi*K_Max*M/Lfft,2*pi);
%             fi = (mod(fi,2*pi)-pi)/(2*pi*M);
%             fi = fi + (K_Max)/Lfft;
%  
%             fi = fi(2:end);
%             
%             Lmedian = 9;
%             % Filtro mediana
%             fi_mf = medfilt1([zeros(floor(Lmedian/2),1);fi;zeros(floor(Lmedian/2),1)],Lmedian);
%             fc = mean(fi_mf([Lmedian:16]));
%             aux_ph = 2*pi*M*cumsum(fi-fc);
%            
%            t1 = linspace(1,length(fi),length(fi)); 
%            t2 = linspace(1,length(fi),1024); 
%            fi = interp1(t1,fi,t2);
%            aux_ph = interp1(t1,aux_ph,t2);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parámetros de la señal
%   X -> I y Q
%   Y -> mod, SNR, params:
           X(ik,:,1) = I;
           X(ik,:,2) = Q;
     %      X(ik,:,3) = fi;
     %      X(ik,:,4) = aux_ph;
           
           out = [datosSig(k,i,1), datosSig(k,i,2), datosSig(k,i,3),datosSig(k,i,7), datosSig(k,i,4), datosSig(k,i,6)];
           
           lbl(ik,:) = out;
           Y(ik,datosSig(k,i,1)) = 1;
           
           ik = ik+1;
           
% mod: datosSig(k,i,1)= clas_Sig
% classes = ['LFM','2FSK','4FSK','8FSK', 'Costas','2PSK','4PSK','8PSK',
% 'Barker','Huffman','Frank','P1','P2','P3','P4','Px','Zadoff-Chu','T1',
% 'T2','T3','T4','NM','ruido']
% PARAMS: Pendiente por definir !!      
%             datosSig(k,i,2) =  SNR (dB)
%             datosSig(k,i,3) =  T_k (muestras)
%             datosSig(k,i,4)    LFM: BW    FSK: vs     PSK: vs     QAM: vs
%             datosSig(k,i,5)    LFM: alpha FSK: n      PSK: n      QAM: n
%             datosSig(k,i,6)               FSK: Df
%             datosSig(k,i,7) = fo

     
     
     %       s=ampS*x;              
     %       s= real(s);       
     %       r = real(r);      
     %       N = 256;          
     %       S  =   acondicionamientoSTFT(s, OL, Lfft);
                         
          end
     end

end
end
