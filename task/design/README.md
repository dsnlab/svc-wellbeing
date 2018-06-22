# ~/svc/design:   
## code to optimize fMRI designs for SVC tasks  

### makeSVCdesigns.m
Converts optimized DSD design sequences into trial matrices. Outputs omnibus structure ('svcDesigns.mat') and individualized stimulus files for each subject/run ('~/svc/paradigm/input/SVC$$$_svc_run$.txt') w/ per-trial info.


### optSVCtor.m 
Creates multi-objective optimized designs for SVC task. Condition sequence (i.e., private vs. friend, private vs. parent, friend vs. parent) optimized for contrast detection, counterbalancing, hrf estimation, and frequency of event types according to strategy of Wager (2002). *add cite/link*

In current form, generates GAworkspace, from which the 'torSVCdesign_{$}.mat' files can be found in the variable MM.



