function [reomega,imagomega] = get_vertical_vorticity(kz,N,uhat,vhat)
% obtain the vertical vorticity from the uhat,vhat fields via ifft
% returns real and imaginary parts of vertical vorticity
% kz ~ vertical wavenumber, N ~ number of grid points
% uhat, vhat are u,v fields in Fourier space


reomega=zeros(N,N);
imagomega=zeros(N,N);
%kx,ky matrices
L=9;
k_x=2*pi/L*repmat([0:N/2 -N/2+1:-1],N,1);
k_y=k_x';

omega=ifft2(1i*k_x.*fft2(vhat)-1i*k_y.*fft2(uhat));

%normalise wrt maximum element
reomega=real(omega)./max(max(real(omega)));
imagomega=imag(omega)./max(max(imag(omega)));
end
