using Pkg;
Pkg.add("LinearAlgebra");
using LinearAlgebra;
import Base.DimensionMismatch


function rijesi_simplex(A,b,c)
   negative=false;
   Z=0;
   bSize=size(b,1);
   numberOfRowsA=size(A,1);
   numberOfColumnsA=size(A,2);
   cSize=size(c,2);
   if  Int(size(b,1))!=Int(numberOfRowsA)
       #greska- nije moguce da A ima vise redova nego b jer b cuva vrijednosti bi dok A cuva vrijednosti xi
       throw(DimensionMismatch("1"));
       end
   if (cSize!=numberOfColumnsA)
       #greska- nije moguce da A ima vise kolona nego c jer c cuva vrijednosti u zadnjem redu simplex tabele dok A cuva vrijednosti xi za sve elemente koji nisu u bazi
       throw(DimensionMismatch("2"));   
   end
   if (size(c,1)!=size(b,2))
       #greska- b treba biti vektor kolona dok c vektor red
       throw(DimensionMismatch("3"));    end
       basesize=numberOfRowsA+cSize;
   base = zeros(basesize);
   b1=zeros(basesize);
   for i in 1:bSize
       b1[i]=b[i];
   end
   for i in 1:cSize
     base[i] = c[i];
   end
   fullMatrix=Float64[A I(bSize)];


   while negative == false
       max,pivotKolona=findmax(base);
       if max<=0
           negative=true;
           break;
       else
       tmin=b1[pivotKolona]/ fullMatrix[1,pivotKolona];
       pivotRed=1;
       for i in 1:bSize
           t=b1[i]/fullMatrix[i,pivotKolona];
           if t<tmin && t>=0
               tmin=t;
               pivotRed=i;
           elseif tmin<0 && t>=0
            tmin=t;
            pivotRed=i;
           end
       end
       if tmin<0
           return "Rješenje je neograničeno";
   elseif tmin==Inf
return "Rješenje je neograničeno";
   end
   b1[pivotRed]= (b1[pivotRed] / fullMatrix[pivotRed, pivotKolona]);
   fullMatrix[pivotRed,1:end]./=fullMatrix[pivotRed,pivotKolona];
   fullmatrixsize=size(fullMatrix,1);
   for i in 1:fullmatrixsize
       if i==pivotRed
           continue
       else
           b1[i]-=(b1[pivotRed]*fullMatrix[i,pivotKolona]);
       fullMatrix[i,1:end].-=(fullMatrix[pivotRed,1:end].*fullMatrix[i,pivotKolona]);
   end
end
 Z+=(b1[pivotRed]*base[pivotKolona]);
   base[1:end].-=(fullMatrix[pivotRed,1:end]*base[pivotKolona]);
end
end
x=zeros(Float64,basesize);
for i in 1:basesize
   index=1;
   if base[i]==0
for j in 1:numberOfRowsA
   if abs(fullMatrix[j,i]-1)<=0.00000000001
       index=j;
       break;
   end
end
x[i]=(b1[index]);
   else
       x[i]=0;
   end
end


return x,Z;
end
try
    x1, Z1 = rijesi_simplex([0.5 0.3; 0.1 0.2], [150; 60], [3 2]); #-Kafa
    x2, Z2 = rijesi_simplex([0.5 0.25; 500 -200], [12; 3000], [1500 300]); #Teretni brod
    x3, Z3 = rijesi_simplex([1 3; 2000 -1000], [8; 2000], [18000 11000]); # Student zavrsne godine

println("Rješenja x1:")
if x1 == "R"
    println("Rjesenje je u beskonacnosti");
else
    println(x1);
    println("Vrijednost cilja:")
    println(Z1);
end
println("Rješenja x2:")
if x2 == "R"
    println("Rjesenje je u beskonacnosti");
else
    println(x2);
    println("Vrijednost cilja:")
    println(Z2);
end
println("Rješenja x3:")
if x3 == "R"
    println("Rjesenje je u beskonacnosti");
else
    println(x3);
    println("Vrijednost cilja:")
    println(Z3);
end
catch e
    println(e);
end