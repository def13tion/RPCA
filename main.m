% 生成一个示例矩阵 M
M = (0:0.1:9.9)'*(0:0.1:9.9);
M(1:25:100, 1:25:100) = M(1:25:100, 1:25:100)+10; % 添加稀疏噪声
N = randn(100,100)*0.5;
M = M + N;
M1 = denoise(M,10,3,5,5,false);%舍弃这个降噪方案
sigma = 0.5; % 标准差
kernelSize = 5; % 滤波器核大小

% 创建高斯滤波器
h = fspecial('gaussian', [kernelSize, kernelSize], sigma);

% 应用高斯滤波器
M2 = imfilter(M, h, 'replicate');%高斯滤波结果
[L, S] = RPCA(M2);

% 可视化结果
figure;
subplot(2,2,1); imagesc(M); title('原始矩阵 M == L + S'); colorbar;
subplot(2,2,2); imagesc(M2);title('(gauss)去噪矩阵 M'); colorbar;
subplot(2,2,3); imagesc(L); title('低秩矩阵 L == Background'); colorbar;
subplot(2,2,4); imagesc(S); title('稀疏矩阵 S == Target'); colorbar;
figure;
[rows, cols] = size(S);

% 创建网格坐标
[X, Y] = meshgrid(1:cols, 1:rows);
surf(X, Y, S, 'EdgeColor', 'none');title('稀疏矩阵 S == Target');
