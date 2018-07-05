%This determines on what trials the prompt is switched, and what it
%switches to. So, for 6 trials per block

rundetails.Trials_Per_Block=6;
rundetails.Prompt_1_Condition_Nums=[1 2 3]; %These must be exclusive
rundetails.Prompt_2_Condition_Nums=[4 5 6];
rundetails.Prompt_1_text='Usually, I (am)...';
rundetails.Prompt_2_text='Usually, can change...';