GAdir = 'GAoutput';
targetDirectory = '../input';
NRealSubsTotal = 250;
NWavesTotal = 3;
NSubsTotal = NRealSubsTotal * NWavesTotal;
trialLength = 7.5;
load('gammaDists.mat'); % loads variables choiceGammaDSD and discoGammaDSD

%% load up the 200 optimized sequences, assign 4 per 'design'
designFile = ([GAdir,filesep,'kaoDSDdesign.mat']);
load(designFile);
for kCount = 1:NSubsTotal %Using the same design for all participants
%   designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount), '.mat']);
  run1.ovf = Out.bestOVF;
  run1.sequence = Out.bestList;
%   designFile = ([GAdir,filesep,'kaoDSDdesign_', num2str(kCount + NSubsTotal), '.mat']);
%   load(designFile)
%   run2.ovf = Out.bestOVF;
%   run2.sequence = Out.bestList;
  dsdDesign(kCount).run1 = run1;
  dsdDesign(kCount).run2 = run1;
end

%% assign positions and coin values
% randomize left/right, optimize coin values (1 = aIsMore,
% 2 = bIsMore, 3 = eqPair)
% more, targets are equal)
% one pair for each comparison, each way (i.e., [1 3] and [3 1] are
% separate pairings, so that each comparison is equally represented
% in each condition)

%!! use new frequencies
coinPairs = [repmat([2,2],4,1); repmat([3,3],5,1); repmat([4,4],5,1); repmat([2,3],4,1); repmat([3,4],4,1); repmat([2,4],6,1); repmat([3,2],4,1);...
    repmat([4,3],4,1); repmat([4,2],6,1)];
leftIsMoreCount = 1;
rightIsMoreCount = 1;
eqCount = 1;
eqPairs = nan(10,2);
leftIsMorePairs = nan(10,2);
rightIsMorePairs = nan(10,2);
for cCount = 1:length(coinPairs)
   if (coinPairs(cCount,1)==coinPairs(cCount,2))
       eqPairs(eqCount,:)=coinPairs(cCount,:);
       eqCount = eqCount + 1;
   elseif (coinPairs(cCount,1)>coinPairs(cCount,2))
       leftIsMorePairs(leftIsMoreCount,:)=coinPairs(cCount,:);
       leftIsMoreCount = leftIsMoreCount + 1;
   elseif (coinPairs(cCount,1)<coinPairs(cCount,2))
       rightIsMorePairs(rightIsMoreCount,:)=coinPairs(cCount,:);
       rightIsMoreCount = rightIsMoreCount + 1;
   end
end

% add statements to designs at random
%!! Distinguish between types of statements to correspond with optimized
%!! ordering of neutral and affective.
neutStatementFile = 'materials/statements_neutral.txt';
affStatementFile = 'materials/statements_affect.txt';

neutRawStatements(:,1) = textread(neutStatementFile,'%s','delimiter','\n');
affRawStatements(:,1) = textread(affStatementFile,'%s','delimiter','\n');

numStatements = (length(neutRawStatements)+length(affRawStatements));



%% convert the 0s in the sequence into + 8sec durations for previous trial,
% get jittered durations (m = 1.5s)
%!! need to make sure these rests due to optimization are not negatively
%!! impacting the total time for the run
rawJitter = choiceGammaDSD./1000';
discoJitter = discoGammaDSD./1000';

%targetA = repmat(1, numTrials, 1); % 1=Private
%targetB = repmat(2, numTrials, 1); % 2=Share

