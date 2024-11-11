using LinearAlgebraa

function simplex(c, A, b)
    m, n = size(A)
    # Initialize simplex tableau
    tableau = hcat(b, A, Matrix{Float64}(I, m, m))  # Add slack variables
    BASE = collect(n+1:n+m)  # Basic variables
    c_row = vcat(0.0, c, zeros(m))  # Cost row with slack variables
    tableau = vcat([c_row'], tableau)
    
    optimal = false

    # Simplex iterations
    while !optimal
        # Find entering variable
        cmax, q = -1.0, -1
        for j = 1:n+m
            if tableau[1, j+1] > 0 && tableau[1, j+1] > cmax
                cmax = tableau[1, j+1]
                q = j + 1
            end
        end

        # Check if the current solution is optimal
        if cmax == -1.0
            optimal = true
            break
        end

        # Find leaving variable
        tmax, p = Inf, -1
        for i = 2:m+1
            if tableau[i, q] > 0
                t = tableau[i, 1] / tableau[i, q]
                if t < tmax
                    tmax = t
                    p = i
                end
            end
        end

        # If the solution is unbounded
        if tmax == Inf
            return "The solution is unbounded"
        end

        # Pivot: update the base and normalize the pivot row
        BASE[p - 1] = q - 1
        pivot = tableau[p, q]
        tableau[p, :] ./= pivot

        # Update other rows
        for i = 1:m+1
            if i != p
                factor = tableau[i, q]
                tableau[i, :] .-= factor .* tableau[p, :]
            end
        end
    end

    # Read the optimal solution from the tableau
    x = zeros(n)
    for i = 1:m
        if BASE[i] <= n
            x[BASE[i]] = tableau[i+1, 1]
        end
    end
    Z = tableau[1, 1]

    return x, Z
end

# Example usage
c = [3.0, 2.0]            # Objective function coefficients
A = [2.0 1.0; 1.0 2.0]    # Constraint coefficients
b = [18.0, 16.0]          # Right-hand side values

x, Z = simplex(c, A, b)
println("Optimal solution: x = $x, Z = $Z")
