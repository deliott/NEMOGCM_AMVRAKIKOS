function [lon, lat, depth] = loadBin(filename, im, jm)
%
% This function loads the data from the binary file provided by
% Mamoutos. 
%INPUT :
%      filename = path to the file
%      im, jm = width and height of the file.
%OUTPUT : 
%      lon = 1*im array
%      lat = jm*1 array
%      depth = jm*im array
%
fid=fopen(filename,'r','ieee-be');
dum=fseek(fid,4,'cof');
[lon]=fread(fid,[im jm],'float32')';
dum=fseek(fid,8,'cof');
[lat]=fread(fid,[im jm],'float32')';
dum=fseek(fid,8,'cof');
[depth]=fread(fid,[im jm],'float32')';
