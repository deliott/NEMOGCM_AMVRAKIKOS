function [lon, lat, depth] = loadBin(filename, im, jm)

fid=fopen(filename,'r','ieee-be');
dum=fseek(fid,4,'cof');
[lon]=fread(fid,[im jm],'float32')';
dum=fseek(fid,8,'cof');
[lat]=fread(fid,[im jm],'float32')';
dum=fseek(fid,8,'cof');
[depth]=fread(fid,[im jm],'float32')';
