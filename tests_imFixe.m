clear all; close all;


RGB = imread('balle.jpg');

% Dimensions
M=size(RGB,1); % 960
N=size(RGB,2); % 720
P=size(RGB,3); % 3


%% Affichage R G B
figure;
R=RGB(:,:,1);G=RGB(:,:,2);B=RGB(:,:,3);
subplot(131); imshow(R); title('Red');
subplot(132); imshow(G); title('Green');
subplot(133); imshow(B); title('Blue');


%% Blue -> B&W and remove noise
figure;
threshold = graythresh(B);
bw = im2bw(imcomplement(B),threshold);
subplot(131); imshow(bw);

% remove all object containing fewer than 3000 pixels
bw = bwareaopen(bw,3000);
subplot(132); imshow(bw);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw = imfill(bw,'holes');
subplot(133); imshow(bw);


%% Draw boundary
figure;
[Bo,L] = bwboundaries(bw,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(Bo)
    boundary = Bo{k};
    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

stats = regionprops(L,'Area','Centroid');

% loop over the boundaries
for k = 1:length(Bo)
    
    % obtain (X,Y) boundary coordinates corresponding to label 'k'
    boundary = Bo{k};
    
    % Mark the center
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');
end



