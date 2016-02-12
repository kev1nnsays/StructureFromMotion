function [R Q]=rq(A)
% function [R Q]=rq(A)
% A [m x n] with m<=n
% return R [m x n] triangular and
% Q [n x n] unitary (i.e., Q'*Q=I)
% such that A=R*Q
% Author: Bruno Luong
% Last Update: 04/Oct/2008

%Method 2
% [m n]=size(A);
% if m>n
%     error('RQ: Number of rows must be smaller than column');
% end
% 
% [Q R]=qr(flipud(A).');
% R=flipud(R.');
% R(:,1:m)=R(:,m:-1:1);
% Q=Q.';
% Q(1:m,:)=Q(m:-1:1,:);

%Method 3
[Q,R] = qr(A(end:-1:1,end:-1:1)');
Q = Q(end:-1:1,end:-1:1)';
R = R(end:-1:1,end:-1:1)';

if det(Q)<0; R = -R; Q = -Q; end

end
