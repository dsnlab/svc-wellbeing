% make SVC stimulus
%% set some paths
matDir = 'materials';
taskDir = '../';
yesFile = [matDir,filesep,'yes-76.png'];
noFile = [matDir,filesep,'no-76.png'];
selfFile = [matDir,filesep,'self-200.png'];
deltaFile = [matDir,filesep,'delta-200.png'];

%% self icon (for svc)
[~,~,stim.alpha.self] = imread(selfFile);

%% delta icon (for svc)
[~,~,stim.alpha.delta] = imread(deltaFile);

%% yes icon (for svc)
[~,~,stim.alpha.yesno{1}] = imread(yesFile);

%% no icon (for svc)
[~,~,stim.alpha.yesno{2}] = imread(noFile);

%% set visual preferences
% colorscheme
stim.bg     = [29  31  33  255]./255; % bg
stim.grey   = [203 203 203 255]./255; % grey
stim.white  = [255 255 255 255]./255; % white
stim.red    = [244  82  82 255]./255; % red
stim.orange = [252 147  55 255]./255; % orange
stim.yellow = [190 168  36 255]./255;  % yellow (how about 255 241 155?)
stim.green  = [ 60 218  96 255]./255; % aquagreen
stim.sky    = [ 59 190 213 255]./255; % sky
stim.blue   = [ 79  82 230 255]./255; % blurple
stim.pink   = [167  47 187 255]./255; % pinkle
stim.purple = [124  70 241 255]./255; % purple

% set up screen positions
xDim = 1440; % 1920; % hardcoded here, but built to work on 3/4 as well
yDim = 900; % 1080;
unit = xDim/16;
xCenter = xDim/2;
yCenter = yDim/2;
box.xDim = xDim;
box.yDim = yDim;
box.unit = unit;
box.xCenter = xCenter;
box.yCenter = yCenter;

% posLR is an N x 3 matrix for making symmetrical boxen 
posLR = [... % [ left x position, y position, right x position ]
(xCenter - 3*unit), (yCenter - 1.5*unit), (xCenter + 3*unit) % choiceBoxen
];

% structure to hold boxen...
box.yesno{1} = CenterRectOnPointd([0 0 76 76],posLR(1,1),posLR(1,2));
box.yesno{2} = CenterRectOnPointd([0 0 76 76],posLR(1,3),posLR(1,2));
box.prompt = CenterRectOnPointd([0 0 200 200],xCenter,(yCenter - 2*unit));

%% prefabricate color boxen (?)
for rgbCount = 1:3
  box.bg(:,:,rgbCount)      = ones(200,200).*stim.bg(rgbCount);
  box.grey(:,:,rgbCount)    = ones(200,200).*stim.grey(rgbCount);
  box.white(:,:,rgbCount)   = ones(200,200).*stim.white(rgbCount);
  box.red(:,:,rgbCount)     = ones(76,76).*stim.red(rgbCount);
  box.orange(:,:,rgbCount)  = ones(200,200).*stim.orange(rgbCount);
  box.yellow(:,:,rgbCount)  = ones(200,200).*stim.yellow(rgbCount);
  box.green(:,:,rgbCount)   = ones(76,76).*stim.green(rgbCount);
  box.sky(:,:,rgbCount)     = ones(200,200).*stim.sky(rgbCount);
  box.blue(:,:,rgbCount)    = ones(200,200).*stim.blue(rgbCount);
  box.pink(:,:,rgbCount)    = ones(200,200).*stim.pink(rgbCount);
  box.purple(:,:,rgbCount)  = ones(200,200).*stim.purple(rgbCount);
end
stim.box = box;

%% save as SVCstim.mat
saveName = [taskDir,filesep,'SVCstim.mat'];
save(saveName,'stim');

