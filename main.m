% 生成一个示例矩阵 M
% M = (0:0.1:9.9)'*(0:0.1:9.9);
% M(1:25:100, 1:25:100) = M(1:25:100, 1:25:100)+10; % 添加稀疏噪声
% N = randn(100,100)*0.5;
% M = M + N;
% M1 = denoise(M,10,3,5,5,false);%舍弃这个降噪方案
clear all;close all;
dirlist = ["1","2","3","4","5"];
N = length(dirlist);
for i = 1:5
    fprintf("Now Processing... %d/%d\n",i,N);
    M = imread("PRCA\"+dirlist(i)+".jpg");
    M = double(M);
    [m,n]=size(M);
    dw = 60;dh=60;x_step=10;y_step=10;
    
    M1 = GetPatch(M,dw,dh,x_step,y_step);
    lamda = 1/sqrt(max(m,n));
    [L0, S0] = RPCA(M1,lamda);
    L = Recover(L0,dw,dh,x_step,y_step,m,n);
    S = Recover(S0,dw,dh,x_step,y_step,m,n);
    % 可视化结果
    subplot(4,N,i); M = mat2gray(M); imshow(M);title(sprintf("Index = %d",i));
    if i == 1
        ylabel('原始图像 M == B + T');
    end
    subplot(4,N,N + i); L = (mat2gray(L)); imshow(L); 
    if i == 1
        ylabel('背景图像 Background');
    end
    subplot(4,N,2*N + i); S = (mat2gray(S)); imshow(S);
    if i == 1
        ylabel('目标图像 Target');
    end
    subplot(4,N,3*N + i);
    [rows, cols] = size(S);
    [X, Y] = meshgrid(1:cols, 1:rows);
    surf(X, Y, S, 'EdgeColor', 'none');
    if i == 1
        ylabel('目标曲面 Target');
    end
end
