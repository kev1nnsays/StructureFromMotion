%World Camera Pose

function[R_world T_world] = cameraWorldPose(r,t)
for camera = 1:size(r,2)
    rotation = [r{camera}, zeros(3,1); 0,0,0,1];
    translation = [eye(3), t{camera}; 0,0,0,1];
    if camera == 1
        RT_current_scene = translation*rotation; 
    else
        RT_current_scene = TR{camera-1}*translation*rotation; 
    end
    TR{camera} = RT_current_scene;
    R_world{camera} =  TR{camera}(1:3,1:3);
    T_world{camera} = TR{camera}(1:3,4);

end