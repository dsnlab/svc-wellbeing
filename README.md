# Self versus Change (versus Y) = SvCvY

This task is a generalizable implementation of the self versus change task used in the DSN lab. Users respond 'Yes' or 'No' to a series of words.
In the default task, they are asked to judge whether a word describes them (Yes or No), and in other blocks,  whether the word describes a trait that
can change.

You should be able to specify a JxK factorial paradigm where J is the number of different prompts (Self, Change, Y...) and K is the number
of different word types. For example, you may have words that are trait adjectives related to both extraversion and neuroticism.

## Setup

In order to get this project going, you need to supply a task design file created by the GA algorithm in `task/design/optSVCtor.m`, which 
produces a file that looks like the one in `task/design/GAoutput/torSVCdesignEXAMPLE.mat`, and a list of trait words like the one 
in `task/design/materials/svcTraitsEXAMPLE.txt`.

1. Open and edit and set options in `task/design/makeSVCdesigns.m`, and then run it
2. Run `task/design/makeSVCstimulus.m` (more on this coming soon)
3. Add `task/code` to your matlab path
4. You **must** run the following from `svc/task`
5. Run `getSubInfo()` on the matlab command line
	- it will ask you to select the study folder -- this will be the `svc/` folder in which you find `task/`, `SVCstim.mat`, and this file, `README.md`. 
6. Run `runSVC()` on the matlab command line

## `~/task`

Contains code and input text to run experiments, design info/materials, task output  

All code is in psych-toolbox-3, often run on OS X using MATLAB_R2014b

Make sure to add the folders in `~/task` to the MATLAB search path. To wit, you can do:  

```matlab
addpath(genpath('~/task'));
```


SVC
authors: wem3, jflournoy, dcos  
edited: 16-03-24  
