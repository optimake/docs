# 求解接口

该章节介绍OPTIMake的求解接口。
求解接口接收problem，option，workspace作为输入，返回exitflag与output。下面为求解接口solve的伪代码：

=== "Pseudocode"
    ``` python
    [exitflag, output] = solve(problem, option, workspace)
    ```

## **problem设置**
优化问题的参数与外部自定义函数通过problem进行设置。

## **option设置**
求解参数通过option设置。

通用option：

- print_level：打印信息的等级，int类型
    - 0：不打印
    - 1：打印错误信息与最终求解状态
    - 2：在1的基础上，打印迭代过程
    - 3：在2的基础上，打印更多求解信息
- obj_scaling_method：objective的scaling方法，int类型
    - 0：无scaling
    - 1：用户指定scaling factor，其值通过option中的obj_scaling_factor（double类型，正数）输入
    - 2：自动根据Hessian值进行scaling
- max_num_iter：最大迭代次数，int类型，非负
- tol_eq：等式约束的tolerance，double类型，非负
- tol_ineq：不等式约束的tolerance，double类型，非负
- tol_stat：stationarity condition的tolerance，double类型，非负
- tol_comp：complementarity condition的tolerance，double类型，非负
- tol_step：迭代步长的tolerance，double类型，非负

Interior-point method专有option：

- mu_start：barrier parameter的初始值，double类型，非负
- mu_end：barrier parameter的最终值，double类型，非负且不大于mu_start
- try_warm_start_mu：该参数只对需连续求解的问题（如高频控制问题）有效。barrier parameter是否尝试从mu_end开始warm start，如果尝试失败，barrier parameter会被设置为mu_start开始迭代，如果warm start成功，将有效降低迭代次数。
    - 0：否
    - 1：是

## **workspace设置**
优化问题的初始解通过workspace设定。

!!! Note

    OPTIMake中primal变量的初始解均由workspace提供。若用户未设置，将默认使用上一次workspace中的值（上一次solve产生的值）作为初始值。


## **exitflag**
exitflag为求解状态。

- 1：求解成功
- 2：达到最大迭代次数
- 3：迭代步长小于设定的tolerance（tol_step）
- 4：迭代过程中产生inf/nan非法值
- 100：license检查失败
- 101：初始解检查失败（包含inf/nan非法值）
- 102：参数检查失败（包含inf/nan非法值）



## **output**
output中包含了求解状态，耗时，优化变量，迭代次数，objective，residual信息。