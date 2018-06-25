function [task] = runSVC(studyArg, subNumArg, waveNumArg, runNumArg)
% % RUNSVC.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% usage: [ task ] = runSVC( subNumArg, waveNumArg, runNumArg )
%
%   subNum && runNum are scalar
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% dependencies:
%
%--> (subID)_wave(waveNum)_svc_(runNum).txt = comma delimited text with per trial input
%--> /design/rundetails.m = script to set details of the run (number of
%trials per block and condition to prompt mapping).
%
%    input text columns (%u,%u,%u,%u,%u,%f%f)
%       1. trialNum
%       2. condition (prompt type correspondences are set in
%       /design/run_detauls.m)
%       3. jitter
%       4. reverse coded (0 == normal, 1 == reverse coded)
%       5. syllables
%       6. trait (string w/ trait adjective)
%
%-->  SVCstim.mat = structure w/ precompiled image matrices (prompt icons, yes, no etc.)
%
%--> (subID)_wave(waveNum)_info.mat = structure w/ subject specific info
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set dropbox path for copying
dropboxDir = '~/Dropbox (PfeiBer Lab)/FreshmanProject/tasks/SVC/output';

%% Get subject info
switch nargin
    case 0
        clear all;
        prompt={'Study code'; ...
                'Subject number (3 digits)'; ...
                'Run number (1-2)'};
        dTitle = 'Subject Info';
        nLines = 1;
        % defaults
        def = {'FP', '', '',};
        manualInput = inputdlg(prompt,dTitle,nLines,def);
        study = manualInput{1};
        subNum = str2double(manualInput{2});
        runNum = str2double(manualInput{3});
        waveNum = 1;
    case 1
        error('Must specify 0 or 4 arguments');
    case 2
        error('Must specify 0 or 4 arguments');
    case 3
        study = studyArg;
        subNum = subNumArg;
        waveNum = waveNumArg;
        runNum = runNumArg;
end
rng('default');
Screen('Preference', 'SkipSyncTests', 1);

%% get subID from subNum
if subNum < 10
    subID = [study,'00',num2str(subNum)];
elseif subNum < 100
    subID = [study,'0',num2str(subNum)];
else
    subID = [study,num2str(subNum)];
end

% get thisRun from runNum
thisRun = ['run',num2str(runNum)];

% load subject's svc structure
subInfoFile = ['input', filesep, subID,'_wave_',num2str(waveNum),'_info.mat'];
load(subInfoFile);

if strcmp(thisRun,'run0')
    inputTextFile = [svc.input.path,filesep,'svc_practice_input.txt'];
    subOutputMat = [svc.output.path,filesep,subID,'_wave_',num2str(waveNum),'_rpe_',thisRun,'.mat'];
else
    subOutputMat = [svc.output.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'.mat'];
    inputTextFile = [svc.input.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'_input.txt'];
    outputTextFile = [svc.output.path,filesep,subID,'_wave_',num2str(waveNum),'_svc_',thisRun,'_output.txt'];
end

% load trialMatrix
fid=fopen(inputTextFile);
trialMatrix=textscan(fid,'%u%u%f%u%u%s\n','delimiter',',');
fclose(fid);

% load details about run
run(fullfile(svc.studyDir, 'task/design/run_details.m'));

% check that conditions are all accounted for
if (~(all(ismember([rundetails.Prompt_1_Condition_Nums rundetails.Prompt_2_Condition_Nums], ...
        unique(trialMatrix{2}))) && ...
        length([rundetails.Prompt_1_Condition_Nums rundetails.Prompt_2_Condition_Nums]) == ...
        length(unique(trialMatrix{2}))))
    error('/design/run_details.m conditions do not not match trial conditions')
end


%% store info from trialMatrix in svc structure
task.input.raw = [trialMatrix{1} trialMatrix{2} trialMatrix{3} trialMatrix{4} trialMatrix{5}];
task.input.condition = trialMatrix{2};
task.input.jitter = trialMatrix{3};
task.input.reverse = trialMatrix{4};
task.input.syllables = trialMatrix{5};
task.input.trait = trialMatrix{6};
numTrials = length(trialMatrix{1});
task.output.raw = NaN(numTrials,13);

