function [F_prime] = generateF(priors1, priors2)
A = zeros(length(priors1(1,:)), 9); 
for i = 1: length(A(:,1))
    %priors_set(1 for x or 2 for y, Set Number)
    A(i, 1) = priors1(1,i) * priors2(1,i);
    A(i, 2) = priors2(1,i) * priors1(2,i); 
    A(i, 3) = priors2(1,i);
    A(i, 4) = priors2(2,i) * priors1(1,i); 
    A(i, 5) = priors2(2,i) * priors1(2,i); 
    A(i, 6) = priors2(2,i);
    A(i, 7) = priors1(1,i); 
    A(i, 8) = priors1(2,i); 
    A(i, 9) = 1; %impose 8 DOF
end
    
    %-----solve Af=0 where ||f|| = 1 (i.e. f is the e-vect corresponding to min. e-value)------
%decompose A
[U,S,V] = svd(A);

%identify the minimum singular value of A
[e_A, j_V] = min(S(S>0)); %m = minimum s.v. and j = column of S in which "m" was found

%identify the eigenvector associated with the minimum s.v.; this is f
f = V(:,j_V);

%----impose that F is only rank 2------
%Convert the f vector into a square matrix
%F = (vec2mat(f, 3));
F = [f(1:3)' ; f(4:6)'; f(7:9)'];
%Decompose F
[UF, SF, VF] = svd(F);

%Find minimum s.v. of F
[e_F, j_VF] = min(SF(SF>0));
%impose rank(F)=2
SF_2 = SF;
SF_2(j_VF,j_VF) = 0;

%reconstruct a F that has rank 2 
F_prime = UF*SF_2*VF';
end

