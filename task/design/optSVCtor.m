optDesPath=genpath('/Users/danicosme/Documents/code/CanlabCore');
addpath(optDesPath);
addpath(genpath('/Users/danicosme/Documents/MATLAB/spm12/'));
clear Models, clear MM

GA.conditions = [1 2 3]; % This is within-block conditions mental|physical|social 
GA.freqConditions = [.33 .33 .33]; % Equal number of trials in each condition
GA.scanLength = 210; % 210 / 5 = 42
GA.ISI = 5;  
GA.TR = 2; 
GA.doepochs = 0;
GA.numhox = 0;
GA.hoxrange = [];
nmodels = 1; 
GA.cbalColinPowerWeights = [2 5 1 4];	% 1 = cbal, 2 = eff, 3 = hrf shape, 4 = freq
GA.numGenerations = 10000; 
GA.sizeGenerations = 40;  
GA.maxTime = 21*5;						
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
      1    1    1   -1   -1   -1; ...          %Self v Change
      1    0    0   -1    0    0; ...          %Self well-being v Change mental
      0    1    0    0   -1    0; ...          %Self ill-being v Change physical
      0    0    1    0    0   -1; ...          %Self social v Change social
      1    0    0    0    0    0; ...          %Self well-being v rest
      0    1    0    0    0    0; ...          %Self ill-being v rest
      0    0    1    0    0    0; ...          %Self social v rest
      1   -1    0    0    0    0; ...          %Self well-being v. Self ill-being
      1    0   -1    0    0    0; ...          %Self well-being v. Self social
      0   -1    1    0    0    0];             %Self social v. Self ill-being

% GA.contrasts = [...
%       1    1    1   -1   -1   -1; ...          %Self v Change
%       1  -.5  -.5    0    0    0; ...          %Self mental v Self physical & social
%       1    0    0   -1    0    0; ...          %Self Prosocial v Change prosocial
%       1    0    0    0    0    0; ...          %Self Prosocial v rest
%       1    0   -1    0    0    0; ...          %Self Prosocial v self agressive
%       1   -1    0    0    0    0; ...          %Self Prosocial v self withdrawn
%       0    0    0    1  -.5  -.5];             %Change prosocial v change not prosocial
  
GA.contrastweights = [6 3 3 3 2 2 2 1 1 1 ];	                      
AutocorrelationFileName = 'myscannerxc';
GA.restlength = [1]; %how long between blocks do you want to rest? Units in ISI
GA.restevery = [6]; %how many events before rest? This is the number of events within a block
GA.trans2switch = 0; 
GA.trans2block = 1; %This reproduces the conditions at the type of this file in an ABAB block design
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
