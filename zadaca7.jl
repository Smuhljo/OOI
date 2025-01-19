#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115

using JuMP, GLPK

function min_path(W)
    n = size(W, 1)
    model = Model(GLPK.Optimizer)
    
    @variable(model, x[1:n, 1:n] >= 0, Int)
    
    @objective(model, Min, sum(W[i,j] * x[i,j] for i in 1:n, j in 1:n 
                              if !isinf(W[i,j])))
    
    for i in 1:(n-1)
        @constraint(model, sum(x[i,j] for j in 1:n if !isinf(W[i,j])) == 1)
    end
    
    for j in 2:n
        @constraint(model, sum(x[i,j] for i in 1:n if !isinf(W[i,j])) == 1)
    end
    
    for k in 2:(n-1)
        @constraint(model, 
            sum(x[i,k] for i in 1:n if !isinf(W[i,k])) == 
            sum(x[k,j] for j in 1:n if !isinf(W[k,j]))
        )
    end
    
    @constraint(model, sum(x[1,j] for j in 1:n if !isinf(W[1,j])) == 1)
    @constraint(model, sum(x[i,1] for i in 1:n if !isinf(W[i,1])) == 0)
    
    @constraint(model, sum(x[i,n] for i in 1:n if !isinf(W[i,n])) == 1)
    @constraint(model, sum(x[n,j] for j in 1:n if !isinf(W[n,j])) == 0)
    
    optimize!(model)
    
    if termination_status(model) == MOI.OPTIMAL
        path = Int[]
        push!(path, 1)  
        current = 1
        
        while current != n
            for j in 1:n
                if !isinf(W[current,j]) && value(x[current,j]) ≈ 1
                    push!(path, j)
                    current = j
                    break
                end
            end
        end
        
        T = zeros(Int, length(path)-1, 2)
        for i in 1:(length(path)-1)
            T[i,1] = path[i]
            T[i,2] = path[i+1]
        end
        
        V = sum(W[T[i,1], T[i,2]] for i in 1:size(T,1))
        
        return T, V
    else
        error("No optimal solution found")
    end
end

W = [0 2 3 Inf 8 Inf Inf Inf; 
     2 0 4 Inf 9 Inf Inf Inf;
     3 4 0 7 Inf Inf Inf Inf;
     Inf Inf 7 0 4 3 Inf Inf;
     8 Inf Inf 4 0 5 5 Inf;
     Inf 9 Inf 3 5 0 7 6;
     Inf Inf Inf Inf 5 7 0 1;
     Inf Inf Inf Inf Inf 6 1 0]

T, V = min_path(W)

println("Path matrix T:")
display(T)
println("\nPath length V = ", V)