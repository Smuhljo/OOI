#=
Neko preduzeće plasira na trţište dvije vrste mljevene kafe K1 i K2. Očekivana zarada je 3
novčane jedinice (skraćeno n.j.) po kilogramu za kafu K1 (tj. 3 n.j./kg), a 2 n.j./kg za kafu K2. Pogon
za przenje kafe je na raspolaganju 150 sati sedmično, a pogon za mljevenje kafe 60 sati sedmično.
=#

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


#=
Potrebno je obezbijediti vitaminsku terapiju koja će sadrţavati četiri vrste vitamina V1, V2,
V3 i V4. Na raspolaganju su dvije vrste vitaminskih sirupa S1 i S2 čije su cijene 40 n.j./g i 30 n.j./g
respektivno. Vitaminski koktel mora sadrţavati najmanje 0.2 g, 0.3 g, 3 g i 1.2 g vitamina V1, V2, V3 i
V4 respektivno.
=#

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


#=
Planira se proizvodnja tri tipa detrdţenta D1, D2 i D3. Sa trgovačkom mreţom je dogovorena
isporuka tačno 100 kg detrdţenta bez obzira na tip. Za uvoz odgovarajućeg repromaterijala planirano
su sredstva u iznosu od 110 $. Po jednom kilogramu detrdţenta, za proizvodnju detrdţenata D1, D2 i
D3 treba nabaviti repromaterijala u vrijednosti 2 $, 1.5 $ odnosno 0.5 $. TakoĎer je planirano da se za
proizvodnju uposle radnici sa angaţmanom od ukupno barem 120 radnih sati, pri čemu je za
proizvodnju jednog kilograma detrdţenata D1, D2 i D3 potrebno uloţiti respektivno 2 sata, 1 sat
odnosno 1 sat. Prodajna cijena detrdţenata D1, D2 i D3 po kilogramu respektivno iznosi 10 KM, 5 KM
odnosno 8 KM. Formirati matematski model iz kojeg se moţe odrediti koliko treba proizvesti svakog
od tipova detrdţenata da se pri tome ostvari maksimalna moguća zarada.
=#

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