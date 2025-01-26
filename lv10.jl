#Laboratorijsku vježbu radili: Muhamed Selmanovic 19115 i Mirza Olovcic 19200
function rasporedi(M)
    broj_redova = size(M, 1);
    broj_kolona = size(M,2);

    rasporedi_matrica = 1
    if broj_redova==broj_kolona
        rasporedi_matrica = M.+0
    else
        razlika = abs(broj_redova-broj_kolona)
        if broj_redova>broj_kolona
            rasporedi_matrica = [M zeros(broj_redova,razlika)]
            broj_kolona=broj_redova
        else
            rasporedi_matrica = [M ;zeros(razlika,broj_kolona)]
            broj_redova=broj_kolona
        end
    end


    for i in 1:broj_redova
        min = minimum(rasporedi_matrica[i,:])
        rasporedi_matrica[i,:].-=min
    end

    for i in 1:broj_kolona
        min = minimum(rasporedi_matrica[:,i])
        rasporedi_matrica[:,i].-=min
    end

    while issubset([0], rasporedi_matrica)
        for i in 1:broj_redova
            if count(el->(el==0), rasporedi_matrica[i,:])==1
                indeks_nule = findfirst(el->(el==0), rasporedi_matrica[i,:]) 
                rasporedi_matrica[i,indeks_nule]=-1 
                for j in 1: length(rasporedi_matrica[:, indeks_nule]) 
                    if rasporedi_matrica[j,indeks_nule] == 0
                      rasporedi_matrica[j, indeks_nule] = -10 
                    end
                  end

            end
        end

        for i in 1:broj_kolona
            if count(el->(el==0), rasporedi_matrica[:,i])==1
                indeks_nule = findfirst(el->(el==0), rasporedi_matrica[:,i])
                rasporedi_matrica[indeks_nule,i]=-1
                for j in 1: length(rasporedi_matrica[indeks_nule,:])
                    if rasporedi_matrica[indeks_nule,j] == 0
                      rasporedi_matrica[indeks_nule, j] = -10
                    end
                  end

            end
        end

       
    end

     rezultat = 0

     for i in 1:broj_redova
         for j in 1: broj_kolona
             if rasporedi_matrica[i,j]==-1
                if (i <=size(M,1) && j<=size(M,2))
                 rezultat+=M[i,j]
                end
                 rasporedi_matrica[i, j] = 1
             else
                 rasporedi_matrica[i, j] = 0
                 
             end
         end
     end
    return rasporedi_matrica, rezultat

end

#testovi


#test 1 -52
M = [80 20 23; 31 40 12; 61 1 1];
matrica, rez = rasporedi(M)
display(matrica)
println("Rezultat je: ", rez)

#=
#test2 -175
M = [25 55 40 80; 75 40 60 95; 35 50 120 80; 15 30 55 65];
matrica, rez = rasporedi(M)
display(matrica)
println("Rezultat je: ", rez)=#


#test3 - 3
#=
M= [3 2 5 4; 6 4 7 8; 1 6 3 7]
matrica, rez = rasporedi(M)
display(matrica)
println("Rezultat je: ", rez)
=#

#= test 4 - 109
M=[31 84 85	77; 45 27 53 49; 89 82 66 70; 9	8 31 14];
matrica, rez = rasporedi(M)
display(matrica)
println("Rezultat je: ", rez)=#

#= test 5 - 81
M=[24 48 80	45; 78 29 22 84; 39	35 43 98;7 3 52	93];
matrica, rez = rasporedi(M)
display(matrica)
println("Rezultat je: ", rez);=#