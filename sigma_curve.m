%close all;
%   close all;

kz=[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0, 160.0];
%kz=[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0, 100.0, 110.0, 120.0, 130.0, 140.0];
%kz=[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 45.0, 50.0, 55.0, 60.0, 65.0, 70.0, 75.0, 80.0, 85.0, 90.0, 95.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0, 160.0, 170.0, 180.0, 190.0, 200.0, 210.0, 220.0];

N=512;
Re=10000;
Fh=0.1;

results=zeros(length(kz),2);
j=1;
i=1;
%get dt, make better
sigma_name=strcat('kz.',num2str(i),'.0.sigma.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.dat');
totE_name=strcat('kz.',num2str(i),'.0.sigma.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.dat');
kz_temp=dlmread(sigma_name);
totE_tmep=dlmread(totE_name);
dt=mean((totE_tmep(2:end)-totE_tmep(1:end-1))./kz_temp(1:end-1));
disp(dt);  
for i=kz
    sigma_name=strcat('kz.',num2str(i),'.0.sigma.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.dat');
    totE_name=strcat('kz.',num2str(i),'.0.sigma.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.dat');
    disp(sigma_name);
    results(j,1)=kz(j);
    results(j,2)=get_sigma(sigma_name,totE_name,dt);
    j=j+1;
end
dlmwrite('fh0.1.re10000.512_hyper.dat',results,'precision',15);
%dlmread('kz.1.0.sigma.512.re.10000.0.fh.0.1.');
%dlmread('kz.10.0.sigma.512.re.10000.0.fh.0.1.');