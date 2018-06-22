function drawTraitFeedback(win,stim,trait,condition,traitResponse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawTraitFeedback.m: fade the yes/no they didn't choose
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ynGlow = (0.55:0.05:1);
ynFade = flip(0:0.05:0.45);
% fadeVector is a vector we'll use to construct a gradient of transparencies
fadeVector = (0.3:0.075:1);

%% now fade the non-chosen box
for fadeCount = 1:length(fadeVector)
  switch traitResponse
  case 0
    alphas = [ynFade(fadeCount) ynFade(fadeCount)];
    fadeBox = [stim.box.yesno{1}(1) stim.box.yesno{1}(2) stim.box.yesno{2}(3) stim.box.yesno{2}(4)];
  case 1
    alphas = [ynGlow(fadeCount) ynFade(fadeCount)];
    fadeBox = stim.box.yesno{2};
  case 2
    alphas = [ynFade(fadeCount) ynGlow(fadeCount)];
    fadeBox = stim.box.yesno{1};
  end
  % chosen box
  drawTrait(win,stim,trait,condition,alphas);

  %Screen('FillRect',win,[stim.bg(1:3) fadeVector(fadeCount)], fadeBox);
  WaitSecs(0.025);
  Screen('Flip',win);
  % adjust to acheive desired fade
end

return