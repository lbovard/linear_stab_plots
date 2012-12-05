function omega = get_vertical_vorticity(kz,Fh,Re,N,end_time)
%kz=100;
%Fh=0.2;
%Re=10000;
%N=512;
%end_time=12;
%generate grid
S={'u' 'v' 'w' 'rho'};
L=9;
for i=1:2
    %get filename
    fname=strcat('kz.',num2str(kz),'.0.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.nc');
    repart=ncread(fname,S{i},[1 1 end_time 1],[N N 1 1]);
    impart=ncread(fname,S{i},[1 1 end_time 2],[N N 1 1]);
    D{i}=repart+1i*impart;
end
k_x=2*pi/L*repmat([0:N/2 -N/2+1:-1],N,1);
k_y=k_x';
omega=ifft2(1i*k_x.*fft2(D{2})-1i*k_y.*fft2(D{1}));
end