# Tips

## Solving the Very First OCP
In most of the cases, the very first OCP can be solved offline so that warm-start can be used.
In solving the very first OCP offline, you can start with an easy-to-solve OCP, for example, OCP with less constraints or mild parameters. 
Then, you can gradually modify and solve the OCP to the one you want by starting from the solution obtained before.

## Degree of Parallelism (DoP)

`DoP` is a parameter to specify the number of pieces to split the OCP along the prediction horizon for parallel computing. In general, a faster rate of convergence can be achieved by choosing a smaller `DoP`. In the case of `DoP=1`, the solver is exactly equivalent to the interior-point method.

Meanwhile, when you want to generate serial code without any parallel computing, you can set `DoP` to 1 and edit `Timer.m` to specify your own timer function (the default is `omp_get_wtime`, which is not supported when OpenMP is disabled).

## Tuning

* Specify the tuning parameters such as the weighting matrices as parameters so that they can be tuned without re-generating the OCP.

