function  buildCFGcontinuous(options,sys)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

file='.cfg';
fileID=fopen(strcat(options.cfg_name,file),'w');
fprintf(fileID,'system = "system"\r\n');

var=sys.var;
%n=sys.n;
n=length(sys.A);
output=options.output;
IC=options.IC;
% //To-do make it general
if n==4 
    fprintf(fileID,'initially = "t==0 & %s==%.4f & %s==%f & %s==%f & %s==%f" \r\n',var{1},IC{1},var{2},IC{2},var{3},IC{3},var{4},IC{4});
%     fprintf(fileID,'initially = "t==0 & %.4f<=x1<=%.4f & %.4f<=x2<=%.4f & %.4f<=x3<=%.4f & loc(aut2_1)==loc%d" \r\n',IC(1)-0.04,IC(1),IC(2)-0.04,IC(2),find_Domain_values([IC(1); IC(2)],elements.dynamics{1})); %+ 0.01
end

fprintf(fileID,'forbidden = "" \r\n');
fprintf(fileID,'scenario = stc \r\n');%supp
fprintf(fileID,'directions = box \r\n');% box
fprintf(fileID,'set-aggregation = "chull" \r\n'); %"none"
fprintf(fileID,'sampling-time = 0.1 \r\n');
fprintf(fileID,'flowpipe-tolerance = 0.01 \r\n');
fprintf(fileID,'flowpipe-tolerance-rel = 0 \r\n');
fprintf(fileID,'simu-init-sampling-points = 0 \r\n');
fprintf(fileID,'time-horizon = 10 \r\n');
fprintf(fileID,'clustering = 100 \r\n');
fprintf(fileID,'iter-max = -1 \r\n');
% generalize outputs
fprintf(fileID,'output-variables = "t,%s,%s,%s,%s" \r\n',var{output{1}},var{output{2}},var{output{3}},var{output{4}});
fprintf(fileID,'output-format = GEN \r\n');
fprintf(fileID,'verbosity = m \r\n');
fprintf(fileID,'output-error = 0 \r\n');
fprintf(fileID,'rel-err = 1.0E-12 \r\n');
fprintf(fileID,'abs-err = 1.0E-15 \r\n');


end

