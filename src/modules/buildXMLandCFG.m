function options=buildXMLandCFG(A,B,dt,options)

if nargin<2
    error('Matrices A and B should be specified.')
end
if nargin==2 || isempty(dt)
    model='cont';
    disp('The continuous-time SpaceEx model is requested. ')
end
if nargin==3 || (nargin==4 && ~isempty(dt))
    disp('The discrete-time SpaceEx model is requested. ')
    model='disc';
end

if nargin<4 || (nargin==4 && ~isfield(options,'xml_name'))
    if strcmp(model,'cont')
        options.xml_name='model_continuous';
    elseif strcmp(model,'disc')
        options.xml_name=strcat('model_discrete_',num2str(dt));
    end
end
if nargin<4 || (nargin==4 && ~isfield(options,'cfg_name'))
    options.cfg_name=options.xml_name;
end
if nargin<4 || (nargin==4 && ~isfield(options,'output'))
    options.output=cell(1,length(A));
    for i=1:length(A)
        options.output{i}=i;
    end
end
if nargin<4 || (nargin==4 && ~isfield(options,'IC'))
    options.IC=cell(1,length(A));
    for i=1:length(A)
        options.IC{i}=0;
    end
end

if nargin<4 || (nargin==4 && ~isfield(options,'output_format'))
    options.output_format='GEN';
end
%     disp('')
%     disp('No constraints on the input and the states are specified.')

if nargin==3 || (nargin==4 && ~isfield(options,'discrete_sx_version'))
    options.discrete_sx_version=2;
end
if isfield(options,'T')
    sys.T=options.T;
else
    disp(' Time horizon has not been specified.')
end
if isfield(options,'inputs')
    sys.inputs=options.inputs;
else
        disp('No input constraints are given.')
end

if isfield(options,'states')
    sys.states=options.states;
else
    disp('No state constraints are given.')
end
sys.A=A;
sys.B=B;

switch model
    case 'cont'
        sys=buildXMLcontinuous(options.xml_name,sys);
        buildCFGcontinuous(options,sys)
    case 'disc'
        sys.dt=dt;
        sys=constructDiscrete(sys);
        sys=buildXMLdiscrete(options.xml_name,sys,options.discrete_sx_version);
        buildCFGdiscrete(options,sys);
end
fprintf('The SpaceEx model "%s" is successfully constructed. \r',options.xml_name)
fprintf('The configuration model "%s" is successfully constructed. \r',options.cfg_name)