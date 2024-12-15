using Pkg;
Pkg.add("LinearAlgebra");
using LinearAlgebra;
import Base.DimensionMismatch
#Radili Muhamed Selmanovic i Mirza Olovcic

function general_simplex(goal, c, A, b, csigns, vsigns)
    negative=false;
    Z=0;
    pivotRed=1
    bSize=size(b,1);
    numberOfRowsA=size(A,1);
    numberOfColumnsA=size(A,2);
    cSize=size(c,2);
    if  Int(size(b,1))!=Int(numberOfRowsA)
        #greska- nije moguce da A ima vise redova nego b jer b cuva vrijednosti bi dok A cuva vrijednosti xi 
        return NaN,NaN,NaN,NaN,NaN,5
        end
    if (cSize!=numberOfColumnsA)
        #greska- nije moguce da A ima vise kolona nego c jer c cuva vrijednosti u zadnjem redu simplex tabele dok A cuva vrijednosti xi za sve elemente koji nisu u bazi 
        return NaN,NaN,NaN,NaN,NaN,5
    end
    if (size(c,1)!=size(b,2))
        #greska- b treba biti vektor kolona dok c vektor red 
        return NaN,NaN,NaN,NaN,NaN,5
    end
    if goal!="max" && goal!="min"
        #greska- mozemo samo traziti min i max
        return NaN,NaN,NaN,NaN,NaN,5
    end
if length(csigns)!=bSize
    #greska- csigns predstavlja znak ogranicenja dok b predstavlja desnu stranu ogranicenja, mora biti iste velicine
    return NaN,NaN,NaN,NaN,NaN,5

end
if length(vsigns)!=numberOfColumnsA
    #greska- vsigns predstavlja znak varijabli dok broj kolona predstavlja broj varijabli, mora biti iste velicine
        return NaN,NaN,NaN,NaN,NaN,5

end
for i in 1:bSize
    if (csigns[i]!=1 && csigns[i]!=0 && csigns[i]!=-1)         return NaN,NaN,NaN,NaN,NaN,5
    end
end
for i in 1:numberOfColumnsA
    if (vsigns[i]!=1 && vsigns[i]!=0 && vsigns[i]!=-1)         return NaN,NaN,NaN,NaN,NaN,5
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
   status1=0
   status=0
   indeksi_jednakih=zeros(Int,bSize)
   indeksi_vece=zeros(Int,bSize)
   for j in 1:numberOfRowsA
    if b[j]==0
       status1= 1
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
if goal=="min" && jednako==0 && vece==0
    basesize=numberOfColumnsA+2*manje
else
basesize=numberOfColumnsA+2*vece+manje+2*jednako;
end
    base = zeros(Float64,basesize);
    b1=zeros(Float64,basesize);
    for i in 1:bSize
        b1[i]=b[i];
    end
    for i in 1:cSize
      base[i] = c[i];
    end
    if vece!=0 || goal=="min"
        if vece+jednako==vece+jednako+manje
    fullMatrix=Float64[A I(vece+jednako)*(-1) I(vece+manje+jednako)]
elseif goal=="min" && vece==0 && jednako==0
    fullMatrix=Float64[A I(manje)*(-1) I(manje)]
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
        if (pivotKolona>=numberOfColumnsA+vece+2*jednako+2*manje ||  pivotKolona==numberOfColumnsA+2*manje+2*vece+jednako) && ((goal=="max" && (vece!=0 || jednako!=0)) || (goal=="min"))
    if pivotKolona==numberOfColumnsA+2*manje+2*vece+jednako
        status=1
        negative=true
        break
    end
            max,pivotKolona=findmax(vcat(base[1:pivotKolona-1],base[pivotKolona+1,end]))
            pivotKolona+=1
            if pivotKolona>=numberOfColumnsA+vece+2*jednako+2*manje && ((goal=="max" && (vece!=0 || jednako!=0)) || (goal=="min"))
            negative=true
            break
            end
        end
        else
            max,pivotKolona=findmax(M);
            if pivotKolona>=numberOfColumnsA+vece+jednako && ((goal=="max" && (vece!=0 || jednako!=0)) || goal=="min")
                max,pivotKolona=findmax(vcat(M[1:pivotKolona-1],M[pivotKolona+1,end]))
            end
            max1,pivotKolona1=findmax(vcat(M[1:pivotKolona-1],M[pivotKolona+1,end]))
            if max1==max
                if base[pivotKolona]<base[pivotKolona1+1]
                    max=max1
                    pivotKolona=pivotKolona1+1
                end
            end
        end
        if max<=0.000000001
            if MisOut==true
            negative=true;
            break
            else 
                for k in 1:bSize
                    if  indeksi_jednakih[k]!=0 || indeksi_vece[k]!=0 
                        return   NaN,NaN,NaN,NaN,NaN,4
                    end
                end
                MisOut=true
            end
        else
            if pivotKolona>numberOfColumnsA && pivotKolona<=numberOfColumnsA+vece+jednako+manje && MisOut==true
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
        return Inf,NaN,NaN,NaN,NaN,3
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
if Z==Z-(b1[pivotRed]*base[pivotKolona])
    status1=1
