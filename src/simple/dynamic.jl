# DAE kernel, defined for each time ∈ t.
function f!_simple(resid,du,u,p,t)
    @unpack Ξ₁, L_1, L_2, z, r, μ, g, υ, π, T, P, x, ω = p
    # Carry out calculations.
    v_t = u[1:P]
    g_t = u[P+1]
    A = (r(t) - μ - υ^2/2)*I - (μ + υ^2 - g_t)*L_1 - υ^2/2 * L_2 # (17)
    # Calculate residuals.
    resid[1:P] .= A * v_t - π.(t, z) # (26)
    resid[1:P] .-= du[1:P] # discretized system of ODE for v (26)
    resid[P+1] = Ξ₁*v_t[1] - dot(ω, v_t) + x(t) # value matching condition (27)
end

# DAE constructor
function simpleDAE(params, settings)
    # Unpack necessary objects
    @unpack μ, υ, θ, r, x, π = params
    @unpack z_ex, T, g = settings
    
    @assert z_ex[1] == 0.0 && issorted(z_ex) # validate grid 
    z = z_ex[2:end-1]
    P = length(z)

    # Quadrature weighting
    ω = ω_weights(z_ex, θ, 1)

    # Everything to follow will use z instead of z_ex 
    # Differential objects
    bc = (Mixed(1), Mixed(1)) # boundary conditions for differential operators
    L_1_minus = L₁₋(z, bc) # use backward difference as the drift is negative
    L_2 = L₂(z, bc) 

    # Calculate the stationary solution.
    r_T = r(T)
    g_T = g(T)
    A_T = (r_T - μ - υ^2/2)*I - (μ + υ^2 - g_T)*L_1_minus - υ^2/2 * L_2 # (17)
    v_T = A_T \ π.(T, z) # (24)
    
    # Bundle as before.
    Ξ₁ = 1/(1 - ξ*(z[1] - 0.0)) # (A.11)
    p = (Ξ₁ = Ξ₁, L_1 = L_1_minus, L_2 = L_2, z = z, g = g, r = r, υ = υ, π = π, T = T, μ = μ, g_T = g_T, P = P, x = x, ω = ω)
    
    # Other objects
    u_T = [v_T; g_T]
    resid_M1 = zeros(P+1)
    return DAEProblem(f!_simple, resid_M1, u_T, (T, 0.0), differential_vars = [fill(true, P); false], p)
end

# Calculate residuals given diffeq problem and primitives
function calculate_residuals(ode_prob, x, ω, ode_solve_algorithm, ts) # To keep the params consistent with other tuples.
    # Solve ode
    sol = Sundials.solve(ode_prob, ode_solve_algorithm, tstops = ts)
    P = length(ω)
    # Calculate the residual at each time point
    residuals = zeros(length(ts))
    v_ts = zeros(P, length(ts))
    g_ts = zeros(length(ts))
    for (i, t) in enumerate(ts)
        v_t = sol(t)[1:P] # i.e., the value function at the point.
        # TODO: FIGURE OUT BEST WAY TO PASS in Ξ₁ TO THIS FUNCTION 
        residuals[i] = Ξ₁*v_t[1] + x(t) - dot(ω, v_t) # value matching condition (27)
        v_ts[:,i] = v_t
        g_ts[i] = sol(t)[end]
    end
    return (residuals = residuals, v_ts = v_ts, g_ts = g_ts)
end
