parameter_defaults = @with_kw (ρ = 0.02,
                                σ = 3.9896,
                                N = 10,
                                θ = 4.7060,
                                γ = 1.00,
                                κ = 0.0103,
                                ζ = 1.,
                                η = 0.,
                                Theta = 1,
                                χ = 0.4631,
                                υ = 0.0755,
                                μ = 0.,
                                δ = 0.053,
                                d_0 = 3.0700,
                                d_T = 2.5019,
                                d = d_T,
                                d0 = 3.07)

# some default settings
settings_defaults = @with_kw (z_max = 5,
                                z = unique([range(0., 0.1, length = 400)' range(0.1, 1., length = 400)' range(1., z_max, length = 100)']),
                                Δ_E = 1e-6,
                                iterations = 2,
                                ode_solve_algorithm = CVODE_BDF(),
                                g_node_count = 30,
                                T = 40.0,
                                t = range(0.0, T, length = 10),
                                g = LinearInterpolation(t, stationary_numerical(parameter_defaults(), z).g .+ 0.01*t),
                                E_node_count = 15,
                                entry_residuals_nodes_count = 15,
                                transition_x0 = [-0.9292177397159866, -0.7943649969667788, -0.6074874641357887, -0.49189979684672824, -0.3347176170032159, -0.24481769383592616, -0.24481769383592616, -0.12833092365907556, -0.08936576264703058, -0.07942433422192792, -0.05398997533585611, -0.041889325410586, -0.02836357671136145, -0.02836357671136145],
                                fifty_node_iv = [-0.929218, -0.89344, -0.857663, -0.821886, -0.782924, -0.733344, -0.683764, -0.634184, -0.593334, -0.562668, -0.532002, -0.501336, -0.46303, -0.421328, -0.379627, -0.337925, -0.312701, -0.28885, -0.264999, -0.244818, -0.244818, -0.244818, -0.244818, -0.232931, -0.202027, -0.171122, -0.140217, -0.121969, -0.111632, -0.101294, -0.0909562, -0.087134, -0.0844965, -0.081859, -0.0789053, -0.0721574, -0.0654095, -0.0586616, -0.0530022, -0.0497918, -0.0465814, -0.043371, -0.0399571, -0.0363686, -0.0327801, -0.0291917, -0.0283636, -0.0283636, -0.0283636, -0.0283636],
                                continuation_x0 = zeros(length(transition_x0))
                                transition_lb = -ones(length(transition_x0)),
                                transition_ub = zeros(length(transition_x0)),
                                transition_iterations = 1000,
                                transition_weights = [fill(15, 3); fill(1, entry_residuals_nodes_count-3)],
                                transition_penalty_coefficient = 0.0, # coefficient to be used for a penalty function for constraints on increasing E
                                tstops = nothing)
