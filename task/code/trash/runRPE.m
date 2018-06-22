 function [task] = runRPE(subNum,runNum)
% % RUNRPE.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runRPE( subNum, runNum )
%
%   subNum && runNum are scalar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%    (subID)_rpe_input.txt = comma delimited text with per trial input
%     note: same input file for runs 1 & 2
%    input text columns (%u,%u,%f,%f,%u) 
%       1. trialNum
%       2. condition (1:6, each is a different alien)
%       3. stimOnset (intended stimulus onset time)
%       4. fbOnset (intended feedback onset time)
%       5. outcome (0 == 'LUX', 1 == 'RAZ')
%
%     DRSdrs.stim.mat = structure w/ precompiled image matrices (coins, hands, etc.)
%
%     (subID)_info.mat = structure w/ subject specific info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% adapted from Jess Cohen's rpe task
% author: wem3 
% last edited: 141121
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% get subID from subNum
if subNum < 10
  subID = ['drs00',num2str(subNum)];
elseif subNum < 100
  subID = ['drs0',num2str(subNum)];
else
  subID = ['drs',num2str(subNum)];
end
% get thisRun from runNum
thisRun = ['run',num2str(runNum)];
% load subject's drs structure
subInfoFile = [subID,'_info.mat'];
load(subInfoFile);
thisRun = ['run',num2str(runNum)];
if strcmp(thisRun,'run0')
  inputTextFile = [drs.input.path,filesep,'rpe_practice_input.txt'];
  subOutputMat = [drs.output.path,filesep,'temp.mat'];
else
  subOutputMat = [drs.output.path,filesep,subID,'_rpe_',thisRun,'.mat'];
  inputTextFile = [drs.input.path,filesep,subID,'_rpe_input.txt'];
  outputTextFile = [drs.output.path,filesep,subID,'_rpe_',thisRun,'_output.txt'];
end

% load trialMatrix
fid=fopen(inputTextFile);
trialMatrix=textscan(fid,'%u%u%f%f%u\n','delimiter',',');
fclose(fid);
%% store info from trialMatrix in drs structure
task.input.raw = [trialMatrix{1} trialMatrix{2} trialMatrix{3} trialMatrix{4} trialMatrix{5}];
task.input.condition = trialMatrix{2};
task.input.stimOnset = trialMatrix{3};
task.input.fbOnset = trialMatrix{4};
task.input.outcome = trialMatrix{5};
numTrials = length(trialMatrix{1});
task.output.raw = NaN(numTrials,9);
task.probabilities = [.17 .17 0.5 0.5 .83 .83];
task.magnitudes = [2 4 2 4 2 4];
%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));
% open a window, set more params
%[win,winBox] = PsychImaging('OpenWindow',screenNumber,bg,[0 0 1920/2 1080/2],[],'kPsychGUIWindow');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,drs.stim.bg);
% flip to get ifi
Screen('Flip', win);
drs.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

drs.keys = initKeys;
inputDevice = drs.keys.deviceNum;

% to inform subject about upcoming task
prefaceText = ['Coming up... ','Alien Identification: ',thisRun, '\n\n(left for ''LUX'', right for ''RAZ'') '];
DrawFormattedText(win, prefaceText, 'center', 'center', drs.stim.purple);
[~,programOnset] = Screen('Flip',win);
%KbStrokeWait(inputDevice);

%% present during multiband calibration
% skip the long wait for training session
if runNum == 0
    calibrationTime = 1;
else
    calibrationTime = 17;
end
% remind em' not to squirm!
DrawFormattedText(win, 'Calibrating scanner\n\n Please hold VERY still',...
  'center', 'center', drs.stim.white);
