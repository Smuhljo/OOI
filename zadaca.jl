using JuMP
using GLPK

function min_path_bellman(W)
    # Number of nodes in the graph
    n = size(W, 1)
    
    # Initialize distances with infinity and the previous node for path reconstruction
    dist = fill(Inf, n)
    prev = fill(-1, n)  # To store the parent of each node in the path

    # Distance to the source node is 0
    dist[1] = 0

    # Bellman-Ford algorithm: Relax edges (n-1) times
    for _ in 1:(n-1)
        for i in 1:n, j in 1:n
            if W[i, j] < Inf && dist[i] + W[i, j] < dist[j]
                dist[j] = dist[i] + W[i, j]
                prev[j] = i  # Update the previous node
            end
        end
    end

    # Check for negative-weight cycles (optional for this problem)
    for i in 1:n, j in 1:n
        if W[i, j] < Inf && dist[i] + W[i, j] < dist[j]
            error("Graph contains a negative-weight cycle")
        end
    end

    # Reconstruct the path from the last node back to the first
    T = []
    current = n
    while current != -1 && current != 1
        push!(T, (prev[current], current))
        current = prev[current]
    end
    push!(T, (1, T[end][1]))  # Add the first edge to complete the path
    reverse!(T)

    # Total path length
    V = dist[n]

    return T, V
end

# Example usage
W = [0   2   3   Inf 8   Inf Inf Inf;
     2   0   4   Inf 9   Inf Inf Inf;
     3   4   0   7   Inf Inf Inf Inf;
     Inf Inf 7   0   4   3   Inf Inf;
     8   Inf Inf 4   0   5   5   Inf;
     Inf 9   Inf 3   5   0   7   6;
     Inf Inf Inf Inf 5   7   0   1;
     Inf Inf Inf Inf Inf 6   1   0]

T, V = min_path_bellman(W)
println("T = ", T)
println("V = ", V)

