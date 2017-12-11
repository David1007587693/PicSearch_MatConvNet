function [X] = normalize1(X)
% X:n*d

for i=1:size(X,1)%从1到行数X
    if(norm(X(i,:))==0)%判断第i行作为向量时的二范数是否为0
        
    else
        X(i,:) = X(i,:)./norm(X(i,:));%X的第I行点除其二范数
    end
end