
%
% Genera un pulso de una señal 2^n-ASK a partir de sus características.
%   Parámetros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       ns: Número de muestras por símbolo (tiempo de símbolo).
%       numSimbolos: Número de símbolos en el pulso (tiempo de pulso).
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       cAl: 1 Si el código es aleatorio, 0 si no lo es.
%       cod: Código introducido (amplitud).
%       n: número de bits por símbolo: n=0 (CW), n=1 (2ASK) n=2 (4ASK),...
%       TOA: Tiempo de llegada de la señal (muestras o segundos).
%       Tsecuencia: Número de muestras (tiempo) de la señal generada.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       R: factor de roll-off en el filtro raíz cuadrada de coseno alzado, coseno alzado o factor BT del filtro gaussiano.
%       fl: Pulso RCCA (1), pulso CA (2) o pulso gaussiano (3).
%   Parámetros de salida:
%       s: Señal generada.
%       t: Vector de tiempos.
%       cod: Código generado (amplitud).
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,cod,error]=m_ask(fs,fo,ns,numSimbolos,pAl,cAl,cod,n,Tsecuencia,muestras,R,fl)

    error=0;
    s=0;
    t=0;
    
    if nargin<11,
        disp('Faltan parámetros');
        error=1;
        return
    end
    
    if isempty(fs)|isempty(fo)|isempty(ns)|isempty(numSimbolos)|isempty(pAl)|isempty(cAl)|isempty(n)|isempty(Tsecuencia)|isempty(muestras),
        disp('Faltan parámetros')
        error=1;
        return
    end
    
    if nargin==10,
        R=[];
    end
    
    if (n<0)||(n~=round(n)),
        error=1;
        return
    end
    
    % Número de amplitudes de la señal M-ASK
    M=2^n;
    
%     % Número de fases de la señal M-PSK
%     M=2^n;
    
    % Si los tiempos introducidos son en segundos se pasan a muestras.
    % El número de muestras de la señal de salida se redondea hacia abajo.
    if muestras==0,
        ns=ns*fs;
        Tsecuencia=floor(Tsecuencia*fs);
    else,
        Tsecuencia=floor(Tsecuencia);
    end
    
    % Si el número de muestras por símbolo no es entero se fuerza a que lo
    % sea, de tal forma que la frecuencia de muestreo se ve modificada.
    if ns~=round(ns),
%         ns=roundn(ns,-2);
        [p,q]=rat(ns);
        ns2=max([p,8]);
        %         ns2=min([ns2,50]);
        ns2=min([ns2,round(2*ns)]);
        ns2=max([ns2,50]);
        fs2=(ns2/ns)*fs;
        
%         ns2=max([2*round(ns),8]);
%         factorFs=ns2/ns;
%         fs2=factorFs*fs;
    else,
        fs2=fs;
        ns2=ns;
    end
    
    Ttotal=ns2*numSimbolos;
    
    % Si el código es aleatorio se generan -numSimbolos- símbolos en
    % en función de la constelación.
    
    % Si no es aleatorio se toman los -numSimbolos- primeros del código
    % introducido. Si no hay suficientes símbolos se da error.
    
    if cAl,
        cod=floor((M-1e-12)*rand(1,numSimbolos))+1;
        c_cod=xcorr(cod,'coeff');
        while c_cod(length(cod)-1)>=(1-1/(length(cod))),
            cod=floor((M-1e-12)*rand(1,numSimbolos))+1;
            c_cod=xcorr(cod,'coeff');
        end
        codigo=cod;
    else,
        if isempty(cod)||(length(cod)<numSimbolos),
            error=1;
            return
        else,
            if length(cod)>numSimbolos,
                cod=cod(1:numSimbolos);
            end
            codigo=cod;
        end
    end
    
    % Si el parámetro R está vacío se utiliza una forma de pulso
    % rectangular. Si se ha introducido algún valor de R en función
    % del parámetro fl se filtra en raíz cuadrada de coseno alzado,
    % coseno alzado o pulso gaussiano.
    
    if isempty(R),
        
        codigoP=repmat(codigo,ns2,1);
        smask=reshape(codigoP,1,Ttotal);
        
    else,
        
        codigoP=[codigo;zeros(ns2-1,numSimbolos)];
        codigoP2=reshape(codigoP,1,Ttotal);
        switch fl
            case 1,
                num=rcosine(fs2,fs2*ns2,'sqrt',R);
            case 2,
                num=rcosine(fs2,fs2*ns2,'normal',R);
            case 3,
                num=gaussfir(R,1,ns2);
        end
        tran=(length(num)-1)/2;
        a=filter(num,1,[codigoP2,zeros(1,tran)]);
        smask=a(tran+1:end);
        
    end
    
    % Se obtiene la señal para fs mediante una interpolación lineal
    
    t2=(0:ns2*numSimbolos-1)/fs2;
    t1=(0:ceil(ns)*numSimbolos-1)/fs;
    s=interp1(t2,smask,t1,'linear','extrap');
        
    % Cogemos el número de muestras pedidas
    
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

