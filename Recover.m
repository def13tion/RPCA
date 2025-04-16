function recover = Recover(reshaped,dw,dh,x_step,y_step,m,n)
AA = zeros(m, n, 100);
temp = zeros(dh, dw);
index = 0;
C = zeros(m, n);
recover = zeros(m,n);
for i = [1:y_step:m-dh+1,m-dh+1]
    for j = [1:x_step:n-dw+1,n-dw+1]
        index = 1+index;
        temp(:) = reshaped(:, index);
        C(i:i+dh-1, j:j+dw-1) = C(i:i+dh-1, j:j+dw-1)+1;
        for ii = i:i+dh-1
            for jj = j:j+dw-1
                AA(ii,jj, C(ii,jj)) = temp(ii-i+1, jj-j+1);
            end
        end
    end
end
%     C(find(C==0)) = 1000;
for i=1:m
    for j=1:n
        if C(i,j) > 0
            recover(i,j) = max(AA(i,j,1:C(i,j)));
        end
    end
end