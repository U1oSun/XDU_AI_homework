import numpy as np
import random


def fit_fun(X):  # 适应函数
    Y=-np.abs(np.sin(X[0]) * np.cos(X[1]) * np.exp(np.abs(1 - np.sqrt(X[0] ** 2 + X[1] ** 2) / np.pi)))
    return Y


class Particle:
    # 初始化
    def __init__(self, x_max, max_vel, dim):
        self.__pos = [random.uniform(-x_max, x_max) for i in range(dim)]  # 粒子的位置
        self.__vel = [random.uniform(-max_vel, max_vel) for i in range(dim)]  # 粒子的速度
        self.__bestPos = [0.0 for i in range(dim)]  # 粒子最好的位置
        self.__fitnessValue = fit_fun(self.__pos)  # 适应度函数值

    def set_pos(self, i, value):
        self.__pos[i] = value

    def get_pos(self):
        return self.__pos

    def set_best_pos(self, i, value):
        self.__bestPos[i] = value

    def get_best_pos(self):
        return self.__bestPos

    def set_vel(self, i, value):
        self.__vel[i] = value

    def get_vel(self):
        return self.__vel

    def set_fitness_value(self, value):
        self.__fitnessValue = value

    def get_fitness_value(self):
        return self.__fitnessValue


class PSO:
    def __init__(self, dim, size, iter_num, x_max, max_vel, best_fitness_value=float('Inf'), C1=2, C2=2, W=1):
        self.C1 = C1
        self.C2 = C2
        self.W = W
        self.dim = dim  # 粒子的维度
        self.size = size  # 粒子个数
        self.iter_num = iter_num  # 迭代次数
        self.x_max = x_max
        self.max_vel = max_vel  # 粒子最大速度
        self.best_fitness_value = best_fitness_value
        self.best_position = [0.0 for i in range(dim)]  # 种群最优位置
        self.fitness_val_list = []  # 每次迭代最优适应值
        self.avg_fitness_values = []  # 存储每一代适应度的平均值
        self.worst_fitness_values = []  # 存储每一代适应度的最差值

        # 对种群进行初始化
        self.Particle_list = [Particle(self.x_max, self.max_vel, self.dim) for i in range(self.size)]

    def set_bestFitnessValue(self, value):
        self.best_fitness_value = value

    def get_bestFitnessValue(self):
        return self.best_fitness_value

    def set_bestPosition(self, i, value):
        self.best_position[i] = value

    def get_bestPosition(self):
        return self.best_position

    # 更新速度
    def update_vel(self, part):
        for i in range(self.dim):
            vel_value = self.W * part.get_vel()[i] + self.C1 * random.random() * (part.get_best_pos()[i] - part.get_pos()[i]) \
                        + self.C2 * random.random() * (self.get_bestPosition()[i] - part.get_pos()[i])
            if vel_value > self.max_vel:
                vel_value = self.max_vel
            elif vel_value < -self.max_vel:
                vel_value = -self.max_vel
            part.set_vel(i, vel_value)

    # 更新位置
    def update_pos(self, part):
        for i in range(self.dim):
            pos_value = part.get_pos()[i] + part.get_vel()[i]
            part.set_pos(i, pos_value)
        value = fit_fun(part.get_pos())
        if value < part.get_fitness_value():
            part.set_fitness_value(value)
            for i in range(self.dim):
                part.set_best_pos(i, part.get_pos()[i])
        if value < self.get_bestFitnessValue():
            self.set_bestFitnessValue(value)
            for i in range(self.dim):
                self.set_bestPosition(i, part.get_pos()[i])
    def update(self):
        for i in range(self.iter_num):
            current_fitness_values = []  # 存储当前迭代的所有适应度值
            for part in self.Particle_list:
                self.update_vel(part)
                self.update_pos(part)
                current_fitness_values.append(fit_fun(part.get_pos()))  # 记录当前粒子的适应度值

            # 计算当前迭代的适应度统计值
            avg_fitness = np.mean(current_fitness_values)
            worst_fitness = np.max(current_fitness_values)

            self.avg_fitness_values.append(avg_fitness)
            self.worst_fitness_values.append(worst_fitness)

            # 更新全局最优适应值和位置
            best_fitness = np.min(current_fitness_values)
            best_index = np.argmin(current_fitness_values)
            if best_fitness < self.get_bestFitnessValue():
                self.set_bestFitnessValue(best_fitness)
                self.set_bestPosition(self.Particle_list[best_index].get_pos())

            self.fitness_val_list.append(self.get_bestFitnessValue())
        return self.fitness_val_list, self.get_bestPosition(), self.avg_fitness_values, self.worst_fitness_values