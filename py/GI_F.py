#   Date:       201412
#   Author:     应凌楷@CJLU
#   Citation:   应凌楷, 李子印, 张聪聪. 融合梯度信息与HVS滤波器的无参考清晰度评价[J]. 中国图象图形学报, 2015, 20(11):1446-1452.
#   Description 清晰度评价算法，当时性能最好的算法（含 Accurance 和 TimeCost），MATLAB运行时几十ms，移植到C估计30ms以内吧。
#               One Method of Sharpness Assessment, having the best performance of accurance and timecost at that time,
#               runs on MATLAB for tens of ms while being transplanted to C code, it's within 30ms.

import numpy as np
from scipy.special import gamma
import cv2

def gi_f(rgbimg):
    gray_img = cv2.cvtColor(rgbimg, cv2.COLOR_RGB2GRAY).astype(np.float64)
    shifts = np.array([[0, 1], [0, -1], [1, 1], [1, 0], [1, -1], [-1, 1], [-1, 0], [-1, -1]])
    mmd_map = gif_mmd(gray_img, shifts, pad_len=8)
    sharpness = gif_pool(mmd_map.flatten(), mmd_map.flatten())
    return sharpness

def gif_mmd(graydouble, shifts, pad_len=8):
    num_rows, num_cols = graydouble.shape
    resmean = np.zeros((num_rows, num_cols))
    resmax = np.zeros((num_rows, num_cols))

    for shift_dir in shifts:
        shift_img = np.roll(graydouble, shift=shift_dir, axis=(0, 1))
        diff_img = np.abs(shift_img - graydouble) / 255
        resmax = np.maximum(resmax, diff_img)
        resmean += diff_img

    resmax = resmax[pad_len:-pad_len, pad_len:-pad_len]
    resmean = resmean[pad_len:-pad_len, pad_len:-pad_len] / len(shifts)
    mmd_map = resmax - resmean
    return mmd_map

def gif_pool(weight_src, sigma_index):
    alpha = 1
    sigma = 0.1
    beta = sigma * np.sqrt(gamma(1 / alpha) / gamma(3 / alpha))
    normalized_weight_src = weight_src / np.max(weight_src)
    weight = (alpha / (2 * beta * gamma(1 / alpha))) * np.exp(-((np.abs(normalized_weight_src - 1) / beta) ** alpha))
    weight /= np.sum(weight)
    pooling_value = np.sum(sigma_index * weight)
    return pooling_value

