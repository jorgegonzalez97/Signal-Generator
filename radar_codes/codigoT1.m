% codigoT1.m
%
% Genera las fases del c�digo T1 de longitud T.
%
% Seg�n definici�n del libro: 
%   P. E. Pace, Detecting and Classifying Low Probability of Intercept Radar,
%   Norwood, MA: Artech House, 2009.
%
% Par�metros de entrada:
%   - fs: frecuencia de muestreo en Hz.
%   - T: Duraci�n del pulso chirp.
%   - muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%   - n: n�mero de saltos de fase.
%   - k: n�mero de fragmentos de la se�al.
%
% Par�metros de salida:
%   - phase: vector de fases [0, 2*pi].
%   - phaseUnWrapped: vector de fases desenrollado.
%   - t: vector de tiempos.
%   - error: error en la generaci�n de la fase ('0' no error, '1' error).


function [phase, phaseUnWrapped, t, error] = codigoT1(fs,T,muestras,n,k)

    t = 0;
    error = 0;
    phase = 0;
    phaseUnWrapped = 0;

    if nargin ~= 5,
        disp('N�mero incorrecto de par�metros');
        error = 1;
        return
    end
    
    if isempty(fs)||isempty(T)||isempty(muestras)||isempty(n)||isempty(k),
        disp('Faltan par�metros');
        error = 1;
        return
    end

    % Si los tiempos introducidos son en segundos se pasan a muestras.
    % El n�mero de muestras de la se�al de salida se redondea hacia abajo.
    if muestras==0,
        Tsecuencia=floor(T*fs);
    else
        Tsecuencia=floor(T);
    end
    
    % Generamos el vector de tiempos
    Ts=1/fs;
    t = 0:Ts:(T-Ts);
    
    phase = zeros(1,length(t));
    phaseUnWrapped = zeros(1,length(t));

    for i = 1:length(t)
        % n�mero de segmento
        jj = floor(k*t(i)/T);
        % fase dependiente del segmento y del tiempo
        phase(i) = mod(((2*pi/n)*floor((k*t(i)-jj*T)*(jj*n/T))),2*pi);
        % fase desenrollada
        if i==1
            phaseUnWrapped(i)=phase(i);
        else
            if phase(i)==phase(i-1)
                phaseUnWrapped(i)=phaseUnWrapped(i-1);
            else
                phaseUnWrapped(i)=phaseUnWrapped(i-1)+2*pi/n;
            end
        end
    end
    
    phase = phase(1:Tsecuencia);
    phaseUnWrapped = phaseUnWrapped(1:Tsecuencia);

end