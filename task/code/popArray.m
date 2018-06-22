function [ shortenedArray ] = popArray( array )
%POPARRAY.m if a vector is longer than 1, pop off the first element
% USAGE: [shortenedArray] = popArray(array)   
% ~#wem3#~ why isn't this built in?

if size(array,1) > 1;
    shortenedArray = array(2:end,:);
else
    shortenedArray = array;
end
return
