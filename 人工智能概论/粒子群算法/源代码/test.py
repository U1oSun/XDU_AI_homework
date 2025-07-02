import PSO
import matplotlib.pyplot as plt
import numpy as np
#from PSO import fit_fun

dim = 2
size = 10
iter_num = 500
x_max = 10
max_vel = 0.05

# Quadratic Function
def quadratic_function(X):
    return X[0]**2 + X[1]**2

# Schwefel's Problem 2.21 Function
def schwefel_2_21_function(X):
    return -np.abs(X[0]) - np.abs(X[1]) - np.abs(X[0] * X[1])

# Brown's Almost-Linear Function
def brown_almost_linear_function(X):
    return 2*X[0]**2 + 2*X[0]*X[1] + X[1]**2

# Rastrigin Function
def rastrigin_function(X):
    return -X[0] * np.sin(np.sqrt(np.abs(X[0]))) - X[1] * np.sin(np.sqrt(np.abs(X[1])))

# Ackley Function
def ackley_function(X):
    term1 = X[0]**2 - 10 * np.cos(2 * np.pi * X[0]) + 10
    term2 = X[1]**2 - 10 * np.cos(2 * np.pi * X[1]) + 10
    return term1 + term2

# Sum of Different Powers Function
def sum_of_different_powers_function(X):
    term1 = 20 * (1 - np.exp(-0.2 * np.sqrt(X[0]**2 + X[1]**2)))
    term2 = np.exp(1) - np.exp(0.5 * (np.cos(2 * np.pi * X[0]) + np.cos(2 * np.pi * X[1])))
    return term1 + term2


if __name__ == "__main__":
    functions=[quadratic_function,schwefel_2_21_function,brown_almost_linear_function,rastrigin_function,ackley_function,sum_of_different_powers_function]

    for idx, func in enumerate(functions, start=1):
        print(f"\nExecuting Function {idx}: {func.__name__}")
        #fit_fun = func
        PSO.fit_fun = func
        pso = PSO.PSO(dim, size, iter_num, x_max, max_vel)
        fit_var_list1, best_pos1 ,avg_fitness_values_list,worst_fitness_values_list= pso.update()
        print("PSO最优位置:" + str(best_pos1))
        print("PSO最优解:" + str(fit_var_list1[-1]))
        fig = plt.figure(figsize=(10, 8))
        plt.plot(np.linspace(0, iter_num, iter_num), fit_var_list1, c="red", alpha=0.5, label="PSO_Best_Fitness")
        plt.plot(np.linspace(0, iter_num, iter_num), avg_fitness_values_list, c="green", alpha=0.5, label="PSO_Avg_Fitness")
        plt.plot(np.linspace(0, iter_num, iter_num), worst_fitness_values_list, c="blue", alpha=0.5,  label="PSO_Worst_Fitness")
        plt.legend()  # 显示lebel
        plt.title(f"{idx}: Fitness Evolution Over Iterations of %s" % func.__name__)
        plt.savefig("The Result of %s.png" % func.__name__,dpi=200)
        plt.show()

