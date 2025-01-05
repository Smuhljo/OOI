# LABORATORIJSKA VJEŽBA 8
# Muhamed Selmanovic Mirza Olovcic
# 19115 i 19230

function najkraci_put(M)
    M_druga = parse.(Float64, string.(M))
    brRedova, brKolona = size(M)
    for i in 1:brRedova
        for j in 1:brKolona
            if i == j
                M_druga[1, 1] = 0
            elseif M_druga[i, j] == 0
                M_druga[i, j] = Inf64
            end
        end
    end

    matricaPuteva = [[1 0 1];]
    trenutniCvor = 2
    while trenutniCvor <= brRedova
        moguciPutevi = []
        for i in 1:trenutniCvor-1
            if M_druga[i, trenutniCvor] != Inf64
                push!(moguciPutevi, (M_druga[i, trenutniCvor] + matricaPuteva[i, 2], i))
            end
        end

        minEl = minimum(moguciPutevi)

        matricaPuteva = [matricaPuteva; [trenutniCvor minEl[1] minEl[2]]]
        trenutniCvor = trenutniCvor + 1
    end
    return matricaPuteva
end

#Test 1
M = [0 4 3 0; 0 0 2 4; 0 0 0 4; 0 0 0 0]
putevi = najkraci_put(M)
print(putevi)

#Test 2
M = [0 4 3 0 15; 0 0 2 0 9; 0 0 0 3 2; 0 0 0 0 1; 0 0 0 0 0]
putevi = najkraci_put(M)
print(putevi)

#Test 3 (primjer s LV8)
M = [0 1 3 0 0 0; 0 0 2 3 0 0; 0 0 0 -4 9 0; 0 0 0 0 1 2; 0 0 0 0 0 2; 0 0 0 0 0 0]
putevi = najkraci_put(M)
print(putevi)
#-putevi = [1 0 1; 2 1 1; 3 3 2; 4 -1 3; 5 0 4; 6 1 4]

#Test 4 (Predavanje o grafovima, strana 38)
M = [0 2 10 7 0 0 0; 0 0 0 3 9 0 0; 0 0 0 6 0 6 0; 0 0 0 0 5 8 12; 0 0 0 0 0 1 7; 0 0 0 0 0 0 4; 0 0 0 0 0 0 0]
putevi = najkraci_put(M)
print(putevi)