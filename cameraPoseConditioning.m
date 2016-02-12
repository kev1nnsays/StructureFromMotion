function [bestIndex]= cameraPoseConditioning(t, r,triangulated_pts) %pass back array of good indexes

cam1NegCounter = [0;0;0;0]; 
cam2NegCounter = [0;0;0;0];

for scene = 1:size(triangulated_pts,2)
    for pose = 1:4
        for triangulatedpt = 1:size(triangulated_pts{pose},2)
            % Check my points at camera 1
            if triangulated_pts{pose,scene}(3,triangulatedpt) > 0;
                cam1NegCounter(pose) = cam1NegCounter(pose)+1;
            end
            % Check my points at camera 2
            temp_triangle_2 = [r{pose,scene}, t{pose,scene}; 0,0,0,1]*triangulated_pts{pose,scene}(:,triangulatedpt);
            if temp_triangle_2(3) > 0
                cam2NegCounter(pose) = cam2NegCounter(pose)+1;
            end
        end
    end
    
    [~, index] = max(cam1NegCounter + cam2NegCounter);
    bestIndex(scene) = index;
    cam1NegCounter = [0;0;0;0]; 
    cam2NegCounter = [0;0;0;0];
end


end