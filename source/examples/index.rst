=========
应用案例
=========

----------
飞行器制导
----------

考虑一个导弹飞行器三维动力学模型：

.. math::
   \begin{align}
     \dot{x}=V \cos \gamma \cos \psi \\
     \dot{y}=V \sin \gamma \\
     \dot{z}=-V \cos \gamma \sin \psi \\
     \dot{V}=-D-\sin \gamma / r^{2}  \\ 
     \dot{\gamma}=-L \cos \sigma / V-\cos \gamma / V r^{2} \\
     \dot{\psi}=-L \sin \sigma / V \cos \gamma
   \end{align}
   :label: missile


.. math::
  \begin{align}
       100 + x &= y  \label{a} \tag{2.1} \\
       \frac{y}{x} &\ge 1.3 \label{b} \tag{2.2}\\
       (100+x)-(100+x)z &= y \label{c} \tag{2.3}
  \end{align}

式 :eq:`missile`  :math:`\eqref{missile}` 中， :math:`(x, y, z)` 为导弹的三维位置， :math:`r = 1 + y` 为导弹质心到地心距离，
:math:`V` 为速度， :math:`γ` 为弹道倾角， :math:`ψ` 为弹道偏角；
射程 :math:`x` 、射高 :math:`y` 以及侧向位置 :math:`z` 通过地球半径 :math:`R0` 进行无量纲化，
速度 V 通过 √g0R0 进行无量纲化，其中， g0 为地球表面的重力加速
度。上述方程对无量纲时间 t 求导，时间 t 通过 pg0/R0 进行无量纲化。 σ 为滚转角；
L = 0.5R0ρV 2SCL/m 为无量纲升力， D = 0.5R0ρV 2SCD/m 为无量纲阻力，其中 S
为导弹的参考面积， m 为弹体质量， q = 12ρV 2 为动压。 ρ = ρ0e−kρh 为大气密度，其中
ρ0 为海平面处的大气密度， kρ 为常值系数。对于导弹等飞行器而言，升力系数和阻力
系数作为攻角和马赫数的函数具有一定的关联性，一般用极曲线描述，简化地，可以
用二次函数表示这种关联，即：:math:`\ref{c}`

---------------
可重复使用火箭
---------------

----------
自动驾驶
----------

----------
机器人
----------
