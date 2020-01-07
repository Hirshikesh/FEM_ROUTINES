% purpose: to generate .vtu file for paraview
% Hirshikesh, Indian Institute of Technology Madras,
%===================================================

clear all
close all
clc

FID = fopen('test.vtu', 'w+');

% import data
% node, element, scalardata, vectordata
filename = 'holecrack_405.mat';
lldata=load(filename);

% options: scalar, vector 
datawriteFormat = 'scalar';

udisp = lldata.udisp;
node = lldata.node;
element = lldata.element;


[np,dim] = size(node);
[nt]=size(element,2);
celltype=[3,5,10];
fprintf(FID,'<?xml version="1.0"?>\n');
fprintf(FID,'<VTKFile type="UnstructuredGrid"  version="0.1"  >\n');
fprintf(FID,'<UnstructuredGrid>\n');
fprintf(FID,'<Piece  NumberOfPoints= "%d" ',np);fprintf(FID,'NumberOfCells= "%d"',nt);fprintf(FID,'>\n');
fprintf(FID,'<Points>\n');
fprintf(FID,'<DataArray  type="Float64"  NumberOfComponents="%d" ',dim+1);
fprintf(FID,'format="ascii"');fprintf(FID,'>');
s='%f %f %f\n';
P=[node zeros(np,3-dim)];
fprintf(FID,s,P'); fprintf(FID,'</DataArray>\n');
fprintf(FID,'</Points>\n');
fprintf(FID,'<Cells>\n');
fprintf(FID,'<DataArray  type="UInt32"  Name="connectivity" ');
fprintf(FID,'format="ascii"');fprintf(FID,'>\n');
off_d = [];loop_i = 1;
for iel = 1:length(element)
    
    econ = element{iel};
    s='%d ';
    for k=1:length(econ)+1
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
fprintf(FID,'%d\n',5*ones(size(element,2),1));
fprintf(FID,'</DataArray>\n');
fprintf(FID,'</Cells>\n');

if( strcmp(datawriteFormat,'scalar') )
    
    fprintf(FID,'<PointData  Scalars="f_9">\n');
    fprintf(FID,'<DataArray  type="Float64"  Name="f9" ');
    fprintf(FID,'format="ascii"');fprintf(FID,'>\n');
    s='%f \t';
    fprintf(FID,s,full(phi));
    fprintf(FID,'</DataArray>\n');
    fprintf(FID,'\n</PointData>\n');
    fprintf(FID,'</Piece>\n');
    fprintf(FID,'</UnstructuredGrid>\n');
    fprintf(FID,'</VTKFile>');
    
else
    
    fprintf(FID,'<PointData  Vectors="f_9">\n');
    fprintf(FID,'<DataArray  type="Float64"  Name="f_9"  NumberOfComponents="%d" ',dim+1);
    fprintf(FID,'format="ascii"');fprintf(FID,'>');
    
    s='%f %f %f\n';
    P=[full(ux) full(uy) zeros(np,3-dim)];
    fprintf(FID,s,P');
    fprintf(FID,'</DataArray>\n');
    fprintf(FID,'\n</PointData>\n');
    fprintf(FID,'</Piece>\n');
    fprintf(FID,'</UnstructuredGrid>\n');
    fprintf(FID,'</VTKFile>');
    
end


fclose(FID);
