# 2022_AdiversityMetric
Abstract: Metaheuristic algorithms are techniques that have been successfully applied to solve complex optimization problems in engineering and science. Many metaheuristic approaches, such as Differential Evolution (DE), use the best individual found so far from the whole population to guide the search process. Although this approach has advantages in the algorithm’s exploitation process, it is not completely in agreement with the swarms found in nature, where communication among individuals is not centralized. This paper proposes the use of stigmergy as an inspiration to modify the original DE operators to simulate a decentralized information exchange, thus avoiding the application of a global best. The Stigmergy-based DE (SDE) approach was tested on a set of benchmark problems to compare its performance with DE. Even though the execution times of DE and SDE are very similar, our proposal has a slight advantage in most of the functions and can converge in fewer iterations in some cases, but its main feature is the capability to maintain a good convergence behavior as the dimensionality grows, so it can be a good alternative to solve complex problems.
Experiments from the paper "A diversity metric for population-based metaheuristic algorithms", published in 2022.
The files were created with Matlab, and all the experiments of the paper are included. The main file is runBenchmark.m, which runs a generic test. 
The experiments are separated by number, and some lines of code are commented because their original purpose was to debug the original code. 
In case of using this code, please cite the paper as:
"Valentín Osuna-Enciso, Erik Cuevas, Bernardo Morales Castañeda, A diversity metric for population-based metaheuristic algorithms, Information Sciences, Volume 586, 2022, Pages 192-208."

Let's consider the next example of use for the function nVOL2.m, where we have a population X_k with 3 individuals and four dimensions:

X_k=[   x_11, x_12, x_13, x_14;
      x_21, x_22, x_23, x_24;
      x_31, x_32, x_33, x_34]
      
l=[-50.0, -50.0, -50.0, -50.0]

u=[50.0, 50.0, 50.0, 50.0]

The containers 'u' and 'l' are [1 x D] in size, where D is the dimension of the problem, whereas X_k is [Np x D], where Np is the population size, and k is the actual iteration of the metaheuristic algorithm. To utilize the function presented in the paper:

nVOL(X, l, u)

and the function will return a real number, which is the value obtained by the proposed metric.
