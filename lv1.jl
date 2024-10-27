# LABORATORIJSKA VJEZBA 1

# Zadatak 1
# a)
3 * (456 / 23) + 31.54 + 2^6

# b)
sin(pi / 7) * exp(0.3) * (2 + 0.9im)

# c)
sqrt(pi / 7) * log(10)

# d)
(5 + 3im) / (1.2 + 4.5im)


# Zadatak 2
a = (atan(5) + exp(5.6)) / 3
b = sin(pi / 3) ^ (1 / 15)
c = (log(15) + 1) / 23
d = sin(pi / 2) + cos(pi)

# a)
(a + b) * c

# b)
acos(b) * asin(c / 11)

# c)
(a - b)^4 / d

# d)
c ^ (1 / a) + (b*im) / (3 + 2im)


# Zadatak 3

A = [1 -4*im sqrt(2); log(-1im) sin(pi / 2) cos(pi / 3); asin(0.5) acos(0.8) exp(0.8)]

# a)
transpose(A)

# b)
A + transpose(A)

# c)
A * transpose(A)

# d)
transpose(A) * A

# e)
det(A)

# f)
inv(A)


# Zadatak 4

# a)
zeros(8, 9)

# b)
ones(7, 5)

# c)
I(5) + zeros(5, 5)

# d)
rand(4, 9)


# Zadatak 5

a = [2 7 6; 9 5 1; 4 3 8]

rowSum = sum(a, dims = 2)
rowCol = sum(a, dims = 1)

colMax = maximum(a, dims = 1)
colMin = minimum(a, dims = 1)

rowMax = maximum(a, dims = 2)
rowMin = minimum(a, dims = 2)

diagMax = maximum(diag(a))
diagMin = minimum(diag(a))


# Zadatak 6

a = [1 2 3; 4 5 6; 7 8 9]
b = [1 1 1; 2 2 2; 3 3 3]

# a)
c = sin.(a)

# b)
c = sin.(a) .* cos.(b)

sin(a[1][1]) * cos(b[1][1])

# c)
c = a^(1/3)

# d)
c = a.^(1/3)


# Zadatak 7
# a)
collect(1: 99)

# b)
collect(0: 0.01: 0.99)

# c)
collect(39: -2: 1)


# Zadatak 8

a = [7 * ones(4 ,4) zeros(4, 4); 3 * ones(4, 8) ]

# a)
b = I(8) + zeros(8, 8) + a

# b)
c = b[1:2:8, :]

# c)
d = b[:, 1:2:8]

# d)
e = b[1:2:8, 1:2:8]


# PLOTS ZADACI

# Zadatak 1

# a)
x1 = range(-pi, pi, length = 101)
y1 = sin.(x1)

p1 = plot(x1, y1, title = "Sinus", label = "sin(x)")

# b)
x2 = range(-pi, pi, length = 101)
y2 = cos.(x2)

p2 = plot(x2, y2, title = "Kosinus", label="cos(x)")

# c)
x3 = range(1, 10, length = 101)
y3 = sin.(1 ./ x3)

p3 = plot(x3, y3, title = "Zadatak 1c", color = :black, label = "sin(1 / x)")

# d)
x4 = range(1, 10, length = 101)
y4 = [sin.(1 ./ x4) cos.(1 ./ x4)]

plot(x4, y4, shape = [:star5 :circle], label = ["sin(1/x) cos(1/x)"])



# Zadatak 2
x = -8 : 0.5 : 8
y = -8 : 0.5 : 8

z = [sin(sqrt(xit^2 + yit^2)) for xit in x, yit in y]

surface(x, y, z, title = "Zadatak 2", xlabel = "X", ylabel = "Y", zlabel = "Z")


# FUNKCIJE ZADACI

# Zadatak 1

function sabiranje_i_oduzimanje(x = 0, y = 0)
    if size(x) != size(y)
         return 0,0
    end
    sum = x .+ y
    sub = x .- y
    return sum, sub
end

sabiranje_i_oduzimanje([1 2 3; 4 5 6], [6 5 4; 3 2 1])

# Zadatak 2

using Pkg
Pkg.add("Blink")