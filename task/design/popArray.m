function [ popdMat ] = popArray( aMat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[nrow ncol] = size(aMat);

if(nrow<2)
    popdMat = [];
    return
else
    popdMat = aMat(2:length(aMat),:);
    return

end