for dCount = 1:NSubsTotal
    
    neutStatements = shuffle(neutRawStatements);
    affStatements = shuffle(affRawStatements);
             
    shuffLeftIsMorePairs=leftIsMorePairs(shuffle(1:14),:);
    shuffRightIsMorePairs=rightIsMorePairs(shuffle(1:14),:);
    shuffEqPairs=eqPairs(shuffle(1:14),:);

    for rCount = 1:2;
        thisRun = (['run',num2str(rCount)]);
        rawJitter = shuffle(rawJitter);
        discoJitter = shuffle(discoJitter);
        zCount = 0;
        rawTarget = dsdDesign(dCount).(thisRun).sequence; % Every event from optimized sequence (e.g., numbers 0-6 ...)
        numOptTrials = length(rawTarget(rawTarget~=0));
        adjJitter = NaN(numOptTrials,1);
        condition = NaN(numOptTrials,1);
        for eCount = 1:length(rawTarget) % for every event
            if rawTarget(eCount) == 0 % if it's a rest event
                zCount = zCount + 1; % add one to the counter variable for number of rests
                adjJitter(eCount - zCount) = (rawJitter(eCount - zCount) + trialLength); % this way of indexing ensures it adds 8 seconds to the previous trial
            else
                adjJitter(eCount - zCount) = rawJitter(eCount - zCount);
            end
        end
        dsdDesign(dCount).(thisRun).condition = rawTarget(rawTarget~=0);
        
        dsdDesign(dCount).(thisRun).discoJitter = discoJitter;
        dsdDesign(dCount).(thisRun).choiceJitter = adjJitter;
        condition = dsdDesign(dCount).(thisRun).condition;
        % some temporary NaN vectors
        %!! We can get rid of the below loop because we only care about
        %share versus private (we don't have parents)
        
        nStatementCounter = 1;
        aStatementCounter = 1;
        % Fill design list with affective or neutral statements depending on
        % condition.

        for tCount = 1:length(condition)
            if condition(tCount) > 0 & condition(tCount) < 4;
                dsdDesign(dCount).(thisRun).statement(tCount) = neutStatements(nStatementCounter + (numStatements/4)*(rCount-1));
                nStatementCounter = nStatementCounter + 1;
            elseif condition(tCount) > 3 & condition(tCount) < 7;
                dsdDesign(dCount).(thisRun).statement(tCount) = affStatements(aStatementCounter + (numStatements/4)*(rCount-1));
                aStatementCounter = aStatementCounter + 1;
            else
                error('What the fucking fuck?!')
            end
        end

        coinA = nan(numOptTrials,1);
        coinB = nan(numOptTrials,1);

        % get a different randomized order of coin pairs for each subCondition
        %!! Edit because we don't have t1-3 conditions (but we have affect
        %and neutral
	% orientation = Left is Private, Right is Share
        % t1 = Neutral
        % t2 = Affective
        % c1 = loss to share
        % c2 = loss to private
        % c3 = equal payout
        
	%maybe delete run1 from following variables? or try to make code enter exact run number?

        run1t1c1 = shuffLeftIsMorePairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);
        
        run1t1c2 = shuffRightIsMorePairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);
        
        run1t1c3 = shuffEqPairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);
        
        run1t2c1 = shuffLeftIsMorePairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);
        
        run1t2c2 = shuffRightIsMorePairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);

        run1t2c3 = shuffEqPairs((1+7*(rCount - 1)):(7+7*(rCount - 1)), :);

        %t1c1Count = 1;
        %t1c2Count = 1;
        %t1c3Count= 1;
        %t2c1Count = 1;
        %t2c2Count = 1;
        %t2c3Count= 1;

        for tCount = 1:numOptTrials 
            switch condition(tCount)
                        case 1
                            coinA(tCount) = run1t1c1(1,1);
                            coinB(tCount) = run1t1c1(1,2);                           
                            run1t1c1 = popArray(run1t1c1); 

                      	case 2
                            coinA(tCount) = run1t1c2(1,1);
                            coinB(tCount) = run1t1c2(1,2);
                            run1t1c2 = popArray(run1t1c2);                          
                            
                        case 3
                            coinA(tCount) = run1t1c3(1,1);
                            coinB(tCount) = run1t1c3(1,2);
                            run1t1c3 = popArray(run1t1c3);
    
                        case 4
                            coinA(tCount) = run1t2c1(1,1);
                            coinB(tCount) = run1t2c1(1,2);
                            run1t2c1 = popArray(run1t2c1);
                            
                        case 5
                            coinA(tCount) = run1t2c2(1,1);
                            coinB(tCount) = run1t2c2(1,2);
                            run1t2c2 = popArray(run1t2c2);

                        case 6
                            coinA(tCount) = run1t2c3(1,1);
                            coinB(tCount) = run1t2c3(1,2);
                            run1t2c3 = popArray(run1t2c3);           
            end
        end
        
        %no longer randomly determining screen position
        
        dsdDesign(dCount).(thisRun).leftCoin=coinA;
        dsdDesign(dCount).(thisRun).rightCoin=coinB;
    end
   
end

% because having double rests at the end makes the loop funky, manually fix
% sub007.run2:
%dsdDesign(7).run2.discoJitter(numTrials) = dsdDesign(7).run2.discoJitter(numTrials) + 8;
%save dsdDesigns.mat dsdDesign

%caBut('dsdDesign','targetDirectory'); %!! is problem?
% note, made a separate loop to write output b/c sub007 is funky. Surely, this
% could be adressed programatically, but I only have time for pragmatic address...


for dCount = 1:NSubsTotal
    waveNum = floor(((dCount-1)/250)+1); % wave number is just how far you are in the count
    
    subIDNum = dCount - 250 * (waveNum - 1);
        
    if subIDNum < 10
        subID = ['tag00',num2str(subIDNum)];
    elseif subIDNum >= 10 & subIDNum < 100
        subID = ['tag0',num2str(subIDNum)];
    else
    subID = ['tag',num2str(subIDNum)];
    end
        
    for rCount = 1:2
        thisRun = (['run',num2str(rCount)]);
        condition = dsdDesign(dCount).(thisRun).condition;
        leftTarget = repmat(1,numOptTrials,1);
        rightTarget = repmat(2,numOptTrials,1);
        leftCoin = dsdDesign(dCount).(thisRun).leftCoin;
        rightCoin = dsdDesign(dCount).(thisRun).rightCoin;
        statement = dsdDesign(dCount).(thisRun).statement;
        choiceJitter = dsdDesign(dCount).(thisRun).choiceJitter;
        discoJitter = dsdDesign(dCount).(thisRun).discoJitter;

        for tCount = 1:numOptTrials
          fid = fopen([targetDirectory,filesep,subID,'_wave_',num2str(waveNum),'_dsd_','run',num2str(rCount),'_input.txt'],'a');

          fprintf(fid,'%u,%u,%u,%u,%u,%u,%4.3f,%4.3f,%s\n',tCount,condition(tCount),leftTarget(tCount),rightTarget(tCount),leftCoin(tCount),rightCoin(tCount),choiceJitter(tCount),discoJitter(tCount),statement{tCount});
          fclose(fid);
        end
    end
end
