clc;
clear all;
close all;
%% Load images
%Input: [files names]
%Output: [Cell array holding all the images, N number of
%files]
% [images_org,N] = loadFiles(['hotel.seq01.png';'hotel.seq02.png';'hotel.seq03.png';'hotel.seq04.png']);
[images_org,N] = loadFiles(['all'], '.\testImages\*.jpg',1);
if N < 2
   disp('No images found!!!') ;
end

%% Load Camera Intrinsic Matrix
% A = load('nexus6camCal800600.mat'); %cameraCalibrator, transpose the intrinsic matrix!
% cameraParams = A.camParam; 
% A = load('globecamCal.mat');
% cameraParams = A.cameraParams; 
A = load('sonyA77camCalIntrinsic.mat');
cameraParams = A.sonyA77camCalIntrinsic.IntrinsicMatrix';


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

[matched_points_org, matched_points_new] = detectExtractFeatures(images_proc);


%% Find fundamental matrix
% Input: Cell array of matched points for original image, 
%        Cell array of matched points for original imagenew images)
% Output: Cell array holding all F matrices
% Alternative version of computerFarray modified from Jeffery's Homework 2 can
% be found as computeFarray_Jeff() which takes the same input and number of iter. of RANSAC and returns 
% the same output as computeFarray()

% fundMatrix = computeFarray(matched_points_org, matched_points_new); %Kevin's implementation
[fundMatrix,NumOfInliers] = computeFarray_Jeff(matched_points_org, matched_points_new,200); %Jeff's RANSAC Implemenation


%% Condition Matched Points
%% Input: matched points in each scene and the associated fundamental matrix
%% Output: Matched points with only inliers
[matched_points_org_excluded, matched_points_new_excluded] = excludeOutliers(matched_points_org,matched_points_new,fundMatrix);

%% Plot epipolar lines
% epipolar_line_eq = fundMatrix{1}*matched_points_org{1};
% figure()
% imshow(images_proc{1})
% hold on
% graphEpipolarLines(matched_points_org{1},epipolar_line_eq,50);

%% Find r & t for each pair of scenes and R & T of each camera in relation to world frame
% Input: Cell array holding F matrix for pairs of consecutive images
% Output: R and t candidates for each scene
r = cell(4,1);
t = cell(4,1);
for scene = 1:length(fundMatrix)
    if isempty(fundMatrix{scene}) ~= true %only execute if F is not empty
        [r(:,scene), t(:,scene)] = cameraPose(fundMatrix{scene}, cameraParams);
    end
end


%% Triangulation
% for camera frames a and b
% Input: (camera intrinsic, t{a,:}, r{a,:}, t{b,:}, r{b,:}, matched_points_org{a}, matched_points_new{a})
% translation and rotation of two frames. usually t{a,:} and
% r{a,:} are identity matrices; N number of matched points
% Output: 3xN array which holds the 3D coordinates of the matched points
for scene = 1:length(matched_points_org_excluded)
    for pose = 1:4
        r0=eye(3);
        t0=zeros(3,1);
        triangulated_pts{pose,scene} = linear_triangulation(cameraParams, r0,t0,r{pose,scene},t{pose,scene},...
            matched_points_org_excluded{scene}, matched_points_new_excluded{scene});
    end
end

%% Camera Pose Determination/Conditioning
% Input: (r{} candiate, t{} candidate, set of 3D points )
% Output: (R{a}, T{a}) the world rotation and translation
bestIndex =  cameraPoseConditioning(t, r,triangulated_pts);

%% Pick out best R and T
for scene = 1:length(bestIndex)
    r_best{scene} = r{bestIndex(scene),scene};
    t_best{:,scene} = t{bestIndex(scene),scene};
end

%% Rescale t for every scene, with respect to the first scene
t_scaled = scaleTranslation(t_best, r_best, triangulated_pts, matched_points_org_excluded, matched_points_new_excluded,bestIndex);


%% World Pose of each camera
% Input: Vector r and vector t for each scene, starting at Scene 2
% Output: R and T of each camera in relation to the world origin
[R_world, T_world] = cameraWorldPose(r_best,t_scaled); 
temp1 = cell(1);
temp1{1} = eye(3);
R_world = [temp1, R_world];

temp2 = cell(1);
temp2{1} = zeros(3,1);
T_world = [temp2, T_world];

%% Find triangulated points using rescaled t
for scene = 1:length(matched_points_org_excluded)        
    R1 = R_world{scene};
    T1 = T_world{scene}; 
    R2 = R_world{scene+1};
    T2 = T_world{scene+1}; 
    triangulated_pts_scaled{scene} = linear_triangulation(cameraParams, R1,T1,R2,T2,...
        matched_points_org_excluded{scene}, matched_points_new_excluded{scene});
end

