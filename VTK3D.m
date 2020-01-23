clear all
close all
clc

data = load('data_disp.mat');

% strain = data.tt;
node = data.gpp;
element = delaunayTriangulation(node(:,1),node(:,2),node(:,3));
u = data.tt;
fs = ['stress', num2str(64), '.vtu'];
FID = fopen(fs, 'w+');
[np,dim] = size(node);
[nt]=size(element,1);
fprintf(FID,'<?xml version="1.0"?>\n');
fprintf(FID,'<VTKFile type="UnstructuredGrid"  version="0.1"  >\n');
fprintf(FID,'<UnstructuredGrid>\n');
fprintf(FID,'<Piece  NumberOfPoints= "%d" ',np);fprintf(FID,'NumberOfCells= "%d"',nt);fprintf(FID,'>\n');
fprintf(FID,'<Points>\n');
fprintf(FID,'<DataArray  type="Float64"  NumberOfComponents="%d" ',dim);
fprintf(FID,'format="ascii"');fprintf(FID,'>');
s='%f %f %f\n';
P=[node zeros(np,3-dim)];
fprintf(FID,s,P'); fprintf(FID,'</DataArray>\n');
fprintf(FID,'</Points>\n');
fprintf(FID,'<Cells>\n');
fprintf(FID,'<DataArray  type="UInt32"  Name="connectivity" ');
fprintf(FID,'format="ascii"');fprintf(FID,'>\n');
off_d = [];loop_i = 1;
for iel = 1:size(element,1)
    
    econ = element(iel,:);
    s=' ';
    for k=1:length(econ)
        s=horzcat(s,{' %d'});
    end
    s=cell2mat(horzcat(s,{' \n'}));
    %     fprintf(FID,s,[(length(econ)) econ-1]');
    fprintf(FID,s,[econ-1]');
    off_d = [off_d loop_i+length(econ)-1];
    loop_i = loop_i+ length(econ);
end
fprintf(FID,'</DataArray>\n');
fprintf(FID,'<DataArray  type="UInt32"  Name="offsets" ');
fprintf(FID,'format="ascii"');fprintf(FID,'>');
fprintf(FID,'%d \t',off_d);fprintf(FID,'</DataArray>\n');
fprintf(FID,'<DataArray  type="UInt8"  Name="types" ');
fprintf(FID,'format="ascii"');fprintf(FID,'>');
fprintf(FID,'%d\n',10*ones(size(element,1),1));
fprintf(FID,'</DataArray>\n');
fprintf(FID,'</Cells>\n');
fprintf(FID,'<PointData  Scalars="f_9">\n');
fprintf(FID,'<DataArray  type="Float64"  Name="u" ');
fprintf(FID,'format="ascii"');fprintf(FID,'>\n');
s='%f \t';
fprintf(FID,s,u);
fprintf(FID,'</DataArray>\n');
fprintf(FID,'\n</PointData>\n');
fprintf(FID,'</Piece>\n');
fprintf(FID,'</UnstructuredGrid>\n');
fprintf(FID,'</VTKFile>');
fclose(FID);