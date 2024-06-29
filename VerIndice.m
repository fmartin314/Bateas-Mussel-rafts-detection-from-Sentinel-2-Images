function IdxOut = VerIndice(bname,num1,num2,upsample)
name1 = [bname sprintf('_B%02d.jp2',num1)]; % Nombre 1
name2 = [bname sprintf('_B%02d.jp2',num2)]; % Nombre 2
im1 = im2double(imread(name1));
im2 = im2double(imread(name2)); % Leer
[m1,n1] = size(im1);
[m2,n2] = size(im2); % Tamanhos
if (upsample)
    % Elegir los mayores
    mf = max([m1 m2]);
    nf = max([n1 n2]);
else
    % Elegir los menores
    mf = min([m1 m2]);
    nf = min([n1 n2]);
end
%
% Reescalado
%
im1 = imresize(im1,[mf, nf]);
im2 = imresize(im2,[mf nf]);
%
% Indice
%
IdxOut = (im2-im1)./(im1+im2+eps); % Indice
