function drawDisco(win, stim, statement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawDisco.m: draw chosen target/coins and statement for dsd
%
%               ~wem3 - 141030
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if choiceResponse
%   % make coin
%   coin = Screen('MakeTexture',win,stim.coins{targets(choiceResponse+2)});
%   % draw coins
%   Screen('DrawTexture',win,coin,[],stim.box.coin{choiceResponse},[],[],0.5);
%   % draw choice
%   Screen('TextSize', win, 60);
%   Screen('TextFont', win, 'Arial');
%   Screen('TextStyle', win, 1);
%   DrawFormattedText( win,...
%     stim.targetText{targets(choiceResponse)}, 'center', 'center',...
%     [ stim.targetColors{targets(choiceResponse)}(1:3) 0.7],[],[],[],[],[],...
%     stim.box.choice{choiceResponse} );
% else
%   drawChoice(win, stim, targets)
%   Screen('FillRect',win,[stim.bg(1:3) 0.5], [0 0 stim.box.xDim stim.box.statement(2)]);
% end

Screen('TextSize', win, 60);
Screen('TextFont', win, 'Arial');
Screen('TextStyle',win,1);
DrawFormattedText(win, 'Sometimes I...',...
  'center', stim.box.statement(2)-stim.box.unit/2, stim.grey);
DrawFormattedText(win,statement,'center','center',...
  stim.white,[],[],[],[],[],...
  stim.box.statement );

return;