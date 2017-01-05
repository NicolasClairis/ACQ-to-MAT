
% Samantha Kumarasena, Jan 2017
% Looking at possibilities for features distinguishing spikes, seizures, and 
% artifacts. These possibilities include:
%    - PSD: ie. periodogram() from the Signal Processing Toolbox
%    - FFT
%    - Autocorrelation: ie. autocorr()


%% Loads data from file

filename = 'BM40_spk1.mat';
load(filename);

fs = 500;                           % Sampling frequency of data: 500 Hz

%% Estimates and plots power spectral density for both channels on the same plot.

periodogram(data);                  % plots in dB per unit frequency (normalized)

figure;                             % plots saved data, non-log, non-normalized freq
[pxx, f] = periodogram(data, [], [], fs);       
plot(f, pxx);
hold on;
xlabel('Frequency (Hz)');
ylabel('Power/frequency');
title('Power Spectral Density Estimate');
legend('Channel 1', 'Channel 2');
hold off;


%% Plots Fourier transform of both channels on the same plot.

T = 1/fs;                           % Sampling period
L = length(data);                   % Length of signal
t = (0:L-1)*T;                      % Time vector
f = fs*(0:(L/2))/L;                 % Frequency vector

Y = fft(data);                      % Calculating FFT
[row col] = size(Y);

% For each channel, obtain 1-side spectrum from double-sided
for i = 1:col
    
    ch = Y(:,i);                        % Single channel data
   
    P2 = abs(ch/L);                     % Two-sided spectrum                      
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    plot(f, P1, 'color', rand(1,3));    % Plot channel FFT in random color
    
    hold on;
   
end;

xlabel('Frequency (Hz)');
ylabel('FFT');
title('FFT Plot of Data');
legend('Channel 1', 'Channel 2');
hold off;


%% Calculating and plotting autocorrelation

figure1 = figure;
autocorr(data(:,1));
hold on;

autocorr(data(:,2));



