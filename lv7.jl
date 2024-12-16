using DataStructures

function CPM(A, P, T)
    n = length(A)
    graph = Dict{String, Vector{String}}()
    duration = Dict{String, Int}()
    predecessors = Dict{String, Vector{String}}()

    for i in 1:n
        activity = A[i]
        duration[activity] = T[i]

        if P[i] == "-"
            predecessors[activity] = []
        else
            predecessors[activity] = split(P[i], ", ")
        end
    end

    for i in 1:n
        for pred in predecessors[A[i]]
            if !haskey(graph, pred)
                graph[pred] = []
            end
            push!(graph[pred], A[i])
        end
    end

    earliest_start = Dict{String, Int}()
    earliest_finish = Dict{String, Int}()

    for activity in A
        if isempty(predecessors[activity])
            earliest_start[activity] = 0
        else
            earliest_start[activity] = maximum(earliest_finish[p] for p in predecessors[activity])
        end
        earliest_finish[activity] = earliest_start[activity] + duration[activity]
    end

    latest_finish = Dict{String, Int}()
    latest_start = Dict{String, Int}()
    Z = maximum(values(earliest_finish))

    for activity in reverse(A)
        if !haskey(graph, activity) || isempty(graph[activity])
            latest_finish[activity] = Z
        else
            latest_finish[activity] = minimum(latest_start[s] for s in graph[activity])
        end
        latest_start[activity] = latest_finish[activity] - duration[activity]
    end

    total_float = Dict{String, Int}()
    for activity in A
        total_float[activity] = latest_start[activity] - earliest_start[activity]
    end

    critical_path = []
    for activity in A
        if total_float[activity] == 0
            push!(critical_path, activity)
        end
    end

    return Z, join(critical_path, " -> ")
end

A = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
P = ["-", "-", "-", "C", "A", "A", "B, D", "E", "F, G"]
T = [3, 3, 2, 2, 4, 1, 4, 1, 4]

Z, put = CPM(A, P, T)
println("Trajanje kritičnog puta: $Z")
println("Kritični put: $put")

A1 = ["A", "B", "C", "D", "E", "F", "G", "H"]
P1 = ["-", "-", "-", "A", "A", "A, B", "D", "D, E, F"]
T1 = [5, 4, 5, 1, 2, 7, 2, 2]

Z1, put1 = CPM(A1, P1, T1)
println("Trajanje kritičnog puta: $Z1")
println("Kritični put: $put1")

A2 = ["A", "B", "C", "D", "E", "F", "G", "H"]
P2 = ["-", "A", "A", "A", "A", "B, C", "D, E", "F, G"]
T2 = [15, 30, 45, 45, 15, 15, 15, 15]

Z2, put2 = CPM(A2, P2, T2)
println("Trajanje kritičnog puta: $Z2")
println("Kritični put: $put2")