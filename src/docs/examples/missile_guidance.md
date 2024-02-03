# 导弹制导问题

## 比例导引模型
一般地，假设打击目标静止或低速运动, 二维水平面内制导几何表示如图所示。

<p align="center">
<img src="../missile_guidance_geometry.png" width="300px" >
</p>
<center>导弹制导飞行几何示意图</center>

其中， $V_i$ 分别为第 $i$ 枚导弹的速度； $t_{go,i}$ 为第 $i$ 枚导弹的剩余飞行时间，相应的视线距离 $r_i$、视线角 $q_i$、前置角 $\varphi_i$ 和弹道偏角 $\theta_i$ 等制导飞行状态参数表示如图所示(简单起见，省略第 i 枚导弹的下标)。
导弹制导遵循所谓的比例导引关系，即$\varphi = \theta − q, \dot{\theta} = N(t) \dot q$。
其中， $N$ 为随时间变化的制导增益（比例导引系数），
因此，导弹视线角动力学方程可以表示为：

\begin{align}
	\dot{r}&= -V \cos \varphi \label{1.1} \tag{1.1} \\
	r \dot{q}&= -V \sin \varphi \label{1.2} \tag{1.2} \\
	r \dot{\varphi}&= (1-N(t)) V \sin \varphi \label{1.3} \tag{1.3} 
\end{align}

导弹侧向加速度描述为：
\begin{equation}
a = V \dot{\theta} = V N \dot{q} = - \frac{N V^2 \sin \varphi}{r}  \label{2} \tag{2}
\end{equation}
简单地，考虑导弹制导过程中受到最大侧向过载的限制：
\begin{equation}
r a_{min} \leq - N V^2 \sin \varphi \leq r a_{max}  \label{3} \tag{3}
\end{equation}

此外，基于落角和有限视场角约束, 制导飞行过程还包含如下边界约束：

\begin{align}
	&r(t_0) = r_0, \ q(t_0) = q_0, \ \varphi(t_0) = \varphi_0 \label{4.1} \tag{4.1} \\
	&q(t_f) + \varphi(t_f) = \theta(t_f) \label{4.2} \tag{4.2} \\
	&\varphi_{min} \leq \varphi \leq \varphi_{max} \label{4.3} \tag{4.3} 
\end{align}

## 导弹制导优化问题描述

\begin{array}{cll}
\underset{r(\cdot), q(\cdot), \varphi(\cdot)}{\operatorname{minimize}} & \int_{0}^{T} \ell(a(t)) \mathrm{d} t \\
\text { subject to } & r(0)=\bar{r}_{0}, q(0)=\bar{q}_{0}, \varphi(0)=\bar{\varphi}_{0} & \\
& (1),(3),(4).
\end{array}

优化目标为过载（最小二乘）积分, 模型定义为：

=== "Python"
    ``` python
	prob = multi_stage_problem('missile', N=11)

	r0, q0, phi0 = prob.parameters(['r0', 'q0', 'phi0'])
	length       = prob.parameter('length')
	V            = prob.parameters(['V'], stage_dependent=True)
	aLB, aUB     = prob.parameters(['aLB', 'aUB'], stage_dependent=True)
	phiLB, phiUB = prob.parameters(['phiLB', 'phiUB'], stage_dependent=True)
	rf           = prob.parameters(['rf'], stage_dependent=False)
	thetaf       = prob.parameters(['thetaf'], stage_dependent=False)

	r, q, phi    = prob.variables(['x', 'q', 'phi'])
	uN           = prob.variable('uN', hard_lowerbound=-10.0, hard_upperbound=10.0, \
    							 soft_lowerbound=-5.0, soft_upperbound=5.0, \
                       			 weight_soft_lowerbound=1e1, \
								 weight_soft_upperbound=1e1, \
                     			 penalty_type_soft_lowerbound='quadratic', \
								 penalty_type_soft_upperbound='quadratic')

	accl = [-uN * V**2 * sin(phi) / r]
	objLS = least_square_objective(accl)
	prob.objective(objLS)

	prob.inequality(phi, hard_lowerbound=phiLB, hard_upperbound=phiUB)
	prob.inequality(uN * V**2 * sin(phi) / r, hard_lowerbound=aLB, hard_upperbound=aUB)

	""" ode """
	ode = differential_equation(
    	input=[uN],
		state=[r, q, phi],
		state_dot=[-V * cos(phi), -V * sin(phi) / r, (1 - uN) * V * sin(phi) / r],
		stepsize=0.1,
		discretization_method='forward_euler')
	prob.equality(ode)
	
	prob.fixed_start_variable(r, r0)
	prob.fixed_start_variable(q, q0)
	prob.fixed_start_variable(phi, phi0)
	prob.fixed_end_variable(r, rf)
	prob.fixed_end_variable(q + phi, thetaf)

	option = codegen_option()
	option.platform = 'windows-x86_64-mingw'  # ['windows-x86_64-mingw', 'linux-x86_64-gcc', 'linux-arm64-gcc', 'linux-armv7-gcc']
	option.server = 'http://127.0.0.1'
	option.license_uuid = 'xxxx-xxxx-xxxx-xxxx'
	codegen = pdipm_generator()
	codegen.codegen(prob, option)
    ```
以上。