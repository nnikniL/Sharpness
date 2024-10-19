imgpath = 'test.png';
rgbimg = imread(imgpath);
num_runs = 10; % �������д���
% ��ʼ��ʱ�������
total_time = 0;

% ������в�����ִ��ʱ��
for i = 1:num_runs
    tic;  % ��ʼ��ʱ
    Sharpness = GI_F(rgbimg);
    elapsed_time = toc;  % ������ʱ����¼ʱ��
    total_time = total_time + elapsed_time;
end

%���������
fprintf('Sharpness = %.6f\n', Sharpness);

% ����ƽ��ִ��ʱ��
average_time = total_time / num_runs;

% ��ʾƽ��ִ��ʱ��
fprintf('Average execution time over %d runs: %.6f seconds\n', num_runs, average_time);