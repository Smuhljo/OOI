#=
Fabrika može proizvoditi tri proizvoda P1, P2 i P3, pri čemu se koriste tri sirovine S1, S2 i S3. Za
proizvodnju prvog proizvoda koriste se dvije količinske jedinice prve i tri količinske jedinice druge
sirovine. Za proizvodnju drugog proizvoda koriste se dvije količinske jedinice prve, tri količinske jedinice
druge i jedna količinska jedinica treće sirovine. Za proizvodnju trećeg proizvoda potrebno je dvije
količinske jedinice prve sirovine i jedna količinska jedinica treće sirovine. Dobit od jedne količinske
jedinice prvog proizvoda je dvije novčane jedinice, od drugog tri novčane jedinice, a od trećeg jedna
novčana jedinica. Ako su količine sirovina za planski period ograničene na četiri količinske jedinice za
prvu sirovinu, dvije za drugu i tri za treću, potrebno je napraviti optimalni plan proizvodnje koji de uz
zadana ograničenja ostvariti najveću novčanu dobit.
=#

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


#=
Fabrika proizvodi dva proizvoda. Za proizvodnju oba proizvoda koristi se jedna sirovina čija količina je
ograničena na 20 kg u planskom periodu. Za pravljenje svakog kilograma prvog proizvoda potroši se 250
grama sirovine,a za pravljenje svakog kilograma drugog proizvoda potroši se 750 grama sirovine. Dobit od
prvog proizvoda je 3 KM po kilogramu, a od drugog 7 KM po kilogramu. Potrebno je napraviti plan
proizvodnje koji maksimizira dobit, pri čemu je potrebno povesti računa da je količina proizvoda koji se
mogu plasirati na tržište ograničena. Prvog proizvoda može se prodati maksimalno 10 kg, a drugog 9 kg.
=#

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


#=
Kompanija za proizvodnju slatkiša proizvodi visokokvalitetne čokoladne proizvode i namjerava pokrenuti
proizvodnju dva nova slatkiša. Proizvodi se prave u tri različita odjeljka u kojem provode određeno
vrijeme. Prvi proizvod zahtijeva 1 h proizvodnje u odjeljku 1 i 3 h proizvodnje u odjeljku 3 po jednom
komadu. Drugi proizvod zahtijeva 1 h proizvodnje u odjeljku 2 i 2 h proizvodnje u odjeljku 3 po jedom
komadu. Odjeljak 1 ima na raspolaganju 3 slobodna sata, odjeljak 2 ima 6 slobodnih sati i odjeljak 3 ima
18 slobodnih sati. Svi proizvedeni novi proizvodi mogu se prodati a cijena prvog iznosi 2 KM, a drugog
4 KM po komadu. 
=#

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