

% Samantha Kumarasena, Jan 2017
%
% Looking at possibilities for features distinguishing spikes, seizures, and 
% artifacts. These possibilities include:
%    - PSD: ie. periodogram() from the Signal Processing Toolbox
%    - FFT
%    - ACF: ie. autocorr()
%
% Function inputs: filename, create_plots, save_data
%    - filename: name of .mat file containing spike/seizure/artifact data to be
%    analyzed
%    - create_plots: boolean value indicating whether to generate plots
%    - save_data: boolean value indicating whether to save return variables
%    in .mat file
%
% Function returns: psd, fourier, auto, bounds
%    - psd: Three cols, f (freq vector) and pxx (psd, 1 col for each chan)
%    - fourier: Three cols, f (freq) and P1 (fft, 1 col for each chan)
%    - auto: Three cols, lags1 (lags), acf1, and acf2 (for each chan)
%    - bounds: 1x2 vec containing upper/lower bounds for ACF



function [psd, fourier, auto, bounds] = feature_gen(filename, create_plots, save_data)
%% Loads data from file
load(filename);

fs = 500;                           % Sampling frequency of data: 500 Hz

%% Estimates and plots power spectral density (PSD) for both channels on the same plot.

% periodogram(data);                      % plots in dB per unit frequency (normalized)

[pxx, f] = periodogram(data, [], [], fs); % calculates PSD
psd = [f pxx];

if(create_plots)
    figure;                                   % plots saved data, in dB, non-normalized freq
    plot(f, 10*log10(pxx));
    hold on;
    xlabel('Frequency (Hz)');
    ylabel('dB');
    title('Power Spectral Density Estimate');
    legend('Channel 1', 'Channel 2');
    hold off;
end;


%% Plots Fourier transform of both channels on the same plot.

T = 1/fs;                               % Sampling period
L = length(data);                       % Length of signal
t = (0:L-1)*T;                          % Time vector
f = fs*(0:(L/2))/L;                     % Frequency vector

Y = fft(data);                          % Calculating FFT
[row col] = size(Y);
fourier = f';

colors = ['r' 'b' 'c' 'm' 'k'];

if(create_plots)
    figure;
    % For each channel, obtain 1-side spectrum from double-sided
    for i = 1:col

        ch = Y(:,i);                        % Single channel data

        P2 = abs(ch/L);                     % Two-sided spectrum                      
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);

        colindex = mod(i, length(colors));  % generating color for plot
        color = colors(colindex);

        plot(f, P1, 'color', color);        % Plot channel FFT in random color
        fourier = [fourier P1];             % save new FFT data in return variable

        hold on;
    end;

    xlabel('Frequency (Hz)');               %legend
    ylabel('FFT');
    title('FFT Plot of Data');
    legend('Channel 1', 'Channel 2');
    hold off;

end;


%% Calculating and plotting autocorrelation (ACF)

%{

%calculate and plot autocorr data for first channel
autocorr(data(:,1));
hold on; 

%find the stem plot within the plot, color it blue
h = findobj(gca, 'Type', 'stem');
h.Color = 'blue';                       %so we can distinguish it from the other channel

%calculate and plot autocorr data for second channel
autocorr(data(:,2));                    %autocorr plots red by default
hold off;

%}

%calculate autocorr data for both channels 
[acf1, lags1, bounds1] = autocorr(data(:,1), 100);
[acf2, lags2, bounds2] = autocorr(data(:,2), 100);

auto = [lags1 acf1 acf2];
bounds = bounds1;

%plotting autocorr data
if(create_plots)
    figure;
    stem(lags1, acf1, 'r');              % plot first channel data
    hold on;
    plot(get(gca,'xlim'), [bounds1(1), bounds1(1)], 'r'); % plot bounds, adapting to x-lim of current axes
    plot(get(gca,'xlim'), [bounds1(2), bounds1(2)], 'r'); % plot bounds
   
    stem(lags2, acf2, 'b');              % plot second channel data
    plot(get(gca,'xlim'), [bounds2(1), bounds2(1)], 'b'); % plot bounds
    plot(get(gca,'xlim'), [bounds2(2), bounds2(2)], 'b'); % plot bounds
    
    xlabel('Lag');
    ylabel('Autocorrelation');
    title('Autocorrelation Plot for Both Channels');
    legend('Channel 1', 'CH1 Bounds', 'CH1 Bounds', 'Channel 2', 'CH2 Bounds', 'CH2 Bounds');
    hold off;
end

%% Save relevant PSD, FFT, and autocorr variables

if(save_data)
    savefile = strcat(filename(1:(end-4)), '-feat.mat');
    save(savefile, 'psd', 'fourier', 'auto', 'bounds');
end;

end