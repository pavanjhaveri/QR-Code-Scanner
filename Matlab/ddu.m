clc;
clear all;
close all;

img = imread('D:\check4.jpg');
img1 = rgb2gray(img);
img2 = im2bw(img1);
subplot(3,3,1);
imshow(img2);
count = 0 ;
[m n]=size(img2);
x=1;
for i=1:m
    for j=1:n
        if(img2(i,j)==0)   % black
           count=count+1;
           break;
        end
    end
    if(count==0)
        img3=imcrop(img2,[x i+1 n m]);
        
    end
end
subplot(3,3,2);
imshow(img3);
[m n]=size(img3);
count=0;
for i=1:m
    for j=1:n
        if(img2(i,j)==0)   % black
           count=count+1;
           break;
        end
    end
    if(count==0)
        img4=imcrop(img3,[i+1 x n m]);
        
    end
end
subplot(3,3,3);
imshow(img4);
count=0;
[m n]=size(img4);

for i=m:-1:1
    for j=n:-1:1
        if(img4(i,j)==0)   % black
           count=count+1;
           break;
        end
    end
    if(count==0)
        img5=imcrop(img4,[1 1 n i-1]);
        
    end
end
subplot(3,3,4);
imshow(img5);
[m n]=size(img5);
count=0;
for i=m:-1:1
    for j=n:-1:1
        if(img4(i,j)==0)   % black
           count=count+1;
           break;
        end
    end
    if(count==0)
        img6=imcrop(img5,[1 1 i-1 m]);
    end
end
subplot(3,3,5);
imshow(img6);

[m n]=size(img6);

if(img6(1,1)==1)
    img7=imcrop(img6,[2 2 n m]);
    subplot(3,3,6);
    imshow(img7);
elseif(img6(m,n)==1)
    img7=imcrop(img6,[0 0 n-1 m-1])
    subplot(3,3,6);
    imshow(img7);
end
[m n]=size(img7);
if(img7(1,1)==1 || img7(m,1)==1 || img7(1,n)==1)
    disp('noisy qr code');
end 
i=1;
j=1;
bpix=0;

while img7(i,j)==0
    bpix=bpix+1;
    j=j+1;
end
module_size=round(bpix/7);
version=round(m/module_size);
version_number=round((version-17)/4);
disp(round(version_number));
k=1;
l=1;
for i=1:m
    if (mod(i,round(module_size))==1)
        l=1;
            for j=1:n
                if (mod(j,round(module_size))==1)
                    mat(k,l)=img7(i,j);
                    l=l+1;
                end
            end
            k=k+1;
    end
end

mask=[1 1 1 0 1 1 1 1 1 0 0 0 1 0 0; 1 1 1 0 0 1 0 1 1 1 1 0 0 1 1; 1 1 1 1 1 0 1 1 0 1 0 1 0 1 0; 1 1 1 1 0 0 0 1 0 0 1 1 1 0 1; 1 1 0 0 1 1 0 0 0 1 0 1 1 1 1; 1 1 0 0 0 1 1 0 0 0 1 1 0 0 0; 1 1 0 1 1 0 0 0 1 0 0 0 0 0 1; 1 1 0 1 0 0 1 0 1 1 1 0 1 1 0];
mask1=mat(9,1:6);
mask2=mat(9,8:9);
mask3=mat(8,9);
mask4=mat(1:6,9);
mask5=transpose(mask4);

x=mask5(6);
mask5(6)=mask5(1);
mask5(1)=x;
x=mask5(5);
mask5(5)=mask5(2);
mask5(2)=x;
x=mask5(4);
mask5(4)=mask5(3);
mask5(3)=x;

mainmask = [mask1 mask2 mask3 mask5];
mainmask1=not(mainmask);

count=0;
for i=1:8
    count=0;
    for j=1:15
        if mainmask1(j)~= mask(i,j)
           count=count+1 ;
           break;
        end
    end
    if count==0;
        maskp=i;
        break;
    end
end
matn=not(mat);
fmaskp=maskp-1;

[m n]=size(matn);
if fmaskp==0
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(i+j,2)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end

if fmaskp==1
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(i,2)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end
    
if fmaskp==2
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(j,3)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end

if fmaskp==3
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(i+j,3)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end

if fmaskp==4
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(floor(i/2)+floor(j/3),3)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end

if fmaskp==5
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if ((mod(i*j,2)+mod(i*j,3))==0)
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end


if fmaskp==6
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod(mod(i*j,2)+ mod(i*j,3),2)==0
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end

if fmaskp==7
    for i=0:m-1
        for j=0:n-1
            k=i+1;
            l=j+1;
            if mod((mod(i+j,2)+ mod(i*j,3)),2)==0
                
                matn(k,l)=not(matn(k,l));
            end
        end
    end
