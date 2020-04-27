### README for code associated with calibration, plotting of output, and robustness results of AER Perla, Tonetti, and Waugh (2020)

All in matlab or python with the associated jupyter notebooks.
- [Create calibration moments](#calibration)
- [Master calibration file](#master)
- [Structure of main calibration file ``calibration_wrap``](#cal_func)
- [Plotting transition path results](#plot_trans)
- [Robustness exercises](#robust)

---
#### <a name="calibration"></a> Calibration Moments

This is all described and pulled either from the SLBD or directly from online sources (need to print date) like FRED or bls. In the note book [``calibration_targets_results.ipynb``](calibration_targets_results.ipynb). This file will output several ``.csv`` files which are then the calibration code reads in. The files our outputed to the ``data/`` folder. The files are:

- [``data/growth_and_r_moments.csv``](data/growth_and_r_moments.csv) are the measured productivity growth and real interest generate

- [``data/firm_moments.csv``](data/firm_moments.csv) are the firm transition dynamic moments.

- [``data/bejk_moments.csv``](data/bejk_moments.csv) are the BEJK exporter and relative size moments.

- [``data/trade_moments.csv``](data/trade_moments.csv) is the trade share moment.

- [``data/entry_moment.csv``](data/entry_moment.csv) is the entry moment.

---
#### <a name="master"></a> Master file

The file to run all calibration and robustness results is [``master_calibration.m``](master_calibration.m). In MATLAB, just run
```
>> master_calibration
```
which will run everything, print the results, and generate the appropriate files for plotting or analysis.

---
#### <a name="cal_func"></a> Structure of main calibration file [``calibration_wrap.m``](calibration_wrap.m)

The file [``calibration_wrap.m``](calibration_wrap.m) calibrates the model and computes steady state to steady state results. Transition dynamics are all in julia and described [here]().

The file ``calibration_wrap.m`` does the following:

**1.** Reads in the moments that are generated from the python notebook described above in [create calibration moments](#calibration)

**2.** Minimizes the distance between the data moments and model moments. Code computing the model moments is organized in the following way:

  - [``calibrate_growth.m``](calibrate_growth.m) organizes parameters, passes them to the function to retrieve model moments, then constructs the objective function the calibration is minimizing. The moments are stacked in the following order:

    - g, lambda_{ii}, fraction of exporters, size of exporters vs non exporters, and then the quantile moments (note how these are passed through) into vector form.

    - Then line 47 describes the exact objective function used. This is just the standard GMM objective with an identity matrix. It looks like I scaled the diagonals to be 100, this should not matter.


  -  <a name="main_file"></a> [``compute_growth_fun_cal.m``](compute_growth_fun_cal.m) takes in parameters, compute equilibrium, the moments, and welfare. The following functions perform these operations.

  - [``eq_functions/calculate_equilibrium.m``](eq_functions/calculate_equilibrium.m) finds an equilibrium.

  - [``eq_functions/selection_gbm_constant_Theta_functions.m``](eq_functions/selection_gbm_constant_Theta_functions.m) are the equilibrium functions which map to equations in the paper.

  - [``static_firm_moments.m``](static_firm_moments.m) Computes the BEJK moments, fraction of exporters and then the relative size of domestic shipments for exporters vs non-exporters.

  - [``markov_chain/generate_transition_matrix.m``](markov_chain/generate_transition_matrix.m) constructs the transition matrix across productivity states. **Note** that the code [``markov_chain/generate_stencils.m``](markov_chain/generate_stencils.m) is required to generate the grid. This is called before the calibration routine since it is kept constant.

  - [``markov_chain/coarsen_to_quintiles_four.m``](markov_chain/coarsen_to_quintiles_four.m) maps the transition matrix into a four by four matrix over a 5 year horizon to match up with data moments.

**3.** Given the calibration results, several things happen:

- A file [``/parameters/calibration_params.csv``](/parameters/calibration_params.csv) is created with the calibrated parameters. 

- An associated ``.mat`` file ``cal_params.mat`` is generated for use within matlab. The variable ``new_cal`` has the values in the in the following order: d, theta, kappa, 1/chi, mu, upsilon, sigma.

- Across steady state results are presented. To compute across steady state results the code [``compute_growth_fun_cal``](compute_growth_fun_cal.m) is called with the appropriately changed parameter values.

---
#### <a name="robust"></a> Main robustness calculations

In the paper we have a set of figures (insert numbers) that reports how things change as we vary the GBM parameters $\mu$ and $\upsilon$ and $\delta$.

- **Changes in $\delta$** The code that creates the underlying data for figure XX is:

  - [``robust_no_recalibrate_delta``](robust_no_recalibrate_delta). This reads in ``cal_params.mat`` generated from the calibration routine and then works through a several loops. First it changes $\chi$ by a scale value, then for the given $\chi$ it changes delta. The main file it calls is [``compute_growth_fun_cal.m``](#main_file). The output are a several ``.mat`` files that are labeled the following way

  - [``/output/robust/delta/param_values_delta_xx``](/output/robust/delta/) where ``xx`` is the scale value used for a given run of different $\delta$s. Each row shows the growth rate, baseline parameter values, then $\mu$, $\upsilon$, $\sigma$, $\delta$ for that given run.

  - [``/output/robust/delta/norecalibrate_values_delta_xx``](/output/robust/delta/) where ``xx`` is the scale value for the given run. Each row shows the growth rate, counterfactual growth rate, difference, welfare gain, and the associated $\delta$.

- **Changes in $\mu$ and $\upsilon$** The code that creates the underlying data for figure XX is:
  - [``robust_no_recalibrate_gbm``](robust_no_recalibrate_gbm). This reads in ``cal_params.mat`` generated from the calibration routine and then works through a several loops. First it changes $\chi$ by a scale value, then for the given $\chi$ it changes $\mu$ and $\upsilon$ by a common scale value. The main file it calls is [``compute_growth_fun_cal.m``](#main_file). The output are a several ``.mat`` files that are labeled the following way

  - [``output/robust/gbm/param_values_gbm_xx.mat``](output/robust/gbm/) where ``xx`` is the scale value used for a given run of different $\delta$s. Each row shows the growth rate, baseline parameter values, then $\mu$, $\upsilon$, $\sigma$, $\delta$ for that given run.

  - [``output/robust/gbm/norecalibrate_values_gbm_xx.mat``](output/robust/gbm/) where ``xx`` is the scale value for the given run. Each row shows the growth rate, counterfactual growth rate, difference, welfare gain, and the associated $\delta$.

  - [``/parameters/calibration_chi_XX.csv``](/parameters/) report the parameter values which for a given $\chi$ result in a growth rate which is closest to the targeted growth rate of 0.79.

- **Robustness to changes in scaling parameter $\zeta$** This code is exactly the same as [``calibration_wrap.m``](calibration_wrap.m) with the only difference being that alternative $\zeta$s are fixed and loop over different calibrations is performed over the different $\zeta$s. The output is

  - [``/parameters/calibration_zeta_xx.csv``](/parameters/) where ``xx`` is the scale value for the given run and each ``.mat`` files contains the parameter values


- **Comparison to Sampson (2016)** This code recalibrates the model targeting moments along the lines of Sampson (2016) and dynamics from GBM are shut down. The code [``calibration_wrap_sampson.m``](calibration_wrap_sampson.m) performs the calibration. The underlying code and structure is exactly the same as in the main calibration code [``calibration_wrap.m``](calibration_wrap.m).

  - [``/parameters/calibration_sampson.csv``](/parameters/calibration_sampson.csv) reports the resulting parameter values


- **No Firm Dynamics** This code recalibrates the model with GBM are shut down. The code [``calibration_wrap_no_firm_dynamics.m``](calibration_wrap_no_firm_dynamics.m) performs the calibration. The underlying code and structure is exactly the same as in the main calibration code [``calibration_wrap.m``](calibration_wrap.m).

  - [``/parameters/calibration_nofirmdyn.csv``](/parameters/calibration_nofirmdyn.csv) reports the resulting parameter values.
