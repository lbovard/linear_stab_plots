close all;
clear all;
N=512;

%second peak
%kz=[50,60,70,40,50,55,30,35,45]; 

%oscillation
kz=[8,20,40,8,20,40,8,20,40];
Re=[20000,20000,20000,10000,10000,10000,5000,5000,5000];
vtimes=[12,5,6,5,5,6,5,5,6];
Fh=[0.2,0.1,0.05,0.2,0.1,0.05,0.2,0.1,0.05];
for i=1:9
[om{i},ptitle{i}]=omega_information(kz(i),Fh(i),Re(i),N,vtimes(i),0);
end

L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';
[X,Y]=meshgrid(x,y);

for i=1:9   
	subplot(3,3,i)
	surf(X,Y,om{i},'EdgeColor','none')
	axis([-1.2 1.2 -1.2 1.2])
	axis square
	title(ptitle{i})
	caxis([-1 1])
	view(2)
end
