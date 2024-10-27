#Zadatak 2
#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115
#Paketi koji su korišteni: Interact, Random, Blink

using Pkg
Pkg.add("Blink")
Pkg.add("Interact")
Pkg.add("Random")

using Blink, Interact, Random

prozor = Window()

function sume(matrica)
    suma_ukupna = 0
    suma_redova = zeros(size(matrica, 1))
    suma_kolona = zeros(size(matrica, 2))
    suma_diagonale = 0
    suma_sporedne = 0
    for i = 1:size(matrica, 1)
        for j = 1:size(matrica, 2)
            suma_ukupna += matrica[i, j]
            suma_redova[i] += matrica[i, j]
            suma_kolona[j] += matrica[i, j]
            if size(matrica, 1) == size(matrica, 2)
                if i == j
                    suma_diagonale += matrica[i, j]
                end
                if (i + j) == (size(matrica, 1) + 1)
                    suma_sporedne += matrica[i, j]
                end
            end
        end
    end
    return suma_ukupna, suma_redova, suma_kolona, suma_diagonale, suma_sporedne
end

sadrzaj_interakcije = @manipulate for redovi in 2:5, kolone in 2:5
    matrica = rand(1:10, redovi, kolone)
    suma_ukupna, suma_redova, suma_kolona, suma_diagonale, suma_sporedne = sume(matrica)
    
    vbox(
        hbox("Generisana matrica: ", string(matrica)),
        hbox("Suma matrice: ", string(suma_ukupna)),
        hbox("Suma redova: ", string(suma_redova)),
        hbox("Suma kolona: ", string(suma_kolona)),
        hbox("Suma glavne dijagonale: ", string(suma_diagonale)),
        hbox("Suma sporedne dijagonale: ", string(suma_sporedne))
    )
end

body!(prozor, sadrzaj_interakcije)

show(prozor)
