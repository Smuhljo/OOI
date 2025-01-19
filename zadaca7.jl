using JuMP, GLPK

function min_path(W)
    n = size(W, 1)
    model = Model(GLPK.Optimizer)
    
    # Variables: x[i,j] for each possible edge, must be integer
    @variable(model, x[1:n, 1:n] >= 0, Int)
    
    # Objective: minimize the total path length
    @objective(model, Min, sum(W[i,j] * x[i,j] for i in 1:n, j in 1:n 
                              if !isinf(W[i,j])))
    
    # Each vertex must have exactly one outgoing edge (except the last)
    for i in 1:(n-1)
        @constraint(model, sum(x[i,j] for j in 1:n if !isinf(W[i,j])) == 1)
    end
    
    # Each vertex must have exactly one incoming edge (except the first)
    for j in 2:n
        @constraint(model, sum(x[i,j] for i in 1:n if !isinf(W[i,j])) == 1)
    end
    
    # Flow conservation
    for k in 2:(n-1)
        @constraint(model, 
            sum(x[i,k] for i in 1:n if !isinf(W[i,k])) == 
            sum(x[k,j] for j in 1:n if !isinf(W[k,j]))
        )
    end
    
    # First vertex must have one outgoing edge and no incoming edges
    @constraint(model, sum(x[1,j] for j in 1:n if !isinf(W[1,j])) == 1)
    @constraint(model, sum(x[i,1] for i in 1:n if !isinf(W[i,1])) == 0)
    
    # Last vertex must have one incoming edge and no outgoing edges
    @constraint(model, sum(x[i,n] for i in 1:n if !isinf(W[i,n])) == 1)
    @constraint(model, sum(x[n,j] for j in 1:n if !isinf(W[n,j])) == 0)
    
    # Solve the model
    optimize!(model)
    
    # Extract the result
    if termination_status(model) == MOI.OPTIMAL
        path = Int[]
        push!(path, 1)  # Start from vertex 1
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
        
        # Create T matrix from path
        T = zeros(Int, length(path)-1, 2)
        for i in 1:(length(path)-1)
            T[i,1] = path[i]
            T[i,2] = path[i+1]
        end
        
        # Calculate path length
        V = sum(W[T[i,1], T[i,2]] for i in 1:size(T,1))
        
        return T, V
    else
        error("No optimal solution found")
    end
end

# Test case from the image
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