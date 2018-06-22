targetDirectory = '/Users/wem3/Desktop/DRS/task/input';

for dCount = 1:50
    if dCount < 10
        subID = ['drs00',num2str(dCount)];
    elseif dCount >= 10
        subID = ['drs0',num2str(dCount)];
    end
    
    if mod(dCount,2)
        inFile=['/Users/wem3/Desktop/DRS/design/rpe_list1.txt'];
    else
        inFile=['/Users/wem3/Desktop/DRS/design/rpe_list2.txt'];
    end

    rawInput = dlmread(inFile);
    condition = rawInput(:,3);
    outcome = rawInput(:,4);
    stimOnset = rawInput(:,1);
    fbOnset = rawInput(:,2);
    for tCount = 1:72
        if outcome(tCount)==0
            outcome(tCount)=1;
        elseif outcome(tCount)==1;
            outcome(tCount)=2;
        end
        fid = fopen([targetDirectory,filesep,subID,'_rpe_input.txt'],'a');
        fprintf(fid,'%u,%u,%4.3f,%4.3f,%u\n',tCount,condition(tCount),stimOnset(tCount),fbOnset(tCount),outcome(tCount));
        fclose(fid);
    end

end