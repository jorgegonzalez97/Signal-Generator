% codigoT3.m
%
% Genera las fases del código T3 de longitud T.
%
% Según definición del libro: 
%   P. E. Pace, Detecting and Classifying Low Probability of Intercept Radar,
%   Norwood, MA: Artech House, 2009.
%
% Parámetros de entrada:
%   - fs: frecuencia de muestreo en Hz.
%   - T: duración del pulso chirpperiodo del código en segundos.
%   - muestras: 1 si los tiempos introducidos son en muestras, 0 si son en segundos.
%   - n: número de saltos de fase.
%   - BW: ancho de banda de la modulación en Hz (normalizado de fs).
%
% Parámetros de salida:
%   - phase: vector de fases [0, 2*pi].
%   - phaseUnWrapped: vector de fases desenrollado.
%   - t: vector de tiempos.
%   - error: error en la generación de la fase ('0' no error, '1' error).


function [phase, phaseUnWrapped, t, error] = codigoT3(fs,T,muestras,n,BW)

    t = 0;
    error = 0;
    phase = 0;
    phaseUnWrapped = 0;

    if nargin ~= 5,
        disp('Número incorrecto de parámetros');
        error = 1;
        return
    end
    
    if isempty(fs)||isempty(T)||isempty(muestras)||isempty(n)||isempty(BW),
        disp('Faltan parámetros');
        error = 1;
        return
    end

    % Si los tiempos introducidos son en segundos se pasan a muestras.
    % El número de muestras de la señal de salida se redondea hacia abajo.
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
        % fase dependiente del tiempo
        phase(i) = mod(((2*pi/n)*floor((n*BW*fs*t(i)^2)/(2*T))),2*pi);
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