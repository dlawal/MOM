function [ Z ] = create_Z(k, Ts, rs, ro,Ss,So,Q)
%create_Z Summary of this function goes here
%   Detailed explanation goes here
% k propagation constant
% Ts tagential vector of the source
% rs source coordinate
% ro observer coordinate
% Q points for quadrature rule
% Q point Quadrature rule (eg: 1-point Quadrature)
% find the distance between source and observer
[~,w] = qrule(Q);
Ps = testpts(rs(1),rs(2),Ss,Q);
Po = testpts(ro(1),ro(2),So,Q);
b = zeros(Q,Q);
V = zeros(1,Q);
for i = 1:Q
    for j = 1:Q
        P = Po(:,j)-Ps(:,i);
        Pmag = sqrt(P'*P);
        Punit = zeros(1,3);
        Punit(1:2) = P/Pmag;
        T = zeros(1,3);
        T(1:2) = Ts;
        T(3) = 0;
% new line of code for notes        
        angle = atan2(Ts(2),Ts(1));
%         z_comp = cross(T,Punit);
        z_comp = sin(angle)*Punit(1) - cos(angle)*Punit(2);
        if k*Pmag <= .01
            b(i,j) = (besselh(1,2,k*Pmag))*z_comp;% - 1j*2/pi/(k*Pmag))*z_comp; %sqrt(So(1)^2+So(2)^2)*
%               b(i,j) = 1j*2/pi/(k*Pmag);
        else
            b(i,j) = besselh(1,2,k*Pmag)*z_comp;
        end
    end
end
Z = (b*w')'*w';
% V = (w*b')*w';
end
