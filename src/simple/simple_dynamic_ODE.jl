# This function generate ODE problem with r,π and ζ and g time varying
function create_dynamic_ODE(params,settings)
    # Unpacking
    gamma=params.gamma;
    sigma=params.sigma;
    #alpha=params.alpha; # used for distribution in value matching
    ζ=params.ζ;
    π=params.π;
    r=params.r;

    # unpacking settings
    z=settings.z;
    M=length(z);
    T=settings.T;
    g=settings.g;
    z, L_1_minus, L_1_plus, L_2  = irregulardiffusionoperators(z, M); #Discretize the operator
    
    mu_tilde(t,x)=gamma.-g(t,x);
    rho_p(t,x)=r(t,x).-g(t,x);

        #Check upwind direction

        if all(mu_tilde.(0.0, z) .>= 0)
            p = @NT(L_1 = L_1_plus, L_2 = L_2, z = z, rho_p = rho_p, mu_tilde = mu_tilde, sigma = sigma, π=π, T = T) #Named tuple for parameters.
        elseif all(mu_tilde.(0.0, z) .<= 0)
            p = @NT(L_1 = L_1_minus, L_2 = L_2, z = z, rho_p = rho_p, mu_tilde = mu_tilde, sigma = sigma, π=π, T = T) #Named tuple for parameters.
        else 
            error("Not weakly positive or negative") # Not strictly necessary, but good to have redundancy here.
        end
    #Calculating the stationary solution,
    L_T = Diagonal(rho_p(T,z)) - Diagonal(mu_tilde.(T, z)) * p.L_1 - Diagonal(sigma.(T, z).^2/2.0) * L_2
    u_T = L_T \ π.(T, z)
    @assert(issorted(u_T))

    function f(du,u,p,t)
        L = (Diagonal(rho_p(T,z)) - Diagonal(p.mu_tilde.(t, z)) * p.L_1 - Diagonal(p.sigma.(t, p.z).^2/2.0) * p.L_2)
        A_mul_B!(du,L,u)
        du .-= p.π.(t, p.z)
    end

    #Checks on the residual
    du_T = zeros(u_T)
    f(du_T, u_T, p, T)
    @show norm(du_T)
    @assert norm(du_T) < 1.0E-10

    return ODEProblem(f, u_T, (T, 0.0), p)

end