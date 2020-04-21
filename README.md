[![Build Status](https://travis-ci.com/jlperla/PerlaTonettiWaugh.jl.svg?token=G6ge79qYLosYiRGJBp1G&branch=master)](https://travis-ci.com/jlperla/PerlaTonettiWaugh.jl)

### Overview

This repository has the complete code for the calibration, steady-state analysis, and transition dynamics of Perla, Tonetti, and Waugh [Equilibrium Technology Diffusion, Trade, and Growth](http://christophertonetti.com/files/papers/PerlaTonettiWaugh_DiffusionTradeAndGrowth.pdf)

The [derivation document](/docs/numerical_algorithm.pdf) has the complete set of equations implemented for the model, where all equation numbers in the code refer to this document.  General code and derivations for upwind finite difference methods are in the [SimpleDifferentialOperators.jl](https://github.com/QuantEcon/SimpleDifferentialOperators.jl) package with [detailed derivations](https://github.com/QuantEcon/SimpleDifferentialOperators.jl/releases/download/dev/discretized-differential-operator-derivation.pdf).

As in the derivation, the code has a "warmup" model without trade or monopolistic competition to understand transition dynamics with this sort of growth model, and for experimenting with the DAE and finite-difference discretization methods.

---
### Directory of Code

* **[/src/full](/src/full)** contains all of the code needed to compute the numerical results presented in the paper, given parameter values.

* **[/src/calibration](/src/calibration)** Code to create moments and calibrate the model to match those moments. Parameter values are outputs. [Readme file](/src/calibration/README.md) describes this section of code in complete detail.

---
### Directory of Notebooks for Results in Paper

The following notebooks compute all of the quantitative results and figures presented in the paper. They are organized by Section in accordance with the NBER working paper version.

- **[Section 7-1: Calibration](section_7-1.ipynb)** jupyter (python) notebook which direct pulls data and constructs moments for the calibration of the PTW model. Output are moments as ``.csv`` files which are then read in during the calibration routine.

- **[Section 7-2: Calibration Results](section_7-2.ipynb)** jupyter (python) notebook which calls the MATLAB code to implement the calibration procedure which finds parameter values such that moments in model best fit moments in data. Output is at [``/parameters/calibration_params.csv``](/parameters/calibration_params.csv) which contains the parameter values in the with headers for each column describing the associated parameter.

- **[Section 7.3 The Sources of the Welfare Gains from Trade—A Quantitative Decomposition](section_7-3.ipynb)** jupyter (julia) notebook that performs the local welfare decomposition and results associated with the surrounding discussion in the paper. 

- **[Section 7.4 The Welfare Effects of a Reduction in Trade Costs](section_7-4_main.ipynb)** jupyter (python) notebook which (i) calls julia notebook [TransitionDynamics.ipynb](TransitionDynamics.ipynb) and computes the transition dynamics of the economy and (ii) plots the results to match up with Figures 1-5 of paper.

- **[Section 7.4 The Welfare Effects of a Reduction in Trade Costs, Further Analysis](section_7-4_more.ipynb)** jupyter (python) notebook which (i) performs calibration routines by calling MATLAB routines and (ii) computes welfare gains (by calling julia notebook [SteadyState.ipynb](SteadyState.ipynb)) for alternatives (ACR, Sampson, Atkenson and Burstein, No GBM).

- **[Section 7.5. The Role of Firm Dynamics and Adoption Costs](section_7-5.ipynb)** jupyter notebook (i) which calls MATLAB code to generate results for different GBM and delta shock parameter values and (ii) plots the results corresponding with Figure 6 and 7 of the paper.

---
### Installation and Use

1. Follow the instructions to [install Julia and Jupyter](https://lectures.quantecon.org/jl/getting_started.html)

2. Open the Julia REPL (see the documentation above) and then install the package (by entering package mode with `]`) with

    ```julia
    ] add https://github.com/jlperla/PerlaTonettiWaugh.jl.git
    ```

   2a. **Optional, but strongly encouraged**: To install the exact set of packages used here (as opposed to using existing compatible versions on your machine), first run the following in the REPL

      ```julia
      using PerlaTonettiWaugh # will be slow the first time, due to precompilation
      cd(pkgdir(PerlaTonettiWaugh))
      ```
      Then, enter the package manager in the REPL  (**note** that `]` cannot be copy-pasted on OSX; you need to type it to enter the REPL mode.)
      ```julia
      ] activate .; instantiate
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