end
    
 
    
    fmatn=not(matn);
    subplot(3,3,7);
    imshow(fmatn);
    
    x=(matn(m,n)*2^3) + (matn(m,n-1)*2^2) +(matn(m-1,n)*2^1) +(matn(m-1,n-1)*2^0);
    if x==1
        display('Numeric Mode');
    elseif x==2
        display('AlphaNumeric Mode');
    elseif x==4
        display('Byte Mode');
    end
    
    %Length=(matn(27,29)*2^7) + (matn(27,28)*2^6) +(matn(26,29)*2^5) +(matn(26,28)*2^4)+(matn(25,29)*2^3) + (matn(25,28)*2^2) +(matn(24,29)*2^1) +(matn(24,28)*2^0);
    Length=(matn(m-2,n)*2^7) + (matn(m-2,n-1)*2^6) +(matn(m-3,n)*2^5) +(matn(m-3,n-1)*2^4)+(matn(m-4,n)*2^3) + (matn(m-4,n-1)*2^2) +(matn(m-5,n)*2^1) +(matn(m-5,n-1)*2^0);
    display(Length);
    datab =['0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' '0' ' ' '!' '"' '#' '$' '%' '&' '"' '(' ')' '*' '+' ',' '-' '.' '/' '0' '1' '2' '3' '4' '5' '6' '7' '8' '9' ':' ';' '<' '=' '>' '?' '@' 'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' '[' '\' ']' '^' '_' '`' 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z' '{' '|' '}' '~' '0'];
    
    if version_number==1
        k=21;
        l=15;
        for i=1:Length
            if i==1 || i==6 || i==7 || i==12 || i==13 || i==14
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
            elseif i==2 || i==8 || i==16
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-1,k-2)*2^3) + (matn(l-1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=k-2;
                l=l+1;
            elseif i==3 || i==4 || i==9 || i==10 || i==17
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=l+4;
            elseif i==5 || i==11
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+1,k-2)*2^3) + (matn(l+1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=k-2;
                l=l-1;
            elseif i==15
                l=l-1;
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
            end
        end
    end
    
    if version_number==2
       k=25;
       l=19;
       for i=1:Length
            if i==1 || i==2 || i==9 || i==13
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
            elseif i==3;
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-1,k-2)*2^3) + (matn(l-1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=k-2;
                l=l+1;
            elseif i==4 || i==5 || i==6 || i==11
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=l+4;
            elseif i==7
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+1,k-2)*2^3) + (matn(l+1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=k-2;
                l=l-1;
            elseif i==8
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-7,k)*2^3) + (matn(l-7,k-1)*2^2) +(matn(l-8,k)*2^1) +(matn(l-8,k)*2^0);
                l=l-9;               
            elseif i==10
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l,k-2)*2^5) +(matn(l,k-3)*2^4)+(matn(l+1,k-2)*2^3) + (matn(l+1,k-3)*2^2) +(matn(l+2,k-2)*2^1) +(matn(l+2,k-3)*2^0);
                k=k-2;
                l=l+3;
            elseif i==12
                l=l+5;
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=l+3;
                k=k-2;
            elseif i==14
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k-1)*2^6) +(matn(l-2,k-1)*2^5) +(matn(l-3,k-1)*2^4)+(matn(l-4,k-1)*2^3) + (matn(l-5,k)*2^2) +(matn(l-5,k-1)*2^1) +(matn(l-6,k)*2^0);
                l=l-6;
            elseif i==20 || i==21 || i==22 || i==23 || i==32
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+2,k)*2^4)+(matn(l+2,k-1)*2^3) + (matn(l+3,k)*2^2) +(matn(l+3,k-1)*2^1) +(matn(l+4,k)*2^0);
                l=l+4;
            elseif i==56
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+2,k)*2^4)+(matn(l+2,k-1)*2^3) + (matn(l+2,k-2)*2^2) +(matn(l+2,k-3)*2^1) +(matn(l+1,k-2)*2^0);
                k=k-2;
                l=l+1;
            elseif i==15 || i==17 || i==25 || i==26 || i==27 || i==29
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-2,k)*2^4)+(matn(l-2,k-1)*2^3) + (matn(l-3,k)*2^2) +(matn(l-3,k-1)*2^1) +(matn(l-4,k)*2^0);
                l=l-4;
            elseif i==16 || i==28
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-2,k)*2^4)+(matn(l-2,k-1)*2^3) + (matn(l-3,k)*2^2) +(matn(l-3,k-1)*2^1) +(matn(l-5,k)*2^0);
                l=l-5;
            elseif i==18 || i==30
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-1,k-2)*2^4)+(matn(l-1,k-3)*2^3) + (matn(l,k-2)*2^2) +(matn(l,k-3)*2^1) +(matn(l+1,k-2)*2^0);
                k=k-2;
                l=l+1;
            elseif i==19 || i==31
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+2,k)*2^4)+(matn(l+2,k-1)*2^3) + (matn(l+3,k)*2^2) +(matn(l+3,k-1)*2^1) +(matn(l+5,k)*2^0);
                l=l+5;
            elseif i==24
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+1,k-2)*2^4)+(matn(l+1,k-3)*2^3) + (matn(l,k-2)*2^2) +(matn(l,k-3)*2^1) +(matn(l-1,k-2)*2^0);
                k=k-2;
                l=l-1
            end
        end
   end
    
    if version_number==3
        k=29;
        l=23;
        for i=1:Length
            if i==1 || i==2 || i==3  
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
            elseif i==4;
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-1,k-2)*2^3) + (matn(l-1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=27;
                l=l+1;
            elseif i==5 || i==6 || i==7 || i==8
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=l+4;
            elseif i==9
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+1,k-2)*2^3) + (matn(l+1,k-3)*2^2) +(matn(l,k-2)*2^1) +(matn(l,k-3)*2^0);
                k=25;
                l=l-1;
            elseif i==10
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-7,k)*2^3) + (matn(l-7,k-1)*2^2) +(matn(l-8,k)*2^1) +(matn(l-8,k-1)*2^0);
                l=l-9;
            elseif i==11 || i==12
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
            elseif i==13
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l,k-2)*2^5) +(matn(l,k-3)*2^4)+(matn(l+1,k-2)*2^3) + (matn(l+1,k-3)*2^2) +(matn(l+2,k-2)*2^1) +(matn(l+2,k-3)*2^0);
                k=23;
                l=l+3;
            elseif i==14 || i==15
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=l+4;
            elseif i==16
                l=26;
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l+1,k)*2^5) +(matn(l+1,k-1)*2^4)+(matn(l+2,k)*2^3) + (matn(l+2,k-1)*2^2) +(matn(l+3,k)*2^1) +(matn(l+3,k-1)*2^0);
                l=29;
                k=21;
            elseif i==17
                d(i)=(matn(l,k)*2^7) + (matn(l,k-1)*2^6) +(matn(l-1,k)*2^5) +(matn(l-1,k-1)*2^4)+(matn(l-2,k)*2^3) + (matn(l-2,k-1)*2^2) +(matn(l-3,k)*2^1) +(matn(l-3,k-1)*2^0);
                l=l-4;
                k=k-1;
            elseif i==18
                d(i)=(matn(l,k)*2^7) + (matn(l-1,k)*2^6) +(matn(l-2,k)*2^5) +(matn(l-3,k)*2^4)+(matn(l-4,k)*2^3) + (matn(l-5,k+1)*2^2) +(matn(l-5,k)*2^1) +(matn(l-6,k+1)*2^0);
                k=21;
                l=19;
            elseif i==19 || i==20 || i==22 || i==31 || i==32 || i==33 || i==34 || i==36 || i==45 || i==46 || i==47 || i==48 || i==50
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-2,k)*2^4)+(matn(l-2,k-1)*2^3) + (matn(l-3,k)*2^2) +(matn(l-3,k-1)*2^1) +(matn(l-4,k)*2^0);
                l=l-4;
            elseif i==21 || i==35 || i==49
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-2,k)*2^4)+(matn(l-2,k-1)*2^3) + (matn(l-3,k)*2^2) +(matn(l-3,k-1)*2^1) +(matn(l-5,k)*2^0);
                l=l-5;
            elseif i==23 || i==37 || i==51
                d(i)=(matn(l,k-1)*2^7) + (matn(l-1,k)*2^6) +(matn(l-1,k-1)*2^5) +(matn(l-1,k-2)*2^4)+(matn(l-1,k-3)*2^3) + (matn(l,k-2)*2^2) +(matn(l,k-3)*2^1) +(matn(l+1,k-2)*2^0);
                l=l+1;
                k=k-2;
            elseif i==24 || i==38 || i==52
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+2,k)*2^4)+(matn(l+2,k-1)*2^3) + (matn(l+3,k)*2^2) +(matn(l+3,k-1)*2^1) +(matn(l+5,k)*2^0);
                l=l+5;
            elseif i==25 || i==26 || i==27 || i==28 || i==29 || i==39 || i==40 || i==41 || i==42 || i==43 || i==53
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+2,k)*2^4)+(matn(l+2,k-1)*2^3) + (matn(l+3,k)*2^2) +(matn(l+3,k-1)*2^1) +(matn(l+4,k)*2^0);
                l=l+4;
            elseif i==30 || i==44
                d(i)=(matn(l,k-1)*2^7) + (matn(l+1,k)*2^6) +(matn(l+1,k-1)*2^5) +(matn(l+1,k-2)*2^4)+(matn(l+1,k-3)*2^3) + (matn(l,k-2)*2^2) +(matn(l,k-3)*2^1) +(matn(l-1,k-2)*2^0);
                k=k-2;
                l=27;
            end
        end
    end
    disp(datab(d()+1));
    
    
    
    