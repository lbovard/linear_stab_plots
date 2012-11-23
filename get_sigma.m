%close all;
%clear all;
function sigma=get_sigma(sigma_name,totE_name,dt)
%i=36;
%sigma_name=strcat('kz.',num2str(i),'.0.sigma.512.re.20000.0.fh.0.05.')
%totE_name=strcat('kz.',num2str(i),'.0.totE.512.re.20000.0.fh.0.05.');
kz=dlmread(sigma_name);
totE=dlmread(totE_name);
%dt=0.0019/2;
%dt=0.00075/2;
%ignore first 20% of data
ig=0.2;
N=floor(ig*length(kz));
kz=kz(N:end);
N=length(kz);

osc=0;
has_nans=0;
weird_case=0;
sigma=0;
x=1:1:length(totE);
x=dt*x';

%find peaks
j=1;l=1;
for i=2:N-1
    a=kz(i-1);
    b=kz(i);
    c=kz(i+1);
    if(a<b && b>c)
        maximums(j,:)=[b,i];
        j=j+1;
    elseif (a>b && b<c)
        minimums(l,:)=[b,i];
        l=l+1;
    end
end

if(exist('maximums')==0)
    disp('no maximums')
    sigma=mean(kz);
    return;
end

%compute means of max, min, and data
max_mean=mean(maximums(:,1));
min_mean=mean(minimums(:,1));
dat_mean=mean(kz);


%detect oscillations
if(norm(dat_mean-max_mean,inf)>0.01 || norm(dat_mean-min_mean,inf)>0.01)
    %now check to ensure they are real oscillations by measuring the last
    %maximum with the last 10% of data
    last_mean=mean(kz(floor((0.9)*N):end));
    if(norm(last_mean-kz(maximums(end,2)))>0.1)
        osc=1;
    end
end

%check variation in the last 20% of data
if norm(mean(kz(floor(0.8*N):end))-kz(end),inf)>0.01
    weird_case=1;
end

%%now get sigma by first checking for NaNs and grabbing the last sigma.


%do NaN check
nans=find(isnan(kz)==1);
if sum(nans)~= 0
    %if nans probably means heavily damped so very confident in sigma
    sigma=kz(nans(1)-1);
    disp('NaNs detected')
elseif osc==1
    max_period=maximums(2:end,2)-maximums(1:end-1,2);
    min_period=minimums(2:end,2)-minimums(1:end-1,2);
    parray=horzcat(max_period',min_period');
    period=dt*ceil(mean(parray));
    N=floor(ig*length(totE));
    totE=totE(N:end);
    N=length(totE);
    max_period=totE(maximums(2:end,2))-totE(maximums(1:end-1,2));
    min_period=totE(minimums(2:end,2))-totE(minimums(1:end-1,2));
    parray=horzcat(max_period',min_period');
    sigma=mean(parray/(period));
    disp('oscillations detected');
else %no oscillations and no nans, take last 20% of data to average
    %take the average of the last 20%
    sigma=mean(kz(floor((0.9)*N):end));
end

%plot(kz)
%hold on
%plot(maximums(:,2),maximums(:,1),'r*')
%plot(minimums(:,2),minimums(:,1),'r*')
%axis([0 N -2 2])

end