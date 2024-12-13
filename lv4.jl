#Mirza Olovcic Indeks:19230 
#Muhamed Selmanovic Indeks:19115

using Pkg;
Pkg.add("LinearAlgebra");
using LinearAlgebra;
import Base.DimensionMismatch

function rijesi_simplex(goal, A, b, c, csigns, vsigns)
    negative=false;
    Z=0;
    pivotRed=1
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
    if goal!="max" && goal!="min"
        #greska- mozemo samo traziti min i max
        throw(ArgumentError("3"));    end
if size(csigns,1)!=bSize
    #greska- csigns predstavlja znak ogranicenja dok b predstavlja desnu stranu ogranicenja, mora biti iste velicine
    throw(DimensionMismatch("4"));
end
if size(vsigns,1)!=numberOfColumnsA
    #greska- vsigns predstavlja znak varijabli dok broj kolona predstavlja broj varijabli, mora biti iste velicine
    throw(DimensionMismatch("5"));
end
for i in 1:bSize
    if (csigns[i]!=1 && csigns[i]!=0 && csigns[i]!=-1) throw(ArgumentError("Neispravna vrijednost u csigns, dozvoljeno je samo 0,1 i -1"));
    end
end
for i in 1:numberOfColumnsA
    if (vsigns[i]!=1 && vsigns[i]!=0 && vsigns[i]!=-1) throw(ArgumentError("Neispravna vrijednost u vsigns, dozvoljeno je samo 0,1 i -1"));
    end
end
MisOut=false
#da nemamo brojeve <0 u b
for i in 1:bSize
    if b[i, 1] < 0 
        b[i, 1] *= -1;;
        A[i, :] *= -1;
        csigns[i, 1] *= -1;
    end
   end
   jednako=0
   manje=0
   vece=0
   indeksi_jednakih=zeros(Int,bSize)
   indeksi_vece=zeros(Int,bSize)
   for j in 1:numberOfRowsA
    if b[j]==0
        println("Rješenje je degenerirano")
        break
    end
end
   for i in 1:bSize
    if csigns[i]==0
        jednako+=1;
        indeksi_jednakih[i]=i
    elseif csigns[i]==-1
        manje+=1
    elseif csigns[i]==1
        vece+=1
        indeksi_vece[i]=i
    end
end
if (goal=="max" && (vece!=0 || jednako!=0)) || (goal=="min" &&  (vece!=0 || jednako!=0))
    M=zeros(Float64,numberOfColumnsA+2*vece+manje+2*jednako)
    for i in 1:(numberOfColumnsA)
        M[i]-=sum(A[:,i])
    end
M1=0
 for i in 1:bSize
    if csigns[i]==0
        M1-=b[i]
        M[numberOfColumnsA+i]-=0
    elseif csigns[i]==1
        M1-=b[i]
        M[numberOfColumnsA+i]+=1
    end
end
end
if goal=="min"
    if jednako!=0 || vece!=0
    M*=-1
    M1*=-1
    end
    c*=-1
end
for i in 1:numberOfColumnsA
    if vsigns[i] == -1
        A[:, i] *= -1;
        c[i] *= -1;
    end
end
basesize=numberOfColumnsA+2*vece+manje+2*jednako;
    base = zeros(Float64,basesize);
    b1=zeros(Float64,basesize);
    for i in 1:bSize
        b1[i]=b[i];
    end
    for i in 1:cSize
      base[i] = c[i];
    end
    if vece!=0
        if vece+jednako==vece+jednako+manje
    fullMatrix=Float64[A I(vece+jednako)*(-1) I(vece+manje+jednako)]
        elseif vece+jednako<vece+jednako+manje
            I2=I(vece+jednako)
            m=zeros(manje,size(I2,1))
          
            I1=vcat(I2*(-1),m)
            fullMatrix=Float64[A I1 I(vece+manje+jednako)]
        end
    else
        fullMatrix=Float64[A I(vece+manje+jednako)]
    end
    while negative == false
        if (goal=="max" && jednako==0 && vece==0) || (goal=="min" && jednako==0 && vece==0) || MisOut
        max,pivotKolona=findmax(base);
        else
            max,pivotKolona=findmax(M);
            for j in 1:numberOfColumnsA+vece+manje+jednako
                if abs(M[j]-max)<=0.000000001 && base[j]>base[pivotKolona] && base[j]!=0
                    max=M[j]
                    pivotKolona=j
                end
            end
        end
        if max<=0.000000001
            if MisOut==true
            negative=true;
            else 
                for i in bSize
                    if indeksi_jednakih[i]!=0 || indeksi_vece[i]!=0
                        return "N",NaN
                    end
                end
                MisOut=true
            end
        else
            if pivotKolona>numberOfColumnsA && MisOut==true
                negative=true
                break
            end
        tmin=Inf;
        pivotRed=0;
        for i in 1:numberOfRowsA
            if fullMatrix[i,pivotKolona]>0
            t=b1[i]/fullMatrix[i,pivotKolona];
            if t < tmin || (t== tmin && rand(0:1) > 0.5)
                tmin=t;
                pivotRed=i;
            end
        end
    end
    if tmin==Inf 
        return "R",NaN
    elseif isnan(tmin)
        println("Rjesenje nije jedinstveno")
        x=zeros(Float64,basesize);
