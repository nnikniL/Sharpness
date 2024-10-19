import timeit
import cv2
from GI_F import gi_f

# 读取图片文件并转为RGB格式
image_path = "test.png"
rgbimg = cv2.imread(image_path)

# OpenCV 默认读取为 BGR，需要转换为 RGB
rgbimg = cv2.cvtColor(rgbimg, cv2.COLOR_BGR2RGB)

# 调用 gi_f 函数
sharpness_value = gi_f(rgbimg)
print("Sharpness:", sharpness_value)

# 创建测试函数
def test_gi_f():
    gi_f(rgbimg)

# 使用 timeit 测量执行时间，运行100次
execution_time = timeit.timeit("test_gi_f()", globals=globals(), number=100)
print(f"Average execution time over 100 runs: {execution_time / 100:.6f} seconds")