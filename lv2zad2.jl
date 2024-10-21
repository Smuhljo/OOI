using JuMP, GLPK

m=Model(GLPK.Optimizer)
@variable(m, p1>=0)
@variable(m, p2>=0)
@variable(m, p3>=0)
@objective(m, Max, 2p1 + 3p2 + p3)
@constraint(m, constraint1, 2p1 + 2p2 + 2p3 <= 4)
@constraint(m, constraint2, 3p1 + 3p2 <= 2)
@constraint(m, constraint3, p2 + p3 <= 3)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("p1 = ", value(p1))
println("p2 = ", value(p2))
println("p3 = ", value(p3))
println("Vrijednost cilja: ", objective_value(m))


# Zadatak 2b

m=Model(GLPK.Optimizer)
@variable(m, x1<=10)
@variable(m, x2<=9)
@objective(m, Max, 3x1 + 7x2)
@constraint(m, constraint1, 0.25x1 + 0.75x2 <= 20)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ", objective_value(m))


# Zadatak 2c

using JuMP, GLPK

m=Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, 3x1 + 4x2)
@constraint(m, constraint1, x1 <= 3)
@constraint(m, constraint2, x2 <= 6)
@constraint(m, constraint3, 3x1 + 2x2 <= 18)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ", objective_value(m))