N=512;
Re=20000;
Fh_v=4;
Fh_array=[0.2,0.1,0.05];

L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';
[X,Y]=meshgrid(x,y);

kz_array=Fh_v./Fh_array;
disp(kz_array)

for i=1:3;
    omega=get_vertical_vorticity(kz_array(i),Fh_array(i),Re,N,12);
    subplot(3,1,i)
    surf(X,Y,imag(omega),'EdgeColor','none')
    axis([-1.5 1.5 -1.5 1.5])
    axis square
end