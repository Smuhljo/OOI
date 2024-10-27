#Zadatak 1
#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115
#Paketi koji su korišteni: Interact, Plots, Blink

using Pkg
Pkg.add("Blink")
Pkg.add("Interact")
Pkg.add("Plots")

using Blink, Interact, Plots

prozor = Window()

function zbir_razlika(x=0, y=0)
    if size(x) == size(y)
        return x + y, x - y
    else
        return (0, 0)
    end
end

sadrzaj_interakcije = @manipulate for vrijednost1 in 1:5, vrijednost2 in 1:5
    matrica1 = [vrijednost1 vrijednost1; vrijednost1 vrijednost1]
    matrica2 = [vrijednost2 vrijednost2; vrijednost2 vrijednost2]
    
    zbir, razlika = zbir_razlika(matrica1, matrica2)
    
    vbox(
        "Zbir: $zbir",
        "Razlika: $razlika"
    )
end

body!(prozor, sadrzaj_interakcije)

show(prozor)
