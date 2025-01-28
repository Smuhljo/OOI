# Muhamed Selmanovic 19115 i Mirza Olovcic 19230
function assignment(C)
    brRedova, brKolona = size(C)
    M_druga = parse.(Float64, string.(C))


    if brRedova < brKolona
        M_druga = [M_druga; zeros(brKolona - brRedova, brKolona)]
        C = [C; zeros(brKolona - brRedova, brKolona)]
        brRedova = brKolona
    elseif brRedova > brKolona
        M_druga = [M_druga zeros(brRedova, brRedova - brKolona)]
        C = [C zeros(brRedova, brRedova - brKolona)]
        brKolona = brRedova
    end
    kopijaM = deepcopy(C)

    u = zeros(brKolona)
    v = zeros(brKolona)



    for j in 1:brKolona
        v[j], index = findmin(M_druga[:, j])
    end

    for i in 1:brRedova
        u[i], index = findmin(M_druga[i, :] - v)
    end

    redoviNula = []
    koloneNula = []
    redoviNezavisnih = []
    koloneNezavisnih = []
    lokacijeNezavisnihNula = Array{Tuple{Int,Int}}(undef, 0)
    lokacijeNula = Array{Tuple{Int,Int}}(undef, 0)

    for i in 1:brRedova
        for j in 1:brKolona
            if u[i] + v[j] == M_druga[i, j]
                push!(lokacijeNula, (i, j))
                push!(redoviNula, i)
                push!(koloneNula, j)
                if !(j in koloneNezavisnih) && !(i in redoviNezavisnih)
                    push!(lokacijeNezavisnihNula, (i, j))
                    push!(redoviNezavisnih, i)
                    push!(koloneNezavisnih, j)
                end
            end
        end
    end


    if length(redoviNezavisnih) != brKolona
        novoOznacavanjeKolona = []
        novoOznacavanjeRedova = []
        imaKolona = false
        imaRed = false
        prvaIteracija = true


        # Pronalazak prvog reda za oznacavanje
        for i in 1:brRedova
            if !(i in redoviNezavisnih)
                push!(novoOznacavanjeRedova, i)
                imaRed = true
                break
            end
        end
        i = novoOznacavanjeRedova[1]

        while true
        

            #Pronalazak reda za oznacavanje, osim u prvoj iteraciji kada se radi pronalazak izvan petlje
            if !prvaIteracija
                imaRed = false
                for k in 1:brKolona
                    if ((k, novoOznacavanjeKolona[end]) in lokacijeNezavisnihNula) && !(k in novoOznacavanjeRedova)
                        push!(novoOznacavanjeRedova, k)
                        imaRed = true
                        break
                    end
                end
            end
            prvaIteracija = false
            i = novoOznacavanjeRedova[end]


            #korak 4.5
            # Ako red nije nađen, pronalazak povecavajuceg put
            if !imaRed
                kol = pop!(novoOznacavanjeKolona)
                while length(novoOznacavanjeKolona) != 0
                    red = pop!(novoOznacavanjeRedova)
                    push!(lokacijeNezavisnihNula, (red, kol))

                    kol = pop!(novoOznacavanjeKolona)
                    filter!(x -> x[1] != red || x[2] != kol, lokacijeNezavisnihNula)
                end
                if length(novoOznacavanjeRedova) != 0
                    red = pop!(novoOznacavanjeRedova)
                    push!(lokacijeNezavisnihNula, (red, kol))
                end
                redoviNezavisnih = []
                koloneNezavisnih = []
                for k in 1:length(lokacijeNezavisnihNula)
                    push!(redoviNezavisnih, lokacijeNezavisnihNula[k][1])
                    push!(koloneNezavisnih, lokacijeNezavisnihNula[k][2])
                end
                novoOznacavanjeKolona = []
                novoOznacavanjeRedova = []

                imaRed = false
                for k in 1:brKolona
                    if !(k in novoOznacavanjeRedova) && !(k in redoviNezavisnih)
                        push!(novoOznacavanjeRedova, k)
                        imaRed = true
                        break
                    end
                end

                if !imaRed
                    break
                end
                i = novoOznacavanjeRedova[end]
            end


            # Oznacavanje kolona
            imaKolona = false
            for j in 1:brKolona
                if (i, j) in lokacijeNula && !((i, j) in lokacijeNezavisnihNula) && !(j in novoOznacavanjeKolona)
                    imaKolona = true
                    push!(novoOznacavanjeKolona, j)
                end
            end

            #korak 5 - Oznacavanje je stalo u redu, tj. ne postoji kolona koja se može označiti
            # Postupak nalazenja najmanjeg elementa i oduzimanje
            if !imaKolona
                min_i = -1
                min_j = -1
                minEl = Inf
                for i in 1:brRedova
                    for j in 1:brKolona
                        if (i in novoOznacavanjeRedova) && !(j in novoOznacavanjeKolona)
                            minD = M_druga[i, j] - u[i] - v[j]
                            if minD < minEl
                                min_i = i
                                min_j = j
                                minEl = minD
                            end
                        end
                    end
                end
                #korak 6
                for k in novoOznacavanjeRedova
                    u[k] = u[k] + minEl
                end

                for k in novoOznacavanjeKolona
                    v[k] = v[k] - minEl
                end

                redoviNula = []
                koloneNula = []
                lokacijeNula = Array{Tuple{Int,Int}}(undef, 0)

                for i in 1:brRedova
                    for j in 1:brKolona
                        if u[i] + v[j] == M_druga[i, j]
                            push!(lokacijeNula, (i, j))
                            push!(redoviNula, i)
                            push!(koloneNula, j)
                        end
                    end
                end


                for j in 1:brKolona
                    if (i, j) in lokacijeNula && !((i, j) in lokacijeNezavisnihNula) && !(j in novoOznacavanjeKolona)
                        imaKolona = true
                        push!(novoOznacavanjeKolona, j)
                        break
                    end
                end
            end
        end
    end

    #Korak 7 - Ocitavanje rješenja
    Z = 0
    for i in 1:brRedova
        for j in 1:brKolona
            if (i, j) in lokacijeNezavisnihNula
                Z = Z + kopijaM[i, j]
                C[i, j] = 1
            else
                C[i, j] = 0
            end
        end
    end
    return C, Z
end

#Primjer u postavci zadace 8, rezultat 13
C = [5 6 5 1 0; 4 6 4 1 0; 8 6 7 6 0; 2 4 4 4 0; 6 10 9 4 0];
X, V = assignment(C)

#Primjer 2, korektan
C=[3 2 10; 5 8 12;4 10 5;7 15 10];
X, V = assignment(C)


#Primjer _POGLAVLJE_6_Problem_rasporedjivanja_asignacije_.pdf strana 22, rezultat 18, dobije se nakon 
#negacije rezultata -18, zbog toga sto je prvobitni problem, problem maksimizacije
C = [-3 -2 -5 -4; -6 -4 -7 -8; -1 -6 -3 -7];
X, V = assignment(C)

#Primjer _POGLAVLJE_6_Problem_rasporedjivanja_asignacije_.pdf strana 30, rezultat 27, dobije se nakon 
#negacije rezultata -27, zbog toga sto je prvobitni problem, problem maksimizacije
C = [-5 -6 -5 -1; -4 -6 -4 -1; -8 -6 -7 -6; -2 -4 -4 -4; -6 -10 -9 -4];
X, V = assignment(C)




