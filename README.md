[![Build Status](https://travis-ci.com/jlperla/PerlaTonettiWaugh.jl.svg?token=G6ge79qYLosYiRGJBp1G&branch=master)](https://travis-ci.com/jlperla/PerlaTonettiWaugh.jl)

# Overview

This repository has the complete code for the steady-state and transition dynamics of Perla, Tonetti, and Waugh [Equilibrium Technology Diffusion, Trade, and Growth](http://christophertonetti.com/files/papers/PerlaTonettiWaugh_DiffusionTradeAndGrowth.pdf)

The [derivation document](/docs/numerical_algorithm.pdf) has the complete set of equations implemented for the model, where all equation numbers in the code refer to this document.  General code and derivations for upwind finite difference methods are in the [SimpleDifferentialOperators.jl](https://github.com/QuantEcon/SimpleDifferentialOperators.jl) package with [detailed derivations](https://github.com/QuantEcon/SimpleDifferentialOperators.jl/releases/download/dev/discretized-differential-operator-derivation.pdf).

As in the derivation, the code has a "warmup" model without trade or monopolistic competition to understand transition dynamics with this sort of growth model, and for experimenting with the DAE and finite-difference discretization methods.

## Directory of Code
* **/src/full** contains all of the code needed to compute the numerical results presented in the paper, given parameter values. Code to calibrate parameter values will be added at a later date.

## Directory of Results
The following notebooks compute all of the numerical results and figures presented in the paper. These notebooks use code from /src/full.

* **Steady State Analysis**:
    * [Baseline vs. 10%-Lower-Trade-Cost Comparison, Baseline vs. Autarky Comparison, Sampson Calibration, and No GBM Firm Dynamics Calibration](SteadyState.ipynb)
    * [Baseline Local Welfare Change Decomposition](WelfareChangeDecomposition.ipynb)
    * [Upsilon/Delta/Chi Figures](ChiUpsilonDeltaFigures.ipynb) and [Upsilon/Delta/Chi Welfare Decomposition](ChiUpsilonDelta.ipynb)
    * [Zeta Normalization](ZetaNormalization.ipynb)

* **Transition Dynamics**:
    * [Computation and Welfare Gain](TransitionDynamics.ipynb)
    * [Figures](TransitionDynamicsFigures.ipynb)

## Installation and Use

1. Follow the instructions to [install Julia and Jupyter](https://lectures.quantecon.org/jl/getting_started.html)

2. Open the Julia REPL (see the documentation above) and then install the package (by entering package mode with `]`) with

    ```julia
    ] dev https://github.com/jlperla/PerlaTonettiWaugh.jl.git
    ```
    
2a. **Optional**: To install the exact set of packages used here, run the following 

   ```julia 
   ] activate PerlaTonettiWaugh 
   ] instantiate
   ```

3. There are several ways you can run the notebooks after installation

    Using the built-in Jupyter is straightforward.  In the Julia terminal
    ```julia
    using PerlaTonettiWaugh, IJulia
    jupyterlab(dir=pkgdir(PerlaTonettiWaugh))
    ```

   **Note:** If this is the first time running a `jupyterlab()` command inside Julia, it may prompt you to install Julia via conda. Hit `yes`. Also, this will **hand over control of your Julia session to the notebook.** To get it back, hit `control+c` in the Julia REPL.

    Alternatively, to use a separate Jupyter installation you may have installed with Anaconda,
    ```julia
    using PerlaTonettiWaugh
    cd(pkgdir(PerlaTonettiWaugh))
    ; jupyter lab
    ```
    where the last step runs your `jupyter lab` in the shell. **The ; cannot be copy-and-pasted**; to access shell mode, you must type it manually (and you will see your prompt go red.)

    **In either case, the first time the `using` it will be very slow**, as all dependencies need to be precompiled. 

4. In addition to the notebooks mentioned above, there is also the `simple_transition_dynamics.ipynb` notebook to solve the simple warm-up variation of the model (which does not appear in the paper) as described in the notes.

**NOTE:** When using the notebooks for the first time, it will be very slow as the package and its dependencies are all compiled.
