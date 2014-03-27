function STFTcoef = STFT(f, time_win, factor_redund, f_sampling)
%
% 1D Windowed Fourier Transform. 
%
% Input:
% - f: Input 1D signal.
% - time_win: window size in time (in millisecond).
% - factor_redund: logarithmic redundancy factor. The actual redundancy
%   factor is 2^factor_redund. When factor_redund=1, it is the minimum
%   twice redundancy. 
% - f_sampling: the signal sampling frequency in Hz.
%
% Output:
% - STFTcoef: Spectrogram. Column: frequency axis from -pi to pi. Row: time
%   axis. 
%
% Remarks:
% 1. The last few samples at the end of the signals that do not compose a complete
%    window are ignored in the transform in this Version 1. 
% 2. Note that the reconstruction will not be exact at the beginning and
%    the end of, each of half window size. However, the reconstructed
%    signal will be of the same length as the original signal. 
%
% See also:
% inverseSTFT
%
% Guoshen Yu
% Version 1, Sept 15, 2006


% Check that f is 1D
if length(size(f)) ~= 2 | (size(f,1)~=1 && size(f,2)~=1)
    error('The input signal must 1D.');
end

if size(f,2) == 1
    f = f';
end

% Window size
size_win = round(time_win/1000 * f_sampling);

% Odd size for MakeHanning
if mod(size_win, 2) == 0
    size_win = size_win + 1;
end
halfsize_win =  (size_win - 1) / 2;

% halfsize_win =  (size_win) / 2;

%w_hanning = MakeHanning(size_win); 
w_hanning = hanning(size_win);
Nb_win = floor(length(f) / size_win * 2);

% STFTcoef = zeros(2^(factor_redund-1), size_win, Nb_win-1);
STFTcoef = zeros(size_win, (2^(factor_redund-1) * Nb_win-1));

shift_k = round(halfsize_win / 2^(factor_redund-1));
% Loop over 
for k = 1 : 2^(factor_redund-1)    
    % Loop over windows
    for j = 1 : Nb_win - 2 % Ingore the last few coefficients that do not make a window
        f_win = f(shift_k*(k-1)+(j-1)*halfsize_win+1 : shift_k*(k-1)+(j-1)*halfsize_win+size_win);
        STFTcoef(:, (k-1)+2^(factor_redund-1)*j) = fft(f_win .* w_hanning');
    end
end