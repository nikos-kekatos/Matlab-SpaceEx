function [ A ] = gen2matrix(input_file )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fid=fopen(input_file,'rt');
fseek(fid, 0, 'eof');
chunksize = ftell(fid);
fseek(fid, 0, 'bof');
ch = fread(fid, chunksize, '*uchar');
nol = sum(ch == sprintf('\n')); % number of lines
fprintf('The total number of lines in the GEN file is %i. \r\n',nol);
fclose(fid);


fileID=fopen(input_file,'rt');

if fileID~=-1
    A=[];
    while ~feof(fileID)
        tline = fgetl(fileID);
        if (~strcmp(tline,'') && ~feof(fileID))
            d = sscanf(tline,'%g');
            d_out=d([1 2 4])';
            A=[A;d_out];
            
        end
    end
end

