=========
代码生成
=========

OPTIMake的代码生成使用远程云资源和本地软件两种工具，其中云代码生成提供在线界面和模型文件上传两种形式。
OPTIMake.CodeGen 专门为需要高效求解的在线MPC问题定制和生成快速自定义代码。
只需很少且简单的描述性代码，就可以将数学问题描述转化为高效的求解器。

使用CVXGEN描述您的QP或NLP
用一种简单、强大的语言描述你的小的、二次规划（QP）可表示的问题。

- 自动生成自定义解算器

OPTIMake.CodeGen自动为自定义高速解算器创建无库C代码。这可以立即下载和使用，只需要一个C编译器。
OPTIMake.CodeGen还将提供了一个Matlab函数，该函数只需一个命令即可下载并构建自定义的Matlab-mex求解器。

- 解决问题的速度高达10000倍

OPTIMake.CodeGen离线执行大多数转换和优化，以使在线求解尽可能快。
代码生成需要几秒钟或几分钟的时间，生成的解算器工作时间为微秒或毫秒。
与IPOPT相比，解决时间通常至少快20倍，最小的问题显示速度高达10000倍。

- 局限性

OPTIMake.CodeGen仅适用于QP、QCQP或NLP等可表示的优化控制问题。
考虑到当前应用范围，它最适用于小规模的在线规划和决策场景，其中最终得到的动态优化系统的决策变量、约束受到一定限制。
对于大规模的在线优化任务OPTIMake不能很好地解决和平衡效率和求解最优性之间的矛盾。

代码生成
-----------------
我们首先给出个简单的QP问题的代码生成案例，介绍模型定义基本的组成。

.. code-block:: python
   :caption: Code Generation for 1-stage QP
   :linenos:
   :emphasize-lines: 1,3,6,13,18

   prob = multi_stage_problem('qp', 1)
    
   lv1, uv1, lv2, uv2 = prob.parameters(['lv1', 'uv1', 'lv2', 'uv2'])
   q1, q2, lh, uh = prob.parameters(['q1', 'q2', 'lh', 'uh'])
   
   v1 = prob.variable('v1', hard_lowerbound=lv1, hard_upperbound=uv1)
   v2 = prob.variable('v2', hard_lowerbound=lv2, hard_upperbound=uv2)
   
   Q = [[1.0, 0.0], 
        [0.0, 0.5]]
   q = [q1, q2]
   
   obj = quadratic_objective(Q, q)
   prob.objective(obj)
   
   prob.inequality(v1 + v2, hard_lowerbound=lh, hard_upperbound=uh)
   
   eq = discrete_equation(
       this_stage_expr=[v1],
       next_stage_expr=[0.6])
   prob.equality(eq)
   
   option = codegen_option()
   option.server = 'http://127.0.0.1:8888'
   
   codegen = pdipm_generator()
   # codegen = code_generator()
   
   codegen.codegen(prob, option)

第1行定义问题对象 ``qp`` ，并且指定stage个数为1。OPTIMake.Arts之所以具有很高的在线求解效率，重要一点就是问题变量维度和结构固定。
因此在问题定义阶段就需要指定MPC问题的预测阶段数。

第3行中函数 ``parameters(...)`` 用于定义问题参数，这些参数在Arts中是可变的，将在求解前由用户设置。

第6行函数 ``variable(...)`` 定义了问题的状态或控制变量，为了简化约束表达，OPTIMake允许用户在定义变量的同时指定变量的上线界。
需要注意的是，这里的状态变量具体的离散个数已经由问题定义阶段设置。因此后续有关状态的约束和cost定义，如无特殊函数均对每个stage上的状态量执行像相同的操作。

第13行通过指定目标函数的参数类型来定义目标函数。

第16行定义一般的不等式约束，第一个参数是约束的表达式，后面两个入参为具体约束的上下界。
第18行定义等式约束，OPTIMake模型定义中，除了可以通过变量运算定义每个stage的等式约束表达，还可以通过指定差分方程表达定义当前stage和下一stage的约束。

23行则通过指定服务器相关参数，调用云端资源进行模型分析和代码生成，最后29行输出高度功能内聚的求解器。




本地模型验证
-----------------


测试工具
-----------------


