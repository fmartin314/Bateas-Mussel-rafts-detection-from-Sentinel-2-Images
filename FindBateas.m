function [rgborig,finalmtg] = FindBateas(imgdir,Fres)
% 
% Parametros
th = 0.80;
cradius = 2;
maxarea = 25;
maxdiam = 6;
minsld = 0.75;
%
% Hallar el nombre base
idx = find(imgdir=='\',1,'last');
if (isempty(idx))
    basename = imgdir;
else
    basename = imgdir(idx+1:end);
end
% Bandas a eliminar
EraseB = ErasedBands(); 
%
% Crear vectores.
[FVmatrix,xsize,ysize] = CreateFVex_c(imgdir,Fres,EraseB); % Crear vectores
% Detectar agua
ImAux = VerIndice([imgdir '/' basename],8,3,true);
ImAux(ImAux<0) = 0;
maskw = imbinarize(ImAux);
ee = strel('disk',cradius); % Disco de 50 m
maskw = imclose(maskw,ee); % Cerrar huecos
maskw = imopen(maskw,ee); % Cerrar huecos
maskw = imerode(maskw,ee); % Limar los bordes
%
% Segunda fase ==> bateas
y = MLPbateasSB60m01(double(FVmatrix)); % NN
% Crear mascara
imout2 = reshape(y,[ysize, xsize]);
maskb = (imout2>th);
%
% Filtrado
[label,num] = bwlabel(maskb);
props = regionprops(label,'All');
maskb2 = false(size(maskb));
for i=1:num
    % Condiciones
    if (props(i).Area>maxarea)
        continue;
    end
    if (props(i).EulerNumber~=1)
        continue;
    end
    if (props(i).EquivDiameter>maxdiam)
        continue;
    end
    if (props(i).Solidity<minsld)
        continue;
    end
    % Paso el filtro
    maskb2 = maskb2 | (label==i);
end
%
% Fusion
maskb = maskb2.*maskw;
%
% Composicion
aux1 = dir([imgdir '\*.jp2']);
aux2 = aux1(1).name;
idx2 = find(aux2=='B',1,'last');
bname = [imgdir '\' aux2(1:idx2-2)];
% Imagen RGB
namered = [bname sprintf('_B%02d.jp2',4)]; 
namegreen = [bname sprintf('_B%02d.jp2',3)]; 
nameblue = [bname sprintf('_B%02d.jp2',2)]; % Nombres
rgborig(:,:,1) = imresize(im2double(imread(namered)),[ysize xsize]);
rgborig(:,:,2) = imresize(im2double(imread(namegreen)),[ysize xsize]);
rgborig(:,:,3) = imresize(im2double(imread(nameblue)),[ysize xsize]); % Imagen RGB
rgborig = ColorEnhance(rgborig); % Mejorar color
% Sumar imagenes
r0=1;g0=1;b0=0; % Amarillo
alfa = 1.00; % Transparencia de la capa de deteccion
outrgb(:,:,1) = r0*maskb;
outrgb(:,:,2) = g0*maskb;
outrgb(:,:,3) = b0*maskb; % Salida NN en RGB (coloreada)
finalmtg = rgborig+alfa*outrgb; 
finalmtg(finalmtg>1)=1;
finalmtg(finalmtg<0)=0; % Imagen compuesta
% Grabar
imwrite(finalmtg,'result.jpg');
