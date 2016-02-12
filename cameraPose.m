%Using a fMatrix find R and T

function [r_candidates, t_candidates] = cameraPose(fundMatrix, cameraParams)

%Kevin's implementation using essential matrix following 2008-SFM-Chapters
%pg 12 and the Upenn paper
K = cameraParams;
essentialMatrix = transpose(K) * fundMatrix * K;
%Correct the noise in the essential matrix
[U,S,V]  = svd(essentialMatrix);
S(3,3) = 0; 
essentialMatrixFiltered = U*S*V';
[U,S,V] = svd(essentialMatrixFiltered);

%figure out the combinations of r and t
W = [0,-1,0;
     1,0,0;
     0,0,1]; %180 degree rotation matrix about x-axis of ref camera

t{1,1} = U(:,3); r{1,1} = U*W*transpose(V);
t{2,1} = -U(:,3); r{2,1} = U*W*transpose(V);
t{3,1} = U(:,3); r{3,1} = U*transpose(W)*transpose(V);
t{4,1} = -U(:,3); r{4,1} = U*transpose(W)*transpose(V);

%Check that all rotations have a determinant of 1
for i = 1:4
    if det(r{i,1})<0
        r{i,1}=-r{i,1};
%         t{i,1}=-t{i,1};
    end
end

%return the candidates for r and t
r_candidates = r;
t_candidates = t;

end

%% Old stuff
% K = cameraParams;
% e = null(fundMatrix');
% Ex = [0 -1*e(3) e(2);e(3) 0 -1*e(1); -1*e(2) e(1) 0];
% r = inv(K)*Ex*fundMatrix;
% t = inv(K)*e;


% %Kevin's implementation using fundamental matrix
% e = null(fundMatrix'); 
% Ex = [0 -1*e(3) e(2);e(3) 0 -1*e(1); -1*e(2) e(1) 0];
% P2 = [-Ex*fundMatrix', e];
% [K, r] = rq(P2(1:3,1:3)); %need to fix this so we get back a set of M,R then decide which M is the best
% t = inv(K)*e;