%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));
% open a window, set more params
%[win,winBox] = PsychImaging('OpenWindow',screenNumber,svc.stim.bg,[0 0 1920/3 1080/3],'kPsychGUIWindow');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,svc.stim.bg);

% flip to get ifi
%HideCursor();
Screen('Flip', win);
svc.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Futura');
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

svc.keys = initKeysSVC;
inputDevice = svc.keys.deviceNum;

devices=PsychHID('Devices');
for deviceCount=1:length(devices)
  % Just get the local keyboard
  if ((strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Mitsumi Electric')) ...
          || (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Apple Inc.')) ...
          || (strcmp(devices(deviceCount).usageName,'Keyboard') && strcmp(devices(deviceCount).manufacturer,'Apple')))
    keys.bbox = deviceCount;
    keys.trigger = KbName('SPACE'); % use 'SPACE' as KbTrigger
    internalKeyboardDevice=deviceCount;
  end
end

% % to inform subject about upcoming task
% prefaceText = ['Coming up... ','Change Task: ',thisRun, '\n\n(left for ''yes'', right for ''no'') '];
% DrawFormattedText(win, prefaceText, 'center', 'center', svc.stim.orange);
% [~,programOnset] = Screen('Flip',win);
% KbStrokeWait(internalKeyboardDevice);

%% present during multiband calibration (time shortened for debug)
% skip the long wait for training session
if runNum == 0
    calibrationTime = 1;
else
    calibrationTime = 17;
end

% remind em' not to squirm!
DrawFormattedText(win, 'Calibrating scanner.\n\n Please hold very still.',...
    'center', 'center', svc.stim.white);
[~,calibrationOnset] = Screen('Flip', win);

% trigger pulse code (disabled for debug)
disp(svc.keys.trigger);
if runNum == 0 %%%%%%%% CHANGE THIS TO 0 %%%%%%%%%
    internalKeyboardDevice = inputDevice; % added this statement so I could run it on my laptop. Can delete later -DCos
    KbStrokeWait(internalKeyboardDevice);
else
    KbTriggerWait(svc.keys.trigger,inputDevice); % note: no problems leaving out 'inputDevice' in the mock, but MUST INCLUDE FOR SCANNER
    disabledTrigger = DisableKeysForKbCheck(svc.keys.trigger);
    triggerPulseTime = GetSecs;
    disp('trigger pulse received, starting experiment');
end
Screen('Flip', win);

%% define keys to listen for, create KbQueue (coins & text drawn while it warms up)
keyList = zeros(1,256);
keyList(svc.keys.buttons)=1;
keyList(svc.keys.kill)=1;
if mod(subNum,2)
    leftKeys = svc.keys.b6; %([svc.keys.b0 svc.keys.b1 svc.keys.b2 svc.keys.b3 svc.keys.b4 svc.keys.left]);
    rightKeys = svc.keys.b5; %([svc.keys.b5 svc.keys.b6 svc.keys.b7 svc.keys.b8 svc.keys.b9 svc.keys.right]);
else
    leftKeys = svc.keys.b5; %([svc.keys.b0 svc.keys.b1 svc.keys.b2 svc.keys.b3 svc.keys.b4 svc.keys.left]);
    rightKeys = svc.keys.b6; %([svc.keys.b5 svc.keys.b6 svc.keys.b7 svc.keys.b8 svc.keys.b9 svc.keys.right]);
end

KbQueueCreate(inputDevice, keyList);
traitSkips = [];
blockStartTrials = 1:rundetails.Trials_Per_Block:50;
loopStartTime = GetSecs;

%% trial loop
for tCount = 1:numTrials
    %% set variables for this trial
    condition = trialMatrix{2}(tCount);
    traitJitter = trialMatrix{3}(tCount);
    trait = trialMatrix{6}{tCount};
    traitResponse = 0;
    traitRT = NaN;
    chose = 0;
    multiTraitResponse = [];
    multiTraitRT =[];
    if find(blockStartTrials==tCount)
        if ismember(condition, rundetails.Prompt_1_Condition_Nums)
            iconMatrix = svc.stim.promptMatrix{1};
            promptText = rundetails.Prompt_1_text;
            promptColor = svc.stim.promptColors{1};
            svc.stim.promptIndex=1;
        elseif ismember(condition, rundetails.Prompt_2_Condition_Nums)
            iconMatrix = svc.stim.promptMatrix{2};
            promptText = rundetails.Prompt_2_text;
            promptColor = svc.stim.promptColors{2};
            svc.stim.promptIndex=2;
        end
        
        % draw prompt with instructions
        iconTex = Screen('MakeTexture',win,iconMatrix);
        Screen('DrawTexture',win,iconTex,[],svc.stim.box.prompt);
        Screen('TextSize', win, 80);
        Screen('TextFont', win, 'Futura');
        DrawFormattedText( win, promptText, 'center', 'center', promptColor );
        Screen('Flip',win);
        WaitSecs(5);  %% change this
    end
    
    %% call draw function
    drawTrait(win,svc.stim,trait,condition,[0.5 0.5]);
    KbQueueStart(inputDevice);
    
    % flip the screen to show trait
    [~,traitOnset] = Screen('Flip',win);
    
    %loop for response
    while (GetSecs - traitOnset) < 4.7
    [ pressed, firstPress]=KbQueueCheck(inputDevice);
      if pressed
        if chose == 0
          traitRT = firstPress(find(firstPress)) - traitOnset;
        elseif chose == 1
          multiTraitResponse = [multiTraitResponse traitResponse];
          multiTraitRT =[multiTraitRT traitRT];
          traitRT = firstPress(find(firstPress)) - traitOnset;
        end

        if find(firstPress(leftKeys))
            traitResponse = 1;
        elseif find(firstPress(rightKeys))
            traitResponse = 2;
        end
         chose=1;
        drawTraitFeedback(win,svc.stim,trait,condition,traitResponse);
      end   
  end
  KbQueueStop(inputDevice);
  drawTrait(win,svc.stim,' ',condition,[0.5 0.5]);
  Screen('Flip',win);
  if traitJitter > 4.7 %% change this
      [~,traitOffset] = Screen('Flip',win);
  else
      traitOffset = GetSecs;
  end
  WaitSecs('UntilTime',(traitOnset + 4.7 + traitJitter));  %% change this
  
  %%
  if traitResponse == 0
      traitSkips = [traitSkips tCount];
  end
  % assign output for each trial to task.(thisRun).output.raw matrix
  task.output.raw(tCount,1) = tCount;
  task.output.raw(tCount,2) = trialMatrix{2}(tCount);
  task.output.raw(tCount,3) = (traitOnset - loopStartTime);
  task.output.raw(tCount,4) = traitRT;
  task.output.raw(tCount,5) = traitResponse;
  task.output.raw(tCount,6) = trialMatrix{4}(tCount);
  task.output.raw(tCount,7) = trialMatrix{5}(tCount);
  save(subOutputMat,'task');
  
end
KbQueueRelease(inputDevice);
EndTime = GetSecs - loopStartTime;

% End of experiment screen. We clear the screen once they have made their
% response
Screen('TextSize', win, 50);
DrawFormattedText(win, 'The task is now complete.',...
    'center', 'center', svc.stim.white);
Screen('Flip', win);

if runNum ~= 0
    fid=fopen(outputTextFile,'a');
    for tCount = 1:numTrials
        fprintf(fid,'%u,%u,%4.3f,%4.3f,%u,%u,%u,%s\n',...
            task.output.raw(tCount,1:7), task.input.trait{tCount});
    end
    fclose(fid);
    task.calibration = calibrationOnset;
    task.triggerPulse = triggerPulseTime;
    task.output.skips = traitSkips;
    task.output.multi.response = multiTraitResponse;
    task.output.multi.RT = multiTraitRT;
    save(subOutputMat,'task');
end

WaitSecs(5)
Screen('Close', win);
fprintf('End Time: %.2f\n', EndTime);

%% Copy files to dropbox
dropboxDir = '~/Dropbox (PfeiBer Lab)/FreshmanProject/tasks/SVC/output';
subDir = fullfile(dropboxDir,subID);

if ~exist(subDir)
    mkdir(subDir);
    copyfile(subOutputMat, subDir);
    copyfile(outputTextFile, subDir);
    fprintf('Output files copied to %s\n',subDir);
else
    copyfile(subOutputMat, subDir);
    copyfile(outputTextFile, subDir);
    fprintf('Output files copied to %s\n',subDir);
end

return
