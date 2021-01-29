using Ipopt, JuMP, Plots

function uxsolve()
    model = Model(with_optimizer(Ipopt.Optimizer, print_level=0))

    a = 1.0 #altura
    b = 3.0 #altura 
    L = 30.0 #tamanho  L = [2.25 2.3 2.5 3.0]
    n = 100 #número de nós de corrente 
    h = 2*L/(n) #distância entre os nós

    @variable(model, x[1:n])

    @variable(model, u[1:n])

    for i = 2:n
    @NLobjective(model, Min, h*((x[i]*sqrt(1 + u[i]^2) + x[i-1]*sqrt(1 + u[i-1]^2)/2)))
    
    @NLconstraint(model, 0.5*h*(sqrt(1 + u[i]) + sqrt(1 + u[i-1])) == L)

    @constraint(model, x[i] - x[i-1] == h*(u[i-1] + u[i])/2)
    end

    @constraint(model, x[1] == a)

    @constraint(model, x[n] == b)

    optimize!(model)

    r, s = value.(x), value.(u)
    return r, s
end

#plot(range(0, 1, length = n + 1), x, m=(3, :blue), leg = false)
#png("L1")
   