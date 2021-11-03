



%
% Genera un pulso de una se�al 2^n-FSK a partir de sus caracter�sticas.
%   Par�metros de entrada:
%       fs: Frecuencia de muestreo en Hz.
%       fo: Frecuencia de la portadora normalizada por fs.
%       Df: Excursi�n en frecuencia normalizada por fs.
%       ns: N�mero de muestras por s�mbolo (tiempo de s�mbolo).
%       numSimbolos: N�mero de s�mbolos en el pulso (tiempo de pulso).
%       pAl: 1 Si la fase de la portadora es aleatoria, 0 si no lo es.
%       cAl: 1 Si el c�digo es aleatorio, 0 si no lo es.
%       cod: C�digo introducido (frecuencia normalizada de Df).
%       n: n�mero de bits por s�mbolo: n=0 (CW), n=1 (2FSK) n=2 (4FSK),...
%       Tsecuencia: N�mero de muestras (tiempo) de la se�al generada.
%       muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%       CP: de fase continua (1) o salto de fase (0).
%       R: factor de roll-off en el filtro ra�z cuadrada de coseno alzado, coseno alzado o factor BT del filtro gaussiano.
%       fl: Pulso RCCA (1), pulso CA (2) o pulso gaussiano (3).
%   Par�metros de salida:
%       s: Se�al generada.
%       t: Vector de tiempos.
%       cod: C�digo generado (frecuencia normalizada de Df).
%       error: Indica si ha habido un error (1) o no (0).
%
%
%

function [s,t,cod,error]=m_fsk(fs,fo,Df,ns,numSimbolos,pAl,cAl,cod,n,Tsecuencia,muestras,CP,R,fl)

    error=0;
    s=0;
    t=0;
    
    if nargin<12,
        disp('Faltan par�metros');
        error=1;
        return
    end
    
    if isempty(fs)|isempty(fo)|isempty(Df)|isempty(ns)|isempty(numSimbolos)|isempty(pAl)|isempty(cAl)|isempty(n)|isempty(Tsecuencia)|isempty(muestras)|isempty(CP),
        disp('Faltan par�metros')
        error=1;
        return
    end
    
    if nargin==13,
        R=[];
    end
    
    if (n<0)||(n~=round(n)),
        error=1;
        return
    end
    
    % N�mero de frecuencias de la se�al M-FSK
    M=2^n;
    
    % Si los tiempos introducidos son en segundos se pasan a muestras.
    % El n�mero de muestras de la se�al de salida se redondea hacia abajo.
    if muestras==0,
        ns=ns*fs;
        Tsecuencia=floor(Tsecuencia*fs);
    else,
        Tsecuencia=floor(Tsecuencia);
    end
    
    % Si el n�mero de muestras por s�mbolo no es entero se fuerza a que lo
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
    
    % Si el c�digo es aleatorio se generan -numSimbolos- s�mbolos en
    % en funci�n de la constelaci�n.
    
    % Si no es aleatorio se toman los -numSimbolos- primeros del c�digo
    % introducido. Si no hay suficientes s�mbolos se da error.
    
    if cAl,
        cod=floor((M-1e-12)*rand(1,numSimbolos))-(M-1)/2;
        % Al menos hay 2 transiciones de s�mbolo (aunque no tienen por qu�
        % ser seguidas)
        while length(find(diff(cod)~=0))<2,
            cod=floor((M-1e-12)*rand(1,numSimbolos))-(M-1)/2;
        end

%         c_cod=xcorr(cod,'coeff');
%         while c_cod(length(cod)-1)>=(1-1.2/(length(cod))),
%             cod=floor((M-1e-12)*rand(1,numSimbolos))-(M-1)/2;
%             c_cod=xcorr(cod,'coeff');
%         end
        codigo=Df*cod;
    else,
        if isempty(cod)||(length(cod)<numSimbolos),
            error=1;
            return
        else,
            if length(cod)>numSimbolos,
                cod=cod(1:numSimbolos);
            end
            codigo=Df*cod;
        end
    end
    
    % Si el par�metro R est� vac�o se utiliza una forma de pulso
    % rectangular. Si se ha introducido alg�n valor de R en funci�n
    % del par�metro fl se filtra en ra�z cuadrada de coseno alzado,
    % coseno alzado o pulso gaussiano.
    
    if isempty(R),
        
        codigoP=repmat(codigo,ns2,1);
        frec_smfsk=reshape(codigoP,1,Ttotal);
        
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
        num=num/max(num);
        tran=(length(num)-1)/2;
        a=filter(num,1,[codigoP2,zeros(1,tran)]);
        frec_smfsk=a(tran+1:end);
        
    end
       
    % Se obtiene la se�al para fs mediante una interpolaci�n lineal
    
    t2=(0:ns2*numSimbolos-1)/fs2;
    t1=(0:ceil(ns)*numSimbolos-1)/fs;
    smfsk=interp1(t2,frec_smfsk,t1,'linear','extrap');
    
    if CP,
        s=exp(j*2*pi*cumsum(smfsk));
    else,
        s=exp(j*2*pi*smfsk.*(0:length(smfsk)-1));
    end
    
    % Cogemos el n�mero de muestras pedidas
    
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

