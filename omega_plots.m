close all;
clear all;

velocity_plots=0;
%for lower osc
%kz_array=[10,6,15,40];

%for second peak
kz_array=[20,35,45,50];

%Fh=0.2;
Fh_array=[100000, 0.2,0.1,0.05];
Re=10000;
N=512;
end_time=10;
%generate grid
L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';
[X,Y]=meshgrid(x,y);

S={'u' 'v' 'w' 'rho'};
TT={'Real ','Imag '};
ll=1;
%h=figure('name',strcat('kz=',num2str(kz)),'numbertitle','off');
h=figure('name','various kz','numbertitle','off');
for l=Fh_array
    kz=kz_array(ll);
    Fh=l;
T={strcat('Real',num2str(kz),'fh=',num2str(Fh)), strcat('Imag',num2str(kz),'fh=',num2str(Fh))};

for i=1:4
    %get filename
    if(mod(kz,1)==0)
        %fname=strcat('kz.',num2str(kz),'.0.',S{i},'_',num2str(N),'.dat');
        %fname=strcat('k_z.',num2str(kz),'.0.',S{i},'.dat');
        %fname=strcat('kz.',num2str(kz),'.0.',S{i},'.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.060.dat');
        %kz.15.0.512.re.20000.0.fh.0.05.n
        fname=strcat('kz.',num2str(kz),'.0.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.nc');
        %re_
        %disp(fname);
    else 
        fname=strcat('kz.',num2str(kz),'.',S{i},'_',num2str(N),'.dat');
        disp(fname);
    end
    repart=ncread(fname,S{i},[1 1 end_time 1],[N N 1 1]);
    impart=ncread(fname,S{i},[1 1 end_time 2],[N N 1 1]);
    D{i}=repart+1i*impart;
end

if velocity_plots==1
    for j=1:2
        h=figure('name',T{j},'numbertitle','off');
        for i=1:length(S)
            %fname=[T{j},S{i}]; 
            fname=[TT{j},S{i}];
            subplot(2,2,i)
            if(j==1)
                surf(X,Y,real(D{i}),'EdgeColor','none')
            else
                surf(X,Y,imag(D{i}),'EdgeColor','none')
            end
            view(2)
            axis square
            axis([-L/2 L/2 -L/2 L/2])
            title(fname)
        end
        print(h,'-dpng',T{j});
    end
end
k_x=2*pi/L*repmat([0:N/2 -N/2+1:-1],N,1);
k_y=k_x';
omega=ifft2(1i*k_x.*fft2(D{2})-1i*k_y.*fft2(D{1}));
ftitle=strcat('Omega ',num2str(kz),'fh=',num2str(Fh));
subplot(2,2,ll)
surf(X,Y,real(omega),'EdgeColor','none')
%contour(X,Y,real(omega),10)
%axis([-L/2 L/2 -L/2 L/2])
axis([-1.2 1.2 -1.2 1.2])
axis square
title(strcat('Real \omega_{z}, Fh=',num2str(Fh)))
%view(2)
%subplot(1,2,2)
%surf(X,Y,imag(omega),'EdgeColor','none')
%axis([-L/2 L/2 -L/2 L/2])
%view(2)
%title('Imag \omega')
%kz=100;
%Fh=0.2;
%Re=10000;
%N=512;
%end_time=12;
%generate grid
ll=ll+1;
end
