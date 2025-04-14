function denoised = denoise(noisy, t, f, h1, h2, selfsim)
    % 参数说明：
    % noisy   - 含噪声的输入图像（灰度图，归一化到 [0,1]）
    % t       - 搜索窗口半径
    % f       - 相似窗口半径
    % h1, h2  - 控制相似度权重的参数
    % selfsim - 是否包含自身相似性（布尔值）

    [rows, cols] = size(noisy);
    padded = padarray(noisy, [f f], 'symmetric');
    denoised = zeros(rows, cols);

    for i = 1:rows
        for j = 1:cols
            i1 = i + f;
            j1 = j + f;
            patch1 = padded(i1 - f:i1 + f, j1 - f:j1 + f);
            wmax = 0;
            average = 0;
            sweight = 0;

            rmin = max(i1 - t, f + 1);
            rmax = min(i1 + t, rows + f);
            smin = max(j1 - t, f + 1);
            smax = min(j1 + t, cols + f);

            for r = rmin:rmax
                for s = smin:smax
                    if r == i1 && s == j1 && ~selfsim
                        continue;
                    end
                    patch2 = padded(r - f:r + f, s - f:s + f);
                    d = sum((patch1 - patch2).^2, 'all');
                    w = exp(-d / (h1^2));
                    sweight = sweight + w;
                    average = average + w * padded(r, s);
                    if w > wmax
                        wmax = w;
                    end
                end
            end

            denoised(i, j) = (average + wmax * padded(i1, j1)) / (sweight + wmax);
        end
    end
end
