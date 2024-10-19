%   Date:       201412
%   Author:     应凌楷@CJLU
%   Citation:   应凌楷, 李子印, 张聪聪. 融合梯度信息与HVS滤波器的无参考清晰度评价[J]. 中国图象图形学报, 2015, 20(11):1446-1452.
%   Description 清晰度评价算法，当时性能最好的算法（含 Accurance 和 TimeCost），MATLAB运行时几十ms，移植到C估计30ms以内吧。
%               One Method of Sharpness Assessment, having the best performance of accurance and timecost at that time, 
%               runs on MATLAB for tens of ms while being transplanted to C code, it's within 30ms.
function [ Sharpness ] = GI_F( rgbimg )
  MMDMap        = GIF_MMD   ( double(rgb2gray(rgbimg)) );
  Sharpness     = GIF_POOL  ( MMDMap(:),MMDMap(:));
end
function [ MMDMap ] = GIF_MMD( graydouble )
  pad_len = 8;
  [num_rows, num_cols]  = size(graydouble);
  resmean = zeros(num_rows, num_cols);
  resmax  = zeros(num_rows, num_cols);
  shifts  = [ 0 1;0 -1 ; 1 1;1 0;1 -1; -1 1 ;-1 0 ;-1 -1];
  for itr_shift = 1:size(shifts,1)
          ShiftImg  = circshift(graydouble,shifts(itr_shift,:));    
          resmax    = max(resmax,abs(ShiftImg-graydouble)/255);
          resmean   = resmean+abs(ShiftImg-graydouble)/255;
  end
  resmax    = resmax(pad_len + 1 : end-pad_len, pad_len + 1 : end-pad_len);
  resmean   = resmean(pad_len + 1 : end-pad_len, pad_len + 1 : end-pad_len)/size(shifts,1);
  MMDMap    = resmax-resmean;
end
function [ poolingvalue ] = GIF_POOL(weightSrc,SigmaIndex)
  alpha=1;
  sigma=0.1;
  beta          = sigma*sqrt(gamma(1/alpha)/gamma(3/alpha));
  weight        = alpha/2/beta/gamma(1/alpha)*exp(-(abs(weightSrc./max(weightSrc(:))-1)/beta).^alpha);    
  weight        = weight./sum(weight(:));
  poolingvalue  = SigmaIndex.*weight;
  poolingvalue  = sum(poolingvalue(:));
end
