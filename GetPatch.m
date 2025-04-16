function reshaped = GetPatch(ori,dw,dh,x_step,y_step)
[m, n] = size(ori);

I1 = ori;
reshaped = [];
for i = [1:y_step:m-dh+1,m-dh+1]
    for j = [1:x_step:n-dw+1,n-dw+1]
        temp = I1(i:i+dh-1, j:j+dw-1);
        reshaped = [reshaped, temp(:)];
    end
end
end