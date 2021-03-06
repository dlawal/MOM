function [ Z ] = create_Z_notes(k, Ts, rs, ro,Ss,So,Qs,Qo,flag)
%create_Z Summary of this function goes here
%   Detailed explanation goes here
% k propagation constant
% Ts tagential vector of the source
% rs source coordinate
% ro observer coordinate
% Q points for quadrature rule
% Q point Quadrature rule (eg: 1-point Quadrature)
% find the distance between source and observer
[~,ws] = qrule(Qs);
[~,wo] = qrule(Qo);
Ps = testpts(rs(1),rs(2),Ss,Qs);
Po = testpts(ro(1),ro(2),So,Qo);
b = zeros(Qs,Qo);
for i = 1:Qs
    for j = 1:Qo
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
        if flag %k*Pmag <= .05
            b(i,j) = ((besselh(1,2,k*Pmag))*z_comp - 1j*2/pi/(k*Pmag)*z_comp);%*sqrt(So(1)^2+So(2)^2);
%               b(i,j) = 1j*2/pi/(k*Pmag);
        else
            b(i,j) = (besselh(1,2,k*Pmag)*z_comp);%*sqrt(So(1)^2+So(2)^2);
        end
    end
end

if flag
    Z = (b*wo') + 1j*2/pi*log(k*Pmag)*z_comp; %+ add the analytic solution for singularity
else
    Z = (b*wo')*sqrt(So(1)^2+So(2)^2);
end
% V = (w*b')*w';
end

