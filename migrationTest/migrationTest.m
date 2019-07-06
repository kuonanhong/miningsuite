
testfile = 'voice.wav'


%% testing migration: mirgetdata with obj.getdata

disp('testing migration: mirgetdata with obj.getdata'); 
a = miraudio(testfile);
b = sig.signal(testfile);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 

else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirgetdata (Mono) with obj.getdata (Mix)
disp('testing migration: mirgetdata (Mono) with obj.getdata (Mix)'); 
a = miraudio(testfile, 'Mono');
b = sig.signal(testfile, 'Mix');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;







%% testing migration: mirgetdata (Center) with obj.getdata (Center)
disp('testing migration: mirgetdata (Center) with obj.getdata (Center)'); 
a = miraudio(testfile, 'Center');
b = sig.signal(testfile, 'Center');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;




%% testing migration: mirgetdata (Sampling) with obj.getdata (Sampling)
disp('testing migration: mirgetdata (Sampling) with obj.getdata (Sampling)'); 
samplingRate = 44100;
a = miraudio(testfile, 'Sampling', samplingRate);
b = sig.signal(testfile, 'Sampling', samplingRate);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



%% testing migration: mirgetdata (Extract) with obj.getdata (Extract) by
%seconds
disp('testing migration: mirgetdata (center) with obj.getdata (center)'); 
t1 = 0;
t2 = 2;
u = 's';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;



%% testing migration: mirgetdata (Extract) with obj.getdata (Extract)by
%sampling index
disp('testing migration: mirgetdata (Extract) with obj.getdata (Extract) by index'); 
t1 = 0;
t2 = 2;
u = 'sp';
a = miraudio(testfile, 'Extract', t1,t2,u);
b = sig.signal(testfile, 'Extract',  t1,t2,u);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;


%% testing migration: mirgetdata (Trim) with obj.getdata (Trim)
disp('testing migration: mirgetdata (Trim) with obj.getdata (Trim)'); 
a = miraudio(testfile, 'Trim');
b = sig.signal(testfile, 'Trim');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;





%% testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)
disp('testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)'); 
t = 0.06;
a = miraudio(testfile, 'TrimThreshold', t);
b = sig.signal(testfile, 'TrimThreshold', t);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;




%% >>>> INCOMPLETE
%testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)
disp('testing migration: mirgetdata (TrimThreshold) with obj.getdata (TrimThreshold)'); 
t = 0.06;
a = miraudio(testfile, 'TrimStart');
b = sig.signal(testfile, 'Trim', 'JustStart');
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;








%testing migration: mirspectrum with sig.spectrum

disp('testing migration: mirspectrum with sig.spectrum'); 
a = mirspectrum(testfile);
b = sig.spectrum(testfile);
tf = isequal(mirgetdata(a),b.getdata);

if tf == 1
   disp('test OK!'); 
else
   disp('test fail!');
end
clearvars -except testfile ;