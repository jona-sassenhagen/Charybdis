ALLEEG=[];EEG=[];alldat=[];allrtvar=[];rts=[];dats=[];allrtvar2=[];alldat2=[];

control={'S 41', 'S 42', 'S 51', 'S 52'}
syn = {'S 71' 'S 80' }
sem = {'S 60' 'S 61'}
nsub = 20

channel = 23

for S = 1:nsub

	filename = [num2str((S),'%02i'),'_char_long.set'];
	filepath = '/home/jona/Desktop/charybdis/neufilt/'	
		

	EEG = pop_loadset('filename',filename,'filepath',filepath);
	%EEG = pop_resample( EEG, 100);
	EEG = pop_subcomp(EEG,[EEG.clusters.saccade EEG.clusters.blink]);
	EEG.icawinv = [];EEG.icasphere = [];EEG.icaweights = [];EEG.icachansind = [];

	EEG = pop_reref( EEG, [31 33] );
%	EEG = pop_eegfiltnew(EEG, 0.5, 0);

	EEG = pop_epoch( EEG, control, [-1 3], 'epochinfo', 'yes');
	EEG = pop_rmbase( EEG, []);

	dat = squeeze(eeg_getdatact(EEG,'channel',channel));
	controlerp=mean(dat,2);




	EEG = pop_loadset('filename',filename,'filepath',filepath);
	%EEG = pop_resample( EEG, 100);
	EEG = pop_subcomp(EEG,[EEG.clusters.saccade EEG.clusters.blink]);
	EEG.icawinv = [];EEG.icasphere = [];EEG.icaweights = [];EEG.icachansind = [];

	EEG = pop_reref( EEG, [31 33] );
%	EEG = pop_eegfiltnew(EEG, 0.5, 0);

	EEG = pop_epoch( EEG, syn, [-1 3], 'epochinfo', 'yes');
	EEG = pop_rmbase( EEG, []);

	dat = squeeze(eeg_getdatact(EEG,'channel',channel));
	rtvar = eeg_getepochevent( EEG,{'S196'},[],'latency');


	for ii=1:length(dat(1,:))
	 dat(:,ii)=dat(:,ii)-controlerp;
	end

	allrtvar = [rtvar,allrtvar];
	alldat=[dat,alldat];

	EEG = pop_loadset('filename',filename,'filepath',filepath);
	%EEG = pop_resample( EEG, 100);
	EEG = pop_subcomp(EEG,[EEG.clusters.saccade EEG.clusters.blink]);
	EEG.icawinv = [];EEG.icasphere = [];EEG.icaweights = [];EEG.icachansind = [];

	EEG = pop_reref( EEG, [31 33] );
%	EEG = pop_eegfiltnew(EEG, 0.5, 0);

	EEG = pop_epoch( EEG, sem, [-1 3], 'epochinfo', 'yes');
	EEG = pop_rmbase( EEG, []);

	dat = squeeze(eeg_getdatact(EEG,'channel',channel));
	rtvar = eeg_getepochevent( EEG,{'S196'},[],'latency');


	for ii=1:length(dat(1,:))
	 dat(:,ii)=dat(:,ii)-controlerp;
	end

	allrtvar2 = [rtvar,allrtvar2];
	alldat2=[dat,alldat2];

	rts{S} = allrtvar;
	datas{S} = alldat;
	rts2{S} = allrtvar2;
	datas2{S} = alldat2;
	allrtvar=[];alldat=[];allrtvar2=[];alldat2=[];
end;

eegdata=[];rtdata=[];
for x = 1:nsub
	eegdata=[eegdata,datas{x}];
	rtdata=[rtdata,rts{x}];
end;

eegdata2=[];rtdata2=[];
for x = 1:nsub
	eegdata2=[eegdata2,datas2{x}];
	rtdata2=[rtdata2,rts2{x}];
end;

[~,~,~,~,~,erp1] = erpimage(eegdata,rtdata, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1 ,'NoShow','on','erp',4);
[~,~,~,~,~,erp2] = erpimage(eegdata2,rtdata2, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1 ,'NoShow','on','erp',4);


figure;
sbplot(2,1,1)
plotcurve(EEG.times,[erp1; ones(1,400)],'xlabel','Time (msec)','ylabel','\mu V','legend',{'fastest','second fastest','slow','slowest'},'title','Syntax','vert',0)
sbplot(2,1,2)
plotcurve(EEG.times,[erp2; ones(1,400)],'xlabel','Time (msec)','ylabel','\mu V','legend',{'fastest','second fastest','slow','slowest'},'title','Semantics','vert',0)


figure;