%% Pnp nonlinear estimation
pickedcord=cell(1,size(images_org,2));
for i = 1:size(images_org,2)
pickedcord{1,i}=[NaN;NaN;NaN];
end
PMatrix= cell(size(matched_points_org_excluded,2)+1,1);
%P1 = cameraParams*[r0, t0];
for i =1:size(PMatrix,1)
PMatrix{i}=double(cameraParams*[R_world{i} T_world{i}]);
end
NewThreeDPoints = [];
ColorForNewPoints = [];
for i=1:size(matched_points_org_excluded,2)
    for j = 1:size(matched_points_org_excluded{i},2)
        ThreeDInit = triangulated_pts_scaled{i}(:,i);
        TwoDPoints=zeros(3,size(matched_points_org_excluded,2)+1);
        [amnt amntloc]=(ismember(matched_points_org_excluded{i}(:,j)',pickedcord{i}','rows'));
        if(amnt==0)
            ColorForNewPoints = [ColorForNewPoints;getPixelColor(matched_points_org_excluded{i}(1:2,j),images_org{i})];
            pickedcord{i} = [pickedcord{i} matched_points_org_excluded{i}(:,j)];
            TwoDPoints(:,i) = matched_points_org_excluded{i}(:,j);
            oldpoint = matched_points_new_excluded{i}(:,j);
            TwoDPoints(:,i+1) = matched_points_new_excluded{i}(:,j);
            pickedcord{i+1} = [pickedcord{i+1} oldpoint];
            if(~i==size(matched_points_org_excluded,2))
                for k=(i+1):size(matched_points_org_excluded,2)
                    [num,loc] = ismember(oldpoint',matched_points_org_excluded{k}','rows');
                    if(num>0)
                        oldpoint = matched_points_new_excluded{k}(:,loc);
                        TwoDPoints(:,k+1) = matched_points_new_excluded{k}(:,loc);
                        pickedcord{k+1} = [pickedcord{k+1} oldpoint];
                    else
                        break;
                    end
                end
            end
            haspoint = [];
            for k=1:size(TwoDPoints,2)
                if norm(TwoDPoints(:,k))==0
                    haspoint= [haspoint 0];
                else
                    haspoint= [haspoint 1];
                end
            end
            haspoint = double(haspoint);
            TwoDPoints = double(TwoDPoints);

                fun = @(x)haspoint(1)*(TwoDPoints(1,1)-(PMatrix{3}(1,:)*x)/(PMatrix{3}(3,:)*x))^2+haspoint(1)*(TwoDPoints(2,1)-(PMatrix{3}(2,:)*x)/(PMatrix{3}(3,:)*x))^2+...
                haspoint(2)*(TwoDPoints(1,2)-(PMatrix{2}(1,:)*x)/(PMatrix{2}(3,:)*x))^2+haspoint(2)*(TwoDPoints(2,2)-(PMatrix{2}(2,:)*x)/(PMatrix{2}(3,:)*x))^2+...
                haspoint(3)*(TwoDPoints(1,3)-(PMatrix{1}(1,:)*x)/(PMatrix{1}(3,:)*x))^2+haspoint(3)*(TwoDPoints(2,3)-(PMatrix{1}(2,:)*x)/(PMatrix{1}(3,:)*x))^2;
            
            
            
%             fun = @(x)haspoint(1)*(TwoDPoints(1,1)-(PMatrix{4}(1,:)*x)/(PMatrix{4}(3,:)*x))^2+haspoint(1)*(TwoDPoints(2,1)-(PMatrix{4}(2,:)*x)/(PMatrix{4}(3,:)*x))^2+...
%                 haspoint(2)*(TwoDPoints(1,2)-(PMatrix{3}(1,:)*x)/(PMatrix{3}(3,:)*x))^2+haspoint(2)*(TwoDPoints(2,2)-(PMatrix{3}(2,:)*x)/(PMatrix{3}(3,:)*x))^2+...
%                 haspoint(3)*(TwoDPoints(1,3)-(PMatrix{2}(1,:)*x)/(PMatrix{2}(3,:)*x))^2+haspoint(3)*(TwoDPoints(2,3)-(PMatrix{2}(2,:)*x)/(PMatrix{2}(3,:)*x))^2+...
%                 haspoint(4)*(TwoDPoints(1,4)-(PMatrix{1}(1,:)*x)/(PMatrix{1}(3,:)*x))^2+haspoint(4)*(TwoDPoints(2,4)-(PMatrix{1}(2,:)*x)/(PMatrix{1}(3,:)*x))^2;



            NewThreeDPoints = [NewThreeDPoints fminunc(fun,double(ThreeDInit))];
        end
    end
    
end

NewThreeDPoints = [NewThreeDPoints(1,:)./NewThreeDPoints(4,:); NewThreeDPoints(2,:)./NewThreeDPoints(4,:); NewThreeDPoints(3,:)./NewThreeDPoints(4,:); NewThreeDPoints(4,:)./NewThreeDPoints(4,:)];
%%

%% Visualize
visualize(R_world, T_world,r_best,t_best, triangulated_pts_scaled,matched_points_org_excluded,images_org, NewThreeDPoints,ColorForNewPoints)




