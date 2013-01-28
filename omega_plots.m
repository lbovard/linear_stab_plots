close all;
clear all;
N=512;

%kz=[120,80,50,25];
kz=50*ones(4,1); 
Re=[20000,10000,5000,2000];
vtimes=[11,11,6,3];
Fh=0.2;
for i=1:4
[om{i},ptitle{i}]=omega_information(kz(i),Fh,Re(i),N,vtimes(i),0);
end

L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';
[X,Y]=meshgrid(x,y);

for i=1:4
	subplot(2,2,i)
	surf(X,Y,om{i},'EdgeColor','none')
	axis([-1.2 1.2 -1.2 1.2])
	axis square
	title(ptitle{i})
	caxis([-1 1])
	view(2)
end
