% lfm_tr.m
%
% Genera un pulso de una señal Chirp triangular a partir de sus características.
%
%   La señal generada puede ser de tipo A(ascendente-descendente) o tipo
%    V(descendente-ascendente).
%
%   (Para generar cada una de las rampas se emplea el script lfm.m)
%
%   Parámetros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       T1: Duración del pulso chirp segmento 1.
%       T2: Duración del pulso chirp segmento 2.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       CP: de fase continua (1) o salto de fase (0).
%       k1: chirp rate (normalizada de fs) segmento 1.
%       k2: chirp rate (normalizada de fs) segmento 2.
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

function [s,t,error]=lfm_tr(fs,fo,pAl,T1,T2,muestras,CP,k1,k2,B,tipo)

    error=0;
    s=0;
    t=0;
    
    if nargin<6,
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(fs)||isempty(fo)||isempty(pAl)||isempty(T1)||isempty(T2)||isempty(muestras),
        disp('Faltan parámetros')
        error=1;
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
    
    Ts = 1/fs;
    [s1,t1,error1]=lfm(fs,fo,0,T1+Ts,muestras,k1,B,pendiente(1));
    [s2,t2,error2]=lfm(fs,fo,0,T2,muestras,k2,B,pendiente(2));
    
    % Se provoca continuidad de fase entre el primer segmento y el segundo si se pide
    if CP,
        s2=s2*exp(j*angle(s1(end)));
    end

    % La primera muestra del segundo tramo de la señal, es la misma que la
    % última muestra del primer tramo.
    s = [s1, s2(2:end)];
    
    % Se toman el número de muestras indicadas
    s = s(1:Tsecuencia1+Tsecuencia2);
    
    % Se crea el vector de tiempos
    t=[t1, t2(2:end)+t1(end)];
    
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

