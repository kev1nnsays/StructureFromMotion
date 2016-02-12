function [t_scaled] = scaleTranslation(t_best, r_best, triangulated_pts, matched_points_org_excluded, matched_points_new_excluded,bestIndex)

%% Scene 1 matched points find them in scene 2
% for picture #2 look at the matched points from scene 1
    %for each pixel
        %apply a tolerance to that pixel and look for it in the matched
        %points list for picture #2 from scene 2

t_scaled{1} = t_best{1};
for scene = 2:size(matched_points_org_excluded,2)
    list_old = matched_points_new_excluded{scene-1}; %ref scene
    list_new = matched_points_org_excluded{scene}; %new scene
    
    tol = 2; 
    indexMatchesOrg = [];
    indexMatchesNew = [];
%     figure();
%     imshow(images_org{scene});
%     hold on
    for pixel_list_org = 1:size(list_old,2)
        for pixel_list_new = 1:size(list_new,2) %search for matches
            distance = norm(list_old(:,pixel_list_org)-list_new(:,pixel_list_new));
            if distance < tol && triangulated_pts{bestIndex(scene),scene}(3,pixel_list_org)>0
                distance;
                indexMatchesOrg = [indexMatchesOrg pixel_list_org]; 
                indexMatchesNew = [indexMatchesNew pixel_list_new]; 
            end
        end
    end
    
    %find scale value k

    triangulatedPointsOrg = triangulated_pts{bestIndex(scene-1),scene-1}(:,indexMatchesOrg);
    triangulatedPointsNew = triangulated_pts{bestIndex(scene),scene}(:,indexMatchesNew);
    
    t = t_scaled{scene-1};

    triangulatedPointsNew_rt = [r_best{scene-1}, t;0 0 0 1]*triangulatedPointsNew;
    dismin = -1;
    t_scaled_new_best = 0;
    for i =1:size(triangulatedPointsNew_rt,2)
        %%
    %     normingFactor = norm(triangulatedPointsOrg);
    %     triangulatedPointsOrg1 = triangulatedPointsOrg./normingFactor;
    %     triangulatedPointsNew_rt1 = triangulatedPointsNew_rt./normingFactor;
        triangulatedPointsOrg1 = triangulatedPointsOrg(:,i);
        triangulatedPointsNew_rt1 = triangulatedPointsNew_rt(:,i);
        %%

    %     numel(triangulatedPointsNew_rt)
    %     numel(triangulatedPointsOrg)
        A = reshape(triangulatedPointsNew_rt1, numel(triangulatedPointsNew_rt1),1);
    %     size(A)
        B = reshape(triangulatedPointsOrg1, numel(triangulatedPointsOrg1),1);
    %     size(B)
    
    %% Method 1 Fitting
%         t_scaled_new = (A\B);
%         t_scaled_new_best = t_scaled_new;
    
    %% Method 2 Fitting
        t_scaled_new = (A'*A)^-1*(B'*B);
        if norm(A*t_scaled_new-B)< dismin | dismin==-1
            dismin = norm(A*t_scaled_new-B);
            t_scaled_new_best = t_scaled_new;
        end
        
    end
%     t_scaled{scene}= t_scaled_new*t_best{scene}; 
    t_scaled{scene}= t_scaled_new_best*t_best{scene};
    
    triangulatedPtsNew_rtscaled = t_scaled_new_best*triangulatedPointsNew_rt;

    %% DEBUGGING
%     figure()
% %     subplot(1,2,1)
%     scatter3(triangulatedPointsOrg(3,:), -triangulatedPointsOrg(1,:),-triangulatedPointsOrg(2,:), 'ob')   
%     hold on 
%     scatter3(triangulatedPointsOrg(3,1), -triangulatedPointsOrg(1,1),-triangulatedPointsOrg(2,1), 'xb')   
%     xlabel('X')
%     ylabel('Y')
%     zlabel('Z')
% %     subplot(1,2,2)
%     scatter3(triangulatedPtsNew_rtscaled(3,:), -triangulatedPtsNew_rtscaled(1,:),-triangulatedPtsNew_rtscaled(2,:), 'or')
%     hold on
%     scatter3(triangulatedPtsNew_rtscaled(3,1), -triangulatedPtsNew_rtscaled(1,1),-triangulatedPtsNew_rtscaled(2,1), 'xr')
% xlabel('X')
%     ylabel('Y')
%     zlabel('Z')

    
    
%% Weird stuff
% figure()
%     imshow(images_proc{scene})
%     hold on
%     plot(list_old(1,indexMatchesOrg),list_old(2,indexMatchesOrg), 'xr')
%     
%     plot(list_new(1,indexMatchesNew),list_new(2,indexMatchesNew), 'ob')
    
    
    
end


    

end