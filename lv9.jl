#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115

function nadji_pocetno_SZU(C::Matrix{Float64}, I::Vector{Float64}, O::Vector{Float64})
    supply = copy(I)
    demand = copy(O)
    
    total_supply = sum(supply)
    total_demand = sum(demand)
    
    m, n = size(C)
    
    if total_supply > total_demand
        demand = [demand; total_supply - total_demand]
        C = [C zeros(m, 1)]
        n += 1
    elseif total_supply < total_demand
        supply = [supply; total_demand - total_supply]
        C = [C; zeros(1, n)]
        m += 1
    end
    
    A = fill(-1.0, m, n)
    
    i, j = 1, 1
    
    while i <= m && j <= n
        if supply[i] < demand[j]
            A[i,j] = supply[i]
            demand[j] -= supply[i]
            supply[i] = 0
            i += 1  
        elseif supply[i] > demand[j]
            A[i,j] = demand[j]
            supply[i] -= demand[j]
            demand[j] = 0
            j += 1  
        else  
            A[i,j] = supply[i]
            supply[i] = 0
            demand[j] = 0
            i += 1
            j += 1
        end
    end
    
    T = sum(A[i,j] * C[i,j] for i in 1:m, j in 1:n if A[i,j] >= 0)
    
    return A, T
end

function print_solution(A::Matrix{Float64}, C::Matrix{Float64}, T::Float64)
    println("\nA::")
    display(round.(A, digits=2))
    println("\nC:")
    display(round.(C, digits=2))
    println("\nUkupna cijena: ", round(T, digits=2))
end


