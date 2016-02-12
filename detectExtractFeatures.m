function [matched_points_org, matched_points_new] = detectExtractFeatures(images_proc)
     
     feature_points = cell(1,length(images_proc));
     feature_descriptors = cell(1,length(images_proc));
     valid_points = cell(1,length(images_proc));
     index_pairs = cell(1,length(images_proc)-1);
     matched_points_org = cell(1,length(images_proc)-1);
     matched_points_new = cell(1,length(images_proc)-1);
     
     %% Go through each image to find interesting features
     for i = 1:length(images_proc)
        feature_points{i} = detectSURFFeatures(images_proc{i},'MetricThreshold',100); %detectHarrisFeatures, detectSURFFeaterus, detectFASTFeatures
%        feature_points{i} = detectHarrisFeatures(images_proc{i},'MinQuality', 0.003);
        %extract descriptors at interesting feature pts: [descriptors, pixel locations of interesting points]
        [feature_descriptors{i}, valid_points{i}] = extractFeatures(images_proc{i}, feature_points{i}); 
     end
     
     % Go and find matching feature points in other images
     % Need to implement search in more than one consecutive image, with a limit of up to (TBD) images 
     for i = 1:(length(feature_descriptors)-1)
        index_pairs{i} = matchFeatures(feature_descriptors{i}, feature_descriptors{i+1});
     end
     
     % For the matched feature points, go back and find them in each
     % picture and make a list called matched_points
     for i = 1:length(index_pairs)
         %% Generate matched points in euclidean 2D pixel space
         matched_points1_temp{i} = valid_points{i}(index_pairs{i}(:,1),:);
         matched_points2_temp{i} = valid_points{i+1}(index_pairs{i}(:,2),:);
         
         %% For debugging
%          figure()
%          showMatchedFeatures(images_proc{i}, images_proc{i+1},...
%          matched_points1_temp{i}.Location, matched_points2_temp{i}.Location,...
%          'montage')
         
         %% Make the locations homogeneous coordinates; transfer the values
         %from the matched_points_temp objects into another cell array that
         %just holds the pixel location values
         temp = matched_points1_temp{i}.Location;
         temp(:,3)=1;
         matched_points_org{i} = temp';
         
         temp = matched_points2_temp{i}.Location;
         temp(:,3)=1;
         matched_points_new{i} = temp';
         
         
     end
     
end

