# **建模接口**

该章节介绍OPTIMake支持的问题类型，以及如何通过OPTIMake提供的建模接口定义问题。
## **问题形式**

我们首先考虑形式为的连续时间非线性最优控制问题:

\begin{array}{cll}
\underset{x(\cdot), z(\cdot), u(\cdot)}{\operatorname{minimize}} & \int_{0}^{T} \ell(x(t), z(t), u(t)) \mathrm{d} t+M(x(T)) \\
\text { subject to } & x(0)=\bar{x}_{0}, & \\
& 0=f(\dot{x}(t), x(t), z(t), u(t)), & t \in[0, T], \\
& 0 \geq g(x(t), z(t), u(t)), & t \in[0, T] .
\end{array}


在这个符号中，$\mathbb{R} \rightarrow \mathbb{R}^{n_{x}}$ 表示微分状态，$\mathbb{R} \rightarrow \mathbb{R}^{n_{z}}$ 是代数变量，$\mathbb{R} \rightarrow \mathbb{R}^{n_{u}}$ 表示控制输。
此外，我们使用 $\ell: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times \mathbb{R}^{n_{u}} \rightarrow \mathbb{R}$ 表示拉格朗日项或过程cost，$M:\mathbb{R} \rightarrow \mathbb{R}^{n_{x}}$ 表示Mayer项或终端cost。
动力学模型采用一组右侧为 $f: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times\mathbb{R}^{n_{u}} \rightarrow \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}}$的隐式微分代数方程(DAE)。
其余部分，我们假设隐式DAE的索引为1，即，$\partial f /(\partial \dot{x}, \partial z)$ 。
非线性路径约束由$g: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times \mathbb{R}^{n_{u}} \rightarrow \mathbb{R}^{n_{g}}$
给出，并且状态的初始值是$\bar{x}_{0} \in \mathbb{R}^{n_{x}}$ 。


- Multiple shooting 离散

在OPTIMake中，我们用Multi-Shooting方法离散非线性最优控制问题。
我们引入了一个时间离散点列 $[t_0，t_1r,...,t_N]$ $( t_k＜t_{k+1}，k=0，...，N−1 )$，
离散状态变量 $x_0,...,x_N$ ，代数变量 $z_0,...,z_{N−1}$并控制 $u_0,...$ ，对于控制轨迹，我们选择分段常数控制参数化。
在每个时间间隔 $[t_k,t_{k+1})$上，系统过程表示为：

\begin{equation}
\begin{bmatrix}
  x_{k+1}\\
 z_k
\end{bmatrix} = \phi(x_k,z_k), \ k = 0,...,N-1
\end{equation}


如 [1] 所示，与按正向顺序执行动态过程并进行优化的single shooting相比，multi-shooting方法通常可以带来更好的收敛行为。
得到的非线性规划（NLP）公式如下所示：

\begin{aligned}
\underset{\substack{x_{0}, \ldots, x_{N}, \\ z_{0}, \ldots, z_{N-1}, \\ u_{0}, \ldots, u_{N-1}}}{\operatorname{minimize}} & \sum_{k=0}^{N-1}\left(t_{k+1}-t_{k}\right) \cdot \ell\left(x_{k}, z_{k}, u_{k}\right)+M\left(x_{N}\right) \\
\text { subject to } & x_{0}=\bar{x}_{0}, \\
{\left[\begin{array}{c}
x_{k+1} \\
z_{k}
\end{array}\right] } & =\phi_{k}\left(x_{k}, u_{k}\right), \quad k=0, \ldots, N-1, \\
0 & \geq g_{k}\left(x_{k}, z_{k}, u_{k}\right) \quad k=0, \ldots, N-1 .
\end{aligned}

[1] Bock, H.: Randwertproblemmethoden zur Parameteridentifizierung in Systemen nichtlinearer Differentialgleichungen, Bonner Mathematische Schriften, vol. 183. Universität Bonn, Bonn (1987)

-->

- OPTIMake求解以下的优化问题：

    \begin{equation*}
        \begin{split}
           &\quad \quad \quad \min_{v_1,\cdots,v_N} \sum_{i=1}^{N} l(v_i, p_i) \\
            &\begin{split}
                \text{subject to}
                &\quad  v_1(\mathcal{S}) = v_{start},\\
                &\quad  f(v_{i}, v_{i+1}, p_i) = 0,\quad i=1,\cdots,N - 1,\\
                &\quad  v_N(\mathcal{E}) = v_{end},\\
                &\quad  g(v_i, p_i) \geq 0,\quad i=1,\cdots,N.
            \end{split}
        \end{split}
    \end{equation*}

