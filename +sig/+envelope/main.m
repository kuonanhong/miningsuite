% SIG.ENVELOPE.MAIN
%
% Copyright (C) 2014, 2017 Olivier Lartillot
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function out = main(x,option)
    x = x{1};
    
    if isa(x,'sig.Envelope') 
        out = x;
        return
    end

    if strcmpi(option.method,'Spectro')
        d = x.Ydata.rename('element','freqband');
    elseif strcmpi(option.method,'Filter')
        d = sig.compute(@routine_filter,x.Ydata,x.Srate,option);
    end
    out = {sig.Envelope(d,'Srate',x.Srate,'Ssize',x.Ssize,...
                        'Sstart',x.Sstart,...
                        'Frate',x.Frate,'FbChannels',x.fbchannels)};    
end


function out = routine_filter(in,sampling,option)    
    if option.decim
        sampling = sampling/option.decim;
    end

    if strcmpi(option.filter,'IIR')
        a2 = exp(-1/(option.tau*sampling)); % filter coefficient 
        a = [1 -a2];
        b = 1-a2;
    elseif strcmpi(option.filter,'HalfHann')
        a = 1;
        b = hann(sampling*.4);
        b = b(ceil(length(b)/2):end);
    elseif strcmpi(option.filter,'Butter')
        % From Timbre Toolbox
        w = option.cutoff / ( sampling/2 );
        [b,a] = butter(3, w);
    end
    
    if option.hilb
        try
            in = in.apply(@hilbert,{},{'sample'});
        catch
            disp('Signal Processing Toolbox does not seem to be installed. No Hilbert transform.');
        end    
    end
    
    in = in.apply(@abs,{},{'sample'});
    
    if option.decim
        in = in.apply(@decimate,{option.decim},{'sample'},1);
    end
    
    out = in.apply(@filtfilt,{b,a,'self'},{'sample'});
    
    out = out.apply(@max,{0},{'sample'}); % For security reason...
    
    out = {out};
end