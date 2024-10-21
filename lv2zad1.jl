using Pkg

Pkg.add("JuMP")
using JuMP

Pkg.add("GLPK")
using GLPK

m=Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Max, 3x1 + 2x2)
@constraint(m, constraint1, 0.5x1 + 0.3x2 <= 150)
@constraint(m, constraint2, 0.1x1 + 0.2x2 <= 60)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ", objective_value(m))


# Zadatak 1b

m=Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@objective(m, Min, 40x1 + 30x2)
@constraint(m, constraint1, 0.1x1 >= 0.2)
@constraint(m, constraint2, 0.1x2 >= 0.3)
@constraint(m, constraint3, 0.5x1 + 0.3x2 >= 3)
@constraint(m, constraint4, 0.1x1 + 0.2x2 >= 1.2)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("Vrijednost cilja: ", objective_value(m))


# Zadatak 1c

m=Model(GLPK.Optimizer)
@variable(m, x1>=0)
@variable(m, x2>=0)
@variable(m, x3>=0)
@objective(m, Max, 10x1 + 5x2 + 8x3)
@constraint(m, constraint1, x1 + x2 + x3 == 100)
@constraint(m, constraint2, 2x1 + 1.5x2 + 0.5x3 <= 110)
@constraint(m, constraint3, 2x1 + x2 + x3 >= 120)

print(m)

optimize!(m)

println("Status: ", termination_status(m))
println("Rjesenja: ")
println("x1 = ", value(x1))
println("x2 = ", value(x2))
println("x3 = ", value(x3))
println("Vrijednost cilja: ", objective_value(m))