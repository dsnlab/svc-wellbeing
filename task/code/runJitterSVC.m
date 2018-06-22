%% runJitter.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: Dani Cosme
%
% Description: This script creates the jitter based on the number of
% specified trials and saves a vector of values in svc/task/design as a 
% .mat file (jitter.mat)
% 
% Dependencies: jitterSVC.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set path
pathtofile = mfilename('fullpath');
homepath = pathtofile(1:(regexp(pathtofile,'code/runJitter') - 1));

%% Create jitter vector
meanVal = input('Mean:  ');
ntrials = input('Number of trials per run:  ');
outfile = input('File name (e.g. jitter.mat):  ', 's');
jitter = jitterSVC(meanVal,ntrials,0);  %mean in first position, num trials in second position, sample from long tail in third position
fprintf('The mean jitter is %1.2f\n', mean(jitter));

%% Save jitter vector
outputfile = fullfile(homepath,'design',outfile);
save(outputfile,'jitter')
