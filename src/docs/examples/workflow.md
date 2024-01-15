# Workflow of ParNMPC

## Preparation
1. Choose a compiler that supports code generation with OpenMP by `mex -setup`.
2. Edit `Timer.m` to specify your own timer function.

## NMPC Problem Formulation <div id="nmpc_formulation"></div>

!!!example
	`./NMPC_Problem_Definition.m`

1. Formulate an OCP using Class `OptimalControlProblem`
```Matlab
% Create an OptimalControlProblem object
OCP = OptimalControlProblem(muDim,... % constraints dim
                            uDim,...  % inputs dim
                            xDim,...  % states dim
                            pDim,...  % parameters dim (position reference)
                            T,...     % prediction horizon
                            N);  	  % num of discritization grids
							
% Give names to x, u, p (optional)							
[~] = OCP.setStateName(~);
[~] = OCP.setInputName(~);
[~] = OCP.setParameterName(~);

% Reset the prediction horizon T 
% (optional for variable horizon or nonuniform discretization)
OCP.setT(~);

% Set the dynamic function f
OCP.setf(~);

% Set the matrix M (optional for, e.g., Lagrange model)
OCP.setM(~);

% Set the equality constraint function C (optional)
OCP.setC(~);

% Set the cost function L
OCP.setL(~);

% Set the bound constraints (optional)
OCP.setUpperBound('u',~);
OCP.setLowerBound('u',~);
OCP.setUpperBound('x',~);
OCP.setLowerBound('x',~);

% Set the polytopic constraint G (optional)
OCP.setG(~);
OCP.setUpperBound('G',~);
OCP.setLowerBound('G',~);

% Generate necessary files
OCP.codeGen();
```

2. Configrate the solver using Class `NMPCSolver`
```Matlab
% Create a NMPCSolver object
nmpcSolver = NMPCSolver(OCP);

% Configurate the Hessian approximation method
nmpcSolver.setHessianApproximation(~);

% Generate necessary files
nmpcSolver.codeGen();
```

3. Solve the very first OCP for a given initial state and given parameters using Class `OCPSolver`
```Matlab
% Set the initial state		
x0 = [~];

% Set the parameters		
par = [~];

% Create an OCPSolver object
ocpSolver = OCPSolver(OCP,nmpcSolver,x0,par);

% Choose one of the following methods to provide an initial guess:
% 1. init guess by input
lambdaInitGuess = [~];
muInitGuess     = [~];
uInitGuess      = [~];
xInitGuess      = [~];
% 2. init guess by interpolation
[lambdaInitGuess,muInitGuess,uInitGuess,xInitGuess] = ...
    ocpSolver.initFromStartEnd(~);
% 3. init guess from file
[lambdaInitGuess,muInitGuess,uInitGuess,xInitGuess] = ...
                        ocpSolver.initFromMatFile(~);

% Solve the OCP						
[lambda,mu,u,x] = ocpSolver.OCPSolve(lambdaInitGuess,...
									 muInitGuess,...
									 uInitGuess,...
									 xInitGuess,...
									 method...
									 maxIter);
											  
% Get the dependent variable LAMBDA
LAMBDA = ocpSolver.getLAMBDA(x0,lambda,mu,u,x,par);

% Check the cost % (optional)
cost = ocpSolver.getCost(u,x,par); 

% Save to file for further use
save GEN_initData.mat  ...
     x0 lambda mu u x par LAMBDA ~
```

4. Define the controlled plant using Class `DynamicSystem` (optional for simulation)
```Matlab
% Create a DynamicSystem object
plant = DynamicSystem(uDim,xDim,pDim);

% Give names to x, u, p (optional)
[~] = plant.setStateName(~);
[~] = plant.setInputName(~);
[~] = plant.setParameterName(~);

% Set the dynamic function f
plant.setf(~);

% Set the matrix M (optional for, e.g., Lagrange model)
plant.setM(~);

% Generate necessary files
plant.codeGen();
```

Configuration Table:

|   |  Configurable discretization method |  Configurable Hessian approximation method |
|---|---|---|
| `M` enabled  |  `'Euler'` | `'GaussNewton'`  |
| `M` disabled  | `'Euler'`, `'RK4'`  | `'Newton'`, `'GaussNewton'` when `'Euler'`;<br>`'GaussNewton'` when `'RK4'`; |

## Code Generation and Deployment

### MATLAB
	
Here, assume your closed-loop simulation is performed in `Simu_Matlab.m`.

!!!example
	`./Simu_Matlab.m`
	
#### Code generation

!!! example
	`./Simu_Matlab_Codegen.m`

1. Declare global variables as constants:
```Matlab
global discretizationMethod isMEnabled ...
       uMin uMax xMin xMax GMax GMin ...
       veryBigNum
   
globalVariable = {'discretizationMethod',coder.Constant(discretizationMethod),...
                  'isMEnabled',coder.Constant(isMEnabled),...
                  'uMax',coder.Constant(uMax),...
                  'uMin',coder.Constant(uMin),...
                  'xMax',coder.Constant(xMax),...
                  'xMin',coder.Constant(xMin),...
                  'GMax',coder.Constant(GMax),...
                  'GMin',coder.Constant(GMin),...
                  'veryBigNum',coder.Constant(veryBigNum)};
```

