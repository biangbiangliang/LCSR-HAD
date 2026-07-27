clc 
clear 
% close all

%% data loading and normalize
[file, path] = uigetfile(['E:\224601048document\paper\HSI2\data' '\*.mat']);
load([path file])
raw_data = data;
tic()
X = raw_data;
[H,W,B] = size(X);

%% local spectral contrast computation
scales = [2 3 4 5];
R = zeros(H,W,length(scales));
for s = 1:length(scales)
    R(:,:,s) = carc_single_scale(data,scales(s));
end
A = normalize(max(R,[],3));

%% 3d frenquence residuals salience computation
weight = comput_sptial(raw_data);

%% nonlinear fusion
A1 = (normalize(A)).^(1-normalize(weight));
toc()
imshow(A1, []);colormap("parula")