end
 Z-=(b1[pivotRed]*base[pivotKolona]); 
 if !((goal=="max" || goal=="min") && jednako==0 && vece==0) && MisOut==false
    M1-=(b1[pivotRed]*M[pivotKolona])
M.-=(fullMatrix[pivotRed,:].*M[pivotKolona])
    end
base[1:end].-=(fullMatrix[pivotRed,1:end].*base[pivotKolona]);
end
  
    end
if vece!=0 || jednako!=0
    for k in 1:bSize
        if indeksi_jednakih[k]!=0 || indeksi_vece[k]!=0 
            return   NaN,NaN,NaN,NaN,NaN,4
        end
    end

end
numberOfZeros=0
for i in numberOfColumnsA+vece+jednako+1:basesize
    if base[i]==0 && status1==0
        numberOfZeros+=1
    end
end
for i in 1:numberOfColumnsA
    if base[i]==0 && status1==0
        numberOfZeros+=1
    end
end


if numberOfZeros>numberOfRowsA
    status=2
else
    if status1==0
    status=0
    else
        status=1
    end
end
    x=zeros(Float64,basesize-vece-jednako);
for i in 1:basesize-vece-jednako
index=0;
if base[i]==0
for j in 1:numberOfRowsA
if fullMatrix[j,i]==1
fullMatrix[j,:].=0
index=j;
break;

end
end
if index!=0
x[i]=(b1[index]);
else
    x[i]=0
end
else
x[i]=0;
end
end
x1=x[1:numberOfColumnsA]
x2=x[numberOfColumnsA+1:end]
y=zeros(Float64,basesize-vece-jednako)
for i in 1:basesize-vece-jednako
    if i<=numberOfColumnsA && base[i]<0
        base[i]*=-1
    elseif i>numberOfColumnsA && ((goal=="max" && csigns[i-numberOfColumnsA]==-1)|| (goal=="min" &&csigns[i-numberOfColumnsA]==1) )
        base[i]*=-1
    end

end
for i in 1:(basesize-vece-jednako)
    if i+vece+jednako+numberOfColumnsA<=basesize
    y[i]=base[i+vece+jednako+numberOfColumnsA]
    else
        for j in 1:(basesize-vece-jednako)
        y[i]=base[j]
        if i==basesize-vece-jednako
            break
        end
        i+=1
        end
        break
    end
end
if goal=="max"
Z*=-1
end

y1=y[1:end-numberOfColumnsA]
y2=y[end-numberOfColumnsA+1:end]
    return Z,x1,x2,y1,y2,status
    
end
try
#PRIMJERI ZA PROVJERU IZ KNJIGE:

#Z,X,Xd,Y,Yd,status = general_simplex("max", [3 1],[0.5 0.3; 0.1 0.2], [150; 60],[-1 -1], [1 1]); #jedinstveno
#Z,X,Xd,Y,Yd,status = general_simplex("max", [800 1000], [30 16; 14 19; 11 26; 0 1],[22800; 14100; 15950; 550],[-1; -1; -1; -1], [1; 1]); #jedinstveno
#Z,X,Xd,Y,Yd,status= general_simplex("max",  [1 2], [-2 1; 0 1],[1; 3], [-1;-1], [1; 1]); #rjesenje je u beskonacnosti

#Z,X,Xd,Y,Yd,status= general_simplex("min", [40 30],[0.1 0; 0 0.1; 0.5 0.3; 0.1 0.2],[0.2; 0.3; 3; 1.2], [1; 1; 1; 1], [1; 1]); #nije jedinstveno

#Z,X,Xd,Y,Yd,status= general_simplex("min",  [6 18 24],[1 0 3; 0 2 2],[5; 2],  [1; 1], [0; 1; -1]); #ima rjesenja neogranicenih po znaku

#Z, X, Xd, Y, Yd, status = general_simplex("max", [40 30], [3 1.5; 1 1; 2 1; 3 4; 1 0; 0 1], [300; 80; 200; 360; 60; 60], [-1 -1 -1 -1 -1 -1], [1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("min", [1 1.5], [2 1; 1 1; 1 1], [10; 8; 12], [1 1 1], [1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("min", [32 56 50 60], [1 1 1 1; 250 150 400 200; 0 0 0 1; 0 1 1 0], [1; 300; 0.3; 0.5], [0 1 -1 -1], [1 1 1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("max", [1 300 -0.3 -0.5], [1 250 0 0; 1 150 0 -1; 1 400 0 -1; 1 200 -1 0], [32; 56; 50; 60], [-1 -1 -1 -1], [0 1 1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("max", [1 1], [-2 1; -1 2], [-1; 4], [-1 1], [1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("max", [1 2], [1 1; 3 3], [2; 4], [1 -1], [1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("max", [4000 2000], [3 3; 2 1; 1 0; 0 1], [12000; 6000; 2500; 3000], [-1 -1 -1 -1], [1 1]);

#Z, X, Xd, Y, Yd, status = general_simplex("max", [3 9], [1 4; 1 2], [8; 4], [-1 -1], [1 1]);

 println("Rješenja:")
    println(X);
    println("Vrijednost cilja:")
    println(Z);
    println("Vrijednost duala: ")
    println(Y)
    println("Vrijednost dodatnih: ")
    println(Xd)
    println("status")
    println(status)
    println("Yd")
    println(Yd)
catch e
    println(e);
end