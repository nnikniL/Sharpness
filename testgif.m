imgpath = 'test.png';
rgbimg = imread(imgpath);
num_runs = 10; % 设置运行次数
% 初始化时间计数器
total_time = 0;

% 多次运行并测量执行时间
for i = 1:num_runs
    tic;  % 开始计时
    Sharpness = GI_F(rgbimg);
    elapsed_time = toc;  % 结束计时并记录时间
    total_time = total_time + elapsed_time;
end

%输出清晰度
fprintf('Sharpness = %.6f\n', Sharpness);

% 计算平均执行时间
average_time = total_time / num_runs;

% 显示平均执行时间
fprintf('Average execution time over %d runs: %.6f seconds\n', num_runs, average_time);