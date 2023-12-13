=========
应用案例
=========

----------
飞行器制导
----------

考虑一个导弹飞行器三维动力学模型：

.. math::
   \begin{align}
     \dot{x}&=V \cos \gamma \cos \psi \label{1.1} \tag{1.1} \\
     \dot{y}&=V \sin \gamma \label{1.2} \tag{1.2} \\
     \dot{z}&=-V \cos \gamma \sin \psi \label{1.3} \tag{1.3} \\
     \dot{V}&=-D-\sin \gamma / r^{2}  \label{1.4} \tag{1.4} \\ 
     \dot{\gamma}&=-L \cos \sigma / V-\cos \gamma / V r^{2} \label{1.5} \tag{1.5} \\
     \dot{\psi}&=-L \sin \sigma / V \cos \gamma \label{1.6} \tag{1.6}
   \end{align}


式(1) 中， :math:`(x, y, z)` 为导弹的三维位置， :math:`r = 1 + y` 为导弹质心到地心距离，
:math:`V` 为速度， :math:`γ` 为弹道倾角， :math:`ψ` 为弹道偏角；
射程 :math:`x` 、射高 :math:`y` 以及侧向位置 :math:`z` 通过地球半径 :math:`R_0` 进行无量纲化，
速度 :math:`V` 通过 :math:`\sqrt{g_0 R_0}` 进行无量纲化，其中，:math:`g_0` 为地球表面的重力加速度。
上述方程对无量纲时间 :math:`t` 求导，时间 :math:`t` 通过 :math:`\sqrt{g_0/R_0}` 进行无量纲化。 :math:`\rho` 为滚转角；
:math:`L =  \tfrac{1}{2} R_0 \rho V^2 C_L/m` 为无量纲升力， :math:`D = \tfrac{1}{2} R_0 \rho V^2 C_D/m` 为无量纲阻力，其中 :math:`S` 
为导弹的参考面积， m 为弹体质量， :math:`q = \tfrac{1}{2} \rho V^2` 为动压。 
:math:`\rho=\rho_{0} e^{-k_{\rho} h}` 为大气密度，其中 :math:`\rho_0` 为海平面处的大气密度， :math:`k_\rho` 为常值系数。

对于导弹等飞行器而言，升力系数和阻力系数作为攻角和马赫数的函数具有一定的关联性，一般用极曲线描述，简化地，可以
用二次函数表示这种关联，即： 

.. math::
   C_{D}(\alpha, M)=K(M) C_{L}^{2}(\alpha, M)+C_{D 0}(M) \label{2} \tag{2}



---------------
可重复使用火箭
---------------

----------
自动驾驶
----------

----------
机器人
----------
