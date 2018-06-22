function drawDiscoFeedback(win,stim,targets,statement,discoResponse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawDiscoFeedback.m: draw feedback for subject's disclosure
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

yesnoGlow = (0.55:0.05:1);
yesnoFade = flip(0:0.05:0.45);
% fadeVector is a vector we'll use to construct a gradient of transparencies
fadeVector = (0.1:0.1:1);

%% now fade the non-chosen box
for fadeCount = 1:length(fadeVector)
  switch discoResponse
  case 0
    alphas = [yesnoFade(fadeCount) yesnoFade(fadeCount)];
    fadeBox = [0 0 stim.box.xDim stim.box.statement(2)];
  case 1
    alphas = [yesnoGlow(fadeCount) yesnoFade(fadeCount)];
    fadeBox = [stim.box.xCenter 0 stim.box.xDim stim.box.statement(2)];
  case 2
    alphas = [yesnoFade(fadeCount) yesnoGlow(fadeCount)];
    fadeBox = [0 stim.box.xCenter stim.box.statement(2)];
  end
  drawYesNo(win,stim,alphas);
  drawDisco(win,stim,statement);
  WaitSecs(0.025);
  Screen('Flip',win);
end

return