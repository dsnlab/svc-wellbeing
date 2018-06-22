function drawYesNo(win,stim,alphas)
yesMatrix = stim.box.green;
yesMatrix(:,:,4) = (stim.alpha.yesno{1}) ./255;
yesBox = stim.box.yesno{1};
yesTex = Screen('MakeTexture',win,yesMatrix);
Screen('DrawTexture',win,yesTex,[],yesBox,[],[],alphas(1));
noMatrix = stim.box.red;
noMatrix(:,:,4) = (stim.alpha.yesno{2}) ./255;
noBox = stim.box.yesno{2};
noTex = Screen('MakeTexture',win,noMatrix);
Screen('DrawTexture',win,noTex,[],noBox,[],[],alphas(2));
end