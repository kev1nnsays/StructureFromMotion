%Test
clc;
clear all;
A = load('nexus6camCal.mat');
camParam = A.camParam;
%% Load images
%Input: [files names]
%Output: [Cell array holding all the images, N number of
%files]
% [images_org,N] = loadFiles(['1']);

srcFiles = dir('.\testImages\*.jpg');  % the folder in which ur images exists
images_org = cell(1,length(srcFiles))
for i = 1 : length(srcFiles)
    filename = strcat('.\testImages\',srcFiles(i).name);
    images_org{i} = imread(filename);
   
end

%% Preprocess images
% Input: (Cell array holding original images, outputSize)
% Output: [Cell array holding processed images]
outputSize = [320 NaN]; %define rows, will preserve ratio
images_proc = preprocessImages(images_org, outputSize);

%% Feature detect and match points
%Input: Cell array holding grayscale images
%Output: Cell array holding matched points
%Output format: matched_points_org{i} = matched points for 1st image
%               matched_points_new{i} = matched points for 2nd image
%               each cell holds 3xN array of [x,y,1] pixel locations

     feature_points = cell(1,length(images_proc));
     feature_descriptors = cell(1,length(images_proc));
     valid_points = cell(1,length(images_proc));
     index_pairs = cell(1,length(images_proc)-1);
     matched_points1 = cell(1,length(images_proc)-1);
     matched_points2 = cell(1,length(images_proc)-1);
     workspace;
     
     for i = 1:length(images_proc)
        feature_points{i} = detectSURFFeatures(images_proc{i}); %detectHarrisFeatures, detectSURFFeaterus, detectFASTFeatures
        [feature_descriptors{i}, valid_points{i}] = extractFeatures(images_proc{i}, feature_points{i});
     end
     
     for i = 1:(length(feature_descriptors)-1)
        index_pairs{i} = matchFeatures(feature_descriptors{i}, feature_descriptors{i+1});
     end
     
     for i = 1:length(index_pairs)
         %% Generate matched points in euclidean 2D pixel space
         matched_points1_temp{i} = valid_points{i}(index_pairs{i}(:,1),:)
         matched_points2_temp{i} = valid_points{i+1}(index_pairs{i}(:,2),:)

         
         %% For debugging
         figure()
         showMatchedFeatures(images_proc{i}, images_proc{i+1},...
         matched_points1_temp{i}.Location, matched_points2_temp{i}.Location,...
         'montage')
         
         %% Make the locations homogeneous coordinates; transfer the values
         %from the matched_points_temp objects into another cell array that
         %just holds the pixel location values
         temp = matched_points1_temp{i}.Location;
         temp(:,3)=1;
         matched_points1{i} = temp';
         
         temp = matched_points2_temp{i}.Location;
         temp(:,3)=1;
         matched_points2{i} = temp';
         
         
     end
     
%% Find fundamental matrix
% Input: Cell array of matched points for original image, 
%        Cell array of matched points for original imagenew images)
% Output: Cell array holding all F matrices
fundMatrix = computeFarray(matched_points_org, matched_points_new);

%% Find r & t for each pair of scenes and R & T of each camera in relation to world frame
% Input: Cell array holding F matrix for pairs of consecutive images
% Output: R and t for each scene
for i = 1:length(fundMatrix)
    M = cameraParams;
    e = null(fundMatrix{i}');
    Ex = [0 -1*e(3) e(2);e(3) 0 -1*e(1); -1*e(2) e(1) 0];
    r = inv(M)*Ex*fMatrix{i};
    t = inv(M)*e;
    t = T';
end