%% Tracking coloured ball in a video
%
% Authors :
% - Adrian GRÖGER
% - Alexandre JOLY
% - Antoine BARBOSA
% - Elric GRANDJEAN
%
% Released on : 29/01/2022



%% Lecture de la vidéo

clearvars -except datas; close all;
vid=VideoReader('balle_2D.mp4');
N=vid.NumberOfFrames;


%% Traitement de la vidéo
% A la première execution, cette étape est obligatoire.
% Par contre, comme la variable 'datas' n'est pas supprimée au lancement
% du script, le traitement de la vidéo ne sera pas refait (tant que 'datas'
% n'est pas supprimée).

first   = 80;           % First frame to process
last    = 440;          % Last frame to process

if ~exist('datas', 'var')
    datas=zeros(N,3);
    
    wb = waitbar(0,'');        % Bar de chargement
    for i=first:last
        waitbar(i/N,wb,...
            sprintf('Processing video, please wait... (%d/%d)',i,last));
        
        frame=read(vid,i);     % Extraction d'une image
        
        data=searchBall(frame);% Traitement de l'image (recherche de balle)
        
        % Si la balle a été trouvée, on enregistre sa position et taille
        if data.found
            datas(i,:)=[data.center,data.radii];
        end
    end
    close(wb);
end


%% Résultat vidéo

figure(1);clf(1);
frame=read(vid,1); hImage=imshow(frame);
pos=zeros(1,4);
contour=rectangle('Position',pos,'Curvature',[1 1],'LineWidth',3);

for i=first:last
    
    % Affichage de la vidéo
    frame = read(vid,i);
    set(hImage,'CData',frame);
    
    % Indique si la balle est visible ou non
    if datas(i,3)>0
        title(sprintf('Balle trouvée (%d/%d)',i,last))
    else
        title(sprintf('Balle non trouvée (%d/%d)',i,last))
    end
    
    % Récupération des données calculées précédemment
    center=datas(i,1:2);
    radii=datas(i,3);
    pos = [center(1)-radii center(2)-radii 2*radii 2*radii]; 
    
    % Affichage du contour et centre de la balle
    set(contour,'Position',pos);
    hold on;centre=plot(center(1),center(2),'r+');
    
    drawnow
end


%% Affichage des courbes de positions et vitesses
% 100 px ~   4 cm
%   1 px ~ 4e-4 m
% Framerate = 60 f/s

ss=get(0,'ScreenSize');
figure('Position',[0.1*ss(3) 0.2*ss(4) 0.8*ss(3) 0.6*ss(4)]);
subplot(121);axis equal;axis([0 1920 0 1080]);hold on
title('Trajectoire de la balle')

V=[];Vok=0;
for i=first:last
    if datas(i,3)>0
        
        % Affichage de la trajectoire
        X = datas(i,1);
        Y = -datas(i,2)+1080;
        plot(X, Y, 'r.')
        
        % Calcul des vitesses (m/s)
        if Vok
            V = [V; i, sqrt((X-X_)^2+(Y-Y_)^2) * 4e-4 * 60];
        end
        Vok=1;
        
        X_=X;Y_=Y;
    end
end

% Courbe de vitesse
subplot(122);hold on;
title('Vitesse');xlabel('frame n°');ylabel('m/s');
plot(V(:,1),V(:,2))