2. Generate code using `codegen`:
```Matlab
codegen -config:lib Simu_Matlab -globals globalVariable 
```
C code will be automatically generated to `./codegen/lib/Simu_Matlab`.

#### Deployment in Visual Studio

1. Create an empty Win32 Console Application project.

2. Change to Release x64 mode.

3. Add  `*.h` and `*.c` files in `.\codegen\lib\Simu_Matlab` to the project.

4. Add  `main.h` and `main.c` in `.\codegen\lib\Simu_Matlab\examples` to the project.

5. Add directory `.\codegen\lib\Simu_Matlab` to **Properties > C/C++ > General >  Additional Include Directories**.

6. **Properties > C/C++ > Language >  Open MP Support: Yes (/openmp)**.

7. Compile and run.


### Simulink <div id="workflow_deploy_simulink"></div>
Here, assume your closed-loop simulation is performed in Simulink. You can call the generated C/C++ solver function `NMPC_Iter` directly to compute the optimal input.

#### Code generation

!!! example
	`./Simu_Simulink_Setup.m`
	
1. Define the degree of parallelism:
```Matlab
DoP = ~; % degree of parallism: 1 = in serial, otherwise in parallel
```

2. Split $\{\lambda_i\}_{i=1}^{N}$, $\{\mu_i\}_{i=1}^{N}$, $\{u_i\}_{i=1}^{N}$, $\{x_i\}_{i=1}^{N}$, $\{p_i\}_{i=1}^{N}$, and $\{\Lambda_i\}_{i=1}^{N}$ along the prediction horizon into `DoP` pieces:
```Matlab
sizeSeg     = N/DoP;
lambdaSplit = reshape(lambda, lambdaDim,  sizeSeg,DoP);
muSplit     = reshape(mu,     muDim,      sizeSeg,DoP);
uSplit      = reshape(u,      uDim,       sizeSeg,DoP);
xSplit      = reshape(x,      xDim,       sizeSeg,DoP);
pSplit      = reshape(par,    pDim,       sizeSeg,DoP);
LAMBDASplit = reshape(LAMBDA, xDim, xDim, sizeSeg,DoP);
```

3. Generate dll (lib or mex) and copy it to the working directory:
```Matlab
args_NMPC_Iter = {x0,...
				  lambdaSplit,...
				  muSplit,...
				  uSplit,...
				  xSplit,...
				  pSplit,...
				  LAMBDASplit};
NMPC_Iter_CodeGen('dll','C',args_NMPC_Iter);
copyfile('./codegen/dll/NMPC_Iter/NMPC_Iter.dll');
```

#### Deployment

!!!example
	`./Simu_Simulink.slx`
	
!!! note
	This example shows how to call the generated C interface in Simulink using the `coder.cevel` function within a `MATLAB Function` block. 
	You can also call the C/C++ interface using S-function.
	 
1. Open the Simulation Target pane in the Simulink Editor:
**Simulation > Model Configuration Parameters > Simulation Target**.

2. Add `#include "NMPC_Iter.h"` to **Insert custom C code in generated: Header file**.

3. Add the following directory to **Additional Build Information: Include directories**:
```Matlab
./codegen/dll/NMPC_Iter
```

4. Add `NMPC_Iter.lib` to **Additional Build Information: Libraries**.

5. Call the generated C function in a `MATLAB Function` block in Simulink:
```Matlab
coder.ceval('NMPC_Iter',...
			 x0,...
			 coder.ref(lambdaSplit),...
			 coder.ref(muSplit),... (optional)
			 coder.ref(uSplit),...
			 coder.ref(xSplit),...
			 coder.ref(pSplit),...  (optional)
			 coder.ref(LAMBDASplit),...
			 coder.wref(cost),...
			 coder.wref(error),...
			 coder.wref(timeElapsed));
```


## Accelerating Simulation using MEX-function

1. Code generation

	!!!example
		`./Simu_Simulink_Setup.m`

	Following the code generation for Simulink procedure, MEX-function can be generated by modifying the generation target to `mex`:
	```Matlab
	NMPC_Iter_CodeGen('mex','C',args_NMPC_Iter);
	```
	
2. Deployment

	!!!example
		`./Simu_Matlab.m`
		
	Modify `NMPC_Iter` to `NMPC_Iter_mex` to call the generated `mex` function:
	```Matlab
	[lambdaSplit,muSplit,uSplit,xSplit,...
	 LAMBDASplit,cost,error,timeElapsed] =
	 NMPC_Iter_mex(x0,lambdaSplit,muSplit,...
				   uSplit,xSplit,pSplit,...
				   LAMBDASplit);
	```
	and run.

	MEX-function is typically slower than C code. However, it can speed up your simulation to check the closed-loop response.

## File Dependency

<p align="center">
<img src="../P_F_D.png"  >
</p>

Legend：
<p align="center">
<img src="../P_F_D_exp.png"  width="500px">
</p>

## Advanced Functions

* From the file dependency, you can even edit directly, e.g., `OCP_F_Fu_Fx`, to specify your own dynamic function $F(u,x,p)$, and its Jacobians $\partial F/\partial u$ and $\partial F/\partial x$ rather than using the auto-generated `OCP_GEN_~.m`.

* Currently, only the 4-th order Runge-Kutta method is provided to simulate the controlled plant. You can also program your own method by calling `SIM_GEN_~.m`.