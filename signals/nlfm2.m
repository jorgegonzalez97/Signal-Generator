

%
% Genera un pulso de una señal NLFM con un espectro en forma de 
% coseno alzado.
%   Parámetros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       T: Duración del pulso chirp.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       alfa: Pendiente de la señal (normalizada de fs) 
%       ascend: Pendiente positiva (1) o negativa (-1).
%   Parámetros de salida:
%       s: Señal generada.
%       t: Vector de tiempos.
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,error]=nlfm2(fs,fo,Bc,n,k,pAl,T,muestras,ascend)

    error=0;
    s=0;
    t=0;
    
    if nargin<9,
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(fs)|isempty(fo)|isempty(Bc)|isempty(n)|isempty(k)|isempty(pAl)|isempty(T)|isempty(muestras),
        disp('Faltan parámetros')
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
    
    N=round(T);
    
%     warning off all
    F=@(x)k+(1-k)*cos(pi*x/(Bc)).^n;
%     f=-Bc/2:Bc/N:Bc/2-Bc/N;
    f=-Bc/2:Bc/N:Bc/2-Bc/N;
    Phi1=zeros(1,length(f));
    for i=1:length(f),
        Phi1(i)=2*pi*quad(F,-Bc/2,f(i));
    end
%     warning on all
    
    Tf=(-Phi1)/2*pi;
    np=linspace(min(Tf),max(Tf),N);
    fi=-ascend*interp1(Tf,f,np);
        
%     figure
%     plot(0:T-1,fi)
       
    slfm=exp(j*2*pi*cumsum(fi));
    
    % Cogemos el número de muestras pedidas
    
    s=slfm;
    s=s(1:Tsecuencia);
    Ts=1/fs;
    t=0:Ts:(Tsecuencia-1)*Ts;
    
    % Normalizamos la potencia
    
    potS=sum(abs(s).^2)/length(s);
    s=s/sqrt(potS);
    
    % Lo llevamos a fo
    
    s=s.*exp(j*2*pi*fo*[0:length(s)-1]);
    
    % Le damos fase aleatoria si se pide
    
    if pAl==1,
        s=s*exp(j*2*pi*rand(1));
    end
    
end

