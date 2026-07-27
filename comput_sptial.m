function spatial_re = comput_sptial(data)

    [H,W,B] = size(data);
    %% PCA
    d = 10;
    X2d = reshape(data,H*W,B);
    [~, score] = pca(X2d);
    Xpca = reshape(score(:,1:d),H,W,d);
    for i = 1:d
        Xpca(:,:,i) = normalize(Xpca(:,:,i));
    end

    %% 3D FFT
    F = fftn(Xpca);
    A = abs(F);
    P = angle(F);
    
    %% log spectrum
    L = log(A + eps);
    
    %% 3D smoothing
    h = ones(3,3,3)/27;
    Lavg = imfilter(L,h,'replicate');
    
    %% residual
    R = L - Lavg;
    
    %% reconstruction
    F2 = exp(R + 1i*P);
    S3 = abs(ifftn(F2)).^2;
    
    %% collapse spectral dimension
    spatial_re = (normalize(sqrt(sum(abs(S3),3))));
end