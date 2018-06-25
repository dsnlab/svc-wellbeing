function [ svc ] = getSubInfo()
% GETSUBINFO.M %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   usage: demo = getSubInfo()
%   takes no input, saves harvested subject info dialog to svc structure
%
%   author: wem3, jflournoy, dcos
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prompt for study directory (highest level)
studyDir = uigetdir('../svc','Select study directory');

% interactive dialog to get demographic info
prompt = {...
'Subject number (3 digits)',...,
'Experimenter'...,
'Wave'};

dTitle = 'define subject specific variables';
nLines = 1;

% defaults
def = { '999' , 'SVC', '1' };
manualInput = inputdlg(prompt,dTitle,nLines,def);

% the order is funky here because we want the structure output 
% to be readily readable in summary form (so this, err, isn't)
svc.subID = manualInput{1};
svc.studyDir = studyDir;
svc.subNum = str2num(manualInput{1});
svc.waveNum = str2num(manualInput{3});
svc.input.path = [studyDir,filesep,'task',filesep,'input'];
svc.output.path = [studyDir,filesep,'task',filesep,'output'];

% stimFile created by makesvcstimulus.m
stimFile = [studyDir,filesep,'task',filesep,'SVCstim.mat'];
load(stimFile);

demo.name = '';
demo.exptID = manualInput{2};
demo.exptDate = datestr(now);
svc.demo = demo;


% make icons for svc (there are only two, their colors don't change)
% but make boxen 3 & 4 out of convenience for condition code
stim.promptColors = Shuffle({stim.orange, stim.purple});
for rgbCount = 1:3
  stim.promptMatrix{1}(:,:,rgbCount) = ones(200,200) .* stim.promptColors{1}(rgbCount);
  stim.promptMatrix{2}(:,:,rgbCount) = ones(200,200) .* stim.promptColors{2}(rgbCount);
end
stim.promptMatrix{1}(:,:,4) = (stim.alpha.self) ./255;
stim.promptMatrix{2}(:,:,4) = (stim.alpha.delta) ./255;

% swap right and left responses for odd/even subIDs
subNum = str2num(strip(svc.subID,'left','0'));
if mod(subNum,2)
    stim.box.yesno([1 2]) = stim.box.yesno([2 1]);
    stim.box.leftright = {'no', 'yes'};
else
    stim.box.leftright = {'yes', 'no'};
end

% store stim in svc and save
svc.stim = stim;
saveFile = [svc.input.path,filesep,['FP',sprintf('%03d',str2num(svc.subID)),'_wave_',num2str(svc.waveNum),'_info.mat']];
save(saveFile,'svc');

return