该优化问题为一个具有 $N$ 个stage的优化问题，取决于问题，该优化问题可能为一个非线性非凸的优化问题。
其中，
$v_1,\cdots,v_N \in \mathbb{R}^{n_{v}}$ 为优化变量；
$p_1,\cdots,p_N\in \mathbb{R}^{n_{p}}$ 为参数；
$l：\mathbb{R}^{n_{v}} \times \mathbb{R}^{n_{p}} \rightarrow \mathbb{R}$ 为stage objective；
$f：\mathbb{R}^{n_{v}} \times \mathbb{R}^{n_{v}} \times \mathbb{R}^{n_{p}} \rightarrow \mathbb{R}^{n_{f}}$ 为等式约束；
$g：\mathbb{R}^{n_{v}} \times \mathbb{R}^{n_{p}} \rightarrow \mathbb{R}^{n_{g}}$ 为不等式约束； 
$v_{start}$ 为初始的值（$\mathcal{S}$ 为被固定的初始变量的index）； 
$v_{end}$ 为终点的值（$\mathcal{E}$ 为被固定的终点变量的index）。


## **问题定义**

下面为定义问题的例子，该例子指定了问题的名称为vehicle且具有10个stage：

=== "Python"
    ``` python
    prob = multi_stage_problem(name='vehicle', N=10)
    ```

其中，函数入参的定义如下：

- name: str
    问题的名称，该名称会用在生成代码的文件名，函数名等。

- N: int
    问题的stage数目，必须大于等于1。

在完成问题名称和stage数的定义后，下面说明如何定义优化问题中的参数，优化变量及约束。

!!! Note

    因为上述的优化问题为一个多stage的优化问题，等式约束与不等式约束的表达式在所有stage上都一致，所以不需要在每个stage上都单独定义，只需要定义一次该表达式即可（参数与优化变量同理）。


### **parameter定义**

parameter为在优化过程中不变的量，由用户在调用求解前给定，比如车身长度length，质量mass。

OPTIMake支持两种类型的parameter：stage-independent parameter与stage-dependent parameter。
stage-dependent parameter在不同stage可以有不同的值，
而stage-independent parameter在所有stage的值都一致（可以节约存储与简化设置）。

下面为定义优化变量的例子：

=== "Python"
    ``` python
    length = prob.parameter(name='length', stage_dependent=False)
    mass = prob.parameter('mass')
    xLowerBound = prob.parameter('xLowerBound', stage_dependent=True)
    ```

其中，函数入参的定义如下：

- name: str
    parameter的名称。

- stage_dependent: bool, optional
    parameter是否为stage-dependent。
    默认值为True，表示parameter为stage-dependent。



亦或者通过list的方式定义：

=== "Python"
    ``` python
    length, mass, xLowerBound = prob.parameters(['length', 'mass', 'xLowerBound'], stage_dependent=False)
    ```


### **优化变量定义**

