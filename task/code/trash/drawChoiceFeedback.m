function drawChoiceFeedback(win,stim,targets,statement,discoResponse,choiceResponse)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawChoiceFeedback.m: draw a frame around the subject's choice
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handGlow = (0.55:0.05:1);
handFade = flip(.36:0.01:0.45);
% fadeVector is a vector we'll use to construct a gradient of transparencies
fadeVector = (0:0.0944:.85);

%% now fade the non-chosen box
for fadeCount = 1:length(fadeVector)
%   switch choiceResponse
%   case 0
%     alphas = [handFade(fadeCount) handFade(fadeCount)];
%     fadeBox = [0 0 stim.box.xDim stim.box.statement(2)];
%   case 1
%     alphas = [handGlow(fadeCount) handFade(fadeCount)];
%     fadeBox = [stim.box.xCenter 0 stim.box.xDim stim.box.statement(2)];
%   case 2
%     alphas = [handFade(fadeCount) handGlow(fadeCount)];
%     fadeBox = [0 0 stim.box.xCenter stim.box.statement(2)];
%   end
  switch choiceResponse
  case 1
    alphas = [handGlow(fadeCount) handFade(fadeCount)];
    %fadeBox = stim.box.hand{2};
    fadeChoice = stim.box.choice{2}.*[0 1 0 1]+[stim.box.xCenter 0 stim.box.xDim 0]; %make box cover a wide x range
    fadeCoin = stim.box.coin{2};
  case 2
    alphas = [handFade(fadeCount) handGlow(fadeCount)];
    %fadeBox = stim.box.hand{1};
    fadeChoice = stim.box.choice{1};
    fadeCoin = stim.box.coin{1};
  end
  % chosen box
  %drawHands(win,stim,targets,alphas);
  drawChoice(win,stim,targets,statement,discoResponse);
  %Screen('FillRect',win,[stim.bg(1:3) fadeVector(fadeCount)], fadeBox);
  Screen('FillRect',win,[stim.bg(1:3) fadeVector(fadeCount)], fadeChoice);
  Screen('FillRect',win,[stim.bg(1:3) fadeVector(fadeCount)], fadeCoin);
  WaitSecs(0.025);
  Screen('Flip',win);
  % adjust to acheive desired fade
end

return