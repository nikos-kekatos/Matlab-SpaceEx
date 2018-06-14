function [ sys ] = buildXMLdiscrete( xml_name,sys,option )

% option 1, exact translation/auxiliary variables (e1,e2...,ek)
% uncontrolled and defined in the invariant of the source location. Leads
% to a bug with SpaceEx.
% option 2, working version (defined in the guards, uncontrolled again)
file='.xml';
fileID=fopen(strcat(xml_name,file),'w');

% temp variables
%n=sys.n;
%k=sys.k;
n=length(sys.Ad);
k=size(sys.Bd,2);

% Header
fprintf(fileID,'<?xml version="1.0" encoding="iso-8859-1"?> \r\n');
fprintf(fileID,'<sspaceex xmlns="http://www-verimag.imag.fr/xml-namespaces/sspaceex" version="0.2" math="SpaceEx"> \r\n');

%Clock
fprintf(fileID,' <component id="clock"> \r\n');
fprintf(fileID,    '<param name="t" type="real" local="false" d1="1" d2="1" dynamics="any" /> \r\n');
fprintf(fileID,    '<location id="1" name="loc1" x="210.0" y="110.0">  \r\n');
if isfield (sys,'T')
    fprintf(fileID,    ' <invariant>t &lt;= %f</invariant> \r\n',sys.T);
end
fprintf(fileID,    ' <flow>t''==1</flow> \r\n');
fprintf(fileID,    '</location> \r\n');
fprintf(fileID,    '</component> \r\n');

% Automaton/Plant

var=cell(1,n+1);
for i=1:n+1
    if i~=n+1
        var{i}=char(sprintf('x%d', i));
    else
        var{i}=sprintf('t_local');
    end
end
in=cell(1,k);
extra=cell(1,k);

for i=1:k
    in{i}=char(sprintf('u%d',i));
    extra{i}=char(sprintf('e%d',i));
end

sys.var=var;
sys.in=in;
sys.extra=extra;


block_name='plant';
fprintf(fileID,'<component id="%s"> \r\n',block_name);

%parameters
for i=1:n
    fprintf(fileID,'<param name="%s" type="real" local="false" d1="1" d2="1" dynamics="any" placement="east" /> \r\n',var{i});
end
%add extra timer
fprintf(fileID,'<param name="%s" type="real" local="true" d1="1" d2="1" dynamics="any" placement="east" /> \r\n',var{end});
for i=1:k
    fprintf(fileID,'<param name="%s" type="real" local="false" d1="1" d2="1" dynamics="any" placement="west" controlled="true" /> \r\n',in{i});
    fprintf(fileID,'<param name="%s" type="real" local="true" d1="1" d2="1" dynamics="any" placement="west" controlled="false" /> \r\n',extra{i});
end
fprintf(fileID,'<location id="1" name="loc1" x="346.0" y="241.0" width="250.0" height="300.0"> \r\n');
% Invariant
fprintf(fileID,' <invariant>');
first_condition=1; % for the first condition no & is required
for i=1:k
    if isfield (sys,'inputs')
        if sys.inputs{i}
            if first_condition
                if option==1
                    fprintf(fileID,'%f&lt;=%s&lt;=%f  \r\n',sys.inputs{i}(1),extra{i},sys.inputs{i}(2));
                    first_condition=0;
                end
            else
                if option==1
                    fprintf(fileID,'&amp; %f&lt;=%s&lt;=%f  \r\n',sys.inputs{i}(1),extra{i},sys.inputs{i}(2));
                end
            end
        end
    end
end
for i=1:n
    if isfield (sys,'states')
        if sys.states{i}
            if first_condition
                fprintf(fileID,'%f&lt;=%s&lt;=%f  \r\n',sys.states{i}(1),var{i},sys.states{i}(2));
                first_condition=0;
            else
                fprintf(fileID,'&amp; %f&lt;=%s&lt;=%f  \r\n',sys.states{i}(1),var{i},sys.states{i}(2));
            end
        end
    end
end
%t_local
if first_condition
    fprintf(fileID,'%f&lt;=%s&lt;=%f  \r\n',0,var{end},sys.dt);
    
