% AUD.TEMPO.INIT
%
% Copyright (C) 2014, 2017-2019 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function [y, type] = init(x,option,autocor,spectrum)
    if nargin < 3
        autocor = @aud_autocor;
        spectrum = @aud_spectrum;
    end
    if ~x.istype('sig.Autocor') && ~x.istype('sig.Spectrum')
%         if isframed(x) && strcmpi(option.fea,'Envelope') && not(isamir(x,'mirscalar'))
%             warning('WARNING IN MIRTEMPO: The input should not be already decomposed into frames.');
%             disp('Suggestion: Use the ''Frame'' option instead.')
%         end
        if strcmpi(option.sum,'Before')
            optionsum = 1;
        elseif strcmpi(option.sum,'Adjacent')
            optionsum = 5;
        else
            optionsum = 0;
        end
        if option.frame
            x = aud.events(x,option.fea,'Filterbank',option.fb,...
                        'FilterbankType',option.fbtype,...
                        'FilterType',option.ftype,...
                        'Sum',optionsum,'Method',option.envmeth,...
                        option.band,'Center',option.c,...
                        'HalfwaveCenter',option.chwr,'Diff',option.diff,...
                        'HalfwaveDiff',option.diffhwr,'Lambda',option.lambda,...
                        'Smooth',option.aver,'Sampling',option.sampling,...
                        'Complex',option.complex,'Inc',option.inc,...
                        'Median',option.median(1),option.median(2),...
                        'Halfwave',option.hw,'Detect',0,...
                        'Mu',option.mu,'Log',option.log,...
                        'Frame','FrameSize',option.fsize.value,option.fsize.unit,...
                                'FrameHop',option.fhop.value,option.fhop.unit,...
                        'Gauss',option.gauss);
        else
            x = aud.events(x,option.fea,'Filterbank',option.fb,...
                        'FilterbankType',option.fbtype,...
                        'FilterType',option.ftype,...
                        'Sum',optionsum,'Method',option.envmeth,...
                        option.band,'Center',option.c,...
                        'HalfwaveCenter',option.chwr,'Diff',option.diff,...
                        'HalfwaveDiff',option.diffhwr,'Lambda',option.lambda,...
                        'Smooth',option.aver,'Sampling',option.sampling,...
                        'Complex',option.complex,'Inc',option.inc,...
                        'Median',option.median(1),option.median(2),...
                        'Halfwave',option.hw,'Detect',0,...
                        'Mu',option.mu,'Log',option.log,...
                        'Gauss',option.gauss);
        end
    end
    if option.aut == 0 && option.spe == 0
        option.aut = 1;
    end
    if x.istype('sig.Autocor') || (option.aut && not(option.spe))
        y = autocor(x,option);
    elseif x.istype('sig.Spectrum') || (option.spe && not(option.aut))
        y = spectrum(x,option);
    elseif option.spe && option.aut
        ac = autocor(x,option);
        sp = spectrum(x,option);
        y = ac*sp;
    end
    if ischar(option.sum)
        y = sig.sum(y);
    end
    y = sig.peaks(y,'Total',option.m,...'Track',option.track,...
                   ...'TrackMem',option.mem,...'Fuse',option.fuse,...
                   ...'Pref',option.pref(1),option.pref(2),...
                   'Threshold',option.thr,'Contrast',option.cthr,...
                   'NoBegin','NoEnd',...
                   'Normalize','Local','Order','Amplitude');
    if option.phase
        y = sig.autocor(y,'Phase');
    end

    type = {'sig.Signal','sig.Autocor'};
end


function y = aud_autocor(x,option)
    y = sig.autocor(x,'Min',60/option.ma,'Max',60/option.mi,...
              'Enhanced',option.enh,...'NormalInput','coeff',...
              'NormalWindow',option.nw); %,...
             % 'Phase',option.phase);
end


function y = aud_spectrum(x,option)
    y = aud.spectrum(x,'Min',option.mi/60,'Max',option.ma/60,...
                           'Prod',option.prod,...'NormalInput',...
                           'ZeroPad',option.zp);
end