优化变量为在优化过程中变化的量，比如车辆的转角控制量delta，位置状态x，y。
在定义优化变量时，可以同时定义优化变量的硬边界、软边界以及违反软边界时的惩罚（见[FAQ > 软约束](faq.md#soft_constraint)了解OPTIMake中的软约束定义）。

下面为定义优化变量的例子：

=== "Python"
    ``` python
    delta = prob.variable(name='delta', hard_lowerbound=-0.5, hard_upperbound=0.5)
    
    # xLowerBound与xUpperBound为已定义的parameter
    x = prob.variable('x', hard_lowerbound=xLowerBound, hard_upperbound=xUpperBound, \
                           soft_lowerbound=-0.2, soft_upperbound=0.2, \
                           weight_soft_lowerbound=100.0, weight_soft_upperbound=100.0, \
                           penalty_type_soft_lowerbound='quadratic', penalty_type_soft_upperbound='l1')
    y = prob.variable('y')
    theta = prob.variable('theta')
    ```
<!-- 
亦或者通过list的方式定义：

=== "Python"
    ``` python
    delta, x, y = prob.variables(name=['delta', 'x', 'y'], 
                hard_lowerbound=[-0.5, xLowerBound, None], hard_upperbound=[0.5, xUpperBound, None],
                soft_lowerbound=[None, -0.2, None], soft_upperbound=[None, 0.2, None],
                weight_soft_lowerbound=[None, 100.0, None], weight_soft_upperbound=[None, 100.0, None],
                penalty_type_soft_lowerbound=['quadratic', 'quadratic', 'quadratic'],
                penalty_type_soft_upperbound=['quadratic', 'l1', 'quadratic'])
    ```
-->

其中，函数入参的定义如下：

- name: str
    优化变量的名称。

- hard_lowerbound: float或参数, optional
    硬下界，即优化变量的最小值。
    默认值为-inf，表示无下界。  

- hard_upperbound: float或参数, optional
    硬上界，即优化变量的最大值。
    默认值为inf，表示无上界。

- soft_lowerbound: float或参数, optional
    软下界，即优化变量的最小值。
    默认值为-inf，表示无下界。

- soft_upperbound: float或参数, optional
    软上界，即优化变量的最小值与最大值。
    默认值为inf，表示无下界与上界。

- weight_soft_lowerbound: float或参数, optional
    软下界的惩罚权重，必须为非负。
    默认值为0.0，表示无惩罚。

- weight_soft_upperbound: float或参数, optional
    软下界的惩罚权重，必须为非负。
    默认值为0.0，表示无惩罚。

- penalty_type_soft_lowerbound: str, optional
    软下界的惩罚类型，可选值为'quadratic'或'l1'。
    默认值为'quadratic'。

- penalty_type_soft_upperbound: str, optional
    软上界的惩罚类型，可选值为'quadratic'或'l1'。
    默认值为'quadratic'。


### **objective定义**
objective为需要最小化的目标函数。OPTIMake支持以下类型的objective定义：表达式直接定义与least square接口定义。

#### 表达式

下面为通过表达式直接定义objective的例子：

=== "Python"
    ``` python
    # wyref, wphi为已定义的parameter
    obj = wxref * (x * sin(phi) - xref)**2 + wyref * (y - yref)**2 + wphi * phi**2 + 0.01 * delta**2 + 0.1 * v**2
    prob.objective(obj)
    ```

#### least square

当objective为以下形式时，可通过least square接口定义，其中$r_j(v, p)$为残差项，$w_j(p)$为其对应的权重项。
\begin{equation*}
    l(v_i, p_i) = \sum_{j}w_j(p_i) r^2_j(v_i, p_i)
\end{equation*}

下面为通过least square接口定义objective的例子：
=== "Python"
    ``` python
    r = [x * sin(phi) - xref, y - yref, phi, delta, v]
    w = [wxref, wyref, wphi, 0.01, 0.1]
    obj = least_square_objective(residual=r, weight=w)
    prob.objective(obj)
    ```

其中，least square接口的函数入参的定义如下：

- residual: 表达式的list
    对应$r(v, p)$

- weight: float或参数的list
    对应$w(p)$

!!! Note

    当objective通过least square接口定义时，其Hessian通过Gauss-Newton方式近似计算，通常能使得求解更可靠。

### **等式约束定义**
OPTIMake支持微分方程和离散方程两种等式约束，分别通differential equation与discrete equation接口定义。

#### differential equation

differential equation为 $\dot x = h(u, x)$，在定义differential equation时，需要将优化变量区分为input和state。下面为通过differential equation接口定义等式约束的例子：
=== "Python"
    ``` python
    # ts，length为已定义的parameter
    eq = differential_equation(
        input=[delta, v],
        state=[x, y, phi], 
        state_dot=[v * cos(phi), v * sin(phi), v * tan(delta) / length], 
        stepsize=ts, 
        discretization_method='forward_euler')
    ```
其中，differential equation接口的函数入参的定义如下：

- input: 优化变量的list
    该等式约束的输入量，即 $u$。

- state: 优化变量的list
    该等式约束的状态量，即 $x$。

- state_dot: 表达式的list
    该等式约束的状态微分量，即 $h(u, x)$。

- stepsize: float或参数
    离散步长。

- discretization_method: str
    离散方法，可选值为'forward_euler'，'erk2'，'erk4'，'backward_euler'，'irk2' 或 'irk4'。

#### discrete equation

discrete equation为 $h_{next}(v_{i+1}, p_{i+1}) = h_{this}(v_i, p_i)$，下面为通过discrete equation接口定义等式约束的例子（与differential equation中的例子等效）：
=== "Python"
    ``` python
    # ts，length为已定义的parameter
    eq = discrete_equation(
        this_stage_expr=[x + ts * v * cos(phi), y + ts * v * sin(phi), phi + ts * v * tan(delta) / length],
        next_stage_expr=[x, y, phi])
    ```
其中，discrete equation接口的函数入参的定义如下：

- this_stage_expr: 表达式的list
    当前stage的函数表达式，即 $h_{this}(v_i, p_i)$。

- next_stage_expr: 表达式的list
    下一个stage的函数表达式，即$h_{next}(v_{i+1}, p_{i+1})$。

#### 约束软化

在完成differential equation或difference equation的定义后，在将其加入至等式约束中时，可以选择是否进行软化，这个版本OPTIMake只支持quadratic类型软化（见[FAQ > 软约束](faq.md#soft_constraint)了解OPTIMake中的软约束定义），下面为定义等式约束的例子：
=== "Python"
    ``` python
    # eq为已定义的equation
    prob.equality(eq, weight_soft=[inf, inf, 100.0])
    ```
该例子表示只软化了最后一个等式约束，其惩罚权重为100.0，其余等式约束均未进行软化。

其中，函数入参的定义如下：

- weight_soft: float或参数的list
    等式约束的软化权重，必须为非负。
    默认值为inf，表示无软化。


### **不等式约束定义**

在定义不等式约束时，可以同时定义不等式约束的硬边界、软边界以及违反软边界时的惩罚（见[FAQ > 软约束](faq.md#soft_constraint)了解OPTIMake中的软约束定义）。

下面为定义不等式约束的例子：

=== "Python"
    ``` python

    # x + sin(theta) * y >= 1.0
    prob.inequality(ineq=x + sin(theta) * y, hard_lowerbound=1.0)

    # x + sin(theta) * y的硬边界为[-1.0, 1.0]，软边界为[-0.5, 0.5]
    prob.inequality(x + y, hard_lowerbound=-1.0, hard_upperbound=1.0, \
                    soft_lowerbound=-0.5, soft_upperbound=0.5, \
                    weight_soft_lowerbound=1e2, weight_soft_upperbound=1e2, \
                    penalty_type_soft_lowerbound='l1', penalty_type_soft_upperbound='l1')
    ```

其中，函数入参的定义如下：

- ineq: 表达式
    不等式约束的表达式。

- hard_lowerbound: float或参数, optional
    硬下界，即优化变量的最小值。
    默认值为-inf，表示无下界。  

- hard_upperbound: float或参数, optional
    硬上界，即优化变量的最大值。
    默认值为inf，表示无上界。

- soft_lowerbound: float或参数, optional
    软下界，即优化变量的最小值。
    默认值为-inf，表示无下界。

- soft_upperbound: float或参数, optional
    软上界，即优化变量的最小值与最大值。
    默认值为inf，表示无下界与上界。

- weight_soft_lowerbound: float或参数, optional
    软下界的惩罚权重，必须为非负。
    默认值为0.0，表示无惩罚。

- weight_soft_upperbound: float或参数, optional
    软下界的惩罚权重，必须为非负。
    默认值为0.0，表示无惩罚。

- penalty_type_soft_lowerbound: str, optional
    软下界的惩罚类型，可选值为'quadratic'或'l1'。
    默认值为'quadratic'。

- penalty_type_soft_upperbound: str, optional
    软上界的惩罚类型，可选值为'quadratic'或'l1'。
    默认值为'quadratic'。

### **起点约束定义**

起点约束描述了第一个优化变量 $v_1$ 是否为固定值，比如在车辆轨迹规划问题中的车辆初始状态约束。

下面为定义起点约束的例子：

=== "Python"
    ``` python
    # x0, y0, phi0为已定义的parameter
    prob.fixed_start_variable(var=x, value=x0)
    prob.fixed_start_variable(y, y0)
    prob.fixed_start_variable(phi, phi0)
    ```

其中，函数入参的定义如下：

- var: 优化变量
    需要在起点固定的优化变量。

- value: float或参数
    起点优化变量的值。

### **终点约束定义**

终点约束描述了最后一个优化变量 $v_N$ 是否为固定值，比如在火箭着陆轨迹规划问题中的末端零速度约束。

下面为定义终点约束的例子：

=== "Python"
    ``` python
    # x0, y0, phi0为已定义的parameter
    prob.fixed_end_variable(var=v, value=0.0)
    prob.fixed_end_variable(phi, 0.0)
    ```

其中，函数入参的定义如下：

- var: 优化变量
    需要在终点固定的优化变量。

- value: float或参数
    终点优化变量的值。
