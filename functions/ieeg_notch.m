function data = ieeg_notch(data,srate,notch_freq, verbose)

% data = ecog_notch(data,srate,notch_freq)
% data is time X electrodes
% srate: samplingfrequency
% notch filter data for 50Hz (50 100 150) or 60Hz (60Hz, 120Hz and 180Hz)
%
% DH 2018

if nargin < 4, verbose = true; end

if notch_freq==60
    % 5th order butterworth notch filter, [low/(samplerate/2) high/(samplerate/2)]
    [n1_b, n1_a]=butter(3,2*[59 61]/srate,'stop'); %60hz
    [n2_b, n2_a]=butter(3,2*[119 121]/srate,'stop'); %120hz
    [n3_b, n3_a]=butter(3,2*[179 181]/srate,'stop'); %180hz

    if verbose, disp('notching out 60 120 180'); end

    for elec=1:size(data,2)
        data(:,elec)=filtfilt(n1_b,n1_a,data(:,elec)); %60
        data(:,elec)=filtfilt(n2_b,n2_a,data(:,elec)); %120
        data(:,elec)=filtfilt(n3_b,n3_a,data(:,elec)); %180
    end
elseif notch_freq==50
    % 5th order butterworth notch filter, [low/(samplerate/2) high/(samplerate/2)]
    [n1_b, n1_a]=butter(3,2*[49 51]/srate,'stop'); %60hz
    [n2_b, n2_a]=butter(3,2*[99 101]/srate,'stop'); %120hz
    [n3_b, n3_a]=butter(3,2*[149 151]/srate,'stop'); %180hz

    if verbose, disp('notching out 60 120 180'); end

    for elec=1:size(data,2)
        data(:,elec)=filtfilt(n1_b,n1_a,data(:,elec)); %60
        data(:,elec)=filtfilt(n2_b,n2_a,data(:,elec)); %120
        data(:,elec)=filtfilt(n3_b,n3_a,data(:,elec)); %180
    end
    
end

