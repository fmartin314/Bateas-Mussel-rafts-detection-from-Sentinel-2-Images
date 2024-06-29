function [FVmatrix,xsize,ysize] = CreateFVex_c(imgdir,Fres,EraseB)
%
% Crear vectores de caracteristicas.
%
aux1 = dir([imgdir '\*.jp2']);
aux2 = aux1(1).name;
idx2 = find(aux2=='B',1,'last');
bname = [imgdir '\' aux2(1:idx2-2)];
% Inicio
Nbands = NTotalBands(); 
% Calcular resolucion
name = [bname sprintf('_B%02d.jp2',Fres)]; % Nombre fichero
info = imfinfo(name);
xsize = info.Width;
ysize = info.Height;
%
% Obtener matrices.
%
FVmatrix = zeros(Nbands-length(EraseB),xsize*ysize);
%
% Ir obteniendo "filas".
%
k=1;
for i=1:Nbands
    if (sum(EraseB==i)>0)
       % Banda eliminada
       continue;
    end
    name = [bname sprintf('_B%02d.jp2',i)]; % Nombre fichero
    imaux1 = imread(name); % Leer
    if (size(imaux1,1)~=ysize)
        % Ajustar tamanho
        imaux2 = imresize(imaux1,[ysize xsize],'Lanczos3');
    else
        % No need
        imaux2 = imaux1;
    end
    % Guardar k-ésima banda (fila)
    FVmatrix(k,:) = (imaux2(:))';
    k = k+1;
end
