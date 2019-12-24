close all
clear
h = 16;
w = 100;
h_1 = h-1;
w_1 = w-1;

option = 2;
switch option
    case 1
        theta = -((0:w_1)-w_1/2)/(w_1/2)*pi/180*180;
        phi = -((0:h_1)-h_1/2)/(h_1/2)*pi/180*60;
        [Th,Ph] = meshgrid(theta, phi);
        img = 5*ones(h,w);
    case 2
        theta = -((0:w_1)-w_1/2)/(w_1/2)*pi/180*180;
        phi = -((0:h_1)-h_1/2)/(h_1/2)*pi/180*15;
        [Th,Ph] = meshgrid(theta, phi);
        img = 2 ./ cos(Ph);        
    case 3
        theta = -((0:w_1)-w_1/2)/(w_1/2)*pi/180*60;
        phi = -((0:h_1)-h_1/2)/(h_1/2)*pi/180*15;
        [Th,Ph] = meshgrid(theta, phi);
        d = 6;
        b = pi/2;
        img = (d * sin(b))./(cos(b)*sin(Ph) + cos(Th).*cos(Ph).*sin(b));
    case 4
        theta = -((0:w_1)-w_1/2)/(w_1/2)*pi/180*180;
        phi = -((0:h_1)-h_1/2)/(h_1/2)*pi/180*15;
        phi(h/2+1:end) = nan;
        [Th,Ph] = meshgrid(theta, phi);
        img = 1 ./ sin(Ph);        
end

X = img.*cos(Th).*cos(Ph);
Y = img.*sin(Th).*cos(Ph);
Z = img.*sin(Ph);
dRdth = (img(:,3:end) - img(:,1:end-2))/(2*(theta(1) - theta(2)));
dRdth = [NaN(h,1) dRdth NaN(h,1)];
dRdph = (img(3:end,:) - img(1:end-2,:))/(2*(phi(1) - phi(2)));
dRdph = [NaN(1,w); dRdph; NaN(1,w)];
scatter3(X(:), Y(:), Z(:),'.');
N = zeros(h,w,3);
for u = 1:h
    for v = 1:w
        th = Th(u,v);
        ph = Ph(u,v);
        R_theta = [cos(th) -sin(th) 0
            sin(th) cos(th) 0
            0 0 1];
        R_phi = [cos(ph) 0 -sin(ph)
            0 1 0
            sin(ph) 0 cos(ph)];
        R = R_theta * R_phi;
        N(u,v,:) = -R*[1;
            1/(img(u,v)*cos(ph))*dRdth(u,v);
            1/img(u,v)*dRdph(u,v)];
        N(u,v,:) = N(u,v,:)/norm([N(u,v,1) N(u,v,2) N(u,v,3)]);
    end
end
hold on
n0 = [X(:) Y(:) Z(:)];
n1 = n0 + reshape(N, [h*w, 3]);
plot3([n0(:,1)';n1(:,1)'],[n0(:,2)';n1(:,2)'],[n0(:,3)';n1(:,3)'],'b')
axis equal
color = N/2 + 0.5;
figure
image(color)
