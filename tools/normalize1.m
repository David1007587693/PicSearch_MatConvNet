function [X] = normalize1(X)
% X:n*d

for i=1:size(X,1)%��1������X
    if(norm(X(i,:))==0)%�жϵ�i����Ϊ����ʱ�Ķ������Ƿ�Ϊ0
        
    else
        X(i,:) = X(i,:)./norm(X(i,:));%X�ĵ�I�е���������
    end
end