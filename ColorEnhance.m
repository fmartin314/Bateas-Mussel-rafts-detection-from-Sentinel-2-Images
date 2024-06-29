function ImOUT = ColorEnhance(ImIN)
%
% Pues eso... mejorar el color.
%
nbits = 12; % Numero de bits de entrada, si nos pasamos no importa
if (~ismatrix(ImIN))
    % Pasar a grises
    ImGray = rgb2gray(ImIN);
else
    % Ya era gris
    ImGray = ImIN;
end
h = imhist(ImGray,2^nbits); 
hnorm = h/sum(h); % Histograma
cola = 0.01; % Cola a eliminar
%
% Detectar limites.
%
suma = 0;
for l=1:length(hnorm)
    suma = suma + hnorm(l);
    if (suma>=cola)
        begin = l;
        break;
    end
end
suma = 0;
for l=length(hnorm):-1:1
    suma = suma + hnorm(l);
    if (suma>=cola)
        ending = l;
        break;
    end
end
%
% Normalizar.
%
negro = begin/length(hnorm);
blanco = ending/length(hnorm);
ImOUT = (ImIN-negro)/(blanco-negro);
%
% Corregir.
%
ImOUT(ImOUT(:)<0)=0;
ImOUT(ImOUT(:)>1)=1;
