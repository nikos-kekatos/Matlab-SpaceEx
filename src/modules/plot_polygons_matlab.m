function varargout=plot_polygons_matlab(fname,option,name_fig,color)
% plot_2d_vertices    Plot a sequence of polygons defined by their
%                     vertices.
%
% plot_2d_vertices(fname)
% Plots the contents of the file "fname", which must be a two-column
% list of vertices separated by empty lines:
%    x11 y11
%    x12 y12
%    ...
%    x1n1 y1n1
%
%    x21 y21
%    x22 y22
%    ...
%    x2n2 y2n2
%
%    ...
%
% Each sequence of vertices defines a polygon. When an empty line is
% encountered, a new polygon is started.
%
% plot_2d_vertices(fname,...)
% Passes "..." as options to the patch command that draws the polygons.
% E.g., to plot in red color:
%    plot_2d_vertices(fname,'r')
%
% H=plot_2d_vertices(...)
% Returns a vector of handles to the patch objects.
% Allows the manipulation of the patches, e.g., to remove the outline:
%    set(H,'LineStyle','none')
%

% it is recommended to save that data as a .mat file, because these 


tic
if nargin==0
    fname = 'cruise_control_0.gen';
    %error('Filename not specified.');
end
if nargin==1
    option=0;
end
if nargin<=3
    color='b';
end

fid=fopen(fname,'rt');
fseek(fid, 0, 'eof');
chunksize = ftell(fid);
fseek(fid, 0, 'bof');
ch = fread(fid, chunksize, '*uchar');
nol = sum(ch == sprintf('\n')); % number of lines
fprintf('The total number of lines in the GEN file is %i. \r\n',nol);
fclose(fid);

fid=fopen(fname,'rt');

count = 0;
jump = 2;

max_x = 20; max_y = 20;

if fid~=-1
    X=zeros(max_x,1);
    Y=zeros(max_y,1);
    %X=[];
    %Y=[];
    
    %H=[];
    figure;
     i=1;
    while ~feof(fid)
        tline = fgetl(fid);
       
        if (~strcmp(tline,'') && ~feof(fid))
            d = sscanf(tline,'%g');
            
            X(i) = d(1);
            Y(i) = d(2);
            i=i+1;
            %X=[X;d(1)];
            %Y=[Y;d(2)];
        else
            if mod(count, jump) == 1
                h=patch(X(1:i-1),Y(1:i-1),color); %drawnow;
            end
            
            X=zeros(max_x,1);
            Y=zeros(max_y,1);
            
            %X=[];
            %Y=[];
            
            %H=[H;h];
            count = count + 1;
            i=1;
        end
    end
end

fclose(fid);
% if nargout>0
%     varargout(1)={H};
% else
%     error('Error: Could not open file.')
% end

fprintf('The total elapsed time is %.4f seconds. \r\n',toc)
% if option.plot
%     if isempty(name_fig)
%         temp_fig=strsplit(fname,'.');
%         name_fig=strcat(temp_fig(1),'_out.fig');
%     end
%     if nol~=0
%         savefig(gcf,char(name_fig));
%     else
%         warning('SpaceEx could produce reachable sets.')
%     end
% end
