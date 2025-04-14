function [L, S] = RPCA(M, lambda, tol, max_iter)
    % 输入：
    % M         - 输入矩阵（观测数据）
    % lambda    - 权重参数，通常设为 1 / sqrt(max(size(M)))
    % tol       - 收敛阈值，默认值为 1e-7
    % max_iter  - 最大迭代次数，默认值为 1000

    if nargin < 2
        lambda = 1 / sqrt(max(size(M)));
    end
    if nargin < 3
        tol = 1e-7;
    end
    if nargin < 4
        max_iter = 1000;
    end

    % 初始化
    [m, n] = size(M);
    L = zeros(m, n);
    S = zeros(m, n);
    Y = M / max(norm(M, 2), norm(M(:), inf) / lambda);
    mu = 1.25 / norm(M, 2); % 可以调整的参数
    mu_bar = mu * 1e7;
    rho = 1.5;

    for iter = 1 : max_iter
        % 更新低秩矩阵 L
        [U, sigma, V] = svd(M - S + (1/mu)*Y, 'econ');
        sigma = diag(sigma);
        svp = length(find(sigma > 1/mu));
        if svp >= 1
            sigma = sigma(1:svp) - 1/mu;
        else
            svp = 1;
            sigma = 0;
        end
        L = U(:, 1:svp) * diag(sigma) * V(:, 1:svp)';

        % 更新稀疏矩阵 S
        temp = M - L + (1/mu)*Y;
        S = sign(temp) .* max(abs(temp) - lambda/mu, 0);

        % 更新拉格朗日乘子 Y
        Z = M - L - S;
        Y = Y + mu * Z;

        % 检查收敛
        if norm(Z, 'fro') / norm(M, 'fro') < tol
            break;
        end

        mu = min(mu * rho, mu_bar);
    end
end
