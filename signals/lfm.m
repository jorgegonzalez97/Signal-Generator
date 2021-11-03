

%
% Genera un pulso de una señal LFM a partir de sus características.
%   Parámetros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       T: Duración del pulso chirp.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       k: chirp rate (normalizada de fs).
%       B: Ancho de banda (normalizado de fs).
%       ascend: Pendiente positiva (1) o negativa (-1).
%           Es posible introducir el chirp rate (k) o bien el ancho de
%           banda de la señal (B) y la pendiente, de tal forma que 
%           k=ascend*(B/T).
%
%   Parámetros de salida:
%       s: Señal generada.
%       t: Vector de tiempos.
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,error]=lfm(fs,fo,pAl,T,muestras,k,B,ascend)

    error=0;
    s=0;
    t=0;
    
    if nargin<6,
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(fs)|isempty(fo)|isempty(pAl)|isempty(T)|isempty(muestras),
        disp('Faltan parámetros')
        error=1;
        return
    end
    
    if isempty(k)&&(isempty(B)||isempty(ascend)),
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    % Si los tiempos introducidos son en segundos se pasan a muestras.
    % El número de muestras de la señal de salida se redondea hacia abajo.
    if muestras==0,
        Tsecuencia=floor(T*fs);
    else,
        Tsecuencia=floor(T);
    end
    
    % Generamos el vector de tiempos
    Ts=1/fs;
    n=0:Ts:T-Ts;
    
    if isempty(k),
        slfm=exp(j*pi*ascend*(B*fs/T)*n.^2);
        if ascend==1,
            fc=B/2;
        else,
            fc=-B/2;
        end
    else,
        slfm=exp(j*pi*k*fs*n.^2);
        fc=0.5*k*(T-1)*fs;
    end
    
    % Cogemos el número de muestras pedidas
    
    s=slfm;
    s=s(1:Tsecuencia);
    Ts=1/fs;
    t=0:Ts:(Tsecuencia-1)*Ts;
    
    % Normalizamos la potencia
    
    potS=sum(abs(s).^2)/length(s);
    s=s/sqrt(potS);
    
    % Lo llevamos a fo-fc
    
    s=s.*exp(j*2*pi*(fo-fc)*[0:length(s)-1]);
    
    % Le damos fase aleatoria si se pide
    
    if pAl==1,
        s=s*exp(j*2*pi*rand(1));
    end
    
end

