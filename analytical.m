%% Analytical solution from Text
clc;clear;
constants
%% current on PEC cylinder
n = 50; % number of terms
r = lamb0/2/pi;
ka = k0*r; % ka = k*a --> (2pi/lambda)*(lambda) --> 2pi : if r = lambda
E0 = w*mu0*pi*r/2;
theta = 0:2*pi/(2*n):2*pi;
J = -2*E0/w/mu0/pi/r*ones(1,length(theta));
for t = 1:length(theta)
    angle = theta(t);
    sum = 0;
    for i = -n:n
      sum = sum + (1j^(-i)*exp(1j*i*angle))/(besselh(i,2,ka));
    end
    J(t) = J(t)*sum;
end
plot(theta*180/pi,abs(J)/E0)
xlim([theta(1)*180/pi theta(end)*180/pi])
%% Ratio of Scattered field to incident field
rho = 1;
coeff = sqrt(2/pi/k0/rho);
sigma = zeros(1,length(theta));
for t = 1:length(theta)
    angle = theta(t);
    sum = 0;
    for i = -n:n
        sum = sum + besselj(i,ka)*exp(1j*i*angle)/besselh(i,2,ka);
    end
    sigma(t) = abs(sum)*coeff;
end
polar(theta,sigma)