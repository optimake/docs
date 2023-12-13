==========
问题定义
==========

我们首先考虑形式为的连续时间非线性最优控制问题:

.. math::

   \begin{array}{cll}
   \underset{x(\cdot), z(\cdot), u(\cdot)}{\operatorname{minimize}} & \int_{0}^{T} \ell(x(t), z(t), u(t)) \mathrm{d} t+M(x(T)) \\
   \text { subject to } & x(0)=\bar{x}_{0}, & \\
   & 0=f(\dot{x}(t), x(t), z(t), u(t)), & t \in[0, T], \\
   & 0 \geq g(x(t), z(t), u(t)), & t \in[0, T] .
   \end{array}


在这个符号中，:math:`\mathbb{R} \rightarrow \mathbb{R}^{n_{x}}` 表示微分状态，:math:`\mathbb{R} \rightarrow \mathbb{R}^{n_{z}}` 是代数变量，:math:`\mathbb{R} \rightarrow \mathbb{R}^{n_{u}}` 表示控制输入。
此外，我们使用
:math:`\ell: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times \mathbb{R}^{n_{u}} \rightarrow \mathbb{R}` 表示拉格朗日项或过程cost，:math:`M:\mathbb{R} \rightarrow \mathbb{R}^{n_{x}}` 表示Mayer项或终端cost。
动力学模型采用一组右侧为
:math:`f: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times\mathbb{R}^{n_{u}} \rightarrow \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}}`
的隐式微分代数方程(DAE)。
其余部分，我们假设隐式DAE的索引为1，即，:math:`\partial f /(\partial \dot{x}, \partial z)` 。
非线性路径约束由
:math:`g: \mathbb{R}^{n_{x}} \times \mathbb{R}^{n_{z}} \times \mathbb{R}^{n_{u}} \rightarrow \mathbb{R}^{n_{g}}`
给出，并且状态的初始值是 :math:`\bar{x}_{0} \in \mathbb{R}^{n_{x}}` 。

- Multiple shooting 离散

在OPTIMake中，我们用Multi-Shooting方法离散非线性最优控制问题。
我们引入了一个时间离散点列 :math:`[t_0，t_1r,...,t_N]`, 其中 :math:`( t_k＜t_{k+1}，k=0，...，N−1 )` ，
离散状态变量 :math:`x_0,...,x_N` ，代数变量 :math:`z_0,...,z_{N−1}`
并控制 :math:`u_0,...` ，对于控制轨迹，我们选择分段常数控制参数化。
在每个时间间隔:math:`[t_k,t_{k+1}` 上，系统过程表示为：

.. math::
  \begin{bmatrix}
    x_{k+1}\\
    z_k
   \end{bmatrix} = \phi(x_k,z_k), \ k = 0,...,N-1



如[1] 所示，与按正向顺序执行动态过程并进行优化的single shooting相比，multi-shooting方法通常可以带来更好的收敛行为。
得到的非线性规划（NLP）公式如下所示：

.. math::
   \begin{aligned}
   \underset{\substack{x_{0}, \ldots, x_{N}, \\ z_{0}, \ldots, z_{N-1}, \\ u_{0}, \ldots, u_{N-1}}}{\operatorname{minimize}} & \sum_{k=0}^{N-1}\left(t_{k+1}-t_{k}\right) \cdot \ell\left(x_{k}, z_{k}, u_{k}\right)+M\left(x_{N}\right) \\
   \text { subject to } & x_{0}=\bar{x}_{0}, \\
   {\left[\begin{array}{c}
   x_{k+1} \\
   z_{k}
   \end{array}\right] } & =\phi_{k}\left(x_{k}, u_{k}\right), \quad k=0, \ldots, N-1, \\
   0 & \geq g_{k}\left(x_{k}, z_{k}, u_{k}\right) \quad k=0, \ldots, N-1 .
   \end{aligned}

.. [1] Bock, H.: Randwertproblemmethoden zur Parameteridentifizierung in Systemen nichtlinearer Differentialgleichungen, Bonner Mathematische Schriften, vol. 183. Universität Bonn, Bonn (1987)
