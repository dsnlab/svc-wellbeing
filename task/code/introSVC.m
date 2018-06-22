% % introSVC.m $%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   introSVC.m: a script what runs the introduction to SVC tasks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   dependencies:
%   getSubInfo.m (function to collect subject info)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open dialog to get some info from participant
Screen('Preference', 'SkipSyncTests', 1);
svc = getSubInfo();

% set subID & studyDir (cause I keep forgetting to drill into svc.subID/studyDir)
subID = svc.subID;
studyDir = svc.studyDir;

%% set up screen preferences, rng
Screen('Preference', 'VisualDebugLevel', 1);
PsychDefaultSetup(2); % automatically call KbName('UnifyKeyNames'), set colors from 0-1;
rng('default');
rng('shuffle'); % if incompatible with older machines, use >> rand('seed', sum(100 * clock));
screenNumber = max(Screen('Screens'));

% open a window, set more params
PsychImaging('PrepareConfiguration');
[win,winBox] = PsychImaging('OpenWindow',screenNumber,svc.stim.bg);
% flip to get ifi
Screen('Flip', win);
svc.stim.ifi = Screen('GetFlipInterval', win);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Futura');
Screen('TextStyle',win,0);
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% query button box, set up keys
svc.keys = initKeys;
inputDevice = svc.keys.deviceNum;

leftKeys = ([svc.keys.b0 svc.keys.b1 svc.keys.b2 svc.keys.b3 svc.keys.b4 svc.keys.left]);
rightKeys = ([svc.keys.b5 svc.keys.b6 svc.keys.b7 svc.keys.b8 svc.keys.b9 svc.keys.right]);

%% preface
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, ['Welcome to the SVC study!\n\n (press any button to continue)'],...
  'center', 'center', svc.stim.white);
[~,instructionOnset] = Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'Today, we''re going to do\n\n one task \n\n (press any button to continue)',...
  'center', 'center', svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
Screen('Flip', win);
DrawFormattedText(win, 'We''ll do two ''runs'' of this task\n\n and each ''run'' takes ~5-7 minutes \n\n (press any button to continue)',...
  'center', 'center', svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
DrawFormattedText(win, 'The task is called: ','center', (svc.stim.box.yCenter - 2*svc.stim.box.unit), svc.stim.white);
DrawFormattedText(win, 'Change Task ','center', svc.stim.box.yCenter, svc.stim.purple);
DrawFormattedText(win, '(press any button to continue) ','center',(svc.stim.box.yCenter + svc.stim.box.unit), svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);

%%
%%Practice SvC

%%
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'Change Task:','center', (svc.stim.box.yCenter - 2*svc.stim.box.unit), svc.stim.white);
DrawFormattedText(win, 'Each time you see a word \nyou will have to decide if it describes you \nor if it''s something that can change.','center', (svc.stim.box.yCenter - svc.stim.box.unit), svc.stim.yellow);
DrawFormattedText(win, 'You''ll have about 4 seconds to decide.','center',(svc.stim.box.yCenter + svc.stim.box.unit), svc.stim.white);
DrawFormattedText(win, '(press any button to continue) ','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
WaitSecs(1);

%%
trait='funny';
condition=1;

iconMatrix = svc.stim.promptMatrix{1};
promptText = 'true about me?';
promptColor = svc.stim.promptColors{1};
iconTex = Screen('MakeTexture',win,iconMatrix);
Screen('DrawTexture',win,iconTex,[],svc.stim.box.prompt);
Screen('TextSize', win, 80);
Screen('TextFont', win, 'Arial');
DrawFormattedText( win, promptText, 'center', 'center', promptColor );
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'If you see this, you''ll need to decide \nif the next set of words describe you.','center',(svc.stim.box.yCenter + .5*svc.stim.box.unit), svc.stim.white);
DrawFormattedText(win, '(press any button to continue) ','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip',win)
KbStrokeWait(inputDevice);

drawTrait(win,svc.stim,trait,condition,[0.5 0.5]);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left for yes or right for no)','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
% flip the screen to show trait

%%
trait='weird';
condition=4;

iconMatrix = svc.stim.promptMatrix{2};
promptText = 'can it change?';
promptColor = svc.stim.promptColors{2};
iconTex = Screen('MakeTexture',win,iconMatrix);
Screen('DrawTexture',win,iconTex,[],svc.stim.box.prompt);
Screen('TextSize', win, 80);
Screen('TextFont', win, 'Arial');
DrawFormattedText( win, promptText, 'center', 'center', promptColor );
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, 'If you see this, you''ll need to decide \nif the next set of words can change.','center',(svc.stim.box.yCenter + .5*svc.stim.box.unit), svc.stim.white);
DrawFormattedText(win, '(press any button to continue) ','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip',win)
KbStrokeWait(inputDevice);

drawTrait(win,svc.stim,trait,condition,[0.5 0.5]);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press left for yes or right for no)','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip', win);
KbStrokeWait(inputDevice);
% flip the screen to show trait
DrawFormattedText(win, 'Let''s practice the change task! ','center',(svc.stim.box.yCenter), svc.stim.yellow);
Screen('TextSize', win, 50);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,0);
DrawFormattedText(win, '(press any button to start the practice)','center',(svc.stim.box.yCenter + 3*svc.stim.box.unit), svc.stim.white);
Screen('Flip',win);
KbStrokeWait(inputDevice);

runSVC(svc.subNum,1,0)

Screen('CloseAll')
