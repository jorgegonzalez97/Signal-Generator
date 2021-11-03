% lfm_esc_tr.m
%
% Genera un pulso de una señal Chirp triangular escalonada a partir de sus características.
%
%   La señal generada puede ser de tipo A(ascendente-descendente) o tipo
%    V(descendente-ascendente).
%
%   (Para generar cada una de las rampas se emplea el script lfm_esc.m)
%
%   Parámetros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       T1: Duración del pulso chirp segmento 1.
%       T2: Duración del pulso chirp segmento 2.
%       Tc1: Tiempo de Chip en el segmento 1.
%       Tc2: Tiempo de Chip en el segmento 2
%       Nc1: Numero de Chips en el segmento 1.
%       Nc2: Numero de Chips en el segmento 2.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       CP: de fase continua (1) o salto de fase (0).
%       k1: chirp rate (normalizada de fs) segmento 1.
%       k2: chirp rate (normalizada de fs) segmento 2.
%       Df1: Excursion en frecuencia en el segmento 1.
%       Df2: Excursion en frecuencia en el segmento 2.
%       B: Ancho de banda (normalizado de fs).
%       tipo: Chirp en A ('A') o Chirp en V ('V').
%
%       Es posible introducir el chirp rate (k) o bien el ancho de
%       banda de la señal (B) y la pendiente, de tal forma que 
%       k=ascend*(B/T).
%
%   Parámetros de salida:
%       s: Señal generada.
%       t: Vector de tiempos.
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,error]=lfm_esc_tr(fs,fo,pAl,T1,T2,Tc1,Tc2,Nc1,Nc2,muestras,CP,k1,k2,Df1,Df2,B,tipo,CC)

    error=0;
    s=0;
    t=0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<6,
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(fs)||isempty(fo)||isempty(pAl)||isempty(muestras),
        disp('Faltan parámetros')
        error=1;
        return
    end
    
    if isempty(T1)&&(isempty(Nc1)||isempty(Tc1)),
        disp('Faltan parámetros')
        error = 1;
        return
    end
    
    if isempty(T2)&&(isempty(Nc2)||isempty(Tc2)),
        disp('Faltan parámetros')
        error = 1;
        return
    end
    
    if isempty(k1)&&(isempty(B)||isempty(tipo)),
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(k2)&&(isempty(B)||isempty(tipo)),
        disp('Faltan parámetros');
        error=1;
        return
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if isempty(T1)
        T1 = Tc1*Nc1;
    end
    
    if isempty(T2)
        T2 = Tc2*Nc2;
    end
    
    if muestras==0,
        Tsecuencia1=floor(T1*fs);
        Tsecuencia2=floor(T2*fs);
    else,
        Tsecuencia1=floor(T1);
        Tsecuencia2=floor(T2);
    end
    
    % se determina la pendiente de cada uno de los segmentos de la señal
    % triangular
    pendiente = zeros(1,2);
    if strcmp(tipo,'A'),
        % pendiente ascendente - pendiente descendente
        pendiente=[1,-1];
    elseif strcmp(tipo,'V')
        % pendiente descendente - pendiente ascendente
        pendiente=[-1,1];
    end
    
    
    % se generan cada uno de los segmentos
    Ts = 1/fs;
    [s1,t1,error1]=lfm_esc(fs,fo,0,T1,Tc1,Nc1,muestras,CP,k1,B,Df1,pendiente(1));
    [s2,t2,error2]=lfm_esc(fs,fo,0,T2,Tc2,Nc2,muestras,CP,k2,B,Df2,pendiente(2));
    
    % Si el tiempo de chip es el mismo en ambos segmentos, y si se pide, se
    % fuerza a que ambos segmentos compartan el chip de cambio de
    % tendencia, para de esta manera mantener el periodo de chip inalterado
    % en todo el pulso.
    if CC&&(Tc1==Tc2),
        Tc = Tc1;
        s1 = s1(1:end-Tc);
    else 
        Tc = 0;
    end
    
    % Se provoca continuidad de fase entre el primer segmento y el segundo si se pide
    if CP,
        s2=s2(1:end)*exp(j*angle(s1(end)));
    end
    
    s = [s1, s2];
    
    % Se toman el número de muestras indicadas
    Tsecuencia1 = Tsecuencia1-Tc*fs;
    s = s(1:Tsecuencia1+Tsecuencia2);
    
    t1 = t1(1:end-Tc);
    Ts = 1/fs;
    % Se crea el vector de tiempos
    t=[t1, t2(1:end)+t1(end)+Ts];
    
    % Normalizamos la potencia
    potS=sum(abs(s).^2)/length(s);
    s=s/sqrt(potS);
    
    % Se asigna fase aleatoria si se pide
    if pAl==1,
        s=s*exp(j*2*pi*rand(1));
    end

    if error1||error2,
        error = 1;
    end
end

