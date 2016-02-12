function [F_array] = computeFarray(matched_pts_org, matched_pts_new)
    F_array = cell(1, length(matched_pts_org));
    for i = 1:length(matched_pts_org)
        %normalize matched points for the current scene
        priors1 = matched_pts_org{i};
        priors2 = matched_pts_new{i};
        if length(priors1(1,:)) >= 8 
         [T, T_prime] = calcNormTrans(priors1, priors2);
         
%         %compute fundamental matrix for the current scene using
%         normalization
         priors1_norm = T * priors1;
         priors2_norm = T_prime * priors2;

        %Uncomment if we want NO NORMALIZATION TO DATA
%          priors1_norm = priors1;
%          priors2_norm = priors2;

         F_norm = generateF(priors1_norm, priors2_norm);
         F_array{i} = T' * F_norm * T_prime; 
%          F_array{i} = F_norm; 
        
        end
    end
        
end