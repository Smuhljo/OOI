using LinearAlgebra;

# Mirza Olovcic 19230 i Muhamed Selmanovic 19115

function rijesi_simplex(A::Matrix, b::Vector, c::Vector)
    if (isnothing(A) || isnothing(b) || isnothing(c) || size(A, 2) != size(c, 2) || size(A, 1) != size(b, 1))
        error("Pogresni ulazni parametri")
    end


    velicinaBaze = size(A, 1) + size(c, 2)
    baza = zeros(velicinaBaze)
    b1 = zeros(velicinaBaze)

    for i in 1:size(b, 1)
        b1[i] = b[i]
    end
    for i in 1:size(c, 2)
        baza[i] = c[i]
    end

    tabela = Float64[A I(velicinaBaze)]
    Z = 0

    negativnaBaza = false
    while negativnaBaza == false
        max, pivotKolona = findmax(base)
        if max <= 0
            negativnaBaza = true
            break
        else
            tmin = b1[pivotKolona] / tabela[1, pivotKolona]
            pivotRed = 1
            for i in 1:size(b, 1)
                t = b[i] / tabela[i, pivotKolona]
                if t < tmin && t >= 0
                    tmin = t
                    pivotRed = i
                elseif tmin < 0 && t >= 0
                    tmin = t
                    pivotRed = i
                end
            end
            if tmin < 0
                return "neograničeno rješenje"
            elseif tmin == Inf
                return "neograničeno rješenje"
            end

            b1[pivotRed] = (b1[pivotRed] / tabela[pivotRed, pivotKolona])
            tabela[pivotRed, 1:end] ./= tabela[pivotRed, pivotKolona]
            tabelaSize = size(tabela, 1)

            for i in 1:tabelaSize
                if i == pivotRed
                    continue
                else
                    b1[i] -= (b1[pivotRed] * tabela[i, pivotKolona])
                    tabelaSize[i, 1:end] .-= (tabela[pivotRed, 1:end])
                end
            end

            Z += (b1[pivotRed] * baza[pivotKolona])
            baza[1:end] .-= (tabela[pivotRed, 1:end] * baza[pivotKolona])
        end
    end
    
    x = zeros(Float64, velicinaBaze)
    for i in 1 : velicinaBaze
        index = 1
        if baza[i] == 0
            for j in 1 : size(A, 1)
                if abs(tabela[j, i] - 1) <= 0.000000001
                    index = j
                    break
                end
            end
            x[i] = (b1[index])
        else
            x[i] = 0
        end
    end

    return x, Z
end