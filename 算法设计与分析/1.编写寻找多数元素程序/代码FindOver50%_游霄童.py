# 找出数组中超过50%的元素
# Created by 游霄童 2023/10/10


n = int(input("请输入数组的个数n:"))
# 数组的输入
A = []
print("请依次输入数组元素：")
for i in range(n):
    num = input()
    A.append(num)

print("您输入的数组为：", A)
# 思路：使用python的字典实现哈希映射，仅需比较一遍数组的值便可得出结论，算法复杂度为O（n）
hashh = {}

# 初始化
for i in range(n):
    hashh[A[i]] = 0
for i in range(n):
    hashh[A[i]] += 1

flag = 0
for key in hashh:
    if hashh[key] > n / 2:
        flag = 1
        print("存在出现次数大于n/2的元素为：", key, "出现次数为：", hashh[key])
if flag == 0: print("不存在出现次数大于n/2的元素")
