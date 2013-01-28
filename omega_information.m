function [romega,ptitle]=omega_information(kz,Fh,Re,N,vtime,recp)
% imports information about vertical vorticity and outputs vertical vorticity field and plot title
% kz ~ vertical wavenumber, Fh ~ Froude, Re ~Renyolds, N ~ timestep
% vtime ~ dump to be considered
% recp ~ real or complex part
%velocity_plots=0;

romega=zeros(N,N);

%%GET SOME IMPORTANT DATA 
nc_fname=strcat('kz.',num2str(kz),'.0.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.nc');
%get number of time dumps by looking at u variable. 
% the first dump is the initial data
% the final dump is the data at the last timestep
% ndumps -2 is the actual simulation data
vinfo=ncinfo(nc_fname,'u');
ndumps=vinfo.Size(3);

% get the timestep and total simulation time from sigma and totE data
sigma_name=strcat('kz.',num2str(kz),'.0.sigma.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.');
totE_name=strcat('kz.',num2str(kz),'.0.totE.',num2str(N),'.re.',num2str(Re),'.0.fh.',num2str(Fh),'.');
kz_temp=dlmread(sigma_name);
totE_temp=dlmread(totE_name);
%handle the cases where there are nans in data
nan_index=find(isnan(kz_temp)==1,1,'first');
if(nan_index~=length(kz_temp))
	disp('Nans detected');
	dt=mean((totE_temp(2:nan_index-1)-totE_temp(1:nan_index-2))./kz_temp(1:nan_index-2));
	end_time=dt*length(kz_temp);
else
	dt=mean((totE_temp(2:end)-totE_temp(1:end-1))./kz_temp(1:end-1));
	end_time=dt*length(kz_temp);
end
clear sigma_name totE_name kz_temp totE_temp


%how frequent is the data dumped?
fdump=end_time/(ndumps-2);
curr_time=round((vtime-1)*fdump);


%generate grid for plotting
L=9;dx=L/N;
x=-L/2+dx*(1:N);
y=x';

%variable names for plotting and grabbing data from netcdf
VN={'u' 'v' 'w' 'rho'};
FT={'Real ','Imag '};
%h=figure('name',strcat('kz=',num2str(kz)),'numbertitle','off');
%h=figure('name','various kz','numbertitle','off');

T={strcat('Real kz=',num2str(kz),' fh= ',num2str(Fh)), strcat('Imag kz=',num2str(kz),' fh= ',num2str(Fh))};


%%OBTAIN DATA

%routine to get the [u,v,w,rho] from netcdf data
%remember data is in FOURIER SPACE
for i=1:4
    repart=ncread(nc_fname,VN{i},[1 1 vtime 1],[N N 1 1]);
    impart=ncread(nc_fname,VN{i},[1 1 vtime 2],[N N 1 1]);
    D{i}=repart+1i*impart;
end
clear repart impart
%if velocity_plots==1
%    for j=1:2
%        h=figure('name',T{j},'numbertitle','off');
%        for i=1:length(VN)
%            nc_fname=[FT{j},VN{i}];
%            subplot(2,2,i)
%            if(j==1)
%                surf(X,Y,real(D{i}),'EdgeColor','none')
%            else
%                surf(X,Y,imag(D{i}),'EdgeColor','none')
%            end
%            view(2)
%            axis square
%            axis([-L/2 L/2 -L/2 L/2])
%            title(nc_fname)

%        end
%        print(h,'-dpng',T{j});
%    end
%end
%compute vertical vorticity
[reom,imom]=get_vertical_vorticity(kz,N,D{1},D{2});

%filename for printing
ftitle=strcat('Omega ',num2str(kz),'fh=',num2str(Fh));
%plotname
ptitle=strcat('Real \omega_{z} kz=',num2str(kz),' Fh=',num2str(Fh),' T=',num2str(curr_time), ' Re=', num2str(Re));
if recp==0
	romega=reom;
else
	romega=imom;
end	
end
