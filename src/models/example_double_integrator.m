% In this example, we define the double integrator (A,B and constraints),
% create continuous and discrete SpaceEx models (xml file (Hybrid
% Automata), cfg (options/configuration), call from SpaceEx from Matlab,
% compute the reachable sets and find the state constraints over time.

% initialization
clc,clear, close all;

% model
A=[0 1 0 0;0 0 0 0; 0 0 0 1; 0 0 0 0];
B= [0 0; 1 0; 0 0;0 1];
dt=0.1;

% options
options.T=10;
options.xml_name='test_model_discrete';
options.discrete_sx_version=2;
options.inputs=cell(size(B,2),1);
options.inputs{1}=[ -3 3];
options.inputs{2}=[-1 1];
options.states=cell(length(A),1);
options.states{2}= [-8 8];
options.states{4}= [-4 4];
options.output={1,2,3,4};
options.IC=cell(length(A),1);
options.IC{1}=[50];
options.IC{2}=[0.2];
options.IC{3}=[3];
options.IC{4}=[0];

%-------------------------------------------------%
%-------------------------------------------------%
%-- Construct SpaceEx models ---------------------%
%-------------------------------------------------%
%-------------------------------------------------%

% % constuct continuous-time model
% [options]=buildXMLandCFG(A,B);
% % constuct continuous-time model with options 
% options=buildXMLandCFG(A,B,[],options);
% % construct discrete-time model
% [options]=buildXMLandCFG(A,B,dt);

% constuct discrete-time model with options 
[options]=buildXMLandCFG(A,B,dt,options);


%-------------------------------------------------%
%-------------------------------------------------%
%-------- Run SpaceEx models ---------------------%
%-------------------------------------------------%
%-------------------------------------------------%

% the executable SpaceEx version (binary) should be downloaded.
% need to modify the spaceex path accordingly.
startup_spaceex;
if ~isfield(options,'output_file')
    options.output_file=options.xml_name;
end
spaceex.model_file = strcat(options.xml_name,'.xml');
spaceex.config_file = strcat(options.cfg_name,'.cfg');
spaceex.output_file=strcat(options.output_file,'.',options.output_format);

warning('Consider manually changing the output variables.')

% Flowpipe t,x1
system(sprintf('sspaceex -g %s -m %s -o %s -a t,x1', spaceex.config_file, spaceex.model_file, spaceex.output_file));

% Plot
plot_polygons_matlab(spaceex.output_file)
plot_2d_vertices_updated(spaceex.output_file,0,'reach_set','r')

% Flowpipe t,x1,x3
spaceex.output_file_constraints='reach_t_px_py.gen';

system(sprintf('sspaceex -g %s -m %s -o  %s -a t,x1,x3 ', spaceex.config_file, spaceex.model_file, spaceex.output_file_constraints));

%-------------------------------------------------%
%-------------------------------------------------%
%-------- Obtain state constraints ---------------%
%-------------------------------------------------%
%-------------------------------------------------%

% Save constraints from gen file to a matrix

%t,x1,x3 (all constraints)

A_flowpipe=gen2matrix(spaceex.output_file_constraints);

%t,x1,x3 (min/max constraints every dt for x1 and x3)
% 1st column: sampled time, 2nd column: min of x1, 3rd: max of x1, 4th: min
% of x3, and 5th: max of x3. 
if ~isempty(dt)
    [A_constraints,dd]=findRange(A_flowpipe,dt,options.T);
    disp('The state constraints for each time step (dt) have been computed.')
else
    disp('The state constraints cannot be computed for continuous time.')
end
save('state_bounds.mat','A_constraints')