
function startup_spaceex()
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

S = dbstack('-completenames');



SPACEEX_PATH_old = '/Users/kekatos/Downloads/spaceex_exe_mac/';
SPACEEX_PATH = '/Users/kekatos/Files/workspace/sspaceex/Release/';

setenv('PATH', [getenv('PATH'), ':', SPACEEX_PATH]);

addpath(genpath(SPACEEX_PATH)); %% sspaceex
addpath(genpath(SPACEEX_PATH_old)); % spaceex

try
    system('sspaceex --help'); % or system('spaceex --help')
    disp('')
    disp('SpaceEx path correctly defined.')
    disp('')
catch
    warning('SpaceEx path is not defined correctly.')
end
end