else
    fprintf(fileID,'&amp; %f&lt;=%s&lt;=%f  \r\n',0,var{end},sys.dt);
end
fprintf(fileID,' </invariant> \r\n');
%flow
fprintf(fileID,' <flow>');
A=sys.Ad;
B=sys.Bd;
for i=1:n+1
    if n==4 && k==2
        if i~=n+1
            fprintf(fileID,'%s''==0 &amp; \r\n',var{i}) ;
        else % t_local
            fprintf(fileID,'%s''== 1 &amp; \r\n',var{i}) ;
        end
    else
        error(' Model with %i states and %i input(s) is not yet supported. \r',n,k)
    end
end
for i=1:k
    if i~=k
        fprintf(fileID,'%s''==0 &amp; \r\n',in{i}) ;
    else % no extra & at the end
        fprintf(fileID,'%s''== 0 \r\n',in{i}) ;
    end
end
fprintf(fileID,' </flow> \r\n');
fprintf(fileID,'</location> \r\n');

% Transition

fprintf(fileID,'<transition source="1" target="1"> \r\n');
fprintf(fileID,'<labelposition x="14.0" y="-180.0" width="300" height="150"  /> \r\n');
fprintf(fileID,'<middlepoint x="163.0" y="191.0" /> \r\n');
fprintf(fileID,'<guard>');
fprintf(fileID,'%s&gt;=%.6f \r\n',var{end},sys.dt);
if option==2
    if isfield(sys,'inputs')
        for i=1:k
            fprintf(fileID,'&amp; %f&lt;=%s&lt;=%f  \r\n',sys.inputs{i}(1),extra{i},sys.inputs{i}(2));
        end
    end
end
fprintf(fileID,'</guard>');

fprintf(fileID,'<assignment>');
for i=1:n
    if n==4 && k==2
        fprintf(fileID,'%s :=%f*%s+%f*%s+%f*%s+%f*%s+%f*%s+%f*%s &amp; \r\n',var{i},A(i,1),var{1},A(i,2),var{2},A(i,3),var{3},A(i,4),var{4},B(i,1),in{1},B(i,2),in{2}) ;
    else
        error(' Model with %i states and %i input(s) is not yet supported. \r',n,k)
    end
end
for i=1:k
    fprintf(fileID,'%s :=%s &amp; \r\n',in{i},extra{i}) ;
end
fprintf(fileID,'%s :=0 \r\n',var{end}) ;
fprintf(fileID,'</assignment>');
fprintf(fileID,'</transition> \r\n');

fprintf(fileID,'</component> \r\n');

%Network component
system_name='system';
fprintf(fileID,'<component id="%s"> \r\n',system_name);
fprintf(fileID,'<param name="t" type="real" local="false" d1="1" d2="1" dynamics="any" controlled="true" x="349.0" y="68.0" /> \r\n');
for i=1:n
    fprintf(fileID,'<param name="%s" type="real" local="false" d1="1" d2="1" dynamics="any" controlled="true" x="323.0" y="153.0" /> \r\n',var{i});
end
for i=1:k
    fprintf(fileID,'<param name="%s" type="real" local="false" d1="1" d2="1" dynamics="any" controlled="true" x="171.0" y="260.0" /> \r\n',in{i});
end
fprintf(fileID,'<bind component="clock" as="clock_1" x="262.0" y="70.0">\r\n');
fprintf(fileID,'<map key="t">t</map> \r\n');
fprintf(fileID,'</bind>\r\n');
fprintf(fileID,'<bind component="%s" as="%s_1" x="230.0" y="180.0">\r\n',block_name,block_name);
for i=1:n
    fprintf(fileID,'<map key="%s">%s</map>\r\n',var{i},var{i});
end
for i=1:k
    fprintf(fileID,'<map key="%s">%s</map>\r\n',in{i},in{i});
end
fprintf(fileID,'</bind>\r\n');
fprintf(fileID,'</component> \r\n');



%end file
fprintf(fileID,'</sspaceex>');
fclose(fileID);
end

