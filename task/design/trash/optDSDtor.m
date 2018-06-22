optDesPath=genpath('/vxfsvol/home/research/dsnlab/matlab/CanlabCore/CanlabCore');
%scnPath=genpath('/Users/wem3/matlab/grimoire/SCN_Core_Support/');
addpath(optDesPath);
clear Models, clear MM

GA.conditions = [1 2 3 4 5 6]; %affect|neutral x equal|loss to share|loss to private
                                 % .5    .5        .333    .333       .333
GA.freqConditions = [.1666 .1666 .1666 .1666 .1666 .1666];
GA.scanLength = 810;  
GA.ISI = 7.5;  
GA.TR = 2; 
GA.doepochs = 0;
GA.numhox = 0;
GA.hoxrange = [];
nmodels = 1; 
GA.cbalColinPowerWeights = [2 5 1 4];	% 1 = cbal, 2 = eff, 3 = hrf shape, 4 = freq
GA.numGenerations = 10000; 
GA.sizeGenerations = 40;  
GA.maxTime = 240;						
GA.alph = 2.7; 
GA.plotFlag = 1; 
GA.lowerLimit = [];  
GA.HPlength = [120]; 
GA.LPsmooth = ['hrf']; 
GA.maxOrder = 3;   
GA.NumStimthresh = [];      % maximum number of repeats of any one event type in a row
GA.maxCbalDevthresh = []; 	% maximum acceptable counterbalancing deviation (actual freq - expected freq)
GA.maxFreqDevthresh = [];   % maximum acceptable deviation from input frequencies (GA.freqConditions)
GA.contrasts = [...
      1   -1    0    0    0    0; ...          %Affect equal v Neutral equal 
      0    0    1   -1    0    0; ...          %Affect loss to share v Neutral loss to share 
      0    0    0    0    1   -1; ...          %Affect loss to privtae v Neutral loss to private 
      1    0   -1    0    0    0; ...          %Affect equal v Affective loss to share  
      1    0    0    0   -1    0; ...          %Affect equal v Affective loss to private 
      0    1    0   -1    0    0; ...          %Neutral equal v Neutrak loss to share
      0    1    0    0    0   -1]; ...          %Neutral equal v Neutrak loss to private

% GA.contrasts = [...
%      1     1    -1    -1     1     1    -1    -1
%      1     0    -1     0     1     0    -1     0
%      0     1     0    -1     0     1     0    -1
%      1    -1     1    -1     1    -1     1    -1
%      ];

GA.contrastweights = [2 2 2 1 1 1 1]; 	                      
AutocorrelationFileName = 'myscannerxc';
GA.restlength = [.2]; 
GA.restevery = [1]; 
GA.trans2switch = 0; 
GA.trans2block = 0; 
GA.dofirst = 0; 
GA.nonlinthreshold = []; 
% ---------------------------------------------------------------
%
% * E N D   U S E R   I N P U T
%
% ---------------------------------------------------------------
eval(['load ' AutocorrelationFileName]);  
GA.xc = myscannerxc;





% =============================================
% * vary by parameter - set this in this script
% * if running multiple models, nmodels > 1
% ---------------------------------------------

varyparam = 0;
fieldname = 'alph';		% or 'freqConditions(end), etc.
incrementby = 0.3;
incrementevery = 5;		% every n models
contrastsofinterest = 1;% contrasts or predictors, if no cons specified

% =============================================


if varyparam
	eval(['paramvalue = GA.' fieldname ';'])
	disp(' ');disp('* *********************************************************************')
	disp('*  You have selected to vary a parameter across models in ga_gui_script')
	disp(['*  GA.' fieldname ' starting at ' num2str(paramvalue)]) 
	disp('* *********************************************************************')
end


for nm = 1:nmodels

   eval(['diary model' num2str(nm) '.log'])
   disp(['Starting Model ' num2str(nm)])
    % freqConditions

   M = optimizeGA(GA);


   Models(:,nm) = M.stimlist;
   MM{nm} = M;
   save GAworkspace
   
   if varyparam
   	if isfield(M,'consebeta'),
		Fit(1,nm) = mean(M.consebeta(contrastsofinterest));
	else 
		Fit(1,nm) = mean(M.sebeta(contrastsofinterest));
	end
   	eval(['Fit(2,nm) = GA.' fieldname ';'])
   	FC(nm,:) = GA.freqConditions;
   	ALPH(nm,:) = GA.alph;
	str = ['if mod(nm,' num2str(incrementevery) ') == 0,GA.' fieldname ' = GA.' fieldname '+' num2str(incrementby) ';,end']
   	eval(str);
	eval(['paramvalue = GA.' fieldname ';'])
	disp('* *********************************************************************')
	disp('*  Varying parameter option on.')
	disp(['*  GA.' fieldname ' is now ' num2str(paramvalue)]) 
	disp('* *********************************************************************')
   end

   eval(['save model' num2str(nm) '_' M.date ' M'])
   save GAworkspace
   diary off
   fprintf('\n')
end

M.stimPerCondition = [...
  length(M.stimlist(M.stimlist==1)),...
  length(M.stimlist(M.stimlist==2)),...
  length(M.stimlist(M.stimlist==3)),...
  length(M.stimlist(M.stimlist==4)),...
  length(M.stimlist(M.stimlist==5)),...
  length(M.stimlist(M.stimlist==6)),...
  length(M.stimlist(M.stimlist==0))...
]