function out = after(x,option)
    if iscell(x)
        x = x{1};
    end
    
    if isfield(option,'tmp')
        tmp = option.tmp;
    else
        tmp = [];
    end
        
    if option.min || option.max < Inf
        [x.Ydata, x.Xaxis.start] = ...
            sig.compute(@extract,x.Ydata,x.xdata,x.Xaxis.start,option);
        
    end
    
    if option.timesmooth
        [x.Ydata, tmp] = ...
            sig.compute(@routine_timesmooth,x.Ydata,...
                        option.timesmooth,tmp);
    end
    
    if x.power == 1 && (option.pow || any(option.mprod) ...
                        || any(option.msum)) 
                % mprod could be tried without power?
        x.Ydata = sig.compute(@routine_square,x.Ydata);
        x.power = 2;
        x.yname = ['Power ',x.yname];
    end
    
    if any(option.mprod)
        x.Ydata = sig.compute(@routine_mprodsum,x.Ydata,...
                              option.mprod,@times);
        x.yname = 'Spectral product';
    end
    
    if any(option.mprod)
        x.Ydata = sig.compute(@routine_mprodsum,x.Ydata,...
                              option.msum,@sum);
        x.yname = 'Spectral sum';
    end
    
    if option.norm
        x.Ydata = sig.compute(@routine_norm,x.Ydata);
    end
    
    if option.nl
        x.Ydata = sig.compute(@divide,x.Ydata,x.inputlength);
    end
    
    if option.log || option.db
        if ~x.log
            x.Ydata = sig.compute(@routine_log,x.Ydata);
            x.log = 1;
        end
        if option.db && x.log == 1
            x.Ydata = sig.compute(@routine_db,x.Ydata,x.power);
            x.log = 10;
            x.power = 2;
        end
        if option.db>0 && option.db < Inf
            x.Ydata = sig.compute(@routine_crop,x.Ydata,option.db);
        end
        x.phase = [];
    end
    
    if option.aver
        x.Ydata = sig.compute(@routine_smooth,x.Ydata,option.aver);
    end

    if option.gauss
        sigma = option.gauss;
        gauss = 1/sigma/2/pi*exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
        x.Ydata = sig.compute(@routine_gausssmooth,x.Ydata,sigma,gauss);
    end
    
    out = {x,tmp};
end


%%
function out = extract(d,x,start,postoption)
    range = find(x >= postoption.min & x <= postoption.max);
    if ~isempty(range)
        d = d.extract('element',range([1,end]));
    end
    start = start + range(1);
    out = {d,start};
end


%%
function out = routine_timesmooth(d,N,tmp)
    [d, tmp] = d.apply(@timesmooth,{N,tmp},{'sample'});
    out = {d,tmp};
end


function [d, tmp] = timesmooth(d,N,tmp)
    B = ones(1,N)/N;
    [d, tmp] = filter(B,1,d,tmp);
end


%%
function d = routine_square(d)
    d = d.apply(@square,{},{'sample'});
end

function x = square(x)
    x = x.^2;
end


%%
function d = routine_mprodsum(d,coefs,func)
    d = d.apply(@mprodsum,{coefs,func},{'element'},1);
end


function y = mprodsum(x,coefs,func)
    y = x;
    for i = 1:length(coefs)
        mpr = coefs(i);
        if mpr
            xi = ones(size(x));
            xi(1:floor(end/mpr)) = x(mpr:mpr:end);
            x = func(x,xi);
        end
    end
end


%%
function d = routine_norm(d)
    n = d.apply(@norm,{},{'element'});
    d = d.divide(n);
end


%%
function d = divide(d,N)
    d = d.divide(N);
end


%%
function d = routine_log(d)
    d = d.sum(1e-16).apply(@log10,{},{'element'});
end


%%
function d = routine_db(d,power)
    d = d.times(10);
    if power == 1
        d = d.times(2);
    end
end


%%
function d = routine_crop(d,N)
    d = d.apply(@crop,{N},{'element'},1);
end


function d = crop(d,N)
    d = d - max(d);
    d = max(d,-N) + N;
end


%%
function d = routine_smooth(d,N)
    d = d.apply(@smooth,{N},{'element'},1);
end


function d = smooth(d,N)
    d = filter(ones(1,N),1,d);
end


%%
function d = routine_gausssmooth(d,sigma,gauss)
    d = d.apply(@gausssmooth,{sigma,gauss},{'element'},1);
end


function x = gausssmooth(x,sigma,gauss)
    x = filter(gauss,1,[x;zeros(4*sigma,1)]);
    x = x(4*sigma:end);
end