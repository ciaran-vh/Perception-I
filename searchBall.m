function [dataOut] = searchBall(I)
dataOut.found=0;
dataOut.center=[];
dataOut.radii=[];

K = 2; %Coeff pour augmenter l'intensité de l'image

% Filtre que le bleu de l'image (balle orange -> peu de bleu dans l'orange)
B=K*I(:,:,3);

% Converti l'image en nuance de gris vers B&W
bw = B<100;

% Supprime les objets plus petit que la taille de la balle (6000~8000px)
bw = bwareaopen(bw,5000);

% Complète les espaces
bw = imfill(bw,'holes');

% Cherche les objets dans l'image
stats = regionprops('table',bw,'Centroid',...
    'MajorAxisLength','MinorAxisLength');


rang=0;
switch size(stats, 1)
    case 0 % Aucun objet trouvé
        
    case 1 % 1 objet trouvé
        
        % Si la dimension de l'objet trouvé est...
        if stats.MajorAxisLength<130 && stats.MinorAxisLength>80
            % ... alors : Balle trouvée
            rang=1;
        end
        
    otherwise % Plusieurs objets trouvés
        
        % Recherche de la balle parmis ces objets...
        for i=1:size(stats, 1)
            if stats.MajorAxisLength(i)<130 && stats.MinorAxisLength(i)>80
                % Balle trouvée
                rang=i; break
            end
        end
end


% Si elle a été trouvée, on renvoie sa position
if rang
    dataOut.found = 1; % 1 -> Balle trouvée
    dataOut.center= stats.Centroid(rang,:);
    dataOut.radii = (stats.MajorAxisLength(rang)+...
                     stats.MinorAxisLength(rang))/4;
end


end