[~,calibrationOnset] = Screen('Flip', win);
WaitSecs(calibrationTime);
DrawFormattedText(win, 'Alien Identification:\n\n Starting in... 5',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
WaitSecs(1);
DrawFormattedText(win, 'Alien Identification:\n\n Starting in... 4',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);
DrawFormattedText(win, 'Alien Identification:\n\n Starting in... 3',...
  'center', 'center', drs.stim.white);
WaitSecs(1);
Screen('Flip', win);
DrawFormattedText(win, 'Alien Identification:\n\n Get Ready!',...
  'center', 'center', drs.stim.white);
Screen('Flip', win);

% trigger pulse code
%KbTriggerWait(drs.keys.trigger,inputDevice); % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
disabledTrigger = DisableKeysForKbCheck(drs.keys.trigger);
triggerPulseTime = GetSecs;
disp('trigger pulse received, starting experiment');
Screen('Flip', win);

% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList(drs.keys.buttons)=1;
keyList(drs.keys.kill)=1;
leftKeys = ([drs.keys.b0 drs.keys.b1 drs.keys.b2 drs.keys.b3 drs.keys.b4 drs.keys.left]);
rightKeys = ([drs.keys.b5 drs.keys.b6 drs.keys.b7 drs.keys.b8 drs.keys.b9 drs.keys.right]);
KbQueueCreate(inputDevice, keyList);
alienSkips = [];
Screen('TextSize', win, 70);
Screen('TextFont', win, 'Arial');
leftHandMatrix = drs.stim.box.purple;
leftHandMatrix(:,:,4) = (drs.stim.alpha.hand{1}) ./255;
leftHandBox = drs.stim.box.hand{1};
leftHand = Screen('MakeTexture',win,leftHandMatrix);
rightHandMatrix = drs.stim.box.purple;
rightHandMatrix(:,:,4) = (drs.stim.alpha.hand{2}) ./255;
rightHandBox = drs.stim.box.hand{2};
rightHand = Screen('MakeTexture',win,rightHandMatrix);
fadeVector = (0.3:0.075:1);
loopStartTime = GetSecs;
%% trial loop
for tCount = 1:numTrials
  %% set variables for this trial
  condition = task.input.condition(tCount);
  stimOnset = task.input.stimOnset(tCount);
  fbOnset = task.input.fbOnset(tCount);
  outcome = task.input.outcome(tCount);
  alienResponse = 0;
  alienRT = NaN;
  IDed = 0;
  multiAlienResponse = [];
  multiAlienRT =[];
  alien = Screen('MakeTexture',win,drs.stim.alien{condition});
  Screen('DrawTexture',win,alien,[],drs.stim.box.alien);
  KbQueueStart(inputDevice);
  WaitSecs('UntilTime',(loopStartTime+stimOnset));
  % flip the screen to show choice
  [~,alienOnset] = Screen('Flip',win);
  %loop for response
  while ((GetSecs - loopStartTime) < fbOnset)
    [ pressed, firstPress]=KbQueueCheck(inputDevice);
      if pressed
        if IDed == 0
          alienRT = firstPress(find(firstPress)) - alienOnset;
        elseif IDed == 1
          multiAlienResponse = [multiAlienResponse alienResponse];
          multiAlienRT =[multiAlienRT alienRT];
          alienRT = firstPress(find(firstPress)) - alienOnset;
        end

        if find(firstPress(leftKeys))
            alienResponse = 1;
            for fadeCount = 1:length(fadeVector)
              Screen('DrawTexture',win,leftHand,[],leftHandBox);
              Screen('FillRect',win,[drs.stim.bg(1:3) fadeVector(fadeCount)], leftHandBox);
              Screen('DrawTexture',win,alien,[],drs.stim.box.alien);
              WaitSecs(.025);
              Screen('Flip',win);
            end
        elseif find(firstPress(rightKeys))
            alienResponse = 2;
            for fadeCount = 1:length(fadeVector)
              Screen('DrawTexture',win,rightHand,[],rightHandBox);
              Screen('FillRect',win,[drs.stim.bg(1:3) fadeVector(fadeCount)], rightHandBox);
              Screen('DrawTexture',win,alien,[],drs.stim.box.alien);
              WaitSecs(.025);
              Screen('Flip',win);
            end
        end
         IDed=1;
      end   
  end
  KbQueueStop(inputDevice);
  Screen('DrawTexture',win,alien,[],drs.stim.box.alien);
  DrawFormattedText(win, drs.stim.alienText{outcome},'center','center',drs.stim.purple,[],[],[],[],[],drs.stim.box.prompt);
  payout = [];
  if alienResponse == outcome
    payout = task.magnitudes(condition);
    coinTex = Screen('MakeTexture',win,drs.stim.coins{payout});
    Screen('DrawTexture',win,coinTex,[],drs.stim.box.payout);
  else
    payout = 0;
  end
  WaitSecs('UntilTime',(loopStartTime + fbOnset));
  [~,payoutOnset] = Screen('Flip',win);
  WaitSecs(1.25);
  [~,alienOffset] = Screen('Flip',win);
 
  if alienResponse == 0
    alienSkips = [alienSkips tCount];
  end

  % assign output for each trial to task.(thisRun).output.raw matrix
  task.output.raw(tCount,1) = tCount;
  task.output.raw(tCount,2) = trialMatrix{2}(tCount);
  task.output.raw(tCount,3) = (alienOnset - loopStartTime);
  task.output.raw(tCount,4) = alienResponse;
  task.output.raw(tCount,5) = alienRT;
  task.output.raw(tCount,6) = (payoutOnset - loopStartTime);
  task.output.raw(tCount,7) = payout;
  task.output.raw(tCount,8) = task.probabilities(condition);
  task.output.raw(tCount,9) = (alienOffset - alienOnset);
  save(subOutputMat,'task');
end
KbQueueRelease;

% End of experiment screen. 
task.payout = nansum(task.output.raw(:,7));
endText = ['Alien ID ',thisRun,' complete! \n\nYou earned ',num2str(task.payout),' gold coins.'];
DrawFormattedText(win, endText,...
    'center', 'center', drs.stim.white);
Screen('Flip', win);

if runNum ~=0
  fid=fopen(outputTextFile,'a');
  for tCount = 1:numTrials
    fprintf(fid,'%u,%u,%4.3f,%u,%4.3f,%4.3f,%u,%4.2f,%4.3f\n',...
    task.output.raw(tCount,1:9));
  end
  fclose(fid);
  task.calibration = calibrationOnset;
  task.triggerPulse = triggerPulseTime;
  task.output.skips = alienSkips;
  task.output.multi = multiAlienResponse;
  task.output.multiRT = multiAlienRT;
  save(subOutputMat,'task');
end

KbStrokeWait(inputDevice);

Screen('CloseAll');

return