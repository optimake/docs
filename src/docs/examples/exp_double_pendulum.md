# Double Inverted Pendulum on a Cart

!!!example
	`DoubleInvertedPendulum/`
	
!!! quote "Where you can find this pendulum"
	A. Bogdanov, “Optimal control of a double inverted pendulum on a cart,” Oregon Health and Science University, Tech. Rep. CSE-04-006, OGI School of Science and Engineering, Beaverton, OR, 2004.
	
## Problem Description

Swing-up control of a double inverted pendulum on a cart is a benchmark problem for NMPC algorithms due to its high nonlinearity. 
The pendulum we want to swing up is:

<p align="center">
<img src="../dipc.png" width="300px" >
</p>

* The state vector of the system is $x =  [\theta_0,\dot{\theta}_0  , \theta_1 ,\dot{\theta}_1 ,\theta_2  ,\dot{\theta}_2]^{T}$, where $\theta_0$ is the displacement of the cart, and where $\theta_1$, $\theta_2$ are the pendulum angles.

* The control force $u$ is constrained with  $|u|\leq 10$.

* The system is modeled as $D(\theta)\ddot{\theta}+C(\theta,\dot{\theta})\dot{\theta}+G(\theta)=Hu$ with $\theta=[\theta_0,\theta_1,\theta_2]^T$.

* A terminal penalty function is imposed to swing up the pendulum.

The task is to swing up the pendulum from the initial state $x_0 =  [0,\pi,\pi,0,0,0]^{T}$.

## OCP in **`OPTIMake`** 

The underlying OCP defined in **`OPTIMake`** is formulated as:

* State: $x=[\theta_0,\dot{\theta}_0, \theta_1 ,\dot{\theta}_1 ,\theta_2  ,\dot{\theta}_2]^T=[\theta,\dot{\theta}]^T$.
* Input: $u$ with $u_{max} = 10$ and $u_{min} = -10$.
* Parameter: $p=[Q_d,R_d,\gamma]$.
* $L(u,x,p)  = \frac{1}{2}\|x\|_{Q}^2+\frac{1}{2}\|u\|_{R}^2$ with $Q=\text{diag}(Q_d)$ and $R=\text{diag}(R_d)$.

* $f(u,x,p)=[\dot{\theta};Hu-G(\theta)-C(\theta,\dot{\theta})\dot{\theta}]$.

* $M(u,x,p) = \text{blkdiag}(\text{eye(3)},D(\theta))$.

* Prediction horizon $T=1.5$.
* Number of the discritization grids $N=48$.
* Discretization method: Euler.

## Closed-loop Simulation using **`OPTIMake`** 

### Step 1. NMPC problem formulation
See [Workflow of OPTIMake > NMPC Problem Formulation](workflow.md#nmpc_formulation).

!!!example
	`DoubleInvertedPendulum/NMPC_Problem_Formulation.m`
	

### Step 2. Code generation and deployment in Simulink
See [Workflow of OPTIMake > Code Generation and Deployment > Simulink](workflow.md#workflow_deploy_simulink).

1. Code generation

	!!!example
		`DoubleInvertedPendulum/Simu_Simulink_Setup.m`
	
2. Deployment

	!!!example
		`DoubleInvertedPendulum/Simu_Simulink.slx`
