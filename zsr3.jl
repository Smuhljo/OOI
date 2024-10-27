#Zadatak 3
#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115
#Paketi koji su korišteni: Interact, Plots, Blink

using Pkg
Pkg.add("Blink")
Pkg.add("Interact")
Pkg.add("Plots")

using Blink, Interact, Plots

prozor = Window()

function crtaj(izraz::String)
    global x = LinRange(-5, 5, 100)
    x = [x;]
    y = eval(Meta.parse(izraz))
    plot(x, y, title="Graf funkcije: $izraz", xlabel="x", ylabel="y")
end

function crtaj2(izraz::String)
    x = LinRange(-5, 5, 100)
    x = [x;]
    f = eval(Meta.parse("(x) -> $izraz"))
    y = Base.invokelatest(f, x)
    plot(x, y, title="Graf funkcije: $izraz", xlabel="x", ylabel="y")
end

sadrzaj_interakcije = @manipulate for izraz in ["x.^2", "sin.(x)", "cos.(x)", "x.^3 - x"]
    graf1 = crtaj(izraz)
    graf2 = crtaj2(izraz)

    vbox(
        hbox("Graf funkcije (prva verzija):", graf1),
        hbox("Graf funkcije (druga verzija):", graf2)
    )
end

body!(prozor, sadrzaj_interakcije)

show(prozor)

