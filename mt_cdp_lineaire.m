clear all    


%% Paramètres du réseau
n = 2 ; % Nombre de faisceaux
p = 500e-6 ; % Entraxe des faisceaux [m]
w0 = 60e-6 ; % Demi-largeur des faisceaux à 1/e² en intensité [m]
eta = 2*w0/p ; % Taux de remplissage du réseau
lambda = 980e-9 ; % Longueur d'onde du rayonnement [m]


%% Paramètres du filtre spatial
gamma = 0.3 ; % Rapport entre le diamètre du filtre et le diamètre du lobe central en champ lointain
beta2 = 0.04 ; % Transmissivité périphérique en intensité
beta = sqrt(beta2) ; % Transmissivité périphérique en champ
dphi = pi/2 ; % Déphasage entre le plot central et la périphérie [rad]


%% Matrice de couplage diffractif
L(1) = 1 ;
itx = 1:(n-1) ;
L(itx+1) = sin(2*gamma*pi*itx/n)./(2*gamma*pi*itx/n) ;
diffrac = toeplitz(L,L) ;


%% Matrices de transfert du filtre spatial
mt = beta*eye(n) + (exp(1i*dphi)-beta)*(sqrt(pi)*gamma*eta/n)*diffrac ;
mt = mt/max(max(abs(mt))) ;
mti = inv(mt) ;

%% Graphiques
figure(1),clf,colormap viridis

    subplot(2,2,1)
        imagesc(abs(mt))
        colorbar,caxis([0 1])
        axis square
        title('abs(mt)')
        
    subplot(2,2,3)
        imagesc(angle(mt))
        colorbar,caxis(pi*[-1 1])
        axis square
        title('angle(mt)')
        
    subplot(2,2,[2 4])
        imagesc(diffrac)
        colorbar,caxis([0 1])
        axis square
        title('diffraction')

        
%% Test boucle constante
niter = 100 ;
corr = nan(n,niter) ;
yc = mt*ones(n,1) ;
for i=1:niter
    b = [2;4;6] ;
    b = b.*exp(1i*angle(yc)) ;
    
    corr(:,i) = angle(mti*b) ;
end
corr(:,1)

figure(2)
    subplot(2,1,1)
    plot(corr')
    subplot(2,1,2)
    plot(cumsum(corr'))

    
%% Test PIM
niter = 100 ;
corr = nan(n,niter) ;
phi = nan(n,niter) ;
yc = mt*ones(n,1) ;
for i=1:niter
    if i==1
        x = ones(n,1).*exp(1i*2*pi*rand(n,1)) ;
    end
    
    b = abs(mt*x).*exp(1i*angle(yc)) ;
    corr(:,i) = angle(b) ;
    
    x = x.*exp(-1i*corr(:,i)) ;
    phi(:,i) = angle(x) ;
end

dphi = angle(exp(1i*(phi-phi(1,:)))) ;

figure(2)
    subplot(2,1,1)
    plot(corr')
    subplot(2,1,2)
    plot(dphi')
