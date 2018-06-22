function drawTrait(win, stim, trait, condition, alphas)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawTrait.m: draw instructional icon, trait, & yes/no prompts for svc task
%
%               ~wem3 - 141117
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
iconMatrix = stim.promptMatrix{stim.promptIndex};

% draw prompt
iconTex = Screen('MakeTexture',win,iconMatrix);
Screen('DrawTexture',win,iconTex,[],stim.box.prompt);
% draw trait
Screen('TextSize', win, 100);
Screen('TextFont', win, 'Futura');
Screen('TextStyle', win,0);
DrawFormattedText( win, trait, 'center', 'center', stim.white );
% draw yes
yesMatrix = stim.box.green;
yesMatrix(:,:,4) = (stim.alpha.yesno{1}) ./255;
yesBox = stim.box.yesno{1};
yesTex = Screen('MakeTexture',win,yesMatrix);
Screen('DrawTexture',win,yesTex,[],yesBox,[],[],alphas(1));
% draw no
noMatrix = stim.box.red;
noMatrix(:,:,4) = (stim.alpha.yesno{2}) ./255;
noBox = stim.box.yesno{2};
noTex = Screen('MakeTexture',win,noMatrix);
Screen('DrawTexture',win,noTex,[],noBox,[],[],alphas(2));

return;