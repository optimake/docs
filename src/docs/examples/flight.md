# Flight
## 飞行器动力学模型
考虑一个飞行器三维动力学模型：

\begin{align}
	\dot{x}&=V \cos \gamma \cos \psi \label{1.1} \tag{1.1} \\
	\dot{y}&=V \sin \gamma \label{1.2} \tag{1.2} \\
	\dot{z}&=-V \cos \gamma \sin \psi \label{1.3} \tag{1.3} \\
	\dot{V}&=-D-\sin \gamma / r^{2}  \label{1.4} \tag{1.4} \\ 
	\dot{\gamma}&=-L \cos \sigma / V-\cos \gamma / V r^{2} \label{1.5} \tag{1.5} \\
	\dot{\psi}&=-L \sin \sigma / V \cos \gamma \label{1.6} \tag{1.6}
\end{align}

式(1) 中， $(x, y, z)$ 为飞行器的三维位置， $r = 1 + y$ 为质心到地心距离，
$V$ 为速度， $\gamma$ 为航迹倾角， $\psi$ 为航迹偏角；
航程 $x$ 、高度 $y$ 以及侧向位置 $z$ 通过地球半径 $R_0$ 进行无量纲化，
速度 $V$ 通过 $\sqrt{g_0 R_0}$ 进行无量纲化，其中，$g_0$ 为地球表面的重力加速度。

上述方程对无量纲时间 $t$ 求导，时间 $t$ 通过 $\sqrt{g_0/R_0}$ 进行无量纲化。 $\rho$ 为滚转角；
$L =  \tfrac{1}{2} R_0 \rho V^2 C_L/m$ 为无量纲升力， $D = \tfrac{1}{2} R_0 \rho V^2 C_D/m$ 为无量纲阻力，其中 $S$ 为飞行器的参考面积， m 为质量， $q = \tfrac{1}{2} \rho V^2$ 为动压。 
$\rho=\rho_{0} e^{-k_{\rho} h}$ 为大气密度，其中 $\rho_0$ 为海平面处的大气密度， $k_\rho$ 为常值系数。

对于面对称飞行器而言，升力系数和阻力系数作为攻角和马赫数的函数具有一定的关联性，一般用极曲线描述，简化地，可以
用二次函数表示这种关联，即： 

\begin{equation}
   C_{D}(\alpha, M)=K(M) C_{L}^{2}(\alpha, M)+C_{D 0}(M) \label{2} \tag{2}
\end{equation}

其中， $C_{D_0}(M)$ 为零攻角阻力系数，$K(M)$ 为诱导阻力系数，它们仅为马赫数的函数。
依据以上，阻力和升力有如下关系：

\begin{equation}
   D = D_K L^2 + D_0 \label{3} \tag{3}
\end{equation}

其中， $D_K=\frac{2K_m}{\rho V^2 S R_0}$ , $D0 = \tfrac{1}{2} \rho V^2 S C_{D_0} R_0/m$ 为零升阻力，它们均是高度和马赫数的函数。定义如下新控制变量：

\begin{equation}
   u_1 = L \cos \sigma,  u_2 = L \sin \sigma  \label{4} \tag{4}
\end{equation}

 *气动参数* 

| 参数   |  $m$           | $S_{ref}$      |  $g_0$         | $C_{D_0}$      | $K_{m}$   |
| :----- | :---- | :---- | :---- | :---- | :---- |
| __值__     | 200 (kg)       | 0.292 $(m^2)$  | 9.82           | 0.08           | 0.15      |
| __参数__   | $\alpha_{max}$ | $\sigma_{max}$ | $n_{max}$      | $q_{max}$      |           |
| __值__     | 20 (deg)       |   90 (deg)     | 15             | 120(kN/$m^2$ ) |           |


!!!NOTE
	对于飞行器而言，气动系数一般是随着速度、高度等环境因素变化的，OPTIMake将有专门处理 LookupTable函数支持这类输入，并实现与求解器的高效集成。

## 在线轨迹规划问题