for x = 1:20

	[outdata,outrtvar] = erpimage(datas{x}, rts{x}, linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), '', 1, 1 ,'NoShow','on');

	ntrials = length(outrtvar);
	outdata = outdata(:,ntrials*.05:ntrials*.95);
	outrtvar = outrtvar(ntrials*.05:ntrials*.95);
	ntrials = length(outrtvar);

	sbplot(4,5,x);
	plotcurve ( EEG.times, [ mean(outdata(:,1:ntrials*1/4),2)  ; mean(outdata(:,ntrials*1/4:ntrials*2/4),2) ; mean(outdata(:,ntrials*2/4:ntrials*3/4),2) ;  mean(outdata(:,ntrials*3/4:end),2)])

	fasterp(x,:) = mean(outdata(:,1:ntrials*1/4),2);
	mod1erp(x,:) = mean(outdata(:,ntrials*1/4:ntrials*2/4),2);
	mod2erp(x,:) = mean(outdata(:,ntrials*2/4:ntrials*3/4),2);
	slowerp(x,:) = mean(outdata(:,ntrials*3/4:end),2);
	
	fastrt(x,:) = mean(outrtvar(1:ntrials*1/4));
	mod1rt(x,:) = mean(outrtvar(ntrials*1/4:ntrials*2/4));
	mod2rt(x,:) = mean(outrtvar(ntrials*2/4:ntrials*3/4));
	slowrt(x,:) = mean(outrtvar(ntrials*3/4:end));

end;

figure;
for x = 1:20

	a = 1:20; a(x) = [];

	jackfast(x,:) = mean(fasterp(a,:),1);
	jackmod1(x,:) = mean(mod1erp(a,:),1);
	jackmod2(x,:) = mean(mod2erp(a,:),1);
	jackslow(x,:) = mean(slowerp(a,:),1);

	jackfastrt(x) = mean(fastrt(a,:),1);
	jackmod1rt(x) = mean(mod1rt(a,:),1);
	jackmod2rt(x) = mean(mod2rt(a,:),1);
	jackslowrt(x) = mean(slowrt(a,:),1);


	sbplot(4,5,x);
	plotcurve ( EEG.times, [ jackfast(x,:) ; jackmod1(x,:) ; jackmod2(x,:) ; jackslow(x,:) ] );

end;

jackfast2=jackfast;jackmod12=jackmod1;jackmod22=jackmod2; jackslow2=jackslow;


for y = 1:20
	for x = 1:EEG.pnts
		if jackfast(y,x) < 0
			jackfast2(y,x) = 0;
		end;
		if jackmod1(y,x) < 0
			jackmod12(y,x) = 0;
		end;
		if jackmod2(y,x) < 0
			jackmod22(y,x) = 0;
		end;
		if jackslow(y,x) < 0
			jackslow2(y,x) = 0;
		end;
	end;
end;

for x = 1:20
	erp = jackfast2(x,100:300);
	[~,fastlat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
	erp = jackmod12(x,100:300);
	[~,mod1lat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
	erp = jackmod22(x,100:300);
	[~,mod2lat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
	erp = jackslow2(x,100:300);
	[~,slowlat(x)] = min(abs(cumsum(erp)-sum(erp)/3));
end;



a = [mean(jackfastrt), mean(jackmod1rt), mean(jackmod2rt), mean(jackslowrt)]
b = [mean(fastlat) mean(mod1lat) mean(mod2lat) mean(slowlat)]
[r,p] =corr(a.',b.')


statmatrix2 = [fastlat.' mod1lat.' mod2lat.' slowlat.']
[stats,table]=mes1way(statmatrix2,'partialeta2','isdep',1);
anovaf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;


[stats,table]=mes1way(statmatrix2(:,1:2),'partialeta2','isdep',1);
firstbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

[stats,table]=mes1way(statmatrix2(:,2:3),'partialeta2','isdep',1);
secondbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

[stats,table]=mes1way(statmatrix2(:,3:4),'partialeta2','isdep',1);
thirdbinf = (cell2mat(table(2,5))) / (stats.n(1) -1)^2;

anovaf
firstbinf
secondbinf
thirdbinf

% in R: result <- oneWayAOV.Fstat(17.479, 20, 4, rscale = 0.5)
% exp(result[[’bf’]])

%erp_adjusted = bsxfun(@minus,erp_matrix(samples,:),min(erp_matrix(samples,:)));
%[~,latency_indicies] = min(abs(bsxfun(@minus,cumsum(erp_adjusted),sum(erp_adjusted)/2)));
%latencies = (EEG.xmin + (samples(1)+latency_indicies)/EEG.srate)*1000;
