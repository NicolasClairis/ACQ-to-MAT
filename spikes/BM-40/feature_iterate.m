

matfiles = dir(fullfile('C:\Users\sk430\Documents\ACQ-to-MAT\spikes\BM-40','*.mat'));

for i = 1:length(matfiles)
    filename = matfiles(i).name;
    
    [p, f, a, b] = feature_gen(filename, false, true);
    
    psd = [psd p(:,2:3)];   %= p(:,2:3)
    psd = mean(psd, 2);
    
    plot(p(:,1), 10*log10(psd));
    
    
end