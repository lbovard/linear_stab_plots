%script to make profile plots

function profile_plots(kz,Fh,Re,N,end_time)
%kz=100;
%Fh=0.2;
%Re=10000;
%N=512;
%end_time=12;
%generate grid
L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';
[X,Y]=meshgrid(x,y);

S={'u' 'v' 'w' 'rho'};
TT={'Real ','Imag '};
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
k_x=2*pi/L*repmat([0:N/2 -N/2+1:-1],N,1);
k_y=k_x';
omega=ifft2(1i*k_x.*fft2(D{2})-1i*k_y.*fft2(D{1}));

ftitle=strcat('Omega ',num2str(kz),'fh=',num2str(Fh));
h=figure('name',ftitle,'numbertitle','off');
subplot(1,2,1)
surf(X,Y,real(omega),'EdgeColor','none')
axis([-L/2 L/2 -L/2 L/2])
title('Real \omega')
view(2)
subplot(1,2,2)
surf(X,Y,imag(omega),'EdgeColor','none')
axis([-L/2 L/2 -L/2 L/2])
view(2)
title('Imag \omega')
print(h,'-dpng',ftitle);
end