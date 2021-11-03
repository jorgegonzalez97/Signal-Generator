%
% Genera un pulso de una seÃ±al escalonada en frecuencia a partir de sus caracterÃ­sticas.
%   ParÃ¡metros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       T: DuraciÃ³n del pulso chirp.
%		Tc: Tiempo de chip (periodo de cada escalÃ³n).
%		Nc: NÃºmero de chips en el pulso (escalones).
%		CP: de fase continua (1) o salto de fase (0).
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       k: chirp rate (normalizado de fs).
%       B: Ancho de banda (normalizado de fs).
%		Df: Excursion en frecuencia entre dos chips consecutivos (normalizado de fs).
%       ascend: Pendiente positiva (1) o negativa (-1).
%           Es posible introducir el chirp rate (k) o bien el ancho de
%           banda de la seÃ±al (B) y la pendiente, de tal forma que 
%           k=ascend*(B/T).
%
%   ParÃ¡metros de salida:
%       s: SeÃ±al generada.
%       t: Vector de tiempos.
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,error]=lfm_esc(fs,fo,pAl,T,Tc,Nc,muestras,CP,k,B,Df,ascend)

    error=0;
    s=0;
    t=0;
    
    if nargin<9
        disp('Faltan parámetros')
        error = 1;
        return
    end

    if isempty(fs)||isempty(fo)||isempty(pAl)||isempty(muestras)
        disp('Faltan parámetros')
        error = 1;
        return
    end

    if isempty(k)&&(isempty(B)||isempty(ascend)),
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(Tc)&&isempty(Nc)
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(Df)&&isempty(B)&&isempty(Nc)
        disp('Faltan parámetros');
        error=1;
        return
    end
    %%%%%%%%%%%%% Se determinan los parámetros de generación de señal %%%%%%%%%%%%%%%

    % Diferentes modos de generación de señal en funcion de los parámetros que se proporcionan
    % Solo se puede dejar vacío uno de estos tres parámetros --> Nc,Tc,T
    if isempty(Nc),
    	% Modo Tc, T --> Se determina el nÃºmero de chip que entran en T
    	Nc = floor((T*fs)/(Tc*fs))+1;
    elseif isempty(Tc),
    	% Modo Nc, T --> Se determina el periodo de chip
    	Tc = T/Nc;
    end

    % Tiempo total ajustado al periodo y nÃºmero de chips
    T2 = Nc*Tc;
    
    % Modo Nc, Tc --> T = T2
    if isempty(T),
        T = T2;
    end
    % Solo se puede dejar vacío Df o B. Solo se puede dejar vacío ambos parámetros si se ha introducido el chirp rate
    if isempty(Df),
    	% Modo B --> Se determina la excursión en frecuencia entre chips consecutivos
    	if isempty(B),
    		% Si tampoco se proporciona el ancho de banda
    		B = k*T;
    	end
    	Df = B/(Nc-1);
    end
    	% Modo Df --> no se hace nada

    % Ancho de banda total ajustado al número de chips y la excursión en frecuencia 
    B = Df*(Nc-1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% Si los tiempos introducidos son en segundos se pasan a muestras.
    % El número de muestras de la señal de salida se redondea hacia abajo.
    if muestras==0,
        Tsecuencia=floor(T*fs);
    else,
        Tsecuencia=floor(T);
    end

    % Generamos el vector de tiempos
    Ts=1/fs;
    n=0:Ts:T2-Ts;

    % Se selecciona la frecuencia inicial dependiendo de la pendiente
    if ascend==1,
        fc=B/2;
    else,
        fc=-B/2;
    end
    
    % vector de frecuencias
    freq = (fo-fc):(ascend*Df):(fo+fc);
    freq = repmat(freq,ceil(Tc*fs),1);
    freq = reshape(freq,1,T2*fs);

    % se crea la señal LFM escalonada con fase continua si se pide
    if CP,
    	slfm=exp(j*2*pi*cumsum(freq));
    else
    	slfm=exp(j*2*pi*freq.*n);
    end
    
    % Cogemos el número de muestras pedidas
    s=slfm;
    s=s(1:Tsecuencia);
    Ts=1/fs;
    t=0:Ts:(Tsecuencia-1)*Ts;
    
    % Normalizamos la potencia
    
    potS=sum(abs(s).^2)/length(s);
    s=s/sqrt(potS);
    
    % Le damos fase aleatoria si se pide
    if pAl==1,
        s=s*exp(j*2*pi*rand(1));
    end
    
end