for i in 1:basesize
    index=1;
    if base[i]==0
for j in 1:numberOfRowsA
    if fullMatrix[j,i]==1
        index=j;
        break;
    end
end
x[i]=(b1[index]);
    else
        x[i]=0;
    end
end
if goal=="max"
    Z*=-1
end
        return x,Z
        end
    for i in 1:bSize
        if pivotRed==indeksi_jednakih[i]
            indeksi_jednakih[i]=0
            break
        elseif pivotRed==indeksi_vece[i]
            indeksi_vece[i]=0
            break
        end
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
 Z-=(b1[pivotRed]*base[pivotKolona]);
    if !((goal=="max" || goal=="min") && jednako==0 && vece==0)
        M1-=(b1[pivotRed]*M[pivotKolona])
M.-=(fullMatrix[pivotRed,:].*M[pivotKolona])
    end
base[1:end].-=(fullMatrix[pivotRed,1:end].*base[pivotKolona]);
end
  
    end
x=zeros(Float64,basesize);
for i in 1:basesize
    index=1;
    if base[i]==0
for j in 1:numberOfRowsA
    if fullMatrix[j,i]==1
        index=j;
        break;
    end
end
x[i]=(b1[index]);
    else
        x[i]=0;
    end
end
if vece!=0 || jednako!=0
for i in bSize
    if indeksi_jednakih[i]!=0 || indeksi_vece[i]!=0
        return "N",NaN
    end
end

end
numberOfZeros=0
for j in 1:basesize
    if base[j]==0
        numberOfZeros+=1
    end
end
if numberOfZeros>numberOfRowsA
    println("Rjesenje nije jedinstveno")
else
    println("Rješenje je jedinstveno")
end
    x=zeros(Float64,basesize);
for i in 1:basesize
index=1;
if base[i]==0
for j in 1:numberOfRowsA
if fullMatrix[j,i]==1
index=j;
break;

end
end

x[i]=(b1[index]);
else
x[i]=0;
end
end
if goal=="max"
Z*=-1
end
    return x,Z
    
end
try
#PRIMJERI ZA PROVJERU IZ KNJIGE:

#x, Z = rijesi_simplex("max", [0.5 0.3; 0.1 0.2], [150; 60], [3 1], [-1; -1], [1; 1]); #jedinstveno
#x, Z = rijesi_simplex("max", [30 16; 14 19; 11 26; 0 1], [22800; 14100; 15950; 550], [800 1000], [-1; -1; -1; -1], [1; 1]); #jedinstveno
#x, Z = rijesi_simplex("max", [-2 1; 0 1], [1; 3], [1 2], [-1;-1], [1; 1]); #rjesenje je u beskonacnosti

#x, Z = rijesi_simplex("min", [0.1 0; 0 0.1; 0.5 0.3; 0.1 0.2], [0.2; 0.3; 3; 1.2], [40 30], [1; 1; 1; 1], [1; 1]); #nije jedinstveno
x, Z = rijesi_simplex("min", [0.25 -8 -1 9; 0.5 -12 -0.5 3; 0 0 1 0], [0; 0; 1], [-3 80 -2 24], [-1; -1; -1], [1; 1; 1; 1]); #degenerirano pocetno bazno rjesenje
#x, Z = rijesi_simplex("min", [1 0 3; 0 2 2], [5; 2], [6 18 24], [1; 1], [0; 1; -1]); #ima rjesenja neogranicenih po znaku

    println("Rješenja:")
if x == "R"
    println("Rjesenje je u beskonacnosti");
elseif x == "N"
        println("Rjesenje ne postoji");
else
    println(x);
    println("Vrijednost cilja:")
    println(Z);
end
catch e
    println(e);
end