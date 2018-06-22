function drawHands(win,stim,targets,alphas)
leftHandMatrix = stim.targetBoxen{targets(1)};
leftHandMatrix(:,:,4) = (stim.alpha.hand{1}) ./255;
leftHandBox = stim.box.hand{1};
leftHand = Screen('MakeTexture',win,leftHandMatrix);
Screen('DrawTexture',win,leftHand,[],leftHandBox,[],[],alphas(1));
rightHandMatrix = stim.targetBoxen{targets(2)};
rightHandMatrix(:,:,4) = (stim.alpha.hand{2}) ./255;
rightHandBox = stim.box.hand{2};
rightHand = Screen('MakeTexture',win,rightHandMatrix);
Screen('DrawTexture',win,rightHand,[],rightHandBox,[],[],alphas(2));
end