%clc
clear
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(03281978)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
growth_r_moments = load('./data/growth_and_r_moments.csv', '-ascii');
bejk_moments = load('./data/bejk_moments.csv', '-ascii');
entry_moments = load('./data/entry_moment.csv', '-ascii');
trade_moments = load('./data/trade_moments.csv', '-ascii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.delta = entry_moments(1,1);
params.zeta = 1.00;
params.gtarget = growth_r_moments(2);
params.rho = growth_r_moments(1) - params.gtarget;

params.mu = 0.0001;
params.upsilon = 0.0001;

load('cal_params')
params.sigma = new_cal(end);

M = 500;
z_bar = 7.0;

addpath('./eq_functions');
addpath('./markov_chain');

% Generating grids and stationary distribution
z = linspace(0, z_bar, M); %The grid, if useful at all.
%The following are invariant as long as M and z are fixed
[L_1_minus, L_2] = generate_stencils(z);

params.zgridL1 = L_1_minus;
params.zgridL2 = L_2;
params.zgridz = z;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.gamma = 1.0001;
params.n = 10; % number of countries
params.eta = 0; % denomination of adaption costs
params.Theta = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% moments...
moments.other_moments = [params.gtarget, trade_moments(1,1), bejk_moments(1,1), bejk_moments(2,1)];

% productivity growth, home share, frac exporters, relative size
params.gtarget = moments.other_moments(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initial_val = [3.4113    5.0590    0.0421    4.5370];

options = optimset('Display','final','MaxFunEvals',5e4,'MaxIter',1e5);

tic
[new_cal, fval] =fminsearch(@(xxx) calibrate_growth(xxx,params,moments,1),initial_val,options);
toc

disp(fval)
disp('Parameter Values')
disp('d, theta, kappa, 1/chi')
disp(new_cal)

all_stuff = calibrate_growth(new_cal,params,moments,0);

disp('Moments: Targets and Model')
disp(all_stuff)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% steady state welfare gain
% params.d = new_cal(1);
% params.theta = new_cal(2);
% params.kappa = new_cal(3);
% params.chi = 1/new_cal(4);
% 
% [baseline, b_welfare] = compute_growth_fun_cal(params);
%     
% high_tau = (new_cal(1)-1).*2.90 + 1;
% params.d = high_tau;
% 
% [counterfact, c_welfare] = compute_growth_fun_cal(params);
%     
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lambda_gain = exp((params.rho).*(c_welfare - b_welfare)) - 1;
% disp('Sampson: S to S welfare loss from autarky')
% disp(100*lambda_gain)
% disp('Sampson: S to S growth, basline and autarky')
% disp([baseline(1), counterfact(1)])
% disp('Sampson: S to S trade, basline and autarky')
% disp([baseline(2), counterfact(2)])
% disp('Sampson: ACR Calculation, Percent Gain')
% disp(100*(1/new_cal(2))*log(baseline(2)/counterfact(2)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
params.d = new_cal(1);
params.theta = new_cal(2);
params.kappa = new_cal(3);
params.chi = 1/new_cal(4);
params.gamma = 1.0;
params.dT = (new_cal(1)-1).*0.90 + 1;


header = {'theta', 'kappa', 'chi', 'mu', 'upsilon', 'zeta', 'delta', 'N', 'gamma', 'eta', 'Theta', 'd_0', 'd_T'};

final_cal = [params.theta, params.kappa, params.chi, params.mu, params.upsilon, params.zeta, params.delta...
    params.n, params.gamma, params.eta, params.Theta,params.d, params.dT];

writecell([header; num2cell(final_cal)],'../../parameters/calibration_no_firm_dynamics.csv')
%writematrix(nofirmdyn_cal,'./output/rellit/calibration_nofirmdyn.csv')

rmpath('./eq_functions');
rmpath('./markov_chain